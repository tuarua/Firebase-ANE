/*
 *  Copyright 2018 Tua Rua Ltd.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

import Foundation
import FirebaseMLVision
import FreSwift
import AVFoundation
import Accelerate

extension SwiftController: AVCaptureVideoDataOutputSampleBufferDelegate {
    public func captureOutput(_ output: AVCaptureOutput,
                              didOutput sampleBuffer: CMSampleBuffer,
                              from connection: AVCaptureConnection) {
        
        guard let callbackId = cameraCallbackId,
            let options = self.options else { return }
        
        let visionImage = VisionImage(buffer: sampleBuffer)
        let metadata = VisionImageMetadata()
        let orientation = UIUtilities.imageOrientation(
            fromDevicePosition: .back
        )
        let visionOrientation = UIUtilities.visionImageOrientation(from: orientation)
        metadata.orientation = visionOrientation
        visionImage.metadata = metadata
        let barcodeDetector = Vision.vision().barcodeDetector(options: options)
        barcodeDetector.detect(in: visionImage) { (features, error) in
            if let err = error as NSError? {
                self.dispatchEvent(name: BarcodeEvent.DETECTED,
                               value: BarcodeEvent(callbackId: callbackId,
                                                   error: err,
                                                   continuous: false).toJSONString())
            } else {
                if let features = features, !features.isEmpty {
                    self.results[callbackId] = features
                    self.dispatchEvent(name: BarcodeEvent.DETECTED,
                                   value: BarcodeEvent(callbackId: callbackId,
                                                       continuous: false).toJSONString())
                    self.closeCamera()
                }
            }
        }
    }
    
    private func captureDevice(forPosition position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        return AVCaptureDevice.default(for: .video) ?? nil
    }
    
    private func setUpCaptureSessionInput() {
        var props: [String: Any] = Dictionary()
        sessionQueue.async {
            guard let device = self.captureDevice(forPosition: .back) else { return }
            do {
                let currentInputs = self.captureSession.inputs
                for input in currentInputs {
                    self.captureSession.removeInput(input)
                }
                if device.isFocusModeSupported(.continuousAutoFocus) {
                    try device.lockForConfiguration()
                    device.focusMode = .continuousAutoFocus
                    device.isSmoothAutoFocusEnabled = true
                    device.unlockForConfiguration()
                }
                let input = try AVCaptureDeviceInput(device: device)
                guard self.captureSession.canAddInput(input) else { return }
                self.captureSession.addInput(input)
            } catch {
                props["error"] = "no capture device"
                self.trace("no capture device")
                // self.sendEvent(name: VisionEvent.ERROR, value: JSON(props).description)
            }
        }
    }
    
    private func setUpCaptureSessionOutput() {
        var props: [String: Any] = Dictionary()
        sessionQueue.async {
            self.captureSession.beginConfiguration()
            self.captureSession.sessionPreset = AVCaptureSession.Preset.medium
            
            let output = AVCaptureVideoDataOutput()
            output.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as String): kCVPixelFormatType_32BGRA]
            let queue = DispatchQueue(label: "com.tuarua.firebase.vision.cameraQueue")
            let videoDataOutput = AVCaptureVideoDataOutput()
            videoDataOutput.setSampleBufferDelegate(self, queue: queue)

            guard self.captureSession.canAddOutput(videoDataOutput) else {
                props["error"] = "cannot add camera output"
                self.trace("cannot add camera output")
                // self.sendEvent(name: VisionEvent.ERROR, value: JSON(props).description)
                return
            }
            self.captureSession.addOutput(videoDataOutput)
            self.captureSession.commitConfiguration()
            self.captureSession.startRunning()
        }
    }
    
    private func setUpPreviewLayer(rootViewController: UIViewController) {
        var props: [String: Any] = Dictionary()
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        guard let videoPreviewLayer = videoPreviewLayer,
            let cameraView = cameraView else {
                props["error"] = "cannot add camera input"
                self.trace("cannot add camera input")
                // self.sendEvent(name: VisionEvent.ERROR, value: JSON(props).description)
                return
        }
        videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer.frame = cameraView.layer.bounds
        cameraView.layer.addSublayer(videoPreviewLayer)
        rootViewController.view.addSubview(cameraView)
    }
    
    func inputFromCamera(rootViewController: UIViewController, callbackId: String) {
        cameraView = UIView(frame: CGRect(x: 0, y: 0, width: rootViewController.view.frame.width,
                                          height: rootViewController.view.frame.height))
        setUpCaptureSessionInput()
        setUpPreviewLayer(rootViewController: rootViewController)
        setUpCaptureSessionOutput()
        
        for sv in rootViewController.view.subviews {
            if sv.debugDescription.starts(with: "<VisionANE_LIB.FreNativeContainer") {
                sv.isHidden = false
                rootViewController.view.bringSubviewToFront(sv)
                break
            }
        }
    }
    
    func toggleTorch(on: Bool) {
        guard let device = captureDevice(forPosition: .back) else { return }
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                device.torchMode = on ? .on : .off
                device.unlockForConfiguration()
            } catch {
                trace("Torch could not be used")
            }
        } else {
            trace("Torch is not available")
        }
    }
    
    func closeCamera() {
        sessionQueue.async {
            self.captureSession.stopRunning()
        }
        for input in captureSession.inputs {
            captureSession.removeInput(input)
        }
        for output in captureSession.outputs {
            captureSession.removeOutput(output)
        }
        
        videoPreviewLayer?.removeFromSuperlayer()
        cameraView?.removeFromSuperview()
        
        videoPreviewLayer = nil
        cameraView = nil
        
        for sv in UIApplication.shared.keyWindow?.rootViewController?.view.subviews ?? [] {
            if sv.debugDescription.starts(with: "<VisionANE_LIB.FreNativeContainer") {
                sv.isHidden = true
                break
            }
        }
        
    }
    
}
