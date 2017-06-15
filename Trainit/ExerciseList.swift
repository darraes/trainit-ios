//
//  ExerciseList.swift
//  Trainit
//
//  Created by Daniel Pereira on 6/14/17.
//  Copyright © 2017 Daniel Arraes. All rights reserved.
//

import Foundation
import Firebase

enum ExerciseListType: String
{
    case simple = "simple"
}

class ExerciseList {
    let type: ExerciseListType
    let activityType: String
    let exercises: [Exercise]
    
    init(_ snapshot: DataSnapshot) {
        let exerciseWrapper = snapshot.value as! [String: AnyObject]
        
        self.type = ExerciseListType(
            rawValue: exerciseWrapper["type"] as! String)!
        self.activityType = exerciseWrapper["activity-type"] as! String
        
        let listSnapshot = snapshot.childSnapshot(forPath: "list")
        var myexercises: [Exercise] = []
        for exercise in listSnapshot.children {
            myexercises.append(Exercise(
                exercise as! DataSnapshot, for: activityType))
        }
        self.exercises = myexercises
    }
}
