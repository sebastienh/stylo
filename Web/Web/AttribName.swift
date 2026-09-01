//
//  AttribName.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-01-01.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation
import Common
import os

//  attrib_name
//      :   wqname_prefix? IDENT S*
public final class AttribName: BaseSelector {
    
    // Support for wqname_prefix
    // http://www.w3.org/TR/2011/REC-css3-namespace-20110929/
    var wqnamePrefix: WQNamePrefix?
    
    var ident: Ident?
    
    public var stringValue: String? {
        
        return ident?.identString
    }
    
    init(sourceStringSegment: SourceStringSegment?, ident: Ident?, wqnamePrefix: WQNamePrefix? = nil, parentAttribSelector: AttribSelector?) {
        
        self.ident = ident
        self.wqnamePrefix = wqnamePrefix
        
        super.init(sourceStringSegment: sourceStringSegment)
        
        self.parent = parentAttribSelector
    }
    
    func clone(_ parent: AttribSelector?) -> AttribName {
     
        return AttribName(sourceStringSegment: nil, ident: self.ident?.clone(), parentAttribSelector: parent)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Selector protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override public func calculateSpecificity(_ selectorSpecificity: SelectorSpecificity) {
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Selector specificty shall not be called in AttribName", log: Log.Web.all, type: .error)
        #endif
    }
    
    override public var selectorText: String {
        
        var selectorTextValue: String = ""
        
        if let ident = ident {
        
            selectorTextValue += ident.selectorText
        }
            
        return selectorTextValue
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Positionnable protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /// This method translate the position of the fragment using
    // the count from which moving the fragment by adding this count
    // to the start and end index.
    public func move(_ count: Int) {
        
        self.sourceStringSegment?.move(count)
        self.wqnamePrefix?.move(count)
        self.ident?.move(count)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
        
        if let other = other {
            
            if let other = other as? AttribName {
                
                if !super.equals(to: other, comparePositions: comparePositions) {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: super are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                // ident
                if let ident = self.ident {
                    
                    if !ident.equals(to: other.ident, comparePositions: comparePositions) {
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: ident are different.", log: Log.Web.all, type: .debug)
                        #endif
                        return false
                    }
                }
                else if other.ident != nil {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: other ident is not nil.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                // WQNamePrefix
                if let wqnamePrefix = self.wqnamePrefix {
                    
                    if !wqnamePrefix.equals(to: other.wqnamePrefix, comparePositions: comparePositions) {
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: wqnamePrefix are different.", log: Log.Web.all, type: .debug)
                        #endif
                        return false
                    }
                }
                else if other.wqnamePrefix != nil {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: other wqnamePrefix is not nil.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
            }
            else {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not AttribName.", log: Log.Web.all, type: .debug)
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
        
        return self.parent!.minimalCompilationUnit
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
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                  MARK: Equatable protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////

func ==(lhs: AttribName, rhs: AttribName) -> Bool {
    
    return lhs.equals(to: rhs)
}
