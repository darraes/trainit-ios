//
//  WorkoutPlan.swift
//  Trainit
//
//  Created by Daniel Pereira on 5/23/17.
//  Copyright © 2017 Daniel Arraes. All rights reserved.
//

import Foundation
import Firebase

class WorkoutPlan {
    
    let startDate: Date
    var workouts: [Workout]
    var ref: DatabaseReference?
    
    init(_ startDate: Date) {
        self.startDate = startDate
        self.workouts = []
        self.ref = nil
    }
    
    init(_ snapshot: DataSnapshot) {
        self.workouts = []
        self.ref = snapshot.ref
        
        let plan = snapshot.value as! [String: AnyObject]
        self.startDate = date(for: plan["start-date"] as! String)
        
        let workouts = snapshot.childSnapshot(forPath: "workouts")
        for workout in workouts.children {
            let myWorkout = Workout(workout as! DataSnapshot)
            myWorkout.setOwnerPlan(self)
            self.add(workout: myWorkout)
        }
        // TODO figure out the sorting experience
        // sortOnCompletion()
    }
    
    static func reset(from plan: WorkoutPlan, for date: Date) -> WorkoutPlan {
        let newPlan = WorkoutPlan(date)
        
        for workout in plan.workouts {
            let newWorkout = Workout.reset(from: workout)
            newWorkout.setOwnerPlan(newPlan)
            
            newPlan.add(workout: newWorkout)
        }

        return newPlan
    }
    
    
    func toAnyObject() -> Any {
        var myWorkouts: [Any] = []
        for workout in self.workouts{
            myWorkouts.append(workout.toAnyObject())
        }
        
        let start = dateStr(for: self.startDate)
        return [
            "workouts": myWorkouts,
            "start-date": start
        ]
    }
    
    func add(workout: Workout) {
        self.workouts.append(workout)
    }
    
    func workoutCount() -> Int {
        return self.workouts.count
    }
    
    func save() {
        self.ref?.setValue(self.toAnyObject())
    }
    
    func sortOnCompletion() {
        self.workouts.sort(by:{ (left, right) in
            let leftDelta = left.sessionsPerWeek - left.getSessionsCompleted()
            let rightDelta = right.sessionsPerWeek - right.getSessionsCompleted()
            
            if leftDelta == rightDelta {
                return left.getSessionsCompleted() < right.getSessionsCompleted()
            }
            
            return leftDelta > rightDelta
        })
    }
}
