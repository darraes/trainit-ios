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
    let title: String?
    let type: String
    let sessionsPerWeek: Int
    var completions: [Date]
    var plan: WorkoutPlan
    
    init(owner plan: WorkoutPlan,
         _ id: String,
         _ title: String?,
         _ type : String,
         _ sessionPerWeek: Int) {
        self.plan = plan
        self.id = id
        self.title = title
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
        self.title = workout["title"] as? String
        self.sessionsPerWeek = workout["sessions_per_week"] as! Int
        self.completions = []
        
        let completionsStr = workout["completions"] as? [String]
        if (completionsStr != nil) {
            for completion in completionsStr! {
                self.completions.append(toDate(for: completion))
            }
        }
    }
    
    /**
     * Resets the workout to a initial state where no workouts were completed
     */
    static func reset(from workout: Workout,
                      owner plan: WorkoutPlan) -> Workout {
        return Workout(owner: plan,
                       workout.id,
                       workout.title,
                       workout.type,
                       workout.sessionsPerWeek)
    }
    
    // So we can use the Workout as key of a hashtable
    var hashValue: Int {
        get {
            return self.id.hashValue
        }
    }
    
    // So we can use the Workout as key of a hashtable
    static func ==(lhs: Workout, rhs: Workout) -> Bool {
        return lhs.id == rhs.id && lhs.type == lhs.type
    }
    
    /**
     * Saves the workout into the store
     */
    func save() {
        // The reference lives in the wrapping plan so we saved it from there
        self.plan.save()
    }
    
    /**
     * Serializes the current object into an Any dictionary
     */
    func toAnyObject() -> Any {
        var myCompletions: [String] = []
        for completion in self.completions {
            myCompletions.append(dateStr(for: completion))
        }
        var anyWorkout: [String: Any] = [
            "id": self.id,
            "type": self.type,
            "sessions_per_week": self.sessionsPerWeek,
            "completions": myCompletions
        ]
        
        if self.title != nil {
            anyWorkout["title"] = self.title
        }
        
        return anyWorkout
    }
    
    /**
     * Ho wmany sessions were already completed
     */
    func completedSessionsCount() -> Int {
        return self.completions.count
    }
    
    /**
     * If all sessions were completed
     */
    func isAllCompleted() -> Bool {
        return self.completions.count >= self.sessionsPerWeek
    }
    
    /**
     * Completes a single session (adds a completion stamp) if possible.
     *
     * It is only possible to stamp a completion if the current stamp count is
     * less than the sessions per week
     */
    func completeOneSession() {
        if self.completions.count == self.sessionsPerWeek {
            Log.error("Trying to complete a session on finished"
                + " workout \(self.id)")
            return
        }
        
        self.completions.append(Date())
    }
    
    /**
     * Reverts a session completion (removes a stamp) if possible.
     */
    func revertOneSession() {
        if self.completions.count == 0 {
            // TODO logging
            return
        }
        
        self.completions.removeLast()
    }
}
