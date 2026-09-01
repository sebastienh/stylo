//
//  PushThemeEditorAnimator.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-08-12.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import QuartzCore
import WriterCommon

public final class PushAnimator: NSObject, NSViewControllerPresentationAnimator {
    
    let pushAnimationTimeInterval: TimeInterval
    let dismissAnimationInterval: TimeInterval
    
    public init(pushAnimationTimeInterval: TimeInterval = 0.3, dismissAnimationInterval: TimeInterval = 0.3) {
        
        self.pushAnimationTimeInterval = pushAnimationTimeInterval
        self.dismissAnimationInterval = dismissAnimationInterval
        super.init()
    }
    
    public func animatePresentation(of viewController: NSViewController, from fromViewController: NSViewController) {
            
        fromViewController.addChild(viewController)
        
        let fromViewControllerRect = fromViewController.view.frame
        
        viewController.view.frame = NSMakeRect(NSWidth(fromViewControllerRect),
                                               0,
                                               NSWidth(fromViewControllerRect),
                                               NSHeight(fromViewControllerRect))
        
        fromViewController.view.addSubview(viewController.view, positioned: NSWindow.OrderingMode.above, relativeTo: nil)
        
        // see http://stackoverflow.com/questions/30761996/swift-2-0-binary-operator-cannot-be-applied-to-two-uiusernotificationtype
        viewController.view.autoresizingMask = [NSView.AutoresizingMask.height, NSView.AutoresizingMask.width]
        viewController.view.wantsLayer = true
        viewController.view.layerContentsRedrawPolicy = .onSetNeedsDisplay
        viewController.view.needsLayout = true
        viewController.view.layoutSubtreeIfNeeded()
        
        // fromViewController
        fromViewController.view.wantsLayer = true
        fromViewController.view.layerContentsRedrawPolicy = .onSetNeedsDisplay
        fromViewController.view.needsLayout = true
        fromViewController.view.layoutSubtreeIfNeeded()
        
        let destinationRect: NSRect = fromViewControllerRect
        
        NSAnimationContext.runAnimationGroup(
            { context in
                
                // Customize the animation parameters.
                context.duration = self.pushAnimationTimeInterval
                context.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                viewController.view.animator().frame = destinationRect
        }, completionHandler: {
        
        })
    }
    
    public func animateDismissal(of viewController: NSViewController, from fromViewController: NSViewController) {
        
        let pushableViewController = viewController as? Pushable
        let contentView = pushableViewController?.contentView
        
        assert(pushableViewController != nil)
        assert(contentView != nil)
        if let pushableViewController = pushableViewController, let contentView = contentView {
        
            let destinationRect: NSRect = NSMakeRect(NSWidth(fromViewController.view.frame),
                                                     0,
                                                     NSWidth(fromViewController.view.frame),
                                                     NSHeight(fromViewController.view.frame))
            
            let imageView = viewImageView(from: pushableViewController)!
            viewController.view.addSubview(imageView, positioned: NSWindow.OrderingMode.above, relativeTo: pushableViewController.contentView)
            
            imageView.frame = contentView.frame
            
            // see http://stackoverflow.com/questions/30761996/swift-2-0-binary-operator-cannot-be-applied-to-two-uiusernotificationtype
            viewController.view.autoresizingMask = [NSView.AutoresizingMask.height, NSView.AutoresizingMask.width]
            viewController.view.wantsLayer = true
            viewController.view.layerContentsRedrawPolicy = .onSetNeedsDisplay
            viewController.view.needsLayout = true
            viewController.view.layoutSubtreeIfNeeded()
            
            // fromViewController
            fromViewController.view.wantsLayer = true
            fromViewController.view.layerContentsRedrawPolicy = .onSetNeedsDisplay
            fromViewController.view.needsLayout = true
            fromViewController.view.layoutSubtreeIfNeeded()
            
            if let pushable = fromViewController as? Pushable {
                pushable.beforeDismissal()
            }
            if let pushable = viewController as? Pushable {
                pushable.beforeDismissal()
            }
            
            NSAnimationContext.runAnimationGroup({ context in
                    
                // Customize the animation parameters.
                context.duration = self.dismissAnimationInterval
                context.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
                viewController.view.animator().frame = destinationRect
            }, completionHandler: {
                viewController.view.removeFromSuperview()
                viewController.removeFromParent()
                imageView.removeFromSuperview()
            })
        }
    }
    
    private func viewImageView(from viewController: Pushable) -> NSImageView? {
        
        let contentView = viewController.contentView
        
        assert(contentView != nil)
        if let contentView = contentView {
            
            if let rep = contentView.bitmapImageRepForCachingDisplay(in: contentView.bounds) {
            
                contentView.cacheDisplay(in: contentView.bounds, to: rep)
                let img = NSImage(size: contentView.bounds.size)
                img.addRepresentation(rep)
                return NSImageView(image: img)
            }
        }
        return nil
    }
    
}


