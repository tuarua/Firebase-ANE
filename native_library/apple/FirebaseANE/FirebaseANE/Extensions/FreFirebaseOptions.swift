import Foundation
import FreSwift
import FirebaseCore

public extension FirebaseOptions {
    func toFREObject() -> FREObject? {
        do {
            let ret = try FREObject(className: "com.tuarua.firebase.FirebaseOptions")
            try ret?.setProp(name: "bundleId", value: self.bundleID)
            try ret?.setProp(name: "androidClientId", value: self.androidClientID)
            try ret?.setProp(name: "trackingId", value: self.trackingID)
            try ret?.setProp(name: "apiKey", value: self.apiKey)
            try ret?.setProp(name: "googleAppId", value: self.googleAppID)
            try ret?.setProp(name: "databaseUrl", value: self.databaseURL)
            try ret?.setProp(name: "storageBucket", value: self.storageBucket)
            try ret?.setProp(name: "clientId", value: self.clientID)
            try ret?.setProp(name: "projectId", value: self.projectID)
            try ret?.setProp(name: "gcmSenderId", value: self.gcmSenderID)
            try ret?.setProp(name: "deepLinkUrlScheme", value: self.deepLinkURLScheme)
            return ret
        } catch {
        }
        return nil
    }
}
