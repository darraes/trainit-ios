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
    
    let id: String
    var workouts: [Workout]
    let ref: DatabaseReference?
    
    init(id: String) {
        self.id = id
        self.workouts = []
        self.ref = nil
    }
    
    init(id: String, workouts: [Workout]) {
        self.id = id
        self.workouts = workouts
        self.ref = nil
        sortOnCompletion()
    }
    
    init(_ snapshot: DataSnapshot) {
        self.workouts = []
        self.ref = snapshot.ref
        
        let plan = snapshot.value as! [String: AnyObject]
        self.id = plan["id"] as! String
        
        let workouts = snapshot.childSnapshot(forPath: "workouts")
        for workout in workouts.children {
            self.add(workout: Workout(workout as! DataSnapshot))
        }
        sortOnCompletion()
    }
    
    func toAnyObject() -> Any {
        return []
    }
    
    func add(workout: Workout) {
        self.workouts.append(workout)
        sortOnCompletion()
    }
    
    func workoutCount() -> Int {
        return self.workouts.count
    }
    
    func sortOnCompletion() {
        self.workouts.sort(by:{ (left, right) in
            return (left.sessionsPerWeek - left.completed)
                    > (right.sessionsPerWeek - right.completed)
        })
    }
}
