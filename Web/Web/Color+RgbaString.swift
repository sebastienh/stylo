//
//  Color+RgbaString.swift
//  Web
//
//  Created by Sébastien Hamel on 2017-06-27.
//  Copyright © 2017 NM. All rights reserved.
//

import Foundation
import Common
import os

#if os(OSX)
    import Cocoa
#elseif os(iOS)
    import UIKit
#endif

#if os(OSX)
    typealias StringPlateformColorType = NSColor
#elseif os(iOS)
    typealias StringPlateformColorType = UIColor
#endif

extension StringPlateformColorType {
    
    public convenience init(rgba: String) {
        
        if rgba.hasPrefix("rgba") {
            
            let rbgaString     = rgba.substr(5, end: rgba.length - 1)
            let scanner = Scanner(string: rbgaString!)
            
            var red: Int = 0
            scanner.scanInt(&red)
            scanner.scanString(",", into: nil)
            
            var green: Int = 0
            scanner.scanInt(&green)
            scanner.scanString(",", into: nil)
            
            var blue: Int = 0
            scanner.scanInt(&blue)
            scanner.scanString(",", into: nil)
            
            var alpha: Float = 0
            scanner.scanFloat(&alpha)
            
            let redF: CGFloat = CGFloat(CGFloat(red)/CGFloat(255))
            let greenF: CGFloat = CGFloat(CGFloat(green)/CGFloat(255))
            let blueF: CGFloat = CGFloat(CGFloat(blue)/CGFloat(255))
            
            self.init(red: redF, green: greenF, blue: blueF, alpha: CGFloat(alpha))
        }
        else if rgba.hasPrefix("rgb") {
            
            let rbgaString = rgba.substr(4, end: rgba.length - 1)
            let scanner = Scanner(string: rbgaString!)
            
            var red: Int = 0
            scanner.scanInt(&red)
            scanner.scanString(",", into: nil)
            
            var green: Int = 0
            scanner.scanInt(&green)
            scanner.scanString(",", into: nil)
            
            var blue: Int = 0
            scanner.scanInt(&blue)
            
            let redF: CGFloat = CGFloat(CGFloat(red)/CGFloat(255))
            let greenF: CGFloat = CGFloat(CGFloat(green)/CGFloat(255))
            let blueF: CGFloat = CGFloat(CGFloat(blue)/CGFloat(255))

            self.init(red: redF, green: greenF, blue: blueF, alpha: 1.0)
        }
        else {
        
            assert(false, "wrong color function")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Wrong color function: %@.", log: Log.Web.all, type: .error, %%rgba)
            #endif
            self.init(red: 1, green: 1, blue: 1, alpha: 1.0)
        }
    }
    
    
    
}
