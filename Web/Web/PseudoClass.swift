//
//  PseudoClass.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-11-02.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common
import os

/// see http://dev.w3.org/csswg/selectors4/#pseudo-class
open class PseudoClass: Pseudo, EvaluableSelector, SelectionFilter, SelectorChainLink {
    
    var firstColonToken: Token
    var classIdentToken: Token
    
    init(sourceStringSegment: SourceStringSegment?, parentCompoundSelector: CompoundSelector, firstColonToken: Token, classIdentToken: Token) {
        
        self.firstColonToken = firstColonToken
        self.classIdentToken = classIdentToken
        
        super.init(sourceStringSegment: sourceStringSegment, parentCompoundSelector: parentCompoundSelector)
    }
    
    override func clone(_ parent: CompoundSelector) -> SimpleSelector {
        
        return PseudoClass(sourceStringSegment: nil, parentCompoundSelector: parent, firstColonToken: self.firstColonToken, classIdentToken: self.classIdentToken)
    }
    
    override open func calculateSpecificity(_ selectorSpecificity: SelectorSpecificity) {
        
        selectorSpecificity.B += 1
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: SelectionFilter protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    var reverseFilter: ReverseFilter {
        
        return PseudoClassReverseFilter()
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Positionnable protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /// This method translate the position of the fragment using
    // the count from which moving the fragment by adding this count
    // to the start and end index.
    public override func move(_ count: Int) {
        
        self.sourceStringSegment?.move(count)
        self.firstColonToken.move(count)
        self.classIdentToken.move(count)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSSVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override open func accept(_ visitor: CSSVisitor) {
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Missing subclass implementation!", log: Log.Web.all, type: .fault)
        #endif
        assert(false, "Missing subclass implementation.")
    }
        
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                  MARK: Equatable protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////

func ==(lhs: PseudoClass, rhs: PseudoClass) -> Bool {
    
    // If we are here it's because the two PseudoClass type are not identical (IdentPdeudoClass or 
    // FunctionalPseudoClass) which means they are not the same
    return lhs.equals(to: rhs)
}
