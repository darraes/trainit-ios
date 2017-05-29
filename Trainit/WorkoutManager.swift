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
typealias ExerciseListCallback = ([Exercise]) -> Void

class WorkoutManager {
    // Path to current plans store
    static let kCurrentPlanPathFmt = "workout-plans/%@/current"
    // Path to exercise
    static let kExercisePathFmt = "exercises/%@/%@"
    // Singleton instance
    static let Instance = WorkoutManager()
    // Rollower days
    static let kRolloverIntervalDays = 7
    
    // Reference to users current workout plan
    var workoutPlansRef : DatabaseReference?
    // Current instantiated workout
    var workoutPlan: WorkoutPlan?
    
    var activeWorkoutObservers: [Workout: (ref: DatabaseReference, handle: DatabaseHandle)]
    
    init() {
        self.activeWorkoutObservers = [:]
        self.workoutPlansRef = nil
        
    }
    
    func listen(with callback: @escaping WorkoutPlanCallback) {
        let user = UserAccountManager.Instance.current!
        self.workoutPlansRef = Database.database().reference(
            withPath:  String(format: WorkoutManager.kCurrentPlanPathFmt,
                              user.uid))
        
        workoutPlansRef!.observe(.value, with: { snapshot in
            self.workoutPlan = WorkoutPlan(snapshot)
            
            // If it is a new week of training, rollover the plan
            self.rolloverIfNecessary(self.workoutPlan!)
            
            //Return info to caller
            callback(self.workoutPlan!)
        })
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
    
    func subscribe(for workout: Workout,
                   with callback: @escaping ExerciseListCallback) {
        let user = UserAccountManager.Instance.current!
        let exercisesRef = Database.database().reference(
            withPath:  String(format: WorkoutManager.kExercisePathFmt,
                              user.uid,
                              workout.id))
        
        let handle = exercisesRef.observe(.value, with: { snapshot in
            let listSnapshot = snapshot.childSnapshot(forPath: "list")
            var exercises: [Exercise] = []
            for exercise in listSnapshot.children {
                exercises.append(Exercise(exercise as! DataSnapshot))
            }
            callback(exercises)
        })
        self.activeWorkoutObservers[workout] = (ref: exercisesRef,
                                                handle: handle)
    }
    
    func unsubscribe(for workout: Workout) {
        if let dbPtr = activeWorkoutObservers[workout] {
            dbPtr.ref.removeObserver(withHandle: dbPtr.handle)
        }
        self.activeWorkoutObservers.removeValue(forKey: workout)
    }
}
