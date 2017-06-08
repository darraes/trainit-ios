//
//  WorkoutPlan.swift
//  Trainit
//
//  Created by Daniel Pereira on 5/23/17.
//  Copyright © 2017 Daniel Arraes. All rights reserved.
//

import Foundation
import Firebase

class WorkoutPlan : DBWritable {
    let id: String!
    let startDate: Date
    private(set) var workouts: [Workout]
    
    init(_ id : String, _ startDate: Date) {
        self.id = id
        self.startDate = startDate
        self.workouts = []
        super.init()
    }
    
    /**
     * Snapshot must point to workout-plans/{user-id}/{plan}
     */
    init(_ snapshot: DataSnapshot) {
        
        let plan = snapshot.value as! [String: AnyObject]
        self.id = plan["id"] as! String
        self.startDate = toDate(for: plan["start-date"] as! String)
        self.workouts = []
        super.init()
        
        self.ref = snapshot.ref
        
        let workouts = snapshot.childSnapshot(forPath: "workouts")
        for workout in workouts.children {
            let myWorkout = Workout(workout as! DataSnapshot, owner: self)
            self.workouts.append(myWorkout)
        }

        sortOnCompletions()
    }
    
    static func reset(from plan: WorkoutPlan,
                      for date: Date,
                      with ref: DatabaseReference?) -> WorkoutPlan {
        let newPlan = WorkoutPlan(plan.id, date)
        newPlan.ref = ref
        
        for workout in plan.workouts {
            newPlan.workouts.append(
                Workout.reset(from: workout, owner: newPlan))
        }

        return newPlan
    }
    
    override func toAnyObject() -> Any {
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
    
    func getCompletionsPerDay() -> [String: [Workout]] {
        var workoutPerDay: [String: [Workout]] = [:]
        for workout in self.workouts {
            for completion in workout.completions {
                // TODO will have issues with i18n
                let idx = weekDayStr(for: completion)
                if workoutPerDay[idx] == nil {
                    workoutPerDay[idx] = []
                }
                workoutPerDay[idx]?.append(workout)
            }
        }
        
        return workoutPerDay
    }
    
    func maxCompletions() -> Int {
        let workoutPerDay = self.getCompletionsPerDay()
        var maxCompletionsPerDay = 0
        for (_, completions) in workoutPerDay {
            maxCompletionsPerDay = max(maxCompletionsPerDay, completions.count)
        }
        return maxCompletionsPerDay
    }
    
    func getProgress() -> (completed: Int, total: Int) {
        var completed = 0
        var total = 0
        
        for workout in self.workouts {
            total += workout.sessionsPerWeek
            completed += workout.completions.count
        }
        
        return (completed: completed, total: total)
    }
    
    private func sortOnCompletions() {
        self.workouts.sort(by:{ (left, right) in
            let leftDelta = left.sessionsPerWeek - left.completedSessionsCount()
            let rightDelta = right.sessionsPerWeek
                - right.completedSessionsCount()
            
            if leftDelta == rightDelta {
                return left.completedSessionsCount()
                    < right.completedSessionsCount()
            }
            
            return leftDelta > rightDelta
        })
    }
}
