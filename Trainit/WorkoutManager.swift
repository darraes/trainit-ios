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
    // Singleton instance
    static let Instance = WorkoutManager()
    
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
            withPath: "workout-plans/1/current")
        
        workoutPlansRef!.observe(.value, with: { snapshot in
            self.workoutPlan = WorkoutPlan(snapshot)
            for callback in self.onPlanChangeCallbacks {
                callback(self.workoutPlan!)
            }
        })
    }
    
    func subscribe(with callback: @escaping WorkoutPlanCallback) {
        self.onPlanChangeCallbacks.append(callback)
    }
}