// MARK: NSViewControllerTransitionOptions
extension NSViewController.TransitionOptions {
    
    func slideStartFrame(fromFrame: NSRect, keepOriginalSize: Bool, originalFrame: NSRect) -> NSRect {
        if self.contains(NSViewController.TransitionOptions.slideLeft) {
            let width = keepOriginalSize ? originalFrame.width : fromFrame.width
            return NSRect(x: fromFrame.width, y: 0, width: width, height: fromFrame.height)
        }
        if self.contains(NSViewController.TransitionOptions.slideRight) {
            let width = keepOriginalSize ? originalFrame.width : fromFrame.width
            return NSRect(x: -width, y: 0, width: width, height: fromFrame.height)
        }
        if self.contains(NSViewController.TransitionOptions.slideDown) {
            let height = keepOriginalSize ? originalFrame.height : fromFrame.height
            return NSRect(x: 0, y: fromFrame.height, width: fromFrame.width, height: height)
        }
        if self.contains(NSViewController.TransitionOptions.slideUp) {
            let height = keepOriginalSize ? originalFrame.height : fromFrame.height
            return NSRect(x: 0, y: -height, width: fromFrame.width, height: height)
        }
        if self.contains(NSViewController.TransitionOptions.slideForward) {
            switch NSApp.userInterfaceLayoutDirection {
            case .leftToRight:
                return NSViewController.TransitionOptions.slideLeft.slideStartFrame(fromFrame: fromFrame, keepOriginalSize: keepOriginalSize, originalFrame: originalFrame)
            case .rightToLeft:
                return NSViewController.TransitionOptions.slideRight.slideStartFrame(fromFrame: fromFrame, keepOriginalSize: keepOriginalSize, originalFrame: originalFrame)
            }
        }
        if self.contains(NSViewController.TransitionOptions.slideBackward) {
            switch NSApp.userInterfaceLayoutDirection {
            case .leftToRight:
                return NSViewController.TransitionOptions.slideRight.slideStartFrame(fromFrame: fromFrame, keepOriginalSize: keepOriginalSize, originalFrame: originalFrame)
            case .rightToLeft:
                return NSViewController.TransitionOptions.slideLeft.slideStartFrame(fromFrame: fromFrame, keepOriginalSize: keepOriginalSize, originalFrame: originalFrame)
            }
        }
        return fromFrame
    }
    
    func slideStopFrame(fromFrame: NSRect, keepOriginalSize: Bool, originalFrame: NSRect) -> NSRect {
        if !keepOriginalSize {
            return fromFrame
        }
        if self.contains(NSViewController.TransitionOptions.slideLeft) {
            return NSRect(x: fromFrame.width - originalFrame.width , y: 0, width: originalFrame.width , height: fromFrame.height)
        }
        if self.contains(NSViewController.TransitionOptions.slideRight) {
            return NSRect(x: 0, y: 0, width: originalFrame.width , height: fromFrame.height)
        }
        if self.contains(NSViewController.TransitionOptions.slideUp) {
            return NSRect(x: 0, y: 0, width: fromFrame.width, height: originalFrame.height )
        }
        if self.contains(NSViewController.TransitionOptions.slideDown) {
            return NSRect(x: 0, y: fromFrame.height - originalFrame.height , width: fromFrame.width, height: originalFrame.height)
        }
        if self.contains(NSViewController.TransitionOptions.slideForward) {
            switch NSApp.userInterfaceLayoutDirection {
            case .leftToRight:
                return NSViewController.TransitionOptions.slideLeft.slideStopFrame(fromFrame: fromFrame, keepOriginalSize: keepOriginalSize, originalFrame: originalFrame)
            case .rightToLeft:
                return NSViewController.TransitionOptions.slideRight.slideStopFrame(fromFrame: fromFrame, keepOriginalSize: keepOriginalSize, originalFrame: originalFrame)
            }
        }
        if self.contains(NSViewController.TransitionOptions.slideBackward) {
            switch NSApp.userInterfaceLayoutDirection {
            case .leftToRight:
                return NSViewController.TransitionOptions.slideRight.slideStopFrame(fromFrame: fromFrame, keepOriginalSize: keepOriginalSize, originalFrame: originalFrame)
            case .rightToLeft:
                return NSViewController.TransitionOptions.slideLeft.slideStopFrame(fromFrame: fromFrame, keepOriginalSize: keepOriginalSize, originalFrame: originalFrame)
            }
        }
        return fromFrame
    }
    
}
