//
//  StylesStackView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-07-15.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import AppKit
import WriterCommon
import Common
import os

protocol StylesStackViewDelegate: class {
    
    func updatedVisibleIndexes(visibleIndexes: [Int], over count: Int)
}


/// see https://stackoverflow.com/questions/12191817/autolayout-is-resizing-my-window
class StylesStackView: NSStackView {
    
    var displayedIndexes: [Int] {
        
        didSet {
         
            stylesStackViewDelegate?.updatedVisibleIndexes(visibleIndexes: displayedIndexes, over: self.views.count)
        }
    }
    
    weak var stylesStackViewDelegate: StylesStackViewDelegate?
    
    override init(frame frameRect: NSRect) {
    
        self.displayedIndexes = [Int]()
        super.init(frame: frameRect)
    }
    
    required init?(coder decoder: NSCoder) {
        self.displayedIndexes = [Int]()
        super.init(coder: decoder)
    }
    
    func move(view: NSView, at index: Int, to newIndex: Int) {
     
        // TODO
        assert(false, "missing implementation")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("move(..) missing implementation.", log: Log.StyloCore.all, type: .error)
        #endif
    }
    
    override open func insertArrangedSubview(_ view: NSView, at index: Int) {
        
        let _visibilityPriority = insertionVisibilityPriority(for: index)
        super.insertArrangedSubview(view, at: index)
        setVisibilityPriority(_visibilityPriority, for: view)
        updateDisplayedIndexes()
        
        #if DEBUG
            logState()
        #endif
    }
    
    ///
    func insert(button: NSButton, at index: Int? = nil) {
        
        if let index = index {
            insertArrangedSubview(button, at: index)
        }
        else {
            addArrangedSubview(button)
        }
    }
    
    override open func removeArrangedSubview(_ view: NSView) {
        
        super.removeArrangedSubview(view)
        updateDisplayedIndexes()
    }
    
    func disableAllButtons() {
        
        for view in self.views {
         
            if let button = view as? NSButton {
                button.isEnabled = false
            }
        }
    }

    func enableAllButtons() {
        
        for view in self.views {
            
            if let button = view as? NSButton {
                button.isEnabled = true
            }
        }
    }
    
    func didReattach(views: [NSView]) {

        updateDisplayedIndexes()
    }
    
    func willDetach(views: [NSView]) {

        updateDisplayedIndexes(willDetachViews: views)

        #if DEBUG
            // ensure we have contiguous indexes
            if displayedIndexes.count > 1 {
                for (index, displayedIndexe) in displayedIndexes.enumerated() {
                    if index < displayedIndexes.count - 1 {
                        assert(displayedIndexes[index] + 1 == displayedIndexes[index + 1])
                    }
                }
            }
        #endif
    }
    
    fileprivate func insertionVisibilityPriority(for index: Int) -> NSStackView.VisibilityPriority {
        
        // there is no other views
        if self.views.count == 0 {
            
            return NSStackView.VisibilityPriority(1)
        }
        else {
            
            // in all other cases there is already views
            
            // insert at the end
            if index == self.views.count {
                
                // since we insert at the end we just want to reset
                // the existing visibility priorities, and put it's
                // priority at one more.
                resetViewVisibilites()
                return NSStackView.VisibilityPriority(Float(self.views.count + 1))
            }
            else {
                
                let relativePosition: RelativePosition = positionRelativeToVisibleIndexes(index: index)
                
                switch relativePosition {
                    
                case .contained:
                    
                    return insertInVisibleIndexes(index: index)
                    
                case .before:
                    
                    // when we move up, we should move up so that the new view
                    // index becomes the middle one in the displayed views
                    let middlePoint = displayedIndexes.count/2
                    let middleVisibleIndex = displayedIndexes[middlePoint]
                    
                    let positionsToMoveUp = middleVisibleIndex - index
                    moveUp(by: positionsToMoveUp)
                    
                    return insertInVisibleIndexes(index: index)
                    
                case .after:
                    
                    // when we move down, we should move down so that the new view
                    // index becomes the middle one in the displayed views
                    let middlePoint = displayedIndexes.count/2
                    let middleVisibleIndex = displayedIndexes[middlePoint]
                    
                    let positionsToMoveDown = index - middleVisibleIndex
                    moveDown(by: positionsToMoveDown)
                    
                    return insertInVisibleIndexes(index: index)
                }
            }
        }
    }
    
