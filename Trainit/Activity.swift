//
//  Activity.swift
//  Trainit
//
//  Created by Daniel Pereira on 5/24/17.
//  Copyright © 2017 Daniel Arraes. All rights reserved.
//

import Foundation

class Activity {
    
    let type: String
    let title: String
    let icon: String
    let banner: String
    var themeColorRgb: (red: Float, green: Float, blue: Float)
    
    init(type: String,
         title: String,
         icon: String,
         banner: String,
         themeColorRgb: (Float, Float, Float)) {
        self.type = type
        self.title = title
        self.icon = icon
        self.banner = banner
        self.themeColorRgb = themeColorRgb
    }
}
