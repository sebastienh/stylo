//
//  HTMLCollection+Additions.swift
//  Web
//
//  Created by Sébastien Hamel on 2017-09-01.
//  Copyright © 2017 NM. All rights reserved.
//

import Foundation
import Common
import os

public extension HTMLCollection {

    func firstVisibleElementIndex(in range: NSRange) -> Int? {
        
        if let (index, relativePosition) = elementIndex(in: range) {
            
            switch relativePosition {
                
            case .partiallyBefore:
                
                return index
                
            case .inside:
                
                return firstElementIndex(in: range, from: index)
                
            case .partiallyAfter:
                
                return firstElementIndex(in: range, from: index)
                
            case .contains:
                
                return index
                
            default:
                assert(false, "Realtive fragment position should not be: \(relativePosition)")
                break
            }
        }
        return nil
    }
    
    
    /// Method that returns the elements that are completely or partially
    /// in the given range.
    ///
    /// Note: a zero range contains nothing by definition.
    func elementsIndexes(in range: NSRange) -> [Int] {
        
        var elementsIndexes = [Int]()
        
        if let (index, relativePosition) = elementIndex(in: range) {
            
            switch relativePosition {
                
            case .partiallyBefore:
                
                elementsIndexes.append(index)
                let indexesAfter = indexes(after: index, in: range)
                elementsIndexes.append(contentsOf: indexesAfter)
                
            case .same:
                elementsIndexes.append(index)
                
            case .inside:
                
                elementsIndexes.append(index)
                let indexesBefore = indexes(before: index, in: range)
                elementsIndexes.append(contentsOf: indexesBefore)
                let indexesAfter = indexes(after: index, in: range)
                elementsIndexes.append(contentsOf: indexesAfter)
                
            case .partiallyAfter:
                
                elementsIndexes.append(index)
                let indexesBefore = indexes(before: index, in: range)
                elementsIndexes.append(contentsOf: indexesBefore)
                
            case .contains:
                
                elementsIndexes.append(index)
                
            default:
                assert(false, "Realtive fragment position should not be: \(relativePosition)")
                break
            }
        }
        return elementsIndexes.sorted()
    }
    
    private func firstElementIndex(in range: NSRange, from index: Int) -> Int? {
        
        var lastIndexInside: Int?
        
        outerLoop: for i in stride(from: index, through: 0, by: -1) {
            
            let element = self[i]
            
            assert(element != nil)
            if let element = element {
                
                let fragment = element.sourceStringFragment
                
                assert(fragment != nil)
                if let fragment = fragment {
                    
                    let fragmentRelativePosition = fragment.relativePosition(from: range)
                    
                    assert(fragmentRelativePosition != nil)
                    if let fragmentRelativePosition = fragmentRelativePosition {
                        
                        switch fragmentRelativePosition {
                            
                        case .before:
                            break outerLoop
                            
                        case .partiallyBefore:
                            
                            lastIndexInside = i
                            break outerLoop
                            
                        case .same:
                            lastIndexInside = i
                            break outerLoop
                            
                        case .inside:
                            lastIndexInside = i
                            
                        case .partiallyAfter:
                            
                            lastIndexInside = i
                            
                        case .after:
                            
                            #if DEBUG
                            // impossible case
                            assert(false, "we are asking for previous indexes but it is after...")
                            #endif
                            break outerLoop
                            
                        case .contains:
                            
                            #if DEBUG
                            // impossible case
                            assert(false, "we are asking for previous indexes but it contains...")
                            #endif
                            break outerLoop
                        }
                    }
                    else {
                        break
                    }
                }
                else {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("element's fragment is nil: %@", log: Log.Web.all, type: .debug, %%element.nodeName)
                    #endif
                }
            }
            else {
                break
            }
        }
        return lastIndexInside
    }
    
