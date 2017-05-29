//
//  Exercise.swift
//  Trainit
//
//  Created by Daniel Pereira on 5/28/17.
//  Copyright © 2017 Daniel Arraes. All rights reserved.
//

import Foundation
import Firebase

enum ExerciseType: String
{
    case repetition = "rep"
    case time = "time"
    case timed_repetition = "timed_rep"
}

enum TimeUnit: String
{
    case second = "sec"
    case minute = "min"
}

class Exercise {
    // TODO add activity type
    let type: ExerciseType
    let title: String
    var routine: Routine?
    
    init (type: ExerciseType, title: String, routine: Routine) {
        self.type = type
        self.title = title
        self.routine = routine
    }
    
    init(_ snapshot: DataSnapshot) {
        let exercise = snapshot.value as! [String: AnyObject]
        self.title = exercise["title"] as! String
        self.type = ExerciseType(rawValue: exercise["type"] as! String)!
        if (type == .repetition) {
            self.routine = RepetitionRoutine(
                snapshot.childSnapshot(forPath: "routine"))
        }
        self.routine = nil
    }
}

protocol Routine { }

class RepetitionRoutine : Routine {
    var sessions: Int
    var repetitions: Int
    
    init (sessions: Int, repetitions: Int) {
        self.sessions = sessions
        self.repetitions = repetitions
    }
    
    init(_ snapshot: DataSnapshot) {
        let routine = snapshot.value as! [String: AnyObject]
        self.sessions = routine["sessions"] as! Int
        self.repetitions = routine["repetitions"] as! Int
    }
}

class TimedRoutine : Routine {
    var time: Int
    var timeUnit: TimeUnit
    
    init (time: Int, timeUnit: TimeUnit) {
        self.time = time
        self.timeUnit = timeUnit
    }
}

class TimedRepetitionRoutine : Routine {
    var time: Int
    var timeUnit: TimeUnit
    var sessions: Int
    
    init (sessions: Int, time: Int, timeUnit: TimeUnit) {
        self.sessions = sessions
        self.time = time
        self.timeUnit = timeUnit
    }
}
