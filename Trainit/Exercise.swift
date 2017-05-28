//
//  Exercise.swift
//  Trainit
//
//  Created by Daniel Pereira on 5/28/17.
//  Copyright © 2017 Daniel Arraes. All rights reserved.
//

import Foundation

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
    let type: ExerciseType
    let title: String
    
    init (type: ExerciseType, title: String) {
        self.type = type
        self.title = title
    }
}

class RepetitionExercise : Exercise {
    var sessions: Int
    var repetitions: Int
    
    init (title: String, sessions: Int, repetitions: Int) {
        self.sessions = sessions
        self.repetitions = repetitions
        super.init(type: ExerciseType.repetition, title: title)
    }
}

class TimedExercise : Exercise{
    var time: Int
    var timeUnit: TimeUnit
    
    init (title: String, time: Int, timeUnit: TimeUnit) {
        self.time = time
        self.timeUnit = timeUnit
        super.init(type: ExerciseType.repetition, title: title)
    }
}

class TimedRepetitionExercise : Exercise{
    var time: Int
    var timeUnit: TimeUnit
    var sessions: Int
    
    init (title: String, sessions: Int, time: Int, timeUnit: TimeUnit) {
        self.sessions = sessions
        self.time = time
        self.timeUnit = timeUnit
        super.init(type: ExerciseType.repetition, title: title)
    }
}
