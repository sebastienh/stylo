//
//  Positionnable.swift
//  Common
//
//  Created by Sébastien Hamel on 2015-11-10.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation
import os

public protocol Positionnable {
    
    var sourceStringSegment: SourceStringSegment? { get set }
    
    /// The start index as an Int
    var startStringIndex: Int? { get }
    
    /// The end index as an Int
    var endStringIndex: Int? { get }
    
    /// the source string fragment description opbject
    var sourceStringFragment: SourceStringFragment? { get set }
    
    /// This method translate the position of the fragment using
    // the count from which moving the fragment by adding this count
    // to the start and end index.
    mutating func move(_ count: Int)
    
    /// Returns the index relative position regarding the current
    /// positionnable element.
    func contains(_ position: Int) -> RelativePosition?
    
    mutating func applyStringChange(with description: SourceStringChangeDescription)
    
    func createSourceStringSegment(from positionnables: [Positionnable]) -> SourceStringSegment?
    
}

extension Positionnable {
    
    public func createSourceStringSegment(from positionnables: [Positionnable]) -> SourceStringSegment? {
        
        var start: Int?
        var end: Int?
        
        for positionnable in positionnables {
            
            let sourceStringFragment = positionnable.sourceStringFragment
            
            assert(sourceStringFragment != nil)
            if let sourceStringFragment = sourceStringFragment {
                
                if let _start = start {
                    if let startValue = sourceStringFragment.startFragmentIndex?.integerValue, startValue < _start {
                        start = startValue
                    }
                }
                else if let startValue = sourceStringFragment.startFragmentIndex?.integerValue {
                    start = startValue
                }
                
                if let _end = end {
                    if let endValue = sourceStringFragment.endFragmentIndex?.integerValue, endValue > _end {
                        end = endValue
                    }
                }
                else if let endValue = sourceStringFragment.endFragmentIndex?.integerValue {
                    end = endValue
                }
            }
        }

        if let start = start, let end = end {
            return SourceStringSegment(startIntegerIndex: start, endIntegerIndex: end)
        }
        return nil
    }
    
    public var sourceStringSegment: SourceStringSegment? {
        
        get {
            return self.sourceStringFragment as? SourceStringSegment
        }
        set {
            self.sourceStringFragment = newValue
        }
    }
    
    /// The start index as an Int
    public var startStringIndex: Int? {
        
        let fragment = self.sourceStringFragment
        
        assert(fragment != nil)
        if let fragment = fragment {
            return fragment.startFragmentIndex!.integerValue
        }
        
        return nil
    }
    
    /// The end index as an Int
    public var endStringIndex: Int? {
        
        let fragment = self.sourceStringFragment
        
        assert(fragment != nil)
        if let fragment = fragment {
            return fragment.endFragmentIndex?.integerValue
        }
        return nil
    }
    
    /// This method translate the position of the fragment using
    // the count from which moving the fragment by adding this count
    // to the start and end index.
    public mutating func move(_ count: Int) {
        
        self.sourceStringFragment?.move(count)
    }
    
    public func contains(_ position: Int) -> RelativePosition? {
        
        return sourceStringFragment?.indexRelativePosition(position)
    }
    
    public mutating func applyStringChange(with description: SourceStringChangeDescription) {
    
        if let sourceStringFragment = sourceStringFragment {
            
            switch sourceStringFragment {
            
            case _ as SourceStringRegion:
                assert(false, "unhandled type")
                break
        
            case let sourceStringSegment as SourceStringSegment:
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("sourceStringSegment before: %@", log: Log.Common.all, type: .info, String(describing: self.sourceStringSegment))
                #endif
                
                let relativePosition = sourceStringSegment.relativePosition(from: description.range)
                
                assert(relativePosition != nil)
                if let relativePosition = relativePosition {
                
                    switch relativePosition {
                        
                    case .after:
                        self.sourceStringSegment?.move(description.changeLength)
                        
                    case .same:
                        self.sourceStringSegment = nil
                        
                    case .before:
                        // nothing to do
                        break
                    case .partiallyBefore:
                        
                        // part inside is erased
                        var sourceStringSegment = sourceStringSegment
                        let intersect = sourceStringSegment.range?.intersection(range: description.range)
                        
                        assert(intersect != nil)
                        if let intersect = intersect {
                            
                            sourceStringSegment.substractRange(range: intersect)
                            self.sourceStringSegment = sourceStringSegment
                        }
                        
                    case .inside:
                        // erased by the change
                        self.sourceStringSegment = nil
                        
                    case .partiallyAfter:
                        
                        var sourceStringSegment = sourceStringSegment
                        let intersect = sourceStringSegment.range?.intersection(range: description.range)
                        
                        assert(intersect != nil)
                        if let intersect = intersect {
                            
                            sourceStringSegment.substractRange(range: intersect)
                            sourceStringSegment.move(description.changeLength)
                            self.sourceStringSegment = sourceStringSegment
                        }
                            
                    case .contains:
                        self.sourceStringSegment?.moveEnd(description.changeLength)
                        break
                    }
                }
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("sourceStringSegment after: %@", log: Log.Common.all, type: .info, String(describing: self.sourceStringSegment))
                #endif
                
            default:
                assert(false, "unhandled type")
                break
            }
            
            
        }
    }
    
}
