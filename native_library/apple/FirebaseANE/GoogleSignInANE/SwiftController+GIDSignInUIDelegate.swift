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
import Firebase
import GoogleSignIn

extension SwiftController: GIDSignInUIDelegate {
    
    public func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
    }
    
    public func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
            rootViewController.present(viewController, animated: true, completion: nil)
        }
    }
    
    public func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
            rootViewController.dismiss(animated: true, completion: nil)
        }
        
    }
}
