//
//  AttribValue.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-10.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import os

public final class AttribValue: BaseSelector {
    
    var ident: Ident?
    var string: StringToken?
    
    var stringValue: String? {
        
        if let ident = ident {
            
            return ident.rawIdent
        }
        else if let string = string {
            
            if let formattedString = string.formattedIdent {
                
                return formattedString
            }
            
            return string.rawIdent
        }
        return nil
    }

    init(sourceStringSegment: SourceStringSegment?, ident: Ident?, parentAttribSelector: AttribSelector) {
        
        self.ident = ident
        self.string = nil
        super.init(sourceStringSegment: sourceStringSegment)
        
        self.parent = parentAttribSelector
    }
    
    init(sourceStringSegment: SourceStringSegment?, string: StringToken, parentAttribSelector: AttribSelector) {
        
        self.string = string
        self.ident = nil
        super.init(sourceStringSegment: sourceStringSegment)
    }
    
    func clone(_ parent: AttribSelector?) -> AttribValue {
        
        if let ident = ident {
        
            return AttribValue(sourceStringSegment: nil, ident: ident.clone(), parentAttribSelector: parent!)
        }
        else if let string = string {
            
            return AttribValue(sourceStringSegment: nil, string: string.clone(), parentAttribSelector: parent!)
        }
        
        assert(false, "Both ident and string are nil...")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Both ident and string are nil in clone(_ parent: AttribSelector?)", log: Log.Web.all, type: .error)
        #endif
        return AttribValue(sourceStringSegment: nil, ident: nil, parentAttribSelector: parent!)
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
        else if let string = string {

            selectorTextValue += "\""
            selectorTextValue += string.rawIdent
            selectorTextValue += "\""
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
        self.ident?.move(count)
        self.string?.move(count)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
        
        if let other = other {
            
            if let other = other as? AttribValue {
                
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
            }
            else {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not AttribValue.", log: Log.Web.all, type: .debug)
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
        
        visitor.visit(self)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSSVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override public func accept(_ visitor: CSSVisitor) {
        
        visitor.visit(self)
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                  MARK: Equatable protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////

func ==(lhs: AttribValue, rhs: AttribValue) -> Bool {
    
    return lhs.equals(to: rhs)
}
