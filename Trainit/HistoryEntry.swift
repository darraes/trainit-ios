//
//  HistoryEntry.swift
//  Trainit
//
//  Created by Daniel Pereira on 6/3/17.
//  Copyright © 2017 Daniel Arraes. All rights reserved.
//

import Foundation
import Firebase

class WorkoutCompletion {
    let date: Date
    private(set) var activities: [String]
    
    init (date: Date) {
        self.date = date
        self.activities = []
    }
    
    init (date: Date, activities: [String]) {
        self.date = date
        self.activities = activities
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
    private(set) var completions: [WorkoutCompletion]
    
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
        self.completions = []
        
        let completions = snapshot.childSnapshot(forPath: "completions")
        for completion in completions.children {
            let completionSnapshot = completion as! DataSnapshot
            let workoutCompletion = WorkoutCompletion(
                date:toDate(for: completionSnapshot.key))
            
            for completionData in completionSnapshot.children {
                let dataSnapshot = completionData as! DataSnapshot
                workoutCompletion.add(activity: dataSnapshot.value as! String)
            }
            
            self.completions.append(workoutCompletion)
        }
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
