//
//  CSSDeclaration.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-28.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common
import os

// http://dev.w3.org/csswg/css-syntax/#declaration

// A declaration has a name, a value consisting of a list of component values, 
// and an important flag which is initially unset.
public final class CSDeclaration: PreservedCSLanguageObject, Declaration {
    
    // This array contains all the CSComponentValue used to
    // create this declaration except the final semi-colon.
    let preservedDeclarationCompleteComponentValueList: [CSComponentValue]
    
    public var propertyName: String
    var propertyNamePreservedTokenComponentValue: CSPreservedTokenComponentValue
    
    // those are set by the parser 
    var colonToken: Token?
    var endSemiColonToken: Token? 
    
    // This is th list of CSComponentValue of the property value
    // not including the important flag if any and the property name,
    // and no colon and semi-colon.
    var propertyValueComponentValueList: [CSComponentValue]
    public var importantFlag: Bool = false
    var importantDeclaration: CSImportantDeclaration?
    
    var supportedProperty: Bool = false
    public var value: CSSPropertyValueContainer?
    
    /// This value is used for cascading to select the last declared value
    /// is a stylesheet (the last rule override the previous ones).
    /// see http://dev.w3.org/csswg/css-cascade-4/#cascade-order
//    public var order: Int = 0
    
    public var associatedDomNodes: ContiguousArray<Node>? {
        
        guard let correspondingCssDomElement = self.correspondingCssDomElement else {
            return nil
        }
            
        var nodes = ContiguousArray<Node>()
        nodes.append(correspondingCssDomElement)
        return nodes
    }
    
    var valueContainsVarFunctions: Bool {
        for propertyValueComponentValue in self.propertyValueComponentValueList {
            guard let functionComponentValue = propertyValueComponentValue as? CSFunctionComponentValue else {
                continue
            }
            if functionComponentValue.functionType == .var {
                return true
            }
        }
        return false
    }
    
    /// variable access to the complete segment that starts from the first colon until the last semi-colon.
    var propertyValueSourceStringSegment: SourceStringSegment? {
        
        if let colonToken = colonToken {
            
            if let endSemiColonToken = endSemiColonToken {
                
                return SourceStringSegment(startIndex: colonToken.sourceStringSegment!.startIndex, endIndex: endSemiColonToken.sourceStringSegment!.endIndex)
            }
            
            let segment = propertyValueComponentValueList.extractPositionFromComponents()
            
            if let segment = segment {
            
                return SourceStringSegment(startIndex: colonToken.sourceStringSegment!.startIndex, endIndex: segment.endIndex)
                
            }
            
            return colonToken.sourceStringSegment!
        }
        else {
            
            if let endSemiColonToken = endSemiColonToken {
                
                return endSemiColonToken.sourceStringSegment!
            }   
        }
        return propertyValueComponentValueList.extractPositionFromComponents()
    }
    
    init(sourceStringSegment: SourceStringSegment?, propertyName: String, propertyNamePreservedTokenComponentValue: CSPreservedTokenComponentValue, preservedDeclarationCompleteComponentValueList: [CSComponentValue]) {
        self.propertyName = propertyName
        self.propertyValueComponentValueList = [CSComponentValue]()
        self.propertyNamePreservedTokenComponentValue = propertyNamePreservedTokenComponentValue.clone()
        self.preservedDeclarationCompleteComponentValueList = preservedDeclarationCompleteComponentValueList
        super.init(sourceStringSegment: sourceStringSegment)
    }
 
    func clone() -> CSDeclaration {

        let declarationClone = CSDeclaration(sourceStringSegment: self.sourceStringSegment, propertyName: self.propertyName, propertyNamePreservedTokenComponentValue: self.propertyNamePreservedTokenComponentValue.clone(), preservedDeclarationCompleteComponentValueList: self.preservedDeclarationCompleteComponentValueList)
        
        for componentValue in propertyValueComponentValueList {
            declarationClone.propertyValueComponentValueList.append(componentValue.clone())
        }
        
        declarationClone.colonToken =  colonToken
        declarationClone.endSemiColonToken = endSemiColonToken
        declarationClone.importantFlag = self.importantFlag
        declarationClone.importantDeclaration = self.importantDeclaration?.clone(parentDeclaration: declarationClone)
        declarationClone.supportedProperty = self.supportedProperty
        declarationClone.value = self.value
        declarationClone.messageHandler.addMessages(self.allMessages)
        
        return declarationClone
    }
    
    var valueString: DOMString {
        
        var domString = DOMString()
        
        for preservedToken in propertyValueComponentValueList {
            
            domString += preservedToken.cssText()
        }
        
        return domString
    }
    
    /// This method returns true if there is something after the property name part
    /// between the colon and the semi-coloon token.
    /// It is used mainly by the CSSDOM creator code.
    func hasPropertyValuePart() -> Bool {
        
        if !propertyValueComponentValueList.isEmpty {
            for componentValue in propertyValueComponentValueList {
                if !componentValue.isTokenId(§CSTokenId.whitespaceToken) {
                    return true
                }
            }
        }
        return false
    }
    
    public func containsInvalidPositionObject() -> Bool {
        
        if let valid = propertyNamePreservedTokenComponentValue.sourceStringSegment?.isInvalid() , !valid {
            
            return true
        }
        
        for componentValue in propertyValueComponentValueList {
            if let valid = componentValue.sourceStringSegment?.isInvalid() , !valid{
                return true
            }
        }
        return false 
    }
    
    internal func isTransition() -> Bool {
        
        fatalError("Missing implementation.")
    }
    
