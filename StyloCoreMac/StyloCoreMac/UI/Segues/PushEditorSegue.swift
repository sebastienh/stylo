//
//  PushEditorSegue.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-01-25.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
//import Cocoa
//
//final class PushEditorSegue: NSStoryboardSegue {
//    
//    override init(identifier: NSStoryboardSegue.Identifier, source sourceController: Any, destination destinationController: Any) {
//        
//        super.init(identifier: identifier, source: sourceController, destination: destinationController)
//    }
//    
//    override func perform() {
//        
//        // we need to get the object we want to edit here, we will use
//        // a simple protocol to implement that
//        let viewController = self.sourceController as? NSViewController
//        let destinationController = self.destinationController as? NSViewController
//        
//        assert(viewController != nil)
//        assert(destinationController != nil)
//        if let viewController = viewController, let destinationController = destinationController {
//
//            if let cssViewController = viewController as? CSSViewController {
//                
//                (cssViewController as AnyObject).present(destinationController, animator: PushAnimator())
//            }
//        }
//    }
//}
