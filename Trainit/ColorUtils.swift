//
//  Color.swift
//  Trainit
//
//  Created by Daniel Pereira on 5/25/17.
//  Copyright © 2017 Daniel Arraes. All rights reserved.
//

import Foundation
import UIKit

func getColor(for activity: Activity) -> UIColor {
    return UIColor(
        red: CGFloat(activity.themeColorRgb.red),
        green: CGFloat(activity.themeColorRgb.green ),
        blue: CGFloat(activity.themeColorRgb.blue),
        alpha: 1.0)
    
}

func rgbColor(_ rgb: (red: Float, green: Float, blue: Float)) -> UIColor{
    return UIColor(
        red: CGFloat(rgb.red / 255.0),
        green: CGFloat(rgb.green / 255.0),
        blue: CGFloat(rgb.blue / 255.0),
        alpha: 1.0)
}

func getDefaultNavBarColor() -> UIColor {
    return UIColor(
        red: CGFloat(67.0 / 255.0),
        green: CGFloat(130.0 / 255.0),
        blue: CGFloat(144.0 / 255.0),
        alpha: 1.0)
}
