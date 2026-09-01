//
//  OccurencesNavigator.swift
//  Common
//
//  Created by Sebastien Hamel on 2020-05-25.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import os

///
/// This class is responsible to manage the navigation with
/// "previous" and "next" actions through a collection of
/// text element occurences. These TextElementOccurences can
/// be anything: tag, search results, etc... This class purpose
/// is to encapsulate the rules of navigation through occurences
/// of anything when the user might click anywhere to start the
/// navigation from there.
///
public struct OccurencesNavigator<OccurenceType: TextElementOccurence> {
    
    //
    // We use this struct internally since positions in texts are not
    // absolute, meaning each text has its own positionnal context. For this
    // reason, and since we know the texts are orderer, we must create
    // a CompositePosition to help us compare the texts together.
    //
    private struct CompositePosition: Equatable, Comparable, CustomDebugStringConvertible {
        
        var debugDescription: String {
            return "textIndex: \(textIndex), value: \(value)"
        }
        
        let textIndex: Int
        let value: Int
        
        static func ==(lhs: CompositePosition, rhs: CompositePosition) -> Bool {
            return lhs.textIndex == rhs.textIndex && lhs.value == rhs.value
        }
        
        static func <(lhs: CompositePosition, rhs: CompositePosition) -> Bool {
            if lhs.textIndex != rhs.textIndex {
                if lhs.textIndex < rhs.textIndex {
                    return true
                }
                else {
                    return false
                }
            }
            return lhs.value < rhs.value
        }
    }
    
    let originalOccurences: [TextElementOccurence]
    
    private lazy var occurences: [CompositePosition] = buildOccurences()
    
    private lazy var textIndexes: [String: Int] = buildTextIndexes()
    
    private var navigationStartingPoint: CompositePosition?
    
    private var userSelectedPosition: CompositePosition?
    
    private let orderedTextIds: [String]
    
    ///
    /// @param occurences: An orderer, uniquely defined, collection of
    /// text elements that we want to navigate though.
    ///
    public init(occurences: [TextElementOccurence], orderedTextIds: [String]) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("OccurencesNavigator(occurences: %@, orderedTextIds: %@)", log: Log.Common.all, type: .info, %%occurences, %%orderedTextIds)
        #endif
        