    private func indexes(before index: Int, in range: NSRange) -> [Int] {
        
        var indexes = [Int]()
        
        outerLoop: for i in stride(from: index - 1, through: 0, by: -1) {
            
            let element = self[i]
            
            assert(element != nil)
            if let element = element {
                
                let fragment = element.sourceStringFragment
                
                assert(fragment != nil)
                if let fragment = fragment {
                    
                    let fragmentRelativePosition = fragment.relativePosition(from: range)
                    
                    assert(fragmentRelativePosition != nil)
                    if let fragmentRelativePosition = fragmentRelativePosition {
                        
                        switch fragmentRelativePosition {
                            
                        case .before:
                            break outerLoop
                            
                        case .same:
                            indexes.append(i)
                            break outerLoop
                            
                        case .partiallyBefore:
                            
                            indexes.append(i)
                            break outerLoop
                            
                        case .inside:
                            
                            indexes.append(i)

                        case .partiallyAfter:
                            
                            #if DEBUG
                            // impossible case
                            assert(false, "we are asking for previous indexes but it is partially after...")
                            #endif
                            break outerLoop
                            
                        case .after:
                            
                            #if DEBUG
                            // impossible case
                            assert(false, "we are asking for previous indexes but it is after...")
                            #endif
                            break outerLoop
                            
                        case .contains:
                            
                            #if DEBUG
                            // impossible case
                            assert(false, "we are asking for previous indexes but it contains...")
                            #endif
                            break outerLoop
                        }
                    }
                    else {
                        break
                    }
                }
                else {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("element's fragment is nil: %@", log: Log.Web.all, type: .debug, %%element.nodeName)
                    #endif
                }
            }
            else {
                break
            }
        }
        return indexes
    }
    
    private func indexes(after index: Int, in range: NSRange) -> [Int] {
        
        var indexes = [Int]()
        
        outerLoop: for i in index+1..<self.length {
            
            let element = self[i]
            
            assert(element != nil)
            if let element = element {
                
                let fragment = element.sourceStringFragment
                
                assert(fragment != nil)
                if let fragment = fragment {
                    
                    let fragmentRelativePosition = fragment.relativePosition(from: range)
                    
                    assert(fragmentRelativePosition != nil)
                    if let fragmentRelativePosition = fragmentRelativePosition {
                        
                        switch fragmentRelativePosition {
                            
                        case .before:
                            #if DEBUG
                            // impossible case
                            assert(false, "we are asking for after indexes but it is before...")
                            #endif
                            break outerLoop
                            
                        case .partiallyBefore:
                            
                            #if DEBUG
                            // impossible case
                            assert(false, "we are asking for after indexes but it is partially before...")
                            #endif
                            break outerLoop
                            
                        case .same:
                            indexes.append(i)
                            break outerLoop
                            
                        case .inside:
                            
                            indexes.append(i)
                            
                        case .partiallyAfter:
                            
                            indexes.append(i)
                            break outerLoop
                            
                        case .after:
                            break outerLoop
                            
                        case .contains:
                            
                            #if DEBUG
                            // impossible case
                            assert(false, "we are asking for after indexes but it contains...")
                            #endif
                            break outerLoop
                        }
                    }
                    else {
                        break
                    }
                }
                else {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("element's fragment is nil: %@", log: Log.Web.all, type: .debug, %%element.nodeName)
                    #endif
                }
            }
            else {
                break
            }
        }
        return indexes
    }
    
    private func elementIndex(in range: NSRange) -> (Int, RangeRelativePosition)? {
        
        if range.length == 0 || length == 0 {
            return nil
        }
        
        var lowerIndex = 0
        var upperIndex = length
    
        while lowerIndex < upperIndex {
            
            let mid = lowerIndex + ((upperIndex-lowerIndex)/2)
            let element = self[mid]!
            let fragment = element.sourceStringFragment!
            
            let fragmentRelativePosition = fragment.relativePosition(from: range)
            
            assert(fragmentRelativePosition != nil)
            if let fragmentRelativePosition = fragmentRelativePosition {
                
                switch fragmentRelativePosition {
                    
                case .before:
                    lowerIndex = mid + 1
                case .after:
                    upperIndex = mid
                default:
                    return (mid, fragmentRelativePosition)
                }
            }
            else {
                return nil
            }
        }
        return nil
    }
    
    func elements(in range: NSRange) -> ContiguousArray<Web.Element> {
        
        var elementsInRange = ContiguousArray<Web.Element>()
        
        if range.length == 0 || range.length == 1 {
            return elementsInRange
        }
        
        let indexes = elementsIndexes(in: range)
        
        for index in indexes {
            
            let node = self.item(index)
            
            assert(node != nil)
            if let node = node {
                
                assert(node is Web.Element)
                if let element = node as? Web.Element {
                    
                    elementsInRange.append(element)
                }
            }
        }
        return elementsInRange
    }
    
}
