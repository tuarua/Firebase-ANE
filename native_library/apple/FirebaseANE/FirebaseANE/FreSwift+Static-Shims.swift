/* Copyright 2017 Tua Rua Ltd.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import Foundation
import FreSwift

public extension FreSwiftMainController {
    /// trace: sends StatusEvent to our swc with a level of "TRACE"
    ///
    /// ```swift
    /// trace("Hello")
    /// ```
    /// - parameter value: value to trace to console
    /// - returns: Void
    func trace(_ value: Any...) {
        var traceStr = ""
        for v in value {
            traceStr.append("\(v) ")
        }
        dispatchEvent(name: "TRACE", value: traceStr)
    }
    /// info: sends StatusEvent to our swc with a level of "TRACE"
    /// The output string is prefixed with ℹ️ INFO:
    ///
    /// ```swift
    /// info("Hello")
    /// ```
    /// - parameter value: value to trace to console
    /// - returns: Void
    func info(_ value: Any...) {
        var traceStr = "\(Self.TAG):"
        for v in value {
            traceStr = "\(traceStr) \(v) "
        }
        dispatchEvent(name: "TRACE", value: "ℹ️ INFO: \(traceStr)")
    }
    /// warning: sends StatusEvent to our swc with a level of "TRACE"
    /// The output string is prefixed with ⚠️ WARNING:
    ///
    /// ```swift
    /// warning("Hello")
    /// ```
    /// - parameter value: value to trace to console
    /// - returns: Void
    func warning(_ value: Any...) {
        var traceStr = "\(Self.TAG):"
        for v in value {
            traceStr = "\(traceStr) \(v) "
        }
        dispatchEvent(name: "TRACE", value: "⚠️ WARNING: \(traceStr)")
    }
}

public extension FreSwiftController {
    /// trace: sends StatusEvent to our swc with a level of "TRACE"
    ///
    /// ```swift
    /// trace("Hello")
    /// ```
    /// - parameter value: value to trace to console
    /// - returns: Void
    func trace(_ value: Any...) {
        var traceStr = ""
        for v in value {
            traceStr.append("\(v) ")
        }
        dispatchEvent(name: "TRACE", value: traceStr)
    }
    /// info: sends StatusEvent to our swc with a level of "TRACE"
    /// The output string is prefixed with ℹ️ INFO:
    ///
    /// ```swift
    /// info("Hello")
    /// ```
    /// - parameter value: value to trace to console
    /// - returns: Void
    func info(_ value: Any...) {
        var traceStr = "\(Self.TAG):"
        for v in value {
            traceStr = "\(traceStr) \(v) "
        }
        dispatchEvent(name: "TRACE", value: "ℹ️ INFO: \(traceStr)")
    }
    /// warning: sends StatusEvent to our swc with a level of "TRACE"
    /// The output string is prefixed with ⚠️ WARNING:
    ///
    /// ```swift
    /// warning("Hello")
    /// ```
    /// - parameter value: value to trace to console
    /// - returns: Void
    func warning(_ value: Any...) {
        var traceStr = "\(Self.TAG):"
        for v in value {
            traceStr = "\(traceStr) \(v) "
        }
        dispatchEvent(name: "TRACE", value: "⚠️ WARNING: \(traceStr)")
    }
}

public extension FreObjectSwift {
    
    /// init: Creates a new FreObjectSwift.
    ///
    /// ```swift
    /// let newPerson = FreObjectSwift(className: "com.tuarua.Person", args: 1, true, "Free")
    /// ```
    /// - parameter className: name of AS3 class to create
    /// - parameter args: arguments to use. These are automatically converted to FREObjects
    public convenience init?(className: String, args: Any?...) {
        let argsArray: NSPointerArray = NSPointerArray(options: .opaqueMemory)
        for i in 0..<args.count {
            argsArray.addPointer(newObject(any: args[i]))
        }
        if let rv = FreSwiftHelper.newObject(className: className, argsArray) {
            self.init(rv)
        } else {
            return nil
        }
    }
    
    /// value:
    public var value: Any? {
        return getAsId(rawValue)
    }
    
    /// call: Calls a method on a FREObject.
    ///
    /// ```swift
    /// person.call(method: "add", args: 100, 31)
    /// ```
    /// - parameter method: name of AS3 method to call
    /// - parameter args: arguments to pass to the method
    /// - returns: FREObject?
    @discardableResult
    public func call(method: String, args: Any...) -> FREObject? {
        guard let rv = self.rawValue else { return nil }
        let argsArray: NSPointerArray = NSPointerArray(options: .opaqueMemory)
        for i in 0..<args.count {
            argsArray.addPointer(newObject(any: args[i]))
        }
        var ret: FREObject?
        var thrownException: FREObject?
        var numArgs: UInt32 = 0
        numArgs = UInt32((argsArray.count))
        let status = FreSwiftBridge.bridge.FRECallObjectMethod(object: rv, methodName: method,
                                                               argc: numArgs, argv: argsArray,
                                                               result: &ret, thrownException: &thrownException)
        if FRE_OK == status { return ret }
        FreSwiftLogger.shared.log(message: "cannot call method \(method) on \(rv.toString())",
            stackTrace: FreSwiftHelper.getActionscriptException(thrownException),
            type: FreSwiftHelper.getErrorCode(status),
            line: #line, column: #column, file: #file)
        return nil
    }
    
}

private func getAsId(_ rawValue: FREObject?) -> Any? {
    guard let rv = rawValue else { return nil }
    let objectType: FreObjectTypeSwift = FreSwiftHelper.getType(rv)
    switch objectType {
    case .int:
        return getAsInt(rv)
    case .vector, .array:
        return FREArray(rv).value
    case .string:
        return getAsString(rv)
    case .boolean:
        return getAsBool(rv)
    case .object, .cls:
        return getAsDictionary(rv) as [String: AnyObject]?
    case .number:
        return getAsDouble(rv)
    case .bitmapdata:
        return FreBitmapDataSwift(freObject: rv).asCGImage()
    case .bytearray:
        let asByteArray = FreByteArraySwift(freByteArray: rv)
        let byteData = asByteArray.value
        asByteArray.releaseBytes()
        return byteData
    case .point:
        return CGPoint(rv)
    case .rectangle:
        return CGRect(rv)
    case .date:
        return getAsDate(rv)
    case .null:
        return nil
    }
}

private func getAsInt(_ rawValue: FREObject) -> Int? {
    var ret: Int32 = 0
    let status = FreSwiftBridge.bridge.FREGetObjectAsInt32(object: rawValue, value: &ret)
    if FRE_OK == status { return Int(ret) }
    FreSwiftLogger.shared.log(message: "cannot get FREObject \(rawValue.toString()) as Int",
        type: FreSwiftHelper.getErrorCode(status),
        line: #line, column: #column, file: #file)
    return nil
}

private func getAsString(_ rawValue: FREObject) -> String? {
    var len: UInt32 = 0
    var valuePtr: UnsafePointer<UInt8>?
    let status = FreSwiftBridge.bridge.FREGetObjectAsUTF8(object: rawValue,
                                                          length: &len, value: &valuePtr)
    if FRE_OK == status {
        return NSString(bytes: valuePtr!, length: Int(len), encoding: String.Encoding.utf8.rawValue) as String?
    }
    
    FreSwiftLogger.shared.log(message: "cannot get FREObject \(rawValue.toString(true)) as String",
        type: FreSwiftHelper.getErrorCode(status),
        line: #line, column: #column, file: #file)
    return nil
}

private func getAsBool(_ rawValue: FREObject) -> Bool? {
    var val: UInt32 = 0
    let status = FreSwiftBridge.bridge.FREGetObjectAsBool(object: rawValue, value: &val)
    if FRE_OK == status  { return val == 1 }
    FreSwiftLogger.shared.log(message: "cannot get FREObject \(rawValue.toString()) as Bool",
        type: FreSwiftHelper.getErrorCode(status),
        line: #line, column: #column, file: #file)
    return nil
}

private func getAsDouble(_ rawValue: FREObject) -> Double? {
    var ret: Double = 0.0
    let status = FreSwiftBridge.bridge.FREGetObjectAsDouble(object: rawValue, value: &ret)
    if FRE_OK == status  { return ret }
    FreSwiftLogger.shared.log(message: "cannot get FREObject \(rawValue.toString()) as Double",
        type: FreSwiftHelper.getErrorCode(status),
        line: #line, column: #column, file: #file)
    return nil
}

private func getAsDate(_ rawValue: FREObject) -> Date? {
    if let timeFre = rawValue["time"],
        let time = getAsDouble(timeFre) {
        return Date(timeIntervalSince1970: time / 1000.0)
    }
    return nil
}

public extension FREObject {
    init?(className: String, args: Any?...) {
        let argsArray: NSPointerArray = NSPointerArray(options: .opaqueMemory)
        for i in 0..<args.count {
            argsArray.addPointer(newObject(any: args[i]))
        }
        if let rv = FreSwiftHelper.newObject(className: className, argsArray) {
            self.init(rv)
        } else {
            return nil
        }
    }
    
    @discardableResult
    func call(method: String, args: Any?...) -> FREObject? {
        let argsArray: NSPointerArray = NSPointerArray(options: .opaqueMemory)
        for i in 0..<args.count {
            argsArray.addPointer(newObject(any: args[i]))
        }
        var ret: FREObject?
        var thrownException: FREObject?
        var numArgs: UInt32 = 0
        numArgs = UInt32((argsArray.count))
        let status = FreSwiftBridge.bridge.FRECallObjectMethod(object: self, methodName: method,
                                                               argc: numArgs, argv: argsArray,
                                                               result: &ret, thrownException: &thrownException)
        if FRE_OK == status { return ret }
        FreSwiftLogger.shared.log(message: "cannot call method \(method) on \(self.toString())",
            stackTrace: FreSwiftHelper.getActionscriptException(thrownException),
            type: FreSwiftHelper.getErrorCode(status),
            line: #line, column: #column, file: #file)
        return nil
    }
}

private func newObject(any: Any?) -> FREObject? {
    if any == nil {
        return nil
    } else if any is FREObject, let v = any as? FREObject {
        return (v)
    } else if any is FreObjectSwift, let v = any as? FreObjectSwift {
        return v.rawValue
    } else if any is String, let v = any as? String {
        return FreSwiftHelper.newObject(v)
    } else if any is Int, let v = any as? Int {
        return FreSwiftHelper.newObject(v)
    } else if any is Int32, let v = any as? Int32 {
        return FreSwiftHelper.newObject(Int(v))
    } else if any is UInt, let v = any as? UInt {
        return FreSwiftHelper.newObject(v)
    } else if any is UInt32, let v = any as? UInt32 {
        return FreSwiftHelper.newObject(UInt(v))
    } else if any is Double, let v = any as? Double {
        return FreSwiftHelper.newObject(v)
    } else if any is CGFloat, let v = any as? CGFloat {
        return FreSwiftHelper.newObject(v)
    } else if any is Float, let v = any as? Float {
        return FreSwiftHelper.newObject(Double(v))
    } else if any is Bool, let v = any as? Bool {
        return FreSwiftHelper.newObject(v)
    } else if any is Date, let v = any as? Date {
        return FreSwiftHelper.newObject(v)
    } else if any is CGRect, let v = any as? CGRect {
        return v.toFREObject()
    } else if any is CGPoint, let v = any as? CGPoint {
        return v.toFREObject()
    } else if any is NSNumber, let v = any as? NSNumber {
        return v.toFREObject()
    }
    return nil
}

public extension Dictionary where Key == String, Value == Any {
    /// init: Initialise a Dictionary<String, Any> from a FREObjects.
    ///
    /// ```swift
    /// let dictionary:[String: Any]? = Dictionary(argv[0])
    /// ```
    /// - parameter freObject: FREObject which is of AS3 type Object or a Class
    /// - returns: Dictionary?
    init?(_ freObject: FREObject?) {
        self.init()
        guard let rv = freObject else {
            return
        }
        if let val: [String: Any] = getAsDictionary(rv) { // this is any into dyn - why is broken
            self = val
        }
    }
}

private func getAsDictionary(_ rawValue: FREObject) -> [String: AnyObject]? {
    var ret = [String: AnyObject]()
    guard let aneUtils = FREObject(className: "com.tuarua.fre.ANEUtils"),
        let classProps = aneUtils.call(method: "getClassProps", args: rawValue) else {
            return nil
    }
    let array = FREArray(classProps)
    for fre in array {
        if let propNameAs = fre["name"],
            let propName = String(propNameAs),
            let propValAs = rawValue[propName],
            let propVal = FreObjectSwift(propValAs).value {
            ret.updateValue(propVal as AnyObject, forKey: propName)
        }
    }
    return ret
}

public extension FREArray {
    // push: Adds one or more elements to the end of an array and returns the new length of the array.
    ///
    /// - parameter args: One or more values to append to the array.
    @discardableResult
    public func push(_ args: Any?...) -> UInt {
        guard let rv = self.rawValue else { return 0 }
        let argsArray: NSPointerArray = NSPointerArray(options: .opaqueMemory)
        for i in 0..<args.count {
            argsArray.addPointer(newObject(any: args[i]))
        }
        var ret: FREObject?
        var thrownException: FREObject?
        var numArgs: UInt32 = 0
        numArgs = UInt32((argsArray.count))
        let status = FreSwiftBridge.bridge.FRECallObjectMethod(object: rv, methodName: "push",
                                                               argc: numArgs, argv: argsArray,
                                                               result: &ret, thrownException: &thrownException)
        if FRE_OK == status { return UInt(ret) ?? 0 }
        FreSwiftLogger.shared.log(message: "cannot call method push on \(rv.toString())",
            stackTrace: FreSwiftHelper.getActionscriptException(thrownException),
            type: FreSwiftHelper.getErrorCode(status),
            line: #line, column: #column, file: #file)
        return 0
    }
    
    /// init: Initialise a FREArray with a [Any].
    ///
    /// - parameter anyArray: array to be converted
    public convenience init?(anyArray array: [Any]) {
        self.init(className: "Array")
        for any in array {
            push(newObject(any: any))
        }
    }
    
}

public extension Array where Element == Any {
    /// init: Initialise a [Any] from a FREObject.
    ///
    /// ```swift
    /// let array = [Any](argv[0])
    /// ```
    /// - parameter freObject: FREObject which is of AS3 type Array
    /// - returns: [Any]?
    init?(_ freObject: FREObject?) {
        self.init()
        guard let rv = freObject else {
            return
        }
        if let val: [Any] = getAsArray(rv) {
            self = val
        }
    }
    /// toFREObject: Converts an Any Array into a FREObject of AS3 type Array.
    ///
    /// - returns: FREObject
    func toFREObject() -> FREObject? {
        return FREArray(anyArray: self).rawValue
    }
}


private func getAsArray(_ rawValue: FREObject) -> [Bool]? {
    var ret = [Bool]()
    let array = FREArray(rawValue)
    for fre in array {
        if let v = Bool(fre) {
            ret.append(v)
        }
    }
    return ret
}
