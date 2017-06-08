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
    let shortName: String
    let icon: String
    var theme: RGB
    
    init(type: String,
         title: String,
         shortName: String,
         icon: String,
         theme: RGB) {
        self.type = type
        self.title = title
        self.shortName = shortName
        self.icon = icon
        self.theme = theme
    }
}
