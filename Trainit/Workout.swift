//
//  WorkoutRun.swift
//  Trainit
//
//  Created by Daniel Pereira on 5/23/17.
//  Copyright © 2017 Daniel Arraes. All rights reserved.
//

import Foundation
import Firebase

class Workout {
    
    let id: String
    let type: String
    let sessionsPerWeek: Int
    var completed: Int
    var plan: WorkoutPlan?
    
    init(id: String, type: String, sessionsPerWeek: Int, completed: Int) {
        self.id = id
        self.type = type
        self.sessionsPerWeek = sessionsPerWeek
        self.completed = completed
        self.plan = nil
    }
    
    init(_ snapshot: DataSnapshot) {
        let workout = snapshot.value as! [String: AnyObject]
        self.id = workout["id"] as! String
        self.type = workout["type"] as! String
        self.sessionsPerWeek = workout["sessions_per_week"] as! Int
        self.completed = workout["completed"] as! Int
    }
    
    func setOwnerPlan(_ plan: WorkoutPlan) {
        self.plan = plan
    }
    
    func save() {
        // The reference lives in the wrapping plan so we saved it from there
        self.plan!.save()
    }
    
    func toAnyObject() -> Any {
        return [
            "id": self.id,
            "type": self.type,
            "completed": self.completed,
            "sessions_per_week": self.sessionsPerWeek
        ]
    }
}
