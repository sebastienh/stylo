//
//  FilterContext.swift
//  Web
//
//  Created by Sebastien Hamel on 2020-10-15.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Common

public class FilterContext {
    
    public let highlightSelectors: SelectorList?
    
    public private(set) var options: [Element: PseudoClassesOptions] = [:]
    
    public private(set) var focusedRanges: [Element: NSRange] = [:]
    
    private let focusMode: FocusMode

    var focusType: FocusType? {
        
        return focusMode.focusType
    }
    
    private let _defaultPseudoClassesOptions: PseudoClassesOptions
    
    #if CONCURENT_RENDERING
    private let lock: ReadWriteLock
    #endif
    
    public init(highlightSelectors: SelectorList? = nil, defaultPseudoClassesOptions: PseudoClassesOptions = [], focusMode: FocusMode = .disabled) {
        
        self.highlightSelectors = highlightSelectors
        self._defaultPseudoClassesOptions = defaultPseudoClassesOptions
        self.focusMode = focusMode
        #if CONCURENT_RENDERING
        self.lock = ReadWriteLock()
        #endif
    }
    
    private init(highlightSelectors: SelectorList? = nil, options: [Element: PseudoClassesOptions], focusedRanges: [Element: NSRange], focusMode: FocusMode, defaultPseudoClassesOptions: PseudoClassesOptions) {
        
        self.highlightSelectors = highlightSelectors
        self._defaultPseudoClassesOptions = defaultPseudoClassesOptions
        self.focusMode = focusMode
        self.options = options
        self.focusedRanges = focusedRanges
        #if CONCURENT_RENDERING
        self.lock = ReadWriteLock()
        #endif
    }
    
    public func clone() -> FilterContext {
        
        return FilterContext(highlightSelectors: self.highlightSelectors, options: self.options, focusedRanges: self.focusedRanges, focusMode: self.focusMode, defaultPseudoClassesOptions: self._defaultPseudoClassesOptions)
    }
    
    public func isElementHighlighted(_ element: Element) -> Bool {
        
        #if CONCURENT_RENDERING
        return lock.withReadLock {
            return _isElementHighlighted(element)
        }
        #else
        return _isElementHighlighted(element)
        #endif
    }
    
    private func _isElementHighlighted(_ element: Element) -> Bool {
        
        guard let highlightSelectors = self.highlightSelectors else {
            assertionFailure("Error: highlightSelectors is nil")
            return false
        }
        
        guard element.hasAttributesOrClasses else {
            return false
        }
        
        if element is HTMLBodyElement {
            return true
        }
        
        let selection = SelectorSelection(elementToEvaluate: element)
        if highlightSelectors.filterHighlightedSelection(selection, stylesheet: nil) != nil {
            return true
        }
        return false
    }
    
    public func defaultPseudoClassesOptions(forElement element: Element) -> PseudoClassesOptions {
         
        if element.isRoot {
            return []
        }
        
        switch element {
        case is HTMLBodyElement:
            return []
        default:
            return _defaultPseudoClassesOptions
        }
    }
    
    public func ephemeralRanges(forElement element: Element, fromRanges ranges: [NSRange]) -> [NSRange]? {

        let pseudoClassesOptions = self.pseudoClassesOptions(forElement: element)

        if pseudoClassesOptions.isEmpty {
            return ranges
        }
        else {
            if let focusType = self.focusType {
                switch focusType {
                case .bloc:
                    // the complete bloc is rendered so we dont need to ask
                    // for the ephemeral part in the bloc
                    return ranges

                case .paragraph: fallthrough
                case .sentence:

                    guard let focusedRange = self.focusedRange(forElement: element) else {
                        return ranges
                    }
                    if pseudoClassesOptions.contains(.focus) {
                        var ephemeralRanges: [NSRange] = []
                        for range in ranges {
                            let intersection = NSIntersectionRange(range, focusedRange)
                            if !intersection.isEmpty {
                                ephemeralRanges.append(intersection)
                            }
                        }
                        return ephemeralRanges
                    }
                    else {
                        return ranges
                    }

                case .flash(let flashedRange):

                    guard let flashedRange = flashedRange else {
                        return ranges
                    }

                    if pseudoClassesOptions.contains(.flash) {
                        var ephemeralRanges: [NSRange] = []
                        for range in ranges {
                            let intersection = NSIntersectionRange(range, flashedRange)
                            if !intersection.isEmpty {
                                ephemeralRanges.append(intersection)
                            }
                        }
                        return ephemeralRanges
                    }
                    else {
                        return ranges
                    }
                }
            }
            else {
                return ranges
            }
        }
    }
    
    public var highlightPseudoOptions: PseudoClassesOptions {
        if self.highlightSelectors != nil {
            return [.highlight]
        }
        return []
    }
    
    public func updateFocusedRange(forElement element: Element, with range: NSRange?) {
        if let range = range {
            #if CONCURENT_RENDERING
            lock.writeLock()
            #endif
            self.focusedRanges[element] = range
            #if CONCURENT_RENDERING
            lock.unlock()
            #endif
        }
    }
    
    public func focusedRange(forElement element: Element) -> NSRange? {
        #if CONCURENT_RENDERING
        lock.readLock()
        #endif
        let value = focusedRanges[element]
        #if CONCURENT_RENDERING
        lock.unlock()
        #endif
        return value
    }
    
    public func updatePseudoClassesOptions(forElement element: Element, with pseudoClassesOptions: PseudoClassesOptions) {
        #if CONCURENT_RENDERING
        lock.writeLock()
        #endif
        self.options[element] = pseudoClassesOptions
        #if CONCURENT_RENDERING
        lock.unlock()
        #endif
    }
    
    public func pseudoClassesOptions(forElement element: Element) -> PseudoClassesOptions {
        #if CONCURENT_RENDERING
        lock.readLock()
        #endif
        let value = self.options[element] ?? self.defaultPseudoClassesOptions(forElement: element)
        #if CONCURENT_RENDERING
        lock.unlock()
        #endif
        return value
    }
    
}
