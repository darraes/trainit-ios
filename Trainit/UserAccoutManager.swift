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
    
    /**
     * Creates a new user with password authentication mode
     *
     * @callback user=user, error=nil on success
     *           user=nil, error=error on failure
     */
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
    
    /**
     * Signs in a user with password authentication mode
     *
     * @callback user=user, error=nil on success
     *           user=nil, error=error on failure
     */
    func signIn(email: String,
                password: String,
                with callback: @escaping AuthCallback) {
        Auth.auth().signIn(withEmail: email,
                           password: password)
        { (user: User?, error: Error?) in
            if error == nil {
                Log.info("User \(email) is signed in")
                self.current = UserAccount(user!)
                callback(self.current!, nil)
                return
            }
            
            // At time point, something went wrong and error exists
            Log.error(error!.localizedDescription)
            callback(nil, error as NSError?)
        }
    }
    
    /**
     * Signs out a user
     *
     * @onError not called on success
     *          error=error on failure
     */
    func signOut(onError: @escaping AuthErrorCallback) -> Bool {
        if self.current == nil {
            Log.critical("Sign out called with no user logged in")
        }
        
        defer { self.current = nil }
        do {
            try Auth.auth().signOut()
            Log.info("User \(self.current!.email) signed out")
            return true
        } catch let signOutError as NSError {
            Log.error("Error signing out: \(signOutError)")
            onError(signOutError)
        }
        return false
    }
    
    /**
     * Signs in a user with password authentication mode using authentication
     * data from keychain
     *
     * @callback user=user on success
     *           user=nil on failure
     */
    func loggedUser(with callback: @escaping (UserAccount?) -> Void) {
        Auth.auth().addStateDidChangeListener(
            { auth, user in
                if user == nil {
                    // User is not logged in. Return to caller for sign in
                    self.current = nil
                    callback(nil)
                    return
                }
                
                self.current = UserAccount(user!)
                Log.info("User \(self.current!.email) authentication data found"
                         + " in keychain")
                
                callback(self.current)
            }
        )
    }
}
