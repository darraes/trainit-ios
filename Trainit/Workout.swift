//
//  WorkoutRun.swift
//  Trainit
//
//  Created by Daniel Pereira on 5/23/17.
//  Copyright © 2017 Daniel Arraes. All rights reserved.
//

import Foundation
import Firebase

class Workout : Hashable {
    
    let id: String
    let type: String
    let sessionsPerWeek: Int
    var completions: [Date]
    var plan: WorkoutPlan
    
    init(owner plan: WorkoutPlan, _ id: String, _ type : String, _ sessionPerWeek: Int) {
        self.plan = plan
        self.id = id
        self.type = type
        self.sessionsPerWeek = sessionPerWeek
        self.completions = []
    }
    
    /**
     * Snapshot must point to workout-plans/{user-id}/{plan}/workouts/{id}
     */
    init(_ snapshot: DataSnapshot, owner plan: WorkoutPlan) {
        let workout = snapshot.value as! [String: AnyObject]
        
        self.plan = plan
        self.id = workout["id"] as! String
        self.type = workout["type"] as! String
        self.sessionsPerWeek = workout["sessions_per_week"] as! Int
        self.completions = []
        
        let completionsStr = workout["completions"] as? [String]
        if (completionsStr != nil) {
            for completion in completionsStr! {
                self.completions.append(toDate(for: completion))
            }
        }
    }
    
    static func reset(from workout: Workout, owner plan: WorkoutPlan) -> Workout {
        return Workout(owner: plan,
                       workout.id,
                       workout.type,
                       workout.sessionsPerWeek)
    }
    
    var hashValue: Int {
        get {
            return self.id.hashValue
        }
    }
    
    static func ==(lhs: Workout, rhs: Workout) -> Bool {
        return lhs.id == rhs.id && lhs.type == lhs.type
    }
    
    func save() {
        // The reference lives in the wrapping plan so we saved it from there
        self.plan.save()
    }
    
    func toAnyObject() -> Any {
        var myCompletions: [String] = []
        for completion in self.completions {
            myCompletions.append(dateStr(for: completion))
        }
        return [
            "id": self.id,
            "type": self.type,
            "sessions_per_week": self.sessionsPerWeek,
            "completions": myCompletions
        ]
    }
    
    func completedSessionsCount() -> Int {
        return self.completions.count
    }
    
    func isAllCompleted() -> Bool {
        return self.completions.count >= self.sessionsPerWeek
    }
    
    func completeOneSession() {
        if self.completions.count == self.sessionsPerWeek {
            // TODO logging
            return
        }
        
        self.completions.append(Date())
    }
    
    func revertOneSession() {
        if self.completions.count == 0 {
            // TODO logging
            return
        }
        
        self.completions.removeLast()
    }
}
