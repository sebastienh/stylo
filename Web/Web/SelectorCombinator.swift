//
//  SelectorCombinator.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-11-30.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common
import os

// Combinators in Selectors level 4 include: 
//      whitespace, 
//      “greater-than sign” (U+003E, >), 
//      “plus sign” (U+002B, +), 
//      and “tilde” (U+007E, ~).
enum CombinatorType: String {
    
    case Whitespace = " "
    case GreaterThanSign = ">"
    case DoubleGreaterSign = ">>"
    case PlusSign = "+"
    case Tilde = "~"
}

enum SelectorCombinatorClass: String {
    
    // selector combinators
    case ChildSelectorCombinator = "child-combinator"
    case DescendantSelectorCombinator = "descendant-combinator"
    case NextSiblingSelectorCombinator = "next-sibling-combinator"
    case FollowingSiblingSelectorCombinator = "following-sibling-combinator"
}


// http://dev.w3.org/csswg/selectors4/#combinator
// A combinator represents a particular kind of relationship between 
// the elements matched by the compound selectors on either side.
public final class SelectorCombinator: BaseSelector, EvaluableSelector, ComplexSelectorChild, ValueTokenContainer, SelectionFilter {
    
    weak var leftCompoundSelector: CompoundSelector?
    weak var rightCompoundSelector: CompoundSelector?
    let combinatorType: CombinatorType
    
    init(type: CombinatorType, sourceStringSegment: SourceStringSegment?, parent: ComplexSelector) {
        
        self.tokenValues = [Token]()
        self.combinatorType = type
        super.init(sourceStringSegment: sourceStringSegment)
        self.parent = parent
    }
    
    func clone(_ parent: ComplexSelector) -> SelectorCombinator {
        
        return SelectorCombinator(type: self.combinatorType, sourceStringSegment: nil, parent: parent)
    }
    
    override public func calculateSpecificity(_ selectorSpecificity: SelectorSpecificity) {
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Combinator spectificity is not calculable.", log: Log.Web.all, type: .error)
        #endif
    }
    
    override public var selectorText: String {
        
        var selectorTextValue = §combinatorType
   
        if let rightCompoundSelectorValue = rightCompoundSelector {
            selectorTextValue += rightCompoundSelectorValue.selectorText
        } else {
            assert(false, "Right selector of a combinator should not be empty.")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Right selector of a combinator should not be empty.", log: Log.Web.all, type: .error)
            #endif
        }
        return selectorTextValue
    }
    
    override public var selectorTextWithPositions: String {
        
        var selectorTextValue = §combinatorType
   
        if let rightCompoundSelectorValue = rightCompoundSelector {
            selectorTextValue += rightCompoundSelectorValue.selectorTextWithPositions
        } else {
            assert(false, "Right selector of a combinator should not be empty.")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Right selector of a combinator should not be empty.", log: Log.Web.all, type: .error)
            #endif
        }
        return selectorTextValue + "<\(self.sourceStringSegment!.stringRepresentation)>"
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Positionnable protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /// This method translate the position of the fragment using
    // the count from which moving the fragment by adding this count
    // to the start and end index.
    public func move(_ count: Int) {
        
        self.sourceStringFragment?.move(count)
        
        for i in 0..<tokenValues.count {
            tokenValues[i].move(count)
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
    
        if let other = other {
            
            if let other = other as? SelectorCombinator {
                
                if !super.equals(to: other, comparePositions: comparePositions) {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: super are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                if self.combinatorType != other.combinatorType {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: combinatorType are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
            }
            else {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not SelectorCombinator.", log: Log.Web.all, type: .debug)
                #endif
                return false
            }
        }
        else {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Not equals: other is nil.", log: Log.Web.all, type: .debug)
            #endif
            return false
        }
        return true 
    }
        
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Compilable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override public var minimalCompilationUnit: CSSOMLanguageObject {
        
        // we return the parent SelectorList
        // SelectorList -> ComplexSelector -> (CompoundSelector SelectorCombinator CompoundSelector ...)
        return self.parent!.minimalCompilationUnit
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSSSelectorListVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public override func accept(_ visitor: CSSSelectorListVisitor) {
        
        visitor.visit(self)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSSVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override public func accept(_ visitor: CSSVisitor) {
        
        visitor.visit(self)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: SelectionFilter protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public var isCombinator: Bool  {
        
        return true
    }
    
    var reverseFilter: ReverseFilter {
        
        return CombinatorReverseFilter(combinatorType: self.combinatorType)
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ValueTokenContainer protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    fileprivate var tokenValues: [Token]
    
    var tokenCount: Int {
        
        return tokenValues.count
    }
    
    subscript(separatorIndex: Int) -> Token {
     
        return tokenValues[separatorIndex]
    }
    
    func addToken(_ token: Token) {
        
        tokenValues.append(token)
    }
    
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                  MARK: Equatable protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////

func ==(lhs: SelectorCombinator, rhs: SelectorCombinator) -> Bool {
    
    if lhs.combinatorType != rhs.combinatorType {
        return false
    }
    if lhs.leftCompoundSelector != rhs.leftCompoundSelector {
        return false
    }
    if lhs.rightCompoundSelector != rhs.rightCompoundSelector {
        return false
    }
    return true
}
