//
//  FunctionalPseudoClass.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-06.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

public final class FunctionalPseudoClass: PseudoClass {
    
    override var name: String {
     
        fatalError("Missing implementation.")
    }
    
    let selectorList: SelectorList
    
    init() {
    
        fatalError("Missing implementation.")
    }

    override func clone(_ parent: CompoundSelector) -> SimpleSelector {
        
        fatalError("Missing implementation.")
    }
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: SelectionFilter protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override var reverseFilter: ReverseFilter {
           
        return FunctionalPseudoClassReverseFilter()
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSSSelectorListVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public override func accept(_ visitor: CSSSelectorListVisitor) {
        
        if let nodeInfo = visitor.visit(self) {
            
            visitor.push(nodeInfo)
        }
        
        selectorList.accept(visitor)
        
        visitor.pop()
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSSVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override public func accept(_ visitor: CSSVisitor) {
    
        if let nodeInfo = visitor.visit(self) {
    
            visitor.push(nodeInfo)
        }
    
        selectorList.accept(visitor)

        visitor.pop()
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                  MARK: Equatable protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////

func ==(lhs: FunctionalPseudoClass, rhs: FunctionalPseudoClass) -> Bool {
    
    fatalError("Missing implementation.")
}
