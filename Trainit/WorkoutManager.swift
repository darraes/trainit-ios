//
//  WorkoutManager.swift
//  Trainit
//
//  Created by Daniel Pereira on 5/24/17.
//  Copyright © 2017 Daniel Arraes. All rights reserved.
//

import Foundation
import Firebase

typealias WorkoutPlanCallback = (WorkoutPlan) -> Void

class WorkoutManager {
    static let kCurrentPlanPathFmt = "workout-plans/%d/current"
    // Singleton instance
    static let Instance = WorkoutManager()
    // Rollower days
    static let kRolloverIntervalDays = 7
    // Reference to users current workout plan
    var workoutPlansRef : DatabaseReference?
    // Current instantiated workout
    var workoutPlan: WorkoutPlan?
    // Current logged user
    var user: User?
    // Callbacks to be executed on changing the plan
    var onPlanChangeCallbacks: [WorkoutPlanCallback]
    
    init() {
        self.onPlanChangeCallbacks = []
        self.user = nil
        self.workoutPlansRef = nil
        
    }
    
    func listen(for user: User) {
        self.user = user
        self.workoutPlansRef = Database.database().reference(
            withPath:  String(format: WorkoutManager.kCurrentPlanPathFmt, 1))
        
        workoutPlansRef!.observe(.value, with: { snapshot in
            self.workoutPlan = WorkoutPlan(snapshot)
            
            // If it is a new week of training, rollover the plan
            self.rolloverIfNecessary(self.workoutPlan!)
            
            for callback in self.onPlanChangeCallbacks {
                callback(self.workoutPlan!)
            }
        })
    }
    
    func subscribe(with callback: @escaping WorkoutPlanCallback) {
        self.onPlanChangeCallbacks.append(callback)
    }
    
    func save(_ workout: Workout) {
        workout.save()
    }
    
    func rolloverIfNecessary(_ plan: WorkoutPlan) {
        if intervalInDays(for: plan.startDate, and: Date())
            == WorkoutManager.kRolloverIntervalDays {
            print("Rollover")
        }
    }
}