    fileprivate func moveUp(by positions: Int) {
        
        if positions == 0 {
            return
        }
        
        if let firstDisplayedIndex = displayedIndexes.first, firstDisplayedIndex >= positions {
            
            for _ in 0..<positions {
                moveOneUp()
            }
        }
    }
    
    func moveOneUp() {
        
        #if DEBUG
            debugPrint("Before moving up...")
            logState()
        #endif
        
        if let firstDisplayedIndex = displayedIndexes.first, firstDisplayedIndex > 0  {
            
            var priorities = [Int: NSStackView.VisibilityPriority]()
            
            // keep the view before visibility priority
            let viewBefore = self.views[firstDisplayedIndex - 1]
            let visibilityPriorityBefore = visibilityPriority(for: viewBefore)
            
            for displayedIndex in displayedIndexes {
                
                let fromView = self.views[displayedIndex]
                let fromVisibilityPriority = visibilityPriority(for: fromView)
                priorities[displayedIndex - 1] = fromVisibilityPriority
            }
            
            let firstIndexAfterDisplayed = displayedIndexes.last!
            
            // if there is more than one indexes after displayed
            for index in firstIndexAfterDisplayed..<self.views.count - 1 {
                
                let nextViewIndex = index + 1
                if nextViewIndex <= self.views.count - 1 {
                
                    let fromView = self.views[nextViewIndex]
                    let fromVisibilityPriority = visibilityPriority(for: fromView)
                    priorities[index] = fromVisibilityPriority
                }
            }

            // the visibilityPriorityBefore should be put at the end
            priorities[self.views.count - 1] = visibilityPriorityBefore
            updateVisibilityPriorities(priorities: priorities)
            
            #if DEBUG
                debugPrint("After move up..")
                logState()
            #endif
        }
    }
    
    func moveOneDown() {
        
        #if DEBUG
            debugPrint("Before move down..")
            logState()
        #endif
        
        if let lastDisplayedIndex = displayedIndexes.last, lastDisplayedIndex < self.views.count - 1 {
            
            var priorities = [Int: NSStackView.VisibilityPriority]()
            
            // keep the last visibility priority
            let lastView = self.views.last!
            let lastViewVisibilityPriority = visibilityPriority(for: lastView)
            
            if let firstDisplayedIndex = displayedIndexes.first {
                
                for index in stride(from: self.views.count - 1, to: firstDisplayedIndex, by: -1) {
                    
                    let view = views[index - 1]
                    let _visibilityPriority = visibilityPriority(for: view)
                    priorities[index] = _visibilityPriority
                }
                
                priorities[firstDisplayedIndex] = lastViewVisibilityPriority
                
                updateVisibilityPriorities(priorities: priorities)
            }
            
            #if DEBUG
                debugPrint("After move down..")
                logState()
            #endif
        }
    }
    
    fileprivate func updateVisibilityPriorities(priorities: [Int: NSStackView.VisibilityPriority]) {
        
        for (index, priority) in priorities {
            
            let view = self.views[index]
            setVisibilityPriority(priority, for: view)
        }
        
        self.needsLayout = true
        layoutSubtreeIfNeeded()
    }
    
    fileprivate func moveDown(by positions: Int) {
        
        if positions == 0 {
            return
        }
        
        if let firstDisplayedIndex = displayedIndexes.first, firstDisplayedIndex >= positions {
            
            for _ in 0..<positions {
                moveOneDown()
            }
        }
    }
    
