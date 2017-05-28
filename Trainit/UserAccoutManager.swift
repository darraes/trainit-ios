//
//  UserAccoutManager.swift
//  Trainit
//
//  Created by Daniel Pereira on 5/27/17.
//  Copyright © 2017 Daniel Arraes. All rights reserved.
//

import Foundation
import Firebase

class UserAccountManager {
    // Singleton instance
    static let Instance = UserAccountManager()
    // Current logged in user
    var current: UserAccount?
}