        self.originalOccurences = occurences
        self.orderedTextIds = orderedTextIds
    }
    
    private mutating func buildOccurences() -> [CompositePosition] {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("buildOccurences()", log: Log.Common.all, type: .info)
        #endif
        
        let occurences = self.originalOccurences.compactMap({ (textElementOccurence) -> CompositePosition? in
            guard let textIndex = self.textIndexes[textElementOccurence.textId] else {
                assertionFailure("Error: textIndex is nil")
                return nil
            }
            return CompositePosition(textIndex: textIndex, value: textElementOccurence.value)
        })
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("buildOccurences -> occurences: %@", log: Log.Common.all, type: .info, %%occurences)
        #endif
        
        
        return occurences
    }
    
    private mutating func buildTextIndexes() -> [String: Int] {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("buildTextIndexes()", log: Log.Common.all, type: .info)
        #endif
        
        var textIndexes: [String: Int] = [:]
        for (index, textId) in self.orderedTextIds.enumerated() {
            assert(textIndexes[textId] == nil)
            textIndexes[textId] = index
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("buildTextIndexes -> textIndexes: %@", log: Log.Common.all, type: .info, %%textIndexes)
        #endif
        
        return textIndexes
    }
    
    public mutating func previous() -> TextElementOccurence? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("previous()", log: Log.Common.all, type: .info)
        #endif
        
        if let navigationStartingPoint = self.navigationStartingPoint {
            
            let previousOccurence = self.occurence(before: navigationStartingPoint)
            if let previousOccurence = previousOccurence {
                self.navigationStartingPoint = self.compositePosition(fromTextPosition: previousOccurence)
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("previous -> previousOccurence: %@", log: Log.Common.all, type: .info, %%previousOccurence)
                #endif
                
                return previousOccurence
            }
            else {
                return self.returnLastOccurence()
            }
        }
        else {
            return self.returnLastOccurence()
        }
    }
    
    public mutating func next() -> TextElementOccurence? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("next()", log: Log.Common.all, type: .info)
        #endif
        
        guard !originalOccurences.isEmpty else {
            return nil
        }
        
        if let navigationStartingPoint = self.navigationStartingPoint {
            
            let nextOccurence = self.occurence(after: navigationStartingPoint)
            
            if let nextOccurence = nextOccurence {
                self.navigationStartingPoint = self.compositePosition(fromTextPosition: nextOccurence)
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("next -> nextOccurence: %@", log: Log.Common.all, type: .info, %%nextOccurence)
                #endif
                
                return nextOccurence
            }
            else {
                return self.returnFirstOccurence()
            }
        }
        else {
            return self.returnFirstOccurence()
        }
    }
    
    ///
    /// When an OccurencesNavigator is created from a new occurences collection
    /// the default behavior when the next() method is called is to return
    /// the first item in the collection. We basically dont take into consideration
    /// the position already set by the user. We only considere the user selected position
    /// when he changes it while an existing OccurencesNavigator was already created.
    ///
    public mutating func updateUserSelectedPosition(withPosition position: TextPositionType?) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("updateUserSelectedPosition(withPosition: %@)", log: Log.Common.all, type: .info, %%position)
        #endif
        
        let compositePosition: CompositePosition? = {
            if let position = position {
                return self.compositePosition(fromTextPosition: position)
            }
            return nil
        }()

        if self.userSelectedPosition != compositePosition {
            self.navigationStartingPoint = compositePosition
            self.userSelectedPosition = compositePosition
        }
        else {
            self.userSelectedPosition = compositePosition
        }
    }
    
    private mutating func returnFirstOccurence() -> TextElementOccurence? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("returnFirstOccurence()", log: Log.Common.all, type: .info)
        #endif
        
        let nextOccurence = self.originalOccurences.first
        self.navigationStartingPoint = occurences.first
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("returnFirstOccurence -> nextOccurence: %@", log: Log.Common.all, type: .info, %%nextOccurence)
        #endif
        
        return nextOccurence
    }
    
    private mutating func returnLastOccurence() -> TextElementOccurence? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("returnLastOccurence()", log: Log.Common.all, type: .info)
        #endif
        
        let nextOccurence = self.originalOccurences.last
        self.navigationStartingPoint = self.occurences.last
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("returnLastOccurence -> nextOccurence: %@", log: Log.Common.all, type: .info, %%nextOccurence)
        #endif
        
        return nextOccurence
    }
    
    private mutating func occurence(after textPosition: CompositePosition) -> TextElementOccurence? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("occurence(after: %@)", log: Log.Common.all, type: .info, %%textPosition)
        #endif
        
        guard let index = indexOfPositionAfter(textPosition: textPosition) else {
            return nil
        }
        
        guard index >= 0 && index < occurences.count else {
            assertionFailure("Error: inex out of range")
            return nil
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("occurence:after -> originalOccurences[%@]: %@", log: Log.Common.all, type: .info, %%index,  %%originalOccurences[index])
        #endif
        
        return originalOccurences[index]
    }
    
    private mutating func occurence(before textPosition: CompositePosition) -> TextElementOccurence? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("occurence(before: %@)", log: Log.Common.all, type: .info, %%textPosition)
        #endif
        
        guard let index = indexOfPositionBefore(textPosition: textPosition) else {
            return nil
        }
        
        guard index >= 0 && index < occurences.count else {
            assertionFailure("Error: inex out of range")
            return nil
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("occurence:before -> originalOccurences[%@]: %@", log: Log.Common.all, type: .info, %%index, %%originalOccurences[index])
        #endif
        
        return originalOccurences[index]
    }
    
    /// This method returns the index of the search element
    /// in the array. It could be nil if the element is not
    /// present in the array.
    private mutating func indexOfPositionAfter(textPosition: CompositePosition) -> Int? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("indexOfPositionAfter(textPosition: %@)", log: Log.Common.all, type: .info, %%textPosition)
        #endif
        
        guard !self.occurences.isEmpty else {
            return nil
        }
        
        var low = 0
        var max = occurences.count-1
        
        while low <= max {
            
            let sum = low+max
            let mid = sum/2
            
            if occurences[mid] == textPosition {
                return mid < occurences.count-1 ? mid+1 : nil
            }
            else if occurences[mid] < textPosition {
                if mid < occurences.count-1 && occurences[mid+1] > textPosition {
                    
                    return mid+1
                }
                else {
                    low = mid+1
                }
            }
            else if occurences[mid] > textPosition {
                if mid > 0 && occurences[mid-1] < textPosition {
                    return mid
                }
                else {
                    max = mid-1
                }
            }
        }
        return nil
    }
    
    /// This method returns the index of the search element
    /// in the array. It could be nil if the element is not
    /// present in the array.
    private mutating func indexOfPositionBefore(textPosition: CompositePosition) -> Int? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("indexOfPositionBefore(textPosition: %@)", log: Log.Common.all, type: .info, %%textPosition)
        #endif
        
        guard !self.occurences.isEmpty else {
            return nil
        }
        
        var low = 0
        var max = occurences.count-1
        
        while low <= max {
            
            let sum = low+max
            let mid = sum/2
            
            if occurences[mid] == textPosition {
                return mid > 0 ? mid-1 : nil
            }
            else if occurences[mid] < textPosition {
                if mid < occurences.count-1 && occurences[mid+1] > textPosition {
                    return mid
                }
                else {
                    low = mid+1
                }
            }
            else if occurences[mid] > textPosition {
                if mid > 0 && occurences[mid-1] < textPosition {
                    return mid-1
                }
                else {
                    max = mid-1
                }
            }
        }
        return nil
    }
    
    private mutating func compositePosition(fromTextPosition textPosition: TextPositionType) -> CompositePosition? {
        
        guard let textIndex = self.textIndexes[textPosition.textId] else {
            assertionFailure("Error: textIndex is nil")
            return nil
        }
        return CompositePosition(textIndex: textIndex, value: textPosition.value)
        
    }
    
}
