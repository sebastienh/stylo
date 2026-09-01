 //
 //  TokensTokenContainingIndex.swift
 //  Markdown
 //
 //  Created by Sébastien Hamel on 2018-10-06.
 //  Copyright © 2018 Textually Inc. All rights reserved.
 //
 
 import Foundation
 import Common
 import os
 
 fileprivate enum Closest {
    
    case first
    case second
 }
 
 fileprivate enum IndexRelativePosition {
    
    case before(distance: Int)
    case contained
    case after(distance: Int)
    
    static func closest(of relativePosition1: IndexRelativePosition, and relativePosition2: IndexRelativePosition) -> Closest? {
        
        assert(relativePosition1.sameRelativePosition(as: relativePosition2))
        switch (relativePosition1, relativePosition2) {
        case (.before(let distance1), .before(let distance2)):
            
            if abs(distance1) > abs(distance2) {
                return .second
            }
            else {
                // if it's equal we always return the first token
                // to start iterating from there
                return .first
            }
        case (.after(let distance1), .after(let distance2)):
            
            if abs(distance1) > abs(distance2) {
                return .second
            }
            else {
                // if it's equal we always return the first token
                // to start iterating from there
                return .first
            }
        case (.contained, .contained):
            return .first

        default:
            assert(false)
            return nil
        }
    }
    
    func sameRelativePosition(as other: IndexRelativePosition) -> Bool {
        
        switch (self, other) {
            
        case (.before(_), .before(_)):
            return true
        case (.contained, .contained):
            return true
        case (.after(_), .after(_)):
            return true
        default:
            return false
        }
    }
 }
 extension Tokens {
    
    /// Return the token index containing the particular changeIndex.
    /// If it is not found we return nil. The caller should trig complete
    /// compilation for safety, but this situation should not occur.
    public func tokenIndexContaining(_ changeIndex: Int) -> Int? {
        
        if tokenValues.isEmpty {
            return nil
        }
        
        var lowerTokenIndex = 0
        var upperTokenIndex = tokenValues.count-1
        let divideFactor: Int = 2
        
        // lower index
        var indexRelativePositionToTokenAtLowerTokenIndex = validLowerIndex(from: &lowerTokenIndex, changeIndex: changeIndex)!
        
        // upper index
        var indexRelativePositionToTokenAtUpperTokenIndex = validUpperIndex(from: &upperTokenIndex, changeIndex: changeIndex)!
        
        while !indexRelativePositionToTokenAtLowerTokenIndex.sameRelativePosition(as: indexRelativePositionToTokenAtUpperTokenIndex) &&  (upperTokenIndex-lowerTokenIndex) >= divideFactor {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("iterating to find the containing token", log: Log.Markdown.all, type: .info)
            #endif
            
            switch indexRelativePositionToTokenAtLowerTokenIndex {
                
            case .after(let distanceFromLowerIndex):
                
                switch indexRelativePositionToTokenAtUpperTokenIndex {
                    
                case .contained:
                    return upperTokenIndex
                    
                case .before(let distanceToUpperIndex):
                    
                    if distanceFromLowerIndex >= distanceToUpperIndex {
                        
                        let previousLowerTokenIndex = lowerTokenIndex
                        let previousIndexLowerRelativePositionToTokenAtLowerTokenIndex = indexRelativePositionToTokenAtLowerTokenIndex
                        
                        // we increase the lower index
                        lowerTokenIndex += ((upperTokenIndex - lowerTokenIndex)/divideFactor)
                        indexRelativePositionToTokenAtLowerTokenIndex = validLowerIndex(from: &lowerTokenIndex, changeIndex: changeIndex)!
                        
                        switch indexRelativePositionToTokenAtLowerTokenIndex {
                            
                        case .after(_):
                            continue
                        case .before(_):
                            
                            // we put back the old value and we make the upperTokenIndex move lower
                            lowerTokenIndex = previousLowerTokenIndex
                            indexRelativePositionToTokenAtLowerTokenIndex = previousIndexLowerRelativePositionToTokenAtLowerTokenIndex
                            break
                            
                            //
                            //                            let previousUpperTokenIndex = upperTokenIndex
                            //
                            //                            upperTokenIndex -= ((upperTokenIndex - lowerTokenIndex)/divideFactor)
                            //                            if previousUpperTokenIndex != upperTokenIndex {
                            //
                            //                                indexRelativePositionToTokenAtUpperTokenIndex = validUpperIndex(from: &upperTokenIndex, changeIndex: changeIndex)!
                            //                            }
                            //                            else {
                            //
                            //                                upperTokenIndex -= 1
                            //                                indexRelativePositionToTokenAtUpperTokenIndex = validUpperIndex(from: &upperTokenIndex, changeIndex: changeIndex)!
                            //                            }
                            
                        case .contained:
                            return lowerTokenIndex
                        }
                    }
                    else {
                        
                        let previousUpperTokenIndex = upperTokenIndex
                        
                        upperTokenIndex -= ((upperTokenIndex - lowerTokenIndex)/divideFactor)
                        if previousUpperTokenIndex != upperTokenIndex {
                            
                            indexRelativePositionToTokenAtUpperTokenIndex = validUpperIndex(from: &upperTokenIndex, changeIndex: changeIndex)!
                        }
                        else {
                            
                            upperTokenIndex -= 1
                            indexRelativePositionToTokenAtUpperTokenIndex = validUpperIndex(from: &upperTokenIndex, changeIndex: changeIndex)!
                        }
                    }
                    
                case .after(_):
                    assert(false, "should not happen here since it is the stop while loop condition")
                    break
                }
                
            case .before(_):
                
                assert(false, "we should have alread stopped....")
                break
                
            case .contained:
                return lowerTokenIndex
            }
        }
        
        if indexRelativePositionToTokenAtLowerTokenIndex.sameRelativePosition(as: indexRelativePositionToTokenAtUpperTokenIndex) {
            
            let closest = IndexRelativePosition.closest(of: indexRelativePositionToTokenAtLowerTokenIndex, and: indexRelativePositionToTokenAtUpperTokenIndex)
            
            assert(closest != nil)
            if let closest = closest {
                
                switch closest {
                    
                case .first:
                    return tokenIndexContaining(changeIndex, from: lowerTokenIndex)
                case .second:
                    return tokenIndexContaining(changeIndex, from: upperTokenIndex)
                }
            }
        }
        else {
            return tokenIndexContaining(changeIndex, from: lowerTokenIndex)
        }
        
        assert(false)
        return nil
    }
    
    private func tokenIndexContaining(_ changeIndex: Int, from lowerIndex: Int) -> Int? {
        
        var previousIndex: Int?
        var previousRelativePosition: RelativePosition?
        
        for index in lowerIndex..<tokenValues.count {
            
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("iterating to find the containing token", log: Log.Markdown.all, type: .info)
            #endif
            
            let token = tokenValues[index]
            
            if isValidTopLevelToken(token) {
                
                let indexRelativePosition = token.indexRelativePositionFromAllFragment(changeIndex)
                
                if indexRelativePosition == .contained {
                    return index
                }
                else if indexRelativePosition == .before {
                    
                    if index == 0 {
                        return 0
                    }
                    
                    // if the previous relative position was after then we return the
                    // previous index.
                    if let previousIndex = previousIndex, let previousRelativePosition = previousRelativePosition,
                        previousRelativePosition == .after {
                        
                        return previousIndex
                    }
                }
                previousIndex = index
                previousRelativePosition = indexRelativePosition
            }
        }
        
        if let previousIndex = previousIndex, let previousRelativePosition = previousRelativePosition, previousRelativePosition == .after {
            
            return previousIndex
        }
        
//        #if DEBUG
//        fatalError("programming error: token index should not be nil: \(changeIndex)")
//        #else
//        debugPrint("programming error: token index should not be nil: \(changeIndex)")
//        #endif
        
        return nil
    }
    
    
    private func validLowerIndex(from lowerIndex: inout Int, changeIndex: Int) -> IndexRelativePosition? {
        
        // make sure we don't fall into infinite loop
        while lowerIndex < tokenValues.count {
            
            let token = tokenValues[lowerIndex]
            
            if isValidTopLevelToken(token) {
                
                let indexRelativePosition = self.indexRelativePosition(changeIndex, from: token)
                
                assert(indexRelativePosition != nil)
                if let indexRelativePosition = indexRelativePosition {
                    
                    return indexRelativePosition
                }
                
                // it's an invalid index we just move on to the next upper index.
            }
            
            lowerIndex += 1
        }
        
        assert(false)
        return nil
    }
    
    
    private func validUpperIndex(from upperIndex: inout Int, changeIndex: Int) -> IndexRelativePosition? {
        
        // make sure we don't fall into infinite loop
        while upperIndex >= 0 {
            
            let token = tokenValues[upperIndex]
            
            if isValidTopLevelToken(token) {
                
                let indexRelativePosition = self.indexRelativePosition(changeIndex, from: token)
                
                assert(indexRelativePosition != nil)
                if let indexRelativePosition = indexRelativePosition {
                    
                    return indexRelativePosition
                }
                // it's an invalid index we just move on to the next upper index.
            }
            
            upperIndex -= 1
        }
        
        assert(false)
        return nil
    }
    
    private func isValidTopLevelToken(_ token: Token) -> Bool {
        if token.level != 0 || !token.block || token.nesting == .closing || token.type == .inline {
            return false
        }
        return true
    }
    
    /// Method that return true if the token contains the
    /// specified index in the .All fragment
    private func indexRelativePosition(_ index: Int, from token: Token) -> IndexRelativePosition? {
        
        let sourceFragment = token.sourceFragment(for: MarkdownSourceFragmentType.All)
        
        assert(sourceFragment != nil)
        if let sourceFragment = sourceFragment {
            
            return indexRelativePosition(index, from: sourceFragment)
        }
        
        assert(false)
        return nil
    }
    
    private func indexRelativePosition(_ index: Int, from sourceFragment: SourceStringFragment) -> IndexRelativePosition? {
        
        let startFragmentIndex = sourceFragment.startFragmentIndex
        let endFragmentIndex = sourceFragment.endFragmentIndex
        
        assert(startFragmentIndex != nil)
        assert(endFragmentIndex != nil)
        if let startFragmentIndex = startFragmentIndex, let endFragmentIndex = endFragmentIndex {
            
            if index < startFragmentIndex {
                
                return .before(distance: startFragmentIndex - index)
            }
            else if index >= endFragmentIndex {
                
                return .after(distance: endFragmentIndex - index)
            }
            else if index >= startFragmentIndex && index < endFragmentIndex {
                
                return .contained
            }
        }
        return nil
    }
    
 }
