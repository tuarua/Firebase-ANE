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
import FreSwift

public class SwiftController: NSObject {
    public var TAG: String? = "SwiftController"
    public var context: FreContextSwift!
    public var functionsToSet: FREFunctionMap = [:]
    private var userChildren: [String: Any] = [:]
    private var cameraOverlayContainerAdded: Bool = false
    private var cameraOverlayContainer: FreNativeContainer?
    
    func createGUID(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return UUID().uuidString.toFREObject()
    }
    
    public func requestPermissions(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        let pc = PermissionController(context: context)
        pc.requestPermissions()
        return nil
    }
    
    func isCameraSupported(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return true.toFREObject()
    }
    
    func initController(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return true.toFREObject()
    }
    
    func addNativeChild(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let rootVC = UIApplication.shared.keyWindow?.rootViewController,
            let child = argv[0]
            else {
                return FreArgError(message: "addNativeChild").getError(#file, #line, #column)
        }
        if !cameraOverlayContainerAdded {
            cameraOverlayContainer = FreNativeContainer(frame: rootVC.view.frame, visible: false)
            if let coc = cameraOverlayContainer {
                rootVC.view.addSubview(coc)
                cameraOverlayContainerAdded = true
            }
        }
        
        guard let id = String(child["id"]),
            let t = Int(child["type"]),
            let type: FreNativeType = FreNativeType(rawValue: t)
            else {
                return nil
        }
        
        switch type {
        case FreNativeType.image:
            if userChildren.keys.contains(id) {
                if let nativeImage = userChildren[id] as? FreNativeImage {
                    cameraOverlayContainer?.addSubview(nativeImage)
                }
            } else {
                if let nativeImage = FreNativeImage(freObject: child, id: id) {
                    userChildren[id] = nativeImage
                    cameraOverlayContainer?.addSubview(nativeImage)
                }
            }
        case FreNativeType.button:
            if userChildren.keys.contains(id) {
                if let nativeButton = userChildren[id] as? FreNativeButton {
                    cameraOverlayContainer?.addSubview(nativeButton)
                }
            } else {
                if let nativeButton = FreNativeButton(ctx: context, freObject: child, id: id) {
                    userChildren[id] = nativeButton
                    cameraOverlayContainer?.addSubview(nativeButton)
                }
            }
        }
        
        return nil
    }
    
    func updateNativeChild(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 2,
            userChildren.count > 0,
            let id = String(argv[0]),
            let propName = argv[1],
            let propVal = argv[2]
            else {
                return FreArgError(message: "updateNativeChild").getError(#file, #line, #column)
        }
        
        if let child = userChildren[id] as? FreNativeImage {
            child.update(prop: propName, value: propVal)
        } else if let child = userChildren[id] as? FreNativeButton {
            child.update(prop: propName, value: propVal)
        }
        return nil
    }
    
    func removeNativeChild(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let id = String(argv[0])
            else {
                return FreArgError(message: "removeNativeChild").getError(#file, #line, #column)
        }
        if let child = userChildren[id] {
            if let c = child as? FreNativeImage {
                c.removeFromSuperview()
            } else if let c = child as? FreNativeButton {
                c.removeFromSuperview()
            }
        }
        return nil
    }
    
}
