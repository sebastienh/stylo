//
//  InvalidDeclaration.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-07-03.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation
import Common
import os

public class InvalidDeclaration: PreservedCSLanguageObject, Declaration {
    
    // This array contains all the CSComponentValue used to
    // create this declaration except the final semi-colon.
    let preservedDeclarationCompleteComponentValueList: [CSComponentValue]
    
    var endSemiColonToken: Token?
    
    init(sourceStringSegment: SourceStringSegment?, preservedDeclarationCompleteComponentValueList: [CSComponentValue], endSemiColonToken: Token?) {
        
        self.endSemiColonToken = endSemiColonToken
        self.preservedDeclarationCompleteComponentValueList = preservedDeclarationCompleteComponentValueList
        super.init(sourceStringSegment: sourceStringSegment)
    }
    
    
    convenience init(preservedDeclarationCompleteComponentValueList: [CSComponentValue], endSemiColonToken: Token?) {
        
        self.init(sourceStringSegment: nil, preservedDeclarationCompleteComponentValueList: preservedDeclarationCompleteComponentValueList, endSemiColonToken: endSemiColonToken)
        
        self.sourceStringSegment = createSourceStringSegment(from: preservedDeclarationCompleteComponentValueList)
        if let endSemiColonToken = endSemiColonToken, self.sourceStringSegment == nil {
            self.sourceStringSegment = endSemiColonToken.sourceStringSegment
        }
        else if let endSemiColonToken = endSemiColonToken {
            
            let endIndex = endSemiColonToken.sourceStringSegment?.endIndex
            
            assert(endIndex != nil)
            if let endIndex = endIndex {
            
                self.sourceStringSegment?.endIndex = endIndex
            }
        }
    }
    
    func clone() -> InvalidDeclaration {
        
        let declarationClone = InvalidDeclaration(sourceStringSegment: self.sourceStringSegment, preservedDeclarationCompleteComponentValueList: self.preservedDeclarationCompleteComponentValueList, endSemiColonToken: self.endSemiColonToken)
        
        declarationClone.messageHandler.addMessages(self.allMessages)
        
        return declarationClone
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Positionnable protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /// This method translate the position of the fragment using
    /// the count from which moving the fragment by adding this count
    /// to the start and end index.
    ///
    /// Note: we must remember that each Component has it's
    /// own copy of the Token struct, it means we must update CSComponentValue
    /// values even if they contain the same tokens.
    public func move(_ count: Int) {
        
        self.sourceStringSegment?.move(count)
        
        for i in 0..<preservedDeclarationCompleteComponentValueList.count {
//            if preservedDeclarationCompleteComponentValueList[i] is CSPreservedTokenComponentValue || preservedDeclarationCompleteComponentValueList[i] is CSFunctionComponentValue {
                preservedDeclarationCompleteComponentValueList[i].move(count)
//            }
        }
        
        endSemiColonToken?.move(count)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    open override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
        
        if let other = other {
            
            if let other = other as? InvalidDeclaration {
                
                if !super.equals(to: other, comparePositions: comparePositions) {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: super is different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                // var endSemiColonToken: Token?
                if let endSemiColonToken = endSemiColonToken {
                    
                    if !endSemiColonToken.equals(to: other.endSemiColonToken, comparePositions: comparePositions) {
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: endSemiColonToken are different.", log: Log.Web.all, type: .debug)
                        #endif
                        return false
                    }
                }
                else if other.endSemiColonToken != nil {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: other endSemiColonToken is not nil.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                if preservedDeclarationCompleteComponentValueList.count != other.preservedDeclarationCompleteComponentValueList.count {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: preservedDeclarationCompleteComponentValueList.count are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                for index in 0..<preservedDeclarationCompleteComponentValueList.count {
                    
                    let componentValue = preservedDeclarationCompleteComponentValueList[index]
                    
                    if !componentValue.equals(to: other.preservedDeclarationCompleteComponentValueList[index], comparePositions: comparePositions) {
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: preservedDeclarationCompleteComponentValueList componentValue element are different.", log: Log.Web.all, type: .debug)
                        #endif
                        return false
                    }
                }
            }
            else {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not InvalidDeclaration.", log: Log.Web.all, type: .debug)
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
    //                                  MARK: CSSVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override public func accept(_ visitor: CSSVisitor) {
        
        visitor.visit(self)
    }
}
