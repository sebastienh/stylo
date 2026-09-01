//
//  PushSegue.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2015-07-29.
//  Copyright (c) 2015 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa

final class PushSegue: NSStoryboardSegue {
    
    override init(identifier: NSStoryboardSegue.Identifier, source sourceController: Any, destination destinationController: Any) {
        
        super.init(identifier: identifier, source: sourceController, destination: destinationController)
    }

    override func perform() {
        
        // we need to get the object we want to edit here, we will use
        // a simplement protocol to implement that
        
        
        (self.sourceController as AnyObject).present(self.destinationController as! NSViewController, animator: PushAnimator(pushAnimationTimeInterval: 0.2, dismissAnimationInterval: 0.2))
    }
    
}
