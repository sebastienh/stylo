//
//  PushFromBottomAnimator.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2015-12-28.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa

final class PushFromBottomAnimator: NSObject, NSViewControllerPresentationAnimator {

    let pushAnimationTimeInterval: TimeInterval = 0.3
    
    func animatePresentation(of viewController: NSViewController, from fromViewController: NSViewController) {
        
        let fromViewControllerRect = fromViewController.view.frame
        
        viewController.view.frame = NSMakeRect(
            0, // x
            -NSHeight(fromViewControllerRect), // y
            NSWidth(fromViewControllerRect), // width
            NSHeight(fromViewControllerRect)); // height
        
        // see http://stackoverflow.com/questions/30761996/swift-2-0-binary-operator-cannot-be-applied-to-two-uiusernotificationtype
        viewController.view.autoresizingMask = [NSView.AutoresizingMask.height, NSView.AutoresizingMask.width]
        
        fromViewController.view.addSubview(viewController.view)
        
        let destinationRect: NSRect = fromViewControllerRect
        
        NSAnimationContext.runAnimationGroup(
            { context in
                
                // Customize the animation parameters.
                
                context.duration = self.pushAnimationTimeInterval
                context.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                viewController.view.animator().frame = destinationRect
            },
            completionHandler: nil
        )
    }
    
    func animateDismissal(of viewController: NSViewController, from fromViewController: NSViewController) {
        
        let destinationRect: NSRect = NSMakeRect(
            0, // x
            -NSHeight(fromViewController.view.frame), // y
            NSWidth(fromViewController.view.frame), // width
            NSHeight(fromViewController.view.frame)); // height
        
        NSAnimationContext.runAnimationGroup(
            { context in
                
                // Customize the animation parameters.
                context.duration = self.pushAnimationTimeInterval
                context.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                
                viewController.view.animator().frame = destinationRect
            },
            completionHandler: {
                
                viewController.view.removeFromSuperview()
            }
        )
        
    }
    
}
