//
//  DomInspectorTextField.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2016-01-10.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa

final class DomInspectorTextField: NSTextField {
    
//    override var allowsVibrancy: Bool {
//        
//        return true
//    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
    }
    
//    // see http://stackoverflow.com/questions/10463680/how-to-let-nstextfield-grow-with-the-text-in-auto-layout 
//    override var intrinsicContentSize: NSSize {
//        
//        if !cell!.wraps {
//            
//            return super.intrinsicContentSize
//        }
//        
//        var frame = self.frame
//        
//        let width = NSWidth(frame)
//        
//        // Make the frame very high, while keeping the width
//        frame.size.height = CGFloat.max
//        
//        // Calculate new height within the frame
//        // with practically infinite height.
//        let height: CGFloat = self.cell!.cellSizeForBounds(frame).height
//        
//        return NSMakeSize(width, height)
//    }
    
//    
//    -(NSSize)intrinsicContentSize
//    {
//    if ( ![self.cell wraps] ) {
//    return [super intrinsicContentSize];
//    }
//    
//    NSRect frame = [self frame];
//    
//    CGFloat width = frame.size.width;
//    
//    // Make the frame very high, while keeping the width
//    frame.size.height = CGFLOAT_MAX;
//    
//    // Calculate new height within the frame
//    // with practically infinite height.
//    CGFloat height = [self.cell cellSizeForBounds: frame].height;
//    
//    return NSMakeSize(width, height);
//    }
    
    
    
    
    
    
}
