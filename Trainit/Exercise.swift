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
    let routine: Routine
    let notes: String?
    
    init (type: ExerciseType, title: String, notes: String, routine: Routine) {
        self.type = type
        self.title = title
        self.notes = notes
        self.routine = routine
    }
    
    init(_ snapshot: DataSnapshot) {
        let exercise = snapshot.value as! [String: AnyObject]
        self.title = exercise["title"] as! String
        self.notes = exercise["notes"] as? String
        self.type = ExerciseType(rawValue: exercise["type"] as! String)!
        if (type == .repetition) {
            self.routine = RepetitionRoutine(
                snapshot.childSnapshot(forPath: "routine"))
        } else if (type == .timed_repetition) {
            self.routine = TimedRepetitionRoutine(
                snapshot.childSnapshot(forPath: "routine"))
        } else {
            self.routine = TimedRoutine(
                snapshot.childSnapshot(forPath: "routine"))
        }
    }
    
    func infoStr() -> String {
        return self.routine.infoStr()
    }
    
    func typeStr() -> String {
        return self.routine.typeStr()
    }
}

protocol Routine {
    func infoStr() -> String
    func typeStr() -> String
}

class RepetitionRoutine : Routine {
    let sessions: Int
    let repetitions: Int
    
    init (sessions: Int, repetitions: Int) {
        self.sessions = sessions
        self.repetitions = repetitions
    }
    
    init(_ snapshot: DataSnapshot) {
        let routine = snapshot.value as! [String: AnyObject]
        self.sessions = routine["sessions"] as! Int
        self.repetitions = routine["repetitions"] as! Int
    }
    
    func infoStr() -> String {
        return "\(self.sessions)/\(self.repetitions)"
    }
    
    func typeStr() -> String {
        return "Reps"
    }
}

class TimedRoutine : Routine {
    let time: Int
    let timeUnit: TimeUnit
    
    init (time: Int, timeUnit: TimeUnit) {
        self.time = time
        self.timeUnit = timeUnit
    }
    
    init(_ snapshot: DataSnapshot) {
        let routine = snapshot.value as! [String: AnyObject]
        self.time = routine["time"] as! Int
        self.timeUnit = TimeUnit(rawValue: routine["unit"] as! String)!
    }
    
    func infoStr() -> String {
        return "\(self.time)"
    }
    
    func typeStr() -> String {
        return timeUtilStr(self.timeUnit)
    }
}

class TimedRepetitionRoutine : Routine {
    let time: Int
    let timeUnit: TimeUnit
    let sessions: Int
    
    init (sessions: Int, time: Int, timeUnit: TimeUnit) {
        self.sessions = sessions
        self.time = time
        self.timeUnit = timeUnit
    }
    
    init(_ snapshot: DataSnapshot) {
        let routine = snapshot.value as! [String: AnyObject]
        self.sessions = routine["sessions"] as! Int
        self.time = routine["time"] as! Int
        self.timeUnit = TimeUnit(rawValue: routine["unit"] as! String)!
    }
    
    func infoStr() -> String {
        return "\(self.sessions)/\(self.time)"
    }
    
    func typeStr() -> String {
        return timeUtilStr(self.timeUnit)
    }
}
