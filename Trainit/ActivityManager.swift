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
                                         icon: "running_icon",
                                         banner: "running_banner",
                                         themeColorRgb: (254.0 / 255.0,
                                                         194.0 / 255.0,
                                                         0.0 / 255.0))
        
        activities["biking"] = Activity(type: "biking",
                                        title: "Biking",
                                        icon: "biking_icon",
                                        banner: "biking_banner",
                                        themeColorRgb: (65.0 / 255.0,
                                                        156.0 / 255.0,
                                                        114.0 / 255.0))
        
        activities["yoga"] = Activity(type: "yoga",
                                      title: "Yoga",
                                      icon: "yoga_icon",
                                      banner: "yoga_banner",
                                      themeColorRgb: (130.0 / 255.0,
                                                      77.0 / 255.0,
                                                      159.0 / 255.0))
        
        activities["swimming"] = Activity(type: "swimming",
                                          title: "Swimming",
                                          icon: "swimming_icon",
                                          banner: "swimming_banner",
                                          themeColorRgb: (3.0 / 255.0,
                                                          153.0 / 255.0,
                                                          226.0 / 255.0))
        
        activities["cardio"] = Activity(type: "cardio",
                                        title: "Cardio",
                                        icon: "cardio_icon",
                                        banner: "cardio_banner",
                                        themeColorRgb: (255.0 / 255.0,
                                                        103.0 / 255.0,
                                                        43.0 / 255.0))
        
        activities["crossfit"] = Activity(type: "crossfit",
                                          title: "Crossfit",
                                          icon: "crossfit_icon",
                                          banner: "crossfit_banner",
                                          themeColorRgb: (189.0 / 255.0,
                                                          47.0 / 255.0,
                                                          47.0 / 255.0))
        
        activities["leg_training"] = Activity(type: "leg_training",
                                              title: "Lower Body",
                                              icon: "leg_icon",
                                              banner: "leg_training_banner",
                                              themeColorRgb: (14.0 / 255.0,
                                                              88.0 / 255.0,
                                                              54.0 / 255.0))
        
        activities["upper_body_training"] = Activity(
            type: "upper_body_training",
            title: "Upper Body",
            icon: "weight_icon",
            banner: "weight_banner",
            themeColorRgb: (0.25, 0.25, 0.25))
        
        activities["core"] = Activity(type: "core",
                                        title: "Core Strength",
                                        icon: "core_icon",
                                        banner: "core_training_banner",
                                        themeColorRgb: (6.0 / 255.0,
                                                        57.0 / 255.0,
                                                        122.0 / 255.0))
        
    }
    
    func activity(by type: String) -> Activity {
        return activities[type]!
    }
}
