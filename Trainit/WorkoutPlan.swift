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
    let id: String!
    let startDate: Date
    var workouts: [Workout]
    var ref: DatabaseReference?
    var completionsPerDay: [String: [Workout]]?
    
    init(_ id : String, _ startDate: Date) {
        self.id = id
        self.startDate = startDate
        self.workouts = []
        self.ref = nil
    }
    
    init(_ snapshot: DataSnapshot) {
        self.workouts = []
        self.ref = snapshot.ref
        
        let plan = snapshot.value as! [String: AnyObject]
        self.id = plan["id"] as! String
        self.startDate = toDate(for: plan["start-date"] as! String)
        
        let workouts = snapshot.childSnapshot(forPath: "workouts")
        for workout in workouts.children {
            let myWorkout = Workout(workout as! DataSnapshot)
            myWorkout.setOwnerPlan(self)
            self.workouts.append(myWorkout)
        }
        // TODO figure out the sorting experience
        sortOnCompletion()
    }
    
    static func reset(from plan: WorkoutPlan, for date: Date) -> WorkoutPlan {
        let newPlan = WorkoutPlan(plan.id, date)
        
        for workout in plan.workouts {
            let newWorkout = Workout.reset(from: workout)
            newWorkout.setOwnerPlan(newPlan)
            newPlan.workouts.append(newWorkout)
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
            "start-date": start,
            "id": self.id
        ]
    }

    func workoutCount() -> Int {
        return self.workouts.count
    }
    
    func save() {
        self.ref?.setValue(self.toAnyObject())
    }
    
    func getCompletionsPerDay() -> [String: [Workout]] {
        if self.completionsPerDay != nil {
            return self.completionsPerDay!;
        }
        
        var workoutPerDay: [String: [Workout]] = [:]
        for workout in self.workouts {
            for completion in workout.completions {
                let idx = weekDayStr(for: completion)
                if workoutPerDay[idx] == nil {
                    workoutPerDay[idx] = []
                }
                workoutPerDay[idx]?.append(workout)
            }
        }
        
        self.completionsPerDay = workoutPerDay
        return workoutPerDay
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
