//
//  DocumentLoadActivityAnimator.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-08-11.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import QuartzCore
import WriterCommon

final class DocumentLoadActivityAnimator: NSObject, NSViewControllerPresentationAnimator {


    let pushAnimationTimeInterval: TimeInterval = 0.3
    
    func animatePresentation(of viewController: NSViewController, from fromViewController: NSViewController) {
        
        viewController.view.wantsLayer = true
        
        fromViewController.addChild(viewController)
        
        let fromViewControllerRect = fromViewController.view.frame //contentRect
        
        viewController.view.frame = NSMakeRect(0, // x
            0, // y
            NSWidth(fromViewControllerRect), // width
            NSHeight(fromViewControllerRect)); // height
        
        // see http://stackoverflow.com/questions/30761996/swift-2-0-binary-operator-cannot-be-applied-to-two-uiusernotificationtype
        viewController.view.autoresizingMask = [NSView.AutoresizingMask.height, NSView.AutoresizingMask.width]
        
        fromViewController.view.addSubview(viewController.view, positioned: NSWindow.OrderingMode.above, relativeTo: nil)
    }
    
    func animateDismissal(of viewController: NSViewController, from fromViewController: NSViewController) {
        
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
}
