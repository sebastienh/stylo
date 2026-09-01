//
//  CSSDOMTokenElement.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-09-04.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import os

public final class CSSDOMTokenElement: CSSDOMElement {
    
    static func Create(_ preservedToken: CSPreservedTokenComponentValue, document: CSSDOMDocument?) -> CSSDOMTokenElement? {
        
        return CSSDOMTokenElement(segment: preservedToken.sourceStringSegment, document: document, tokenClass: preservedToken.associatedTokenClass(), textValue: preservedToken.value.stringRepresentation)
    }
    
    public let tokenClass: TokenClassType
    
    var sourceStringSegment: SourceStringSegment? {
        
        get {
            return super.sourceStringFragment as? SourceStringSegment
        }
        set {
            super.sourceStringFragment = newValue
        }
    }
    
    init(segment: SourceStringSegment?, document: CSSDOMDocument?, tokenClass: TokenClassType, textValue: String?) {
        
        self.tokenClass = tokenClass
        
        super.init(segment: segment, document: document, localName: §CSSElementType.Token)
        
        self.addClassAttribute(§tokenClass)
        
        assert(textValue != nil)
        if let textValue = textValue {
            self.setCustomVarClass(textValue)
//            self.setTextValueAttribute(textValue)
        }
        
        assert(textValue != nil)
        if let textValue = textValue {
            var exception = Exception()
            let text = Text(sourceStringFragment: segment, document: document, data: textValue)
            self.append(text, exception: &exception)
        }
    }

    #if DEBUG
    public override func addMessage(_ message: Message) {
        
        super.addMessage(message)
    }
    
    public override func addMessage(_ code: MessageCode, args: [CVarArg]? = nil) -> Message {
        
        return super.addMessage(code, args: args)
    }
    
    public override func addMessage(_ code: MessageCode, args: [CVarArg]?, fromMessage messageDependency: Message) -> Message {
        
        return super.addMessage(code, args: args, fromMessage: messageDependency)
    }
    
    public override func addMessage(_ code: MessageCode, args: [CVarArg]?, fromMessages messageDependencies: Array<Message>) -> Message {
     
        return super.addMessage(code, args: args, fromMessages: messageDependencies)
    }
    #endif
    
    private func setCustomVarClass(_ value: String) {
        
        if value.starts(with: "--") {
            self.addClassAttribute(§TokenClassType.customVariable)
        }
    }
    
    private func setTextValueAttribute(_ value: String) {
        
        var exception = Exception()
        
        self.setAttribute("text-value", value: value, exception: &exception)
        
        if exception.isError() {
            debugPrint("Exception: \(exception)")
        }
    }
    
    ///////////////////////////////////////////////////public///////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
        
        if let other = other {
            
            if let other = other as? CSSDOMTokenElement {
                
                if !super.equals(to: other, comparePositions: comparePositions) {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: super is different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                if tokenClass != other.tokenClass {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: tokenClass are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
            }
            else {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not CSSDOMTokenElement.", log: Log.Web.all, type: .debug)
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
    //                                  MARK: DomInspectable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override public var numberOfChildren: Int {
        
        return 0
    }
    
    override public var expandable: Bool {
        
        return false
    }
    
    override public var expandedOpenElementString: String {
        
        let domParsing = HTMLSerializer.createWithGeneratedIds()
        
        return domParsing.plainStringStyleSerializedSelfClosingTag(fromElement: self)
    }
    
    override public var unexpandedElementString: String {
        
        let domParsing = HTMLSerializer.createWithGeneratedIds()
        
        return domParsing.plainStringStyleSerializedSelfClosingTag(fromElement: self)
    }
    
    override public func childAtIndex(_ index: Int) -> DomInspectable? {
        
        return childNodes![index]
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSSDOMVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // 1. Visit the root.
    // 2. Traverse the left subtree.
    // 3. Traverse the right subtree.
    @discardableResult
    override public func accept<Visitor: CSSDOMVisitor>(_ visitor: Visitor) -> Visitor.NodeInfoType? {
        
        let nodeInfo = visitor.visit(self)
        
        if let _nodeInfo = nodeInfo , _nodeInfo.visitChildren {
            
            visitor.push(_nodeInfo)
            
            // token element do not have a corresponding pseudo-element
            // since they will never be part of a tree other by being 
            // parent and children of themeselve.
            // assert(mirrorPseudoElement != nil, "mirrorPseudoElement is nil.")
            
            if let firstChild = self.firstChild {
                
                // if we have a child, this child must also be the last child
                // only one child allowed for CSSDOMTokenElement
                assert(self.lastChild != nil, "self.lastChild == nil")
                
                // only CSSDOMTokenElement are allowed to be child
                assert(firstChild is Text, "firstChild is not Text")
                
                if let tokenElement = firstChild as? CSSDOMTokenElement {
                
                    tokenElement.accept(visitor)
                }
            }
            
            visitor.pop()
        }
        
        return nodeInfo
    }
    
    @discardableResult
    override public func acceptSingle<Visitor: CSSDOMVisitor>(_ visitor: Visitor) -> Visitor.NodeInfoType? {
        
        return visitor.visit(self)
    }
    
}
