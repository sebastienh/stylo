//
//  TypeSelector.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-12-01.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common
import os

// http://dev.w3.org/csswg/selectors4/#type-selector

public final class TypeSelector: SimpleSelector, EvaluableSelector, SelectionFilter {
    
    // Support for wqname_prefix
    // http://www.w3.org/TR/2011/REC-css3-namespace-20110929/
    var wqnamePrefix: WQNamePrefix?
    
    // Element name in type selector
    let elementName: ElementName
    
    public var universal: Bool {
        
        return elementName.universalIdent
    }
    
    override var selectorType: RightmostSelectorType {
        
        if let ident = elementName.ident {
            
            return RightmostSelectorType.tag(ident.identString)
        }
        
        return RightmostSelectorType.generic
    }
    
    public var typeNameString: String? {
        
        if let ident = elementName.ident {
            
            return ident.identString
        }
        else if let delimToken = elementName.delimToken {
            
            return delimToken.rawStringValue
        }
        
        return nil 
    }
    
    private var typeName: String? {
        if let ident = elementName.ident {
            return ident.identString
        }
        return nil
    }
    
    init(sourceStringSegment: SourceStringSegment?, elementName: ElementName, wqnamePrefix: WQNamePrefix? = nil, parentCompoundSelector: CompoundSelector) {
        
        assert(sourceStringSegment != nil, "sourceStringSegment == nil")
        
        self.elementName = elementName
        self.wqnamePrefix = wqnamePrefix
        super.init(sourceStringSegment: sourceStringSegment, parentCompoundSelector: parentCompoundSelector)
    }
    
    override func clone(_ parent: CompoundSelector) -> SimpleSelector {
        
        return TypeSelector(sourceStringSegment: self.sourceStringSegment!, elementName: elementName.clone(), wqnamePrefix: wqnamePrefix?.clone(), parentCompoundSelector: parent)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Selector protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override public func calculateSpecificity(_ selectorSpecificity: SelectorSpecificity) {
        
        switch selectorType {
        case .generic:
            break
        case .tag(_):
            selectorSpecificity.C += 1
        default:
            assert(false)
            break
        }
    }
    
    override public var selectorText: String {

        return elementName.selectorText
    }
    
    public override var selectorTextWithPositions: String {
        
        return elementName.selectorText + "<\(self.sourceStringSegment!.stringRepresentation)>"
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Positionnable protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /// This method translate the position of the fragment using
    // the count from which moving the fragment by adding this count
    // to the start and end index.
    public override func move(_ count: Int) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("before move sourceStringFragment: %@, sourceStringSegment: %@", log: Log.Web.all, type: .info, %%sourceStringSegment)
        #endif
        
        self.sourceStringSegment?.move(count)
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("after move sourceStringSegment: %@", log: Log.Web.all, type: .info, %%String(describing: sourceStringSegment))
        #endif
        
        self.wqnamePrefix?.move(count)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
        
        if let other = other {
            
            if let other = other as? TypeSelector {
            
                if !super.equals(to: other, comparePositions: comparePositions) {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: super are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                if !self.elementName.equals(to: other.elementName, comparePositions: comparePositions) {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: elementName are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
            }
            else {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not TypeSelector.", log: Log.Web.all, type: .debug)
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
    //                                  MARK: Serializable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public override func serialize() -> String {
        
        return selectorText
    }
 
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSSSelectorListVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public override func accept(_ visitor: CSSSelectorListVisitor) {
        
        if let nodeInfo = visitor.visit(self) , nodeInfo.visitChildren {
            
            visitor.push(nodeInfo)
            
            if let wqnamePrefix = wqnamePrefix {
                
                wqnamePrefix.accept(visitor)
            }
            
            visitor.pop()
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSSVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override public func accept(_ visitor: CSSVisitor) {

        if let nodeInfo = visitor.visit(self) , nodeInfo.visitChildren {
            
            visitor.push(nodeInfo)
            
            if let wqnamePrefix = wqnamePrefix {
                
                wqnamePrefix.accept(visitor)
            }
            
            visitor.pop()
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: SelectionFilter protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    var reverseFilter: ReverseFilter {
        
        return TypeSelectorReverseFilter(typeName: self.typeName, wqNamePrefixValue: self.wqnamePrefix?.wqNamePrefixValue)
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                  MARK: Equatable protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////

func ==(lhs: TypeSelector, rhs: TypeSelector) -> Bool {
    
    return lhs.equals(to: rhs)
}
