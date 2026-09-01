//
//  PushThemeEditorSegue.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-08-12.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import StyloCoreMac

final class PushThemeEditorSegue: NSStoryboardSegue {
    
    // public init(identifier: NSStoryboardSegue.Identifier, source sourceController: Any, destination destinationController: Any)
    override init(identifier: NSStoryboardSegue.Identifier, source sourceController: Any, destination destinationController: Any) {
        
        super.init(identifier: identifier, source: sourceController, destination: destinationController)
    }
    
    override func perform() {
        
        // we need to get the object we want to edit here, we will use
        // a simple protocol to implement that
        
        if let viewController = self.sourceController as? NSViewController {
            
            if let themeSetViewController = viewController as? ThemeSetViewController {
                
                (themeSetViewController as AnyObject).present(self.destinationController as! NSViewController, animator: PushAnimator())
            }
        }
    }
}
