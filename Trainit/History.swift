//
//  History.swift
//  Trainit
//
//  Created by Daniel Pereira on 5/30/17.
//  Copyright © 2017 Daniel Arraes. All rights reserved.
//

import Foundation
import Firebase

class History : DBWritable {
    var entries: [HistoryEntry]
    private var isSorted = false
    
    override init() {
        self.entries = []
        super.init()
    }
    
    /**
     * Snapshot must point to history/{user-id}
     */
    init(_ snapshot: DataSnapshot) {
        self.entries = []
        super.init()
        
        self.ref = snapshot.ref
        for entry in snapshot.children {
            self.entries.append(HistoryEntry(entry as! DataSnapshot))
        }
        
        self.sortNewestFirst()
    }
    
    /**
     * Serialization to Any
     */
    override func toAnyObject() -> Any {
        var result: [String:Any] = [:]
        for entry in self.entries {
            result[dateStr(for: entry.weekStartDate)] = entry.toAnyObject()
        }
        return result
    }
    
    /**
     * Adds a workout history entry as part of the history
     */
    func add(entry: HistoryEntry) {
        if !self.isSorted {
            self.sortNewestFirst()
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
    
    /**
     * Sorts the entries leaving the newest first
     */
    private func sortNewestFirst() {
        isSorted = true
        self.entries.sort(by:{ (left, right) in
            return left.weekStartDate > right.weekStartDate
        })
    }
}