    // FIXME: this method should not exist
    internal func updatePosition() {
        
        let startIndex = propertyNamePreservedTokenComponentValue.value.sourceStringSegment!.startIndex
        
        // end index initial value
        var endIndex = propertyNamePreservedTokenComponentValue.value.sourceStringSegment!.startIndex
        
        if propertyValueComponentValueList.count > 0 {
        
            let endComponentValue = propertyValueComponentValueList[propertyValueComponentValueList.count - 1]
            
            endIndex = endComponentValue.sourceStringSegment!.endIndex
        }
                
        self.sourceStringSegment = SourceStringSegment(startIndex: startIndex, endIndex: endIndex)
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
        
        propertyNamePreservedTokenComponentValue.move(count)
        
        // those are set by the parser
        colonToken?.move(count)
        
        for i in 0..<preservedDeclarationCompleteComponentValueList.count {

            preservedDeclarationCompleteComponentValueList[i].move(count)
        }
        
        endSemiColonToken?.move(count)
        
        // This is th list of CSComponentValue of the property value
        // not including the important flag if any and the property name,
        // and no colon and semi-colon.
        for i in 0..<propertyValueComponentValueList.count {
            propertyValueComponentValueList[i].move(count)
        }
        importantDeclaration?.move(count)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
        
        return self.equals(to: other, comparePositions: comparePositions, compareValue: true)
    }
    
    func equals(to other: Any?, comparePositions: Bool = false, compareValue: Bool) -> Bool {
        
        if let other = other {
        
            if let other = other as? CSDeclaration {
        
                if !super.equals(to: other, comparePositions: comparePositions) {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: super is different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                // public var propertyName: String
                if propertyName != other.propertyName {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: propertyName are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                // public var importantFlag: Bool = false
                if importantFlag != other.importantFlag {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: importantFlag are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                // var importantDeclaration: CSImportantDeclaration?
                if let importantDeclaration = importantDeclaration {
                    
                    if !importantDeclaration.equals(to: other.importantDeclaration, comparePositions: comparePositions) {
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: importantDeclaration are different.", log: Log.Web.all, type: .debug)
                        #endif
                        return false
                    }
                }
                else if other.importantDeclaration != nil {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: other importantDeclaration is not nil.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                // var colonToken: Token?
                if let colonToken = colonToken {
                    
                    if !colonToken.equals(to: other.colonToken, comparePositions: comparePositions) {
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: colonToken are different.", log: Log.Web.all, type: .debug)
                        #endif
                        return false
                    }
                }
                else if other.colonToken != nil {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: other colonToken is not nil.", log: Log.Web.all, type: .debug)
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
                
                // var supportedProperty: Bool = false
                if supportedProperty != other.supportedProperty {
                
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: supportedProperty are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                // public var value: CSSPropertyValueContainer?
                if compareValue {
                    
                    if let value = value {
                        
                        if let otherValue = other.value {
                        
                            if value != otherValue {
                                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                                os_log("Not equals: value are different.", log: Log.Web.all, type: .debug)
                                #endif
                                return false
                            }
                        }
                        else {
                            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                            os_log("Not equals: other value is nil.", log: Log.Web.all, type: .debug)
                            #endif
                            return false
                        }
                    }
                    else if other.value != nil {
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: other value is not nil.", log: Log.Web.all, type: .debug)
                        #endif
                        return false
                    }
                }
                    
                // var propertyNamePreservedTokenComponentValue: CSPreservedTokenComponentValue
                if propertyNamePreservedTokenComponentValue != other.propertyNamePreservedTokenComponentValue {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: propertyNamePreservedTokenComponentValue are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                // var propertyValueComponentValueList: [CSComponentValue]
                if propertyValueComponentValueList.count != other.propertyValueComponentValueList.count {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: propertyValueComponentValueList.count are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                for index in 0..<propertyValueComponentValueList.count {
                    
                    let componentValue = propertyValueComponentValueList[index]
                    
                    if !componentValue.equals(to: other.propertyValueComponentValueList[index], comparePositions: comparePositions) {
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: propertyValueComponentValueList componentValue element are different.", log: Log.Web.all, type: .debug)
                        #endif
                        return false
                    }
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
                os_log("Not equals: other is not CSDeclaration.", log: Log.Web.all, type: .debug)
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
        
        // we should return the CSSStyleDeclaration
        return self.parent!.minimalCompilationUnit as! CSSStyleDeclaration
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSSVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override public func accept(_ visitor: CSSVisitor) {
        
        if let nodeInfo = visitor.visit(self) {
        
            visitor.push(nodeInfo)
        }
        
        if let importantDeclaration = importantDeclaration {
            
            importantDeclaration.accept(visitor)
        }
        
        visitor.postVisit(self)
        visitor.pop()
    }
}

extension CSDeclaration: CSTextNode {
    
    func cssText() -> DOMString {
        
        var cssTextValue = ""
        for preservedTokenComponentValue in self.preservedDeclarationCompleteComponentValueList {
            cssTextValue = cssTextValue + preservedTokenComponentValue.cssText()
        }
        return cssTextValue
    }
}

extension CSDeclaration: DotStringNode {
    
    func dotString(_ nodeName: String) -> String {
        
        return "\(nodeName) [shape=record, label=\"CSDeclaration: \(propertyName)\"];\n"
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                  MARK: Equatable protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////

/// Implementation of == required by Equatable
func ==(lhs: CSDeclaration, rhs: CSDeclaration) -> Bool {
    
    return lhs.equals(to: rhs)
}
