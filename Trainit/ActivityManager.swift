//
//  ActivityManager.swift
//  Trainit
//
//  Created by Daniel Pereira on 5/24/17.
//  Copyright © 2017 Daniel Arraes. All rights reserved.
//

import Foundation

class ActivityManager {
    static let Instance = ActivityManager()
    
    // Keeps the list of the activities that are default to all users
    static let defaultActivities: [Activity] = [
        Activity(type: "running",
                 title: "Running",
                 shortName: "Run",
                 icon: "running_icon",
                 theme: (254.0, 194.0, 0.0)),
        Activity(type: "biking",
                 title: "Biking",
                 shortName: "Bike",
                 icon: "biking_icon",
                 theme: (65.0, 156.0, 114.0)),
        Activity(type: "yoga",
                 title: "Yoga",
                 shortName: "Yoga",
                 icon: "yoga_icon",
                 theme: (130.0, 77.0, 159.0)),
        Activity(type: "swimming",
                 title: "Swimming",
                 shortName: "Swim",
                 icon: "swimming_icon",
                 theme: (3.0, 153.0, 226.0)),
        Activity(type: "cardio",
                 title: "Cardio",
                 shortName: "Cardio",
                 icon: "cardio_icon",
                 theme: (255.0, 103.0, 43.0)),
        Activity(type: "crossfit",
                 title: "Crossfit",
                 shortName: "Xfit",
                 icon: "crossfit_icon",
                 theme: (189.0, 47.0, 47.0)),
        Activity(type: "leg_training",
                 title: "Lower Body",
                 shortName: "Lower B",
                 icon: "leg_icon",
                 theme: (14.0, 88.0, 54.0)),
        Activity(type: "upper_body_training",
                 title: "Upper Body",
                 shortName: "Upper B",
                 icon: "weight_icon",
                 theme: (0.25, 0.25, 0.25)),
        Activity(type: "core",
                 title: "Core Strength",
                 shortName: "Core",
                 icon: "core_icon",
                 theme: (6.0, 57.0, 122.0))
    ]
    
    // Hashmap from type to activity
    var activities: [String: Activity] = [:]
    
    init() {
        for activity in ActivityManager.defaultActivities {
            self.activities[activity.type] = activity
        }
        
    }
    
    func activity(by type: String) -> Activity {
        return activities[type]!
    }
}
