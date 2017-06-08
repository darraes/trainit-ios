//
//  WorkoutManager.swift
//  Trainit
//
//  Created by Daniel Pereira on 5/24/17.
//  Copyright © 2017 Daniel Arraes. All rights reserved.
//

import Foundation
import Firebase

typealias ExerciseListCallback = ([Exercise]) -> Void
typealias RollingCallback = (WorkoutPlan, History) -> Void
typealias WorkoutPlanCallback = (WorkoutPlan) -> Void
typealias HistoryCallback = (History) -> Void

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
    // Workout exercise lists being observed
    var activeWorkoutObservers: [Workout: (ref: DatabaseReference, handle: DatabaseHandle)]
    // User's history
    var history: History?
    // used to wait for multiple requests in parallel
    var semaphore: DispatchGroup?
    
    init() {
        self.activeWorkoutObservers = [:]
        self.workoutPlansRef = nil
        
    }
    
    /**
     * Main method to get the workout plan and the workout history.
     *
     * This method adds an observer on the current workout plan and monitors any
     * update made to it. It also monitors when the plan is rolling over.
     *
     * For the history, it does a single query and loads the history from the
     * store since the rollover logic will update the in-memory history if
     * necessary
     *
     * @onPlan      Called if the current plan was updated. Live callback and will
     *              kept being called during life time of app
     * @onHistory   Called when we fetch the current history. Called just once
     * @onRollover  Called when the plan rolled over and a new plan and history
     are in effect
     */
    func listen(onPlan: @escaping WorkoutPlanCallback,
                onHistory: @escaping HistoryCallback,
                onRolling: @escaping RollingCallback) {
        Log.debug("Listening for user "
            + "\(UserAccountManager.Instance.current!.email)")
        
        // Semaphore is used to make sure that the very first call to
        // rolloverIfNecessary: is done when both the plan and the history are
        // already loaded.
        self.semaphore = DispatchGroup()
        
        self.semaphore!.enter()
        self.subscribeForPlan(with: { workoutPlan in
            onPlan(workoutPlan)
            
            // If history is loaded, those calls are most likely after view load
            // and therefore we should also check for rollover
            if self.history != nil {
                if self.rolloverIfNecessary() {
                    onRolling(self.workoutPlan!, self.history!)
                }
            }
            
            // The semaphore will only be active during the life of listen: and
            // not on the further observe: callbacks therefore we must check
            if (self.semaphore != nil) {
                self.semaphore!.leave()
            }
        })
        
        if self.history == nil {
            self.semaphore!.enter()
            self.fetchHistory(with: { history in
                onHistory(history)
                if (self.semaphore != nil) {
                    self.semaphore!.leave()
                }
            })
        }
        
        // If it is a new week of training, rollover the plan
        self.semaphore!.notify(queue: .main) {
            if self.rolloverIfNecessary() {
                onRolling(self.workoutPlan!, self.history!)
            }
        }
        
        self.semaphore = nil
    }
    
    /**
     * Subscribes the called to listen for changes on the current workout plan
     *
     * @callback   Returns the users workout plan - Called on every plan update
     */
    private func subscribeForPlan(with callback: @escaping WorkoutPlanCallback) {
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
    
    /**
     * Does a single fetch of the users workout history
     *
     * @callback   Returns the users workout history
     */
    private func fetchHistory(with callback: @escaping HistoryCallback) {
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
    
    /**
     * On a new week, the current's plan completions will be erased (roll over)
     * and added to the users history.
     * This process is the rollover so the user starts a new workout week
     *
     * @return    True if the rollover is happening. False otherwise
     */
    private func rolloverIfNecessary() -> Bool {
        return synced(self) {
            if (self.workoutPlan == nil || self.history == nil) {
                Log.error("Plan and/or history not loaded. Failing to rollover")
                return false
            }
            
            let plan = self.workoutPlan!
            let interval = intervalInDays(for: plan.startDate, and: Date())
            if (weekDay(for: Date()) == WeekDay.monday && interval > 0)
                || interval > WorkoutManager.kRolloverIntervalDays - 1
            {
                Log.info("Rolling over current plan")
                
                // TODO rolling must be transactional
                
                let historyEntry = HistoryEntry(from: self.workoutPlan!)
                self.history!.add(entry: historyEntry)
                
                // TODO error handling
                Log.debug("Saving updated history")
                self.history!.save()
                
                // Rolling over writes the new plan on the same location
                // therefore we copy the store reference
                let newPlan = WorkoutPlan.reset(from: plan,
                                                for: Date(),
                                                with: plan.ref)
                
                // TODO error handling
                Log.debug("Saving fresh workout plan")
                newPlan.save()
                return true
            }
            return false
        }
    }
    
    /**
     * Saves the @workout into the store
     */
    func save(_ workout: Workout) {
        Log.debug("Saving workout \(workout.id)")
        workout.save()
    }
    
    /**
     * Lists the exercises of a given workout
     *
     * @workout   Target workout
     * @callback  Returns the workout'exercise list
     */
    func listExercises(for workout: Workout,
                       with callback: @escaping ExerciseListCallback) {
        Log.debug("Listing exercises for workout \(workout.id)")
        
        let user = UserAccountManager.Instance.current!
        let exercisesRef = Database.database().reference(
            withPath:  String(format: WorkoutManager.kExercisePathFmt,
                              user.uid,
                              workout.id))
        
        exercisesRef.observeSingleEvent(
            of: .value,
            with: { snapshot in
                let exerciseWrapper = snapshot.value as! [String: AnyObject]
                let activityType = exerciseWrapper["activity-type"] as! String
                let listSnapshot = snapshot.childSnapshot(forPath: "list")
                var exercises: [Exercise] = []
                for exercise in listSnapshot.children {
                    exercises.append(Exercise(
                        exercise as! DataSnapshot, for: activityType))
                }
                callback(exercises)
        })
    }
}
