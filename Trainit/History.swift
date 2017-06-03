//
//  History.swift
//  Trainit
//
//  Created by Daniel Pereira on 5/30/17.
//  Copyright © 2017 Daniel Arraes. All rights reserved.
//

import Foundation
import Firebase

class History {
    var ref: DatabaseReference?
    var entries: [HistoryEntry]
    
    init() {
        self.ref = nil
        self.entries = []
    }
    
    /**
     * Snapshot must point to history/{user-id}
     */
    init(_ snapshot: DataSnapshot) {
        self.ref = snapshot.ref
        self.entries = []
        for entry in snapshot.children {
            self.entries.append(HistoryEntry(entry as! DataSnapshot))
        }
    }
    
    func toAnyObject() -> Any {
        var result: [String:Any] = [:]
        for entry in self.entries {
            result[dateStr(for: entry.weekStartDate)] = entry.toAnyObject()
        }
        return result
    }
    
    func isAttached() -> Bool {
        return self.ref != nil
    }
    
    func attach(ref: DatabaseReference) {
        self.ref = ref
    }
    
    func save() {
        self.ref!.setValue(self.toAnyObject())
    }
    
    func add(entry: HistoryEntry) {
        self.entries.append(entry)
        
        // Rollover
        // TODO make 10 configurable
        if self.entries.count > 10 {
            self.entries.remove(at: 0)
        }
    }
}
