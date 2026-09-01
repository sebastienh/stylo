//
//  CSImportantDeclaration.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-10.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import os

public final class CSImportantDeclaration: PreservedCSLanguageObject {
    
    var preservedTokenComponentValueArray: [CSPreservedTokenComponentValue]
    
    var apostrophToken: CSPreservedTokenComponentValue? {
        
        for preservedTokenComponentValue in preservedTokenComponentValueArray {
            
            if preservedTokenComponentValue.isTokenId(§CSTokenId.delimToken) && preservedTokenComponentValue.value.stringRepresentation == "!" {
                
                return preservedTokenComponentValue
            }
        }
        
        return nil
    }
    
    var importantKeyworkToken: CSPreservedTokenComponentValue? {
        
        for preservedTokenComponentValue in preservedTokenComponentValueArray {
            
            if preservedTokenComponentValue.isTokenId(§CSTokenId.identToken) && preservedTokenComponentValue.value.stringRepresentation == "important" {
                
                return preservedTokenComponentValue
            }
        }
        
        return nil
    }
    
    var unexpectedTokens: [CSPreservedTokenComponentValue] {
        
        var _unexpectedTokens = [CSPreservedTokenComponentValue]()
        
        for preservedTokenComponentValue in preservedTokenComponentValueArray {
            
            if !preservedTokenComponentValue.isTokenId(§CSTokenId.whitespaceToken) {
            
                if preservedTokenComponentValue.value.stringRepresentation != "important" && preservedTokenComponentValue.value.stringRepresentation != "!" {
                    
                    _unexpectedTokens.append(preservedTokenComponentValue)
                }
            }
        }
        return _unexpectedTokens
    }
    
    init(preservedTokenComponentValueArray: [CSPreservedTokenComponentValue], parent: CSDeclaration) {
        
        self.preservedTokenComponentValueArray = [CSPreservedTokenComponentValue]()
        
        for preservedTokenComponent in preservedTokenComponentValueArray {
            self.preservedTokenComponentValueArray.append(preservedTokenComponent.clone())
        }
        
        super.init(sourceStringSegment: nil)
        
        self.sourceStringSegment = calculatePosition()
        
        self.parent = parent
    }
    
    func calculatePosition() -> SourceStringSegment? {
        
        if let firstToken = preservedTokenComponentValueArray.first {
            
            if let lastToken = preservedTokenComponentValueArray.last {
                
                return SourceStringSegment(startIndex: firstToken.sourceStringSegment!.startIndex, endIndex: lastToken.sourceStringSegment!.endIndex)
            }
            else {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("lastToken is nil.", log: Log.Web.all, type: .error)
                #endif
            }
        }
        else {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("firstToken is nil.", log: Log.Web.all, type: .error)
            #endif
        }
        return nil
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Positionnable protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /// This method translate the position of the fragment using
    // the count from which moving the fragment by adding this count
    // to the start and end index.
    public func move(_ count: Int) {
        
        self.sourceStringSegment?.move(count)
        
        for i in 0..<preservedTokenComponentValueArray.count {
            
            preservedTokenComponentValueArray[i].move(count)
        }
    }
    
    
    func clone(parentDeclaration: CSDeclaration) -> CSImportantDeclaration {
     
        let importantDeclarationClone = CSImportantDeclaration(preservedTokenComponentValueArray: self.preservedTokenComponentValueArray, parent: parentDeclaration)
        
        return importantDeclarationClone
        
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Compilable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override public var minimalCompilationUnit: CSSOMLanguageObject {
        
        // we should return the CSSStyleDeclaration
        return self.parent!.minimalCompilationUnit as! CSSStyleDeclaration
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSSVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    override public func accept(_ visitor: CSSVisitor) {
        
        visitor.visit(self)
    }
}