    fileprivate func insertInVisibleIndexes(index: Int) -> NSStackView.VisibilityPriority {
        
        // get the visibility priority of the element at this place
        let currentIndexVisibility = visibilityPriority(for: self.views[index])
        
        // increase all following views visibilities by one
        for i in index...displayedIndexes.last! {
            
            changeVisibility(of: i, by: 1.0)
        }
        return currentIndexVisibility
    }
    
    fileprivate func changeVisibility(of viewIndex: Int, by value: Float) {
        
        let view = self.views[viewIndex]
        let currentVisibilityPriority = visibilityPriority(for: view)
        let rawValue = currentVisibilityPriority.rawValue
        setVisibilityPriority(NSStackView.VisibilityPriority(rawValue + value), for: view)
    }
    
    fileprivate func positionRelativeToVisibleIndexes(index: Int) -> RelativePosition {
        
        if index < displayedIndexes.first! {
            
            return RelativePosition.before
        }
        else if index > displayedIndexes.last! {
            
            return RelativePosition.after
        }
        else {
            
            #if DEBUG
                var inside = false
                for displayedIndexe in displayedIndexes {
                    
                    if index == displayedIndexe {
                        inside = true
                    }
                }
                assert(inside)
            #endif
                
            return RelativePosition.contained
        }
    }
    
    /// This method puts the views visibilities in order from 1 to self.views.count.
    fileprivate func resetViewVisibilites() {
        
        for (index, view) in self.views.enumerated() {
            
            let _visibilityPriority = NSStackView.VisibilityPriority(Float(index + 1))
            setVisibilityPriority(_visibilityPriority, for: view)
        }
        
        self.needsLayout = true
        layoutSubtreeIfNeeded()
    }
    
    fileprivate func updateDisplayedIndexes(willDetachViews viewsToDetach: [NSView]? = nil) {
        
        // create all detached views arrays
        var _detachedViews: [NSView] = self.detachedViews
        
        if let viewsToDetach = viewsToDetach {
            _detachedViews.append(contentsOf: viewsToDetach)
        }
        
        // create all views indexes
        var allIndexes = [Int]()
        for (index, _) in self.views.enumerated() {
            allIndexes.append(index)
        }
        
        // early exit when all views are visible
        if _detachedViews.isEmpty {
            displayedIndexes = allIndexes
            return
        }
        
        var rmIndices = [Int]()
        
        // remove detached views
        for view in _detachedViews {
            
            if let viewIndex = index(of: view) {
                rmIndices.append(viewIndex)
            }
        }
        
        rmIndices = rmIndices.sorted(by: { $1 < $0 })
        
        for index in rmIndices {
            allIndexes.remove(at: index)
        }
        
        displayedIndexes = allIndexes
        
        #if DEBUG
            
            logState()
            
            // ensure we have contiguous indexes
            if displayedIndexes.count > 1 {
                for (index, displayedIndexe) in displayedIndexes.enumerated() {
                    if index < displayedIndexes.count - 1 {
                        assert(displayedIndexes[index] + 1 == displayedIndexes[index + 1])
                    }
                }
            }
        #endif
    }
    
    
    fileprivate func indexes(of views: [NSView]) -> [Int] {
        
        var indexes = [Int]()
        
        for view in views {
            
            if let viewIndex = index(of: view) {
                
                indexes.append(viewIndex)
            }
        }
        return indexes.sorted()
    }
    
    fileprivate func index(of view: NSView) -> Int? {
        
        return self.views.index(of: view)
    }
    
    fileprivate func logState() {
        
//        for (index, view) in views.enumerated() {
//
//            let viewVisibilityPriority = visibilityPriority(for: view)
//            debugPrint("View at index: \(index) has visibility priority: \(viewVisibilityPriority.rawValue)")
//        }
//
//        debugPrint("Displayed indexes...")
//        for displayedIndex in displayedIndexes {
//
//            debugPrint("Diplayed index: \(displayedIndex)")
//        }
    }
    
}
