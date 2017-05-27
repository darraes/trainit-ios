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
                                         themeColorRgb: (240.0 / 275.0,
                                                         209.0 / 275.0,
                                                         141.0 / 275.0))
        
        activities["biking"] = Activity(type: "biking",
                                        title: "Biking",
                                        icon: "biking_icon",
                                        themeColorRgb: (65.0 / 255.0,
                                                        156.0 / 255.0,
                                                        114.0 / 255.0))
        
        activities["yoga"] = Activity(type: "yoga",
                                      title: "Yoga",
                                      icon: "yoga_icon",
                                      themeColorRgb: (160.0 / 255.0,
                                                      94.0 / 255.0,
                                                      196.0 / 255.0))
        
        activities["swimming"] = Activity(type: "swimming",
                                          title: "Swimming",
                                          icon: "swimming_icon",
                                          themeColorRgb: (3.0 / 255.0,
                                                          153.0 / 255.0,
                                                          226.0 / 255.0))
        
        activities["cardio"] = Activity(type: "cardio",
                                        title: "Cardio",
                                        icon: "cardio_icon",
                                        themeColorRgb: (255.0 / 255.0,
                                                        103.0 / 255.0,
                                                        43.0 / 255.0))
        
        activities["sports"] = Activity(type: "sports",
                                        title: "Sports",
                                        icon: "sports_icon",
                                        themeColorRgb: (6.0 / 255.0,
                                                        57.0 / 255.0,
                                                        122.0 / 255.0))
        
        activities["crossfit"] = Activity(type: "crossfit",
                                          title: "Crossfit",
                                          icon: "crossfit_icon",
                                          themeColorRgb: (189.0 / 255.0,
                                                          47.0 / 255.0,
                                                          47.0 / 255.0))
        
        activities["leg_training"] = Activity(type: "leg_training",
                                              title: "Leg Training",
                                              icon: "leg_icon",
                                              themeColorRgb: (28.0 / 255.0,
                                                              114.0 / 255.0,
                                                              120.0 / 255.0))
        
        activities["upper_body_training"] = Activity(
            type: "upper_body_training",
            title: "Upper Body",
            icon: "weight_icon",
            themeColorRgb: (0.25, 0.25, 0.25))
        
    }
    
    func activity(by type: String) -> Activity {
        return activities[type]!
    }
}
