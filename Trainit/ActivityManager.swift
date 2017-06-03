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
    
    var activities: [String: Activity]
    
    init() {
        activities = [:]
        activities["running"] = Activity(type: "running",
                                         title: "Running",
                                         shortName: "Run",
                                         icon: "running_icon",
                                         themeColorRgb: (254.0 / 255.0,
                                                         194.0 / 255.0,
                                                         0.0 / 255.0))
        
        activities["biking"] = Activity(type: "biking",
                                        title: "Biking",
                                        shortName: "Bike",
                                        icon: "biking_icon",
                                        themeColorRgb: (65.0 / 255.0,
                                                        156.0 / 255.0,
                                                        114.0 / 255.0))
        
        activities["yoga"] = Activity(type: "yoga",
                                      title: "Yoga",
                                      shortName: "Yoga",
                                      icon: "yoga_icon",
                                      themeColorRgb: (130.0 / 255.0,
                                                      77.0 / 255.0,
                                                      159.0 / 255.0))
        
        activities["swimming"] = Activity(type: "swimming",
                                          title: "Swimming",
                                          shortName: "Swim",
                                          icon: "swimming_icon",
                                          themeColorRgb: (3.0 / 255.0,
                                                          153.0 / 255.0,
                                                          226.0 / 255.0))
        
        activities["cardio"] = Activity(type: "cardio",
                                        title: "Cardio",
                                        shortName: "Cardio",
                                        icon: "cardio_icon",
                                        themeColorRgb: (255.0 / 255.0,
                                                        103.0 / 255.0,
                                                        43.0 / 255.0))
        
        activities["crossfit"] = Activity(type: "crossfit",
                                          title: "Crossfit",
                                          shortName: "Xfit",
                                          icon: "crossfit_icon",
                                          themeColorRgb: (189.0 / 255.0,
                                                          47.0 / 255.0,
                                                          47.0 / 255.0))
        
        activities["leg_training"] = Activity(type: "leg_training",
                                              title: "Lower Body",
                                              shortName: "Lower B",
                                              icon: "leg_icon",
                                              themeColorRgb: (14.0 / 255.0,
                                                              88.0 / 255.0,
                                                              54.0 / 255.0))
        
        activities["upper_body_training"] = Activity(
            type: "upper_body_training",
            title: "Upper Body",
            shortName: "Upper B",
            icon: "weight_icon",
            themeColorRgb: (0.25, 0.25, 0.25))
        
        activities["core"] = Activity(type: "core",
                                      title: "Core Strength",
                                      shortName: "Core",
                                      icon: "core_icon",
                                      themeColorRgb: (6.0 / 255.0,
                                                      57.0 / 255.0,
                                                      122.0 / 255.0))
        
    }
    
    func activity(by type: String) -> Activity {
        return activities[type]!
    }
}
