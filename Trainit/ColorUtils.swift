//
//  Color.swift
//  Trainit
//
//  Created by Daniel Pereira on 5/25/17.
//  Copyright © 2017 Daniel Arraes. All rights reserved.
//

import Foundation
import UIKit

typealias RGB = (red: Float, green: Float, blue: Float)

class ColorUtils {
    static func rgbColor(_ rgb: RGB) -> UIColor {
            return UIColor(
                red: CGFloat(rgb.red / 255.0),
                green: CGFloat(rgb.green / 255.0),
                blue: CGFloat(rgb.blue / 255.0),
                alpha: 1.0)
    }
    
    static func getColor(for activity: Activity) -> UIColor {
        return UIColor(
            red: CGFloat(activity.theme.red / 255.0),
            green: CGFloat(activity.theme.green / 255.0),
            blue: CGFloat(activity.theme.blue / 255.0),
            alpha: 1.0)
        
    }
    
    static func getDefaultNavBarColor() -> UIColor {
        return ColorUtils.rgbColor((
            red: 67.0, green: 130.0, blue: 144.0
        ))
    }
    
    static func grayScale(_ rate: Float) -> UIColor {
        return UIColor(
            red: CGFloat(rate),
            green: CGFloat(rate),
            blue: CGFloat(rate),
            alpha: 1.0)
    }
}





