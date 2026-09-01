//
//  ColorUtils.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-10-08.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation
import CoreImage
import Common

final class ColorUtils {
    
    internal class func convertHSLAToCIColor(_ h: CGFloat, s: CGFloat, l: CGFloat, a: CGFloat) -> CIColor {
        
        let color = DynamicColor(calibratedHue: h, saturation: s, brightness: l, alpha: a)
        let (r, g, b, a) = color.toRGBAComponents()
        return CIColor(red: r, green: g, blue: b, alpha: CGFloat(a))
    }
}
