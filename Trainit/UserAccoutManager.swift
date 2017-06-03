//
//  UserAccoutManager.swift
//  Trainit
//
//  Created by Daniel Pereira on 5/27/17.
//  Copyright © 2017 Daniel Arraes. All rights reserved.
//

import Foundation
import Firebase

typealias AuthCallback = (UserAccount?, NSError?) -> Void
typealias AuthErrorCallback = (NSError?) -> Void

class UserAccountManager {
    // Singleton instance
    static let Instance = UserAccountManager()
    // Current logged in user
    var current: UserAccount?
    
    func createUser(email: String,
                    password: String,
                    with callback: @escaping AuthCallback) {
        Auth.auth().createUser(withEmail: email,
                               password: password)
        { user, error in
            if error == nil {
                self.current = UserAccount(user!)
                callback(self.current, nil)
                return
            }
            
            Log.error(error!.localizedDescription)
            callback(nil, error as NSError?)
        }
    }
    
    func signIn(email: String,
                password: String,
                with callback: @escaping AuthCallback) {
        Auth.auth().signIn(withEmail: email,
                           password: password)
        { (user: User?, error: Error?) in
            if error == nil {
                self.current = UserAccount(user!)
                callback(self.current!, nil)
                return
            }
            
            // At time point, something went wrong and error exists
            Log.error(error!.localizedDescription)
            callback(nil, error as NSError?)
        }
    }
    
    func signOut(onError: @escaping AuthErrorCallback) -> Bool {
        if self.current == nil {
            Log.critical("Sign out called with no user logged in")
        }
        
        self.current = nil
        do {
            try Auth.auth().signOut()
            return true
        } catch let signOutError as NSError {
            Log.error("Error signing out: \(signOutError)")
            onError(signOutError)
        }
        return false
    }
    
    func loggedUser(with callback: @escaping (UserAccount?) -> Void) {
        Auth.auth().addStateDidChangeListener(
            { auth, user in
                if user == nil {
                    callback(nil)
                    return
                }
                
                self.current = UserAccount(user!)
                callback(self.current)
            }
        )
    }
}
