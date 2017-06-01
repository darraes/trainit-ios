//
//  WorkoutManager.swift
//  Trainit
//
//  Created by Daniel Pereira on 5/24/17.
//  Copyright © 2017 Daniel Arraes. All rights reserved.
//

import Foundation
import Firebase

typealias WorkoutPlanCallback = (WorkoutPlan, Bool) -> Void
typealias ExerciseListCallback = ([Exercise]) -> Void

typealias FetchWorkoutPlanCallback = (WorkoutPlan) -> Void
typealias FetchHistoryCallback = (History) -> Void

class WorkoutManager {
    // Path to current plans store
    static let kCurrentPlanPathFmt = "workout-plans/%@/current"
    // Path to exercise
    static let kExercisePathFmt = "exercises/%@/%@"
    // Path to history
    static let kHistoryPathFmt = "history/%@"
    
    // Singleton instance
    static let Instance = WorkoutManager()
    // Rollower days
    static let kRolloverIntervalDays = 7
    
    // Reference to users current workout plan
    var workoutPlansRef : DatabaseReference?
    // Current instantiated workout
    var workoutPlan: WorkoutPlan?
    // Activity workouts being read
    var activeWorkoutObservers: [Workout: (ref: DatabaseReference, handle: DatabaseHandle)]
    // User's history
    var history: History?
    
    init() {
        self.activeWorkoutObservers = [:]
        self.workoutPlansRef = nil
        
    }
    
    func listen(onPlan: @escaping WorkoutPlanCallback,
                onHistory: @escaping FetchHistoryCallback) {
        let dispatcher = DispatchGroup()
        
        dispatcher.enter()
        self.fetchWorkoutPlan(with: { workoutPlan in
            dispatcher.leave()
        })
        
        dispatcher.enter()
        self.fetchHistory(with: { history in
            onHistory(history)
            dispatcher.leave()
        })
        
        
        // If it is a new week of training, rollover the plan
        dispatcher.notify(queue: .main) {
            let isRolling = self.rolloverIfNecessary()
            onPlan(self.workoutPlan!, isRolling)
        }
    }
    
    func fetchWorkoutPlan(with callback: @escaping FetchWorkoutPlanCallback) {
        let user = UserAccountManager.Instance.current!
        self.workoutPlansRef = Database.database().reference(
            withPath:  String(format: WorkoutManager.kCurrentPlanPathFmt,
                              user.uid))
        
        workoutPlansRef!.observe(.value, with: { snapshot in
            Log.debug("Workout plan updated")
            self.workoutPlan = WorkoutPlan(snapshot)
            
            //Return info to caller
            callback(self.workoutPlan!)
        })
    }
    
    func fetchHistory(with callback: @escaping FetchHistoryCallback) {
        let user = UserAccountManager.Instance.current!
        let historyRef = Database.database().reference(
            withPath:String(format: WorkoutManager.kHistoryPathFmt, user.uid))
        
        historyRef.queryLimited(toLast: 10).observeSingleEvent(
            of: .value,
            with: { (snapshot) in
                Log.debug("Workout history updated")
                self.history = History(snapshot)
                
                // Return to caller
                callback(self.history!)
        })
        
    }
    
    func rolloverIfNecessary() -> Bool {
        if (self.workoutPlan == nil || self.history == nil) {
            Log.error("Plan and/or history not loaded. Failing to rollover")
            return false
        }
        
        var plan = self.workoutPlan!
        
        if intervalInDays(for: plan.startDate, and: Date())
                == WorkoutManager.kRolloverIntervalDays {
            Log.info("Rolling over current plan")
            
            if (self.history != nil) {
                let historyEntry = HistoryEntry(from: self.workoutPlan!)
                history?.add(entry: historyEntry)
                // Push to store
                // TODO error handling
                history?.save()
            }
            
            let newPlan = WorkoutPlan.reset(from: plan, for: Date())
            
            // Rolling over writes the new plan on the same location therefore
            // we copy the store reference
            newPlan.ref = plan.ref
            
            // Push to store
            // TODO error handling
            newPlan.save()
            return true
        }
        return false
    }
    
    /**
     * MARK: Workout and Exercise listing
     */
    
    func save(_ workout: Workout) {
        Log.debug("Saving workout \(workout.id)")
        workout.save()
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
