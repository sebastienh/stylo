//
//  DividerLessSplitView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2015-08-31.
//  Copyright (c) 2015 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon
import Quartz

fileprivate func MDPKeyFromIndex(index: Int) -> String {
    
    return String(format: "%@%@", MDPKeyPrefix, index)
}

fileprivate let MDPKeyPrefix: String = "mdp_"

fileprivate let formatter: NumberFormatter = NumberFormatter()

fileprivate func MDPKeyToIndex(key: String) -> Int {
    
    return formatter.number(from: key.substringFromIndex(MDPKeyPrefix.count)!)!.intValue
}

class CollapsableSplitView: NSSplitView {
    
    var mdp_animationCounts: NSCountedSet = NSCountedSet()
    
    override var dividerThickness: CGFloat {
        
        return 0
    }
    
    override var isOpaque: Bool {
        
        #if ALPHA_COLOR_ENABLED
        return false
        #else
        return true
        #endif
    }
    
    override init(frame frameRect: NSRect) {
        
        super.init(frame: frameRect)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override static func defaultAnimation(forKey key: NSAnimatablePropertyKey) -> Any? {
        
        if key.hasPrefix(MDPKeyPrefix) {
            return CABasicAnimation()
        }
        else {
            return super.defaultAnimation(forKey: key)
        }
    }
    
    override func value(forKey key: String) -> Any? {
        
        if key.hasPrefix(MDPKeyPrefix) {
            
            let index = MDPKeyToIndex(key: key)
            let leftView: NSView = self.subviews[index]
            return self.isVertical ? leftView.frame.maxY : leftView.frame.maxY
        }
        else {
            
            return super.value(forKey: key)
        }
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        
        if key.hasPrefix(MDPKeyPrefix) {
            
            func viewIsClosed(_ view: NSView) -> Bool {
                
                return (self.isVertical ? view.frame.width : view.frame.height) == 0
            }
            
            let index: Int = MDPKeyToIndex(key: key)
            let newPosition: CGFloat = value as! CGFloat
            
            let view1: NSView = self.subviews[index]
            let view2: NSView = self.subviews[index + 1]
            
            let view1WasClosed = viewIsClosed(view1)
            let view2WasClosed = viewIsClosed(view2)
            
            self.setPosition(newPosition, ofDividerAt: index)
            
            let view1IsClosed = viewIsClosed(view1)
            let view2IsClosed = viewIsClosed(view2)
            
            // Why doesn't NSSplitView do this itself? I dunno. But it's buggy on
            // 10.9 at least. But it doesn't work to set them all the time. You have
            // to set the property only when the state should change.
            if view1WasClosed != view1IsClosed {
                
                view1.isHidden = view1IsClosed
            }
            
            if view2WasClosed != view2IsClosed {
                
                view2.isHidden = view2IsClosed
            }
        }
        else {
            
            super.setValue(value, forKey: key)
        }
    }
    
    /*!
     Set the position of a divider, possibly with an animation.
     
     @discussion
     This method will use the split view's animator proxy to animate by calling
     `-setPosition:ofDividerAtIndex:`.
     
     @param position
     The new position of the divider.
     @param dividerIndex
     The index of the divider to position.
     @param animated
     Whether the positioning should be animated.
     */
    
    func setPosition(_ position: CGFloat, ofDividerAt dividerIndex: Int, animated: Bool) {
        
        if animated {
            
            let view1: NSView = self.subviews[dividerIndex]
            let view2: NSView = self.subviews[dividerIndex + 1]
            
            // NSSplitView is adding bogus width constraints. Remove them
            // manually.
            for constraint: NSLayoutConstraint in self.constraints {
                
                let firstItem: NSView = constraint.firstItem as! NSView
                
                if (!(firstItem === view1 || firstItem === view2)) {
                    continue
                }
                if constraint.firstAttribute != (self.isVertical ? NSLayoutConstraint.Attribute.width : NSLayoutConstraint.Attribute.height) {
                    continue
                }
                if constraint.relation != NSLayoutConstraint.Relation.equal {
                    continue
                }
                if constraint.secondItem != nil {
                    continue
                }
                if constraint.priority != NSLayoutConstraint.Priority.required {
                    continue
                }
                self.removeConstraint(constraint)
            }
            
            NSAnimationContext.runAnimationGroup({ (context) in
                
                self.mdp_animationCounts.add(dividerIndex)
                self.animator().setValue(position, forKey: MDPKeyFromIndex(index: dividerIndex))
            }) {
                self.mdp_animationCounts.remove(dividerIndex)
            }
        }
        else {
            
            super.setPosition(position, ofDividerAt: dividerIndex)
        }
    }
    
    /*!
     Whether the divider at the given index is currently being animated.
     */
    func isAnimatingDivider(atIndex index: Int) -> Bool {
        
        return self.mdp_animationCounts.count(for: index) > 0
    }
    
    /*!
     Helper method to toggle a (vertically split) split view’s subview.
     
     @discussion
     This is a helper method to toggle a split view's subview.
     It is animated by calling `-setPosition:ofDividerAtIndex:`.
     There are two versions: one for split views with vertical dividers (this one)
     and another for those with horizontal dividers.
     
     @param subview
     The subview to toggle.
     @param dividerIndex
     The index of the divider to position.
     @param lastWidth
     A reference to the variable you store the last width of the subview in.
     @param animationDuration
     The duration of the animation.
     @param collapsesRightward
     Whether you want to have the subview collapse rightward (or leftward, if NO).
     @param widthConstraint
     The width constraint you have applied to the subview so that it doesn’t become too narrow.
     @param completionHandler
     The completion handler that is called, once the animation has ended.
     */
    func toggleSubview(_ subview: NSView, dividerIndex: Int, lastWidth: inout CGFloat, animationDuration duration: TimeInterval, collapsesRightward: Bool, widthConstraint: NSLayoutConstraint, completionHandler: ((Bool) -> Void)?) {
        
        self.toggleSubview(subview,
                           dividerIndex: dividerIndex,
                           lastExtent: &lastWidth,
                           animationDuration:duration,
                           collapsesInPositiveDirection: collapsesRightward,
                           extentConstraint: widthConstraint,
                           completionHandler: completionHandler)
    }
    
    /*!
     Helper method to toggle a (horizontally split) split view’s subview.
     
     @discussion
     This is a helper method to toggle a split view's subview.
     It is animated by calling `-setPosition:ofDividerAtIndex:`.
     There are two versions: one for split views with horizontal dividers (this one)
     and another for those with vertical dividers.
     
     @param subview
     The subview to toggle.
     @param dividerIndex
     The index of the divider to position.
     @param lastHeight
     A reference to the variable you store the last height of the subview in.
     @param animationDuration
     The duration of the animation.
     @param collapsesUpward
     Whether you want to have the subview collapse upward (or downward, if NO).
     @param heightConstraint
     The height constraint you have applied to the subview so that it doesn’t become too narrow.
     @param completionHandler
     The completion handler that is called, once the animation has ended.
     */
    func toggleSubview(_ subview: NSView, dividerIndex: Int, lastHeight: inout CGFloat, animationDuration duration: TimeInterval, collapsesUpward: Bool, heightConstraint: NSLayoutConstraint, completionHandler: ((Bool) -> Void)?) {
        
        self.toggleSubview(subview,
                           dividerIndex: dividerIndex,
                           lastExtent: &lastHeight,
                           animationDuration: duration,
                           collapsesInPositiveDirection: collapsesUpward, // Positive values extend upwards in Cocoa.
            extentConstraint: heightConstraint,
            completionHandler: completionHandler)
        
    }
    
    func toggleSubview(_ subview: NSView, dividerIndex: Int, lastExtent: inout CGFloat, animationDuration duration: TimeInterval, collapsesInPositiveDirection: Bool, extentConstraint: NSLayoutConstraint, completionHandler: ((Bool) -> Void)?) {
        
        if self.isAnimatingDivider(atIndex: dividerIndex) {
            return
        }
        
        let dividedLeftToRight: Bool = self.isVertical
        
        let initiallyOpen: Bool = !self.isSubviewCollapsed(subview)
        
        var position: CGFloat = (initiallyOpen ? 0.0 : lastExtent)
        
        if collapsesInPositiveDirection {
            
            if dividedLeftToRight {
                position = self.frame.size.width - position
            }
            else {
                position = self.frame.size.height - position
            }
        }
        
        subview.removeConstraint(extentConstraint)
        
        if initiallyOpen {
            
            if dividedLeftToRight {
                lastExtent = subview.frame.size.width;
            }
            else {
                lastExtent = subview.frame.size.height;
            }
        }
        else {
            
            var frame: NSRect = subview.frame
            
            if dividedLeftToRight {
                frame.size.width = 0.0
            }
            else {
                frame.size.height = 0.0
            }
            subview.frame = frame
        }
        
        NSAnimationContext.runAnimationGroup({ (context) in
            
            context.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            context.duration = duration
            self.setPosition(position, ofDividerAt: dividerIndex, animated: true)
        }) {
            
            if !initiallyOpen {
                subview.addConstraint(extentConstraint)
            }
            
            if let completionHandler = completionHandler{
                completionHandler(!initiallyOpen);
            }
        }
    }
    
}

