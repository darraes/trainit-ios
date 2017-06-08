//
//  DBWritable.swift
//  Trainit
//
//  Created by Daniel Pereira on 6/7/17.
//  Copyright © 2017 Daniel Arraes. All rights reserved.
//

import Foundation
import Firebase

/**
 * All classes that can write themselves to the store must inherit from
 * DBWritable.
 *
 * This class offers the simple protocol to write data to the sore
 */
class DBWritable {
    var ref: DatabaseReference?
    
    init() {
        self.ref = nil
    }
    
    /**
     * Checks if the object is currently attached to a database reference
     */
    func isAttached() -> Bool {
        return self.ref != nil
    }
    
    /**
     * Attaches teh object onto a database reference
     */
    func attach(ref: DatabaseReference) {
        self.ref = ref
    }
    
    /**
     * Saves the object to the store
     */
    func save() {
        self.ref!.setValue(self.toAnyObject())
    }
    
    
    func toAnyObject() -> Any {
        Log.critical("abstract method called")
        return []
    }
}
