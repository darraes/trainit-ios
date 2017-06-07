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
    private var isSorted = false
    
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
        self.sortLaterFirst()
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
        if !self.isSorted {
            self.sortLaterFirst()
        }
        
        // Since the list is sorted, we can reduce it to find the index to
        // insert the new element. This is O(n) and a binary search would be
        // better
        let idx = self.entries.reduce(0) {result, element in
            element.weekStartDate > entry.weekStartDate ? result + 1 : result
        }
        
        self.entries.insert(entry, at: idx)
        // TODO make 10 configurable
        while self.entries.count > 10 {
            self.entries.remove(at: self.entries.count - 1)
        }
    }
    
    private func sortLaterFirst() {
        isSorted = true
        self.entries.sort(by:{ (left, right) in
            return left.weekStartDate > right.weekStartDate
        })
    }
}
