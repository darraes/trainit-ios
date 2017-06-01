//
//  UserAccoutManager.swift
//  Trainit
//
//  Created by Daniel Pereira on 5/27/17.
//  Copyright © 2017 Daniel Arraes. All rights reserved.
//

import Foundation
import Firebase

typealias AuthCallback = (UserAccount) -> Void
typealias AuthErrorCallback = (NSError?) -> Void

class UserAccountManager {
    // Singleton instance
    static let Instance = UserAccountManager()
    // Current logged in user
    var current: UserAccount?
    
    func signIn(withEmail email: String,
                password: String,
                onSuccess: @escaping AuthCallback,
                onError: @escaping AuthErrorCallback) {
        Auth.auth().signIn(withEmail: email,
                           password: password)
        { (user: User?, error: Error?) in
            if error == nil {
                self.current = UserAccount(user!)
                onSuccess(self.current!)
                return
            }
            
            // At time point, something went wrong and error exists
            Log.error(error!.localizedDescription)
            onError(error as NSError?)
        }
    }
}
