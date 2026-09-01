//
//  Color+DebugPrinting.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-10-14.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation

#if os(OSX)
    import Cocoa
    #elseif os(iOS)
    import UIKit
#endif

#if os(OSX)
    typealias DebugPrintingPlateformColorType = NSColor
    #elseif os(iOS)
    typealias DebugPrintingPlateformColorType = UIColor
#endif

//extension DebugPrintingPlateformColorType {
//    
//    
//    func colorComponents() -> [CGFloat] {
//        
//        var fRed : CGFloat = 0
//        var fGreen : CGFloat = 0
//        var fBlue : CGFloat = 0
//        var fAlpha: CGFloat = 0
//        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
//            let iRed = Int(fRed * 255.0)
//            let iGreen = Int(fGreen * 255.0)
//            let iBlue = Int(fBlue * 255.0)
//            let iAlpha = Int(fAlpha * 255.0)
//            
//            //  (Bits 24-31 are alpha, 16-23 are red, 8-15 are green, 0-7 are blue).
//            let rgb = (iAlpha << 24) + (iRed << 16) + (iGreen << 8) + iBlue
//            return rgb
//        } else {
//            // Could not extract RGBA components:
//            return nil
//        }
//        
//    }
//    
//    
//    
//}
