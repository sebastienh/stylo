//
//  AppleDevice.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-22.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

public final class AppleDevice: Device {
    
    /// see http://supermegaultragroovy.com/2012/10/24/coding-for-high-resolution-on-os-x-read-this/
    
//    - (void)viewDidChangeBackingProperties {
//        self.layer.contentsScale = [[self window] backingScaleFactor];
//        self.someOtherLayer.contentsScale = self.layer.contentsScale;
//        self.yetAnotherLayer.contentsScale = self.layer.contentsScale;
//    // and so on...
//    }
//    
//    - (void)viewDidChangeBackingProperties {
//        [super viewDidChangeBackingProperties];
//        [[self layer] setContentsScale:[[self window] backingScaleFactor]];
//    }
    
    
    func convertCSSPixelToPoint(_ cssPixelValue: CGFloat) -> CGFloat {
        
        // for apple devices the point represent the reference pixel 
        // size : there is 96 points per inch, which can be physically 
        // represented by more than one pixel (actually 4 on retina display). 
        return cssPixelValue
    }
    
}
