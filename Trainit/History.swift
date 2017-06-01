//
//  History.swift
//  Trainit
//
//  Created by Daniel Pereira on 5/30/17.
//  Copyright © 2017 Daniel Arraes. All rights reserved.
//

import Foundation
import Firebase

class WorkoutCompletion {
    let date: Date
    var activities: [String]
    
    init (date: Date) {
        self.date = date
        self.activities = []
    }
    
    init(_ snapshot: DataSnapshot) {
        self.date = toDate(for: snapshot.key)
        
        var completedActivities: [String] = []
        for completion in snapshot.children {
            let cp = completion as! DataSnapshot
            completedActivities.append(cp.value as! String)
        }
        self.activities = completedActivities
    }
    
    func toAnyObject() -> Any {
        return self.activities
    }
    
    func add(activity: String) {
        self.activities.append(activity)
    }
}

class HistoryEntry {
    let weekStartDate: Date
    let planID: String
    var completions: [WorkoutCompletion]
    
    init(from plan: WorkoutPlan) {
        self.weekStartDate = plan.startDate
        self.planID = plan.id
        self.completions = []
        
        var completionMap: [Date:WorkoutCompletion] = [:]
        for workout in plan.workouts {
            let activity = workout.type
            for completion in workout.completions {
                if completionMap[completion] == nil {
                    completionMap[completion] = WorkoutCompletion(date: completion)
                }
                completionMap[completion]!.add(activity: activity)
            }
        }
        
        for (_, completion) in completionMap {
            self.completions.append(completion)
        }
    }
    
    /**
     * Snapshot must point to history/{user-id}/{entry-date}
     */
    init(_ snapshot: DataSnapshot) {
        self.weekStartDate = toDate(for: snapshot.key)
        
        let entryData = snapshot.value as! [String: AnyObject]
        self.planID = entryData["plan-id"] as! String
        
        var tmpCompletions: [WorkoutCompletion] = []
        let completions = snapshot.childSnapshot(forPath: "completions")
        for completion in completions.children {
            tmpCompletions.append(WorkoutCompletion(completion as! DataSnapshot))
        }
        self.completions = tmpCompletions
    }
    
    func toAnyObject() -> Any {
        var anyCompletions: [String: Any] = [:]
        for completion in self.completions {
            anyCompletions[dateStr(for: completion.date)]
                = completion.toAnyObject()
        }
        
        return [
            "plan-id": self.planID,
            "completions": anyCompletions
        ]
    }
}

class History {
    var ref: DatabaseReference?
    var entries: [HistoryEntry]
    
    init(entries: [HistoryEntry]) {
        self.ref = nil
        self.entries = entries
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
    
    func add(entry: HistoryEntry) {
        self.entries.append(entry)
        
        // Rollover
        // TODO make 10 configurable
        if self.entries.count > 10 {
            self.entries.remove(at: 0)
        }
    }
    
    func save() {
        self.ref?.setValue(self.toAnyObject())
    }
}
