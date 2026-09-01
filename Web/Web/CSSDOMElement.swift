//
//  CSSSourceDOMElement.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-01-11.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation
import Common
import os

open class CSSDOMElement: Element, CSSDOMVisitable {
    
    var descendantElementsHasErrors: Bool {
        
        let descendantsElements = self.descendantElements
        
        for descendantElement in descendantsElements {
            
            if descendantElement.hasErrors() {
                
                return true
            }
        }
        return false
    }
    
    // this position contains both the start index
    // and the end index.
    public init(segment: SourceStringSegment?, document: CSSDOMDocument?, localName: DOMString) {
        
        super.init(fragment: segment, document: document, localName: localName)
        
        self.namespaceURI = §Namespace.CSS
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: DomInspectable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override open var numberOfChildren: Int {
        
        return length
    }
    
    override open var expandable: Bool {
        
        return hasChildNodes()
    }
    
    override open var expandedOpenElementString: String {
        
//        let domParsing = HTMLSerializer.shared
        
        return self.localName //domParsing.serializeOpenTag(fromElement: self)
    }
    
    override open var unexpandedElementString: String {
        
//        let domParsing = HTMLSerializer.shared
        
        return self.localName //domParsing.serializeOpenTag(fromElement: self) + "..." +  domParsing.serializeCloseTag(fromElement: self)
    }
    
    override open func childAtIndex(_ index: Int) -> DomInspectable? {
        
        return childNodes![index]
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    open override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
        
        if let other = other {
            
            if let other = other as? CSSDOMElement {
                
                if !super.equals(to: other, comparePositions: comparePositions) {
                    
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("Not equals: super is different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }                
            }
            else {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Not equals: other is not CSSDOMElement.", log: Log.Web.all, type: .debug)
                #endif
                return false
            }
        }
        else {
            
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Not equals: other is nil.", log: Log.Web.all, type: .debug)
            #endif
            return false
        }
        return true
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSSDOMVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // 1. Visit the root.
    // 2. Traverse the left subtree.
    // 3. Traverse the right subtree.
    @discardableResult
    open func accept<Visitor: CSSDOMVisitor>(_ visitor: Visitor) -> Visitor.NodeInfoType? {
        
        let nodeInfo = visitor.visit(self)
        
        if let _nodeInfo = nodeInfo , _nodeInfo.visitChildren {
            
            visitor.push(_nodeInfo)
            
            for child in children {
                
                if let childCSSDOMVisitableElement = child as? CSSDOMVisitable {
                    
                    _ = childCSSDOMVisitableElement.accept(visitor)
                }
                else {
                    
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("child is not CSSDOMVisitable.", log: Log.Web.all, type: .error)
                    #endif
                }
            }   
            visitor.pop()
        }
        return nodeInfo
    }
    
    @discardableResult
    open func acceptSingle<Visitor: CSSDOMVisitor>(_ visitor: Visitor) -> Visitor.NodeInfoType? {
        
        return visitor.visit(self)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: MessageContainer protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    open func addMessages(_ messages: Array<Message>) {
        
        for message in messages {
            
            addMessage(message)
        }
    }
    
    open func addMessages(_ messages: OrderedSet<Message>) {
        
        for message in messages {
            
            addMessage(message)
        }
    }
    
    open func addMessage(_ message: Message) {
        
        addMessageAttribute(from: message)
        messageHandler.addMessage(message)
    }
    
    @discardableResult
    open func addMessage(_ code: MessageCode, args: [CVarArg]? = nil) -> Message {
        
        let message = messageHandler.addMessage(code, args: args)
        addMessageAttribute(from: message)
        return message
    }
    
    @discardableResult
    open func addMessage(_ code: MessageCode, args: [CVarArg]?, fromMessage messageDependency: Message) -> Message {
        
        let message = messageHandler.addMessage(code, args: args)
        
        addMessageAttribute(from: message)
        
        return message
    }
    
    @discardableResult
    func addMessage(_ code: MessageCode, args: [CVarArg]?, fromMessages messageDependencies: Array<Message>) -> Message {
        
        let message = messageHandler.addMessage(code, args: args)
        
        addMessageAttribute(from: message)
        
        return message
    }
 
    fileprivate func addMessageAttribute(from message: Message) {
        
        var exception = Exception()
        
        if self.hasAttribute(§DomAttributeString.MessageId) {
         
            let existingValue = self.getAttribute(§DomAttributeString.MessageId)
            assert(existingValue != nil)
            setAttribute(§DomAttributeString.MessageId, value: "\(existingValue!) \(message.uuid)", exception: &exception)
        }
        else {
            setAttribute(§DomAttributeString.MessageId, value: message.uuid, exception: &exception)
        }
        
        if self.hasAttribute(§DomAttributeString.MessageCode) {
        
            let existingValue = self.getAttribute(§DomAttributeString.MessageCode)
            assert(existingValue != nil)
            setAttribute(§DomAttributeString.MessageCode, value: "\(existingValue!) \(message.code)", exception: &exception)
        }
        else {
            
            setAttribute(§DomAttributeString.MessageCode, value: String(describing: message.code), exception: &exception)
        }
        if !self.hasClassAttribute(§message.messageSeverity) {
            addClassAttribute(§message.messageSeverity)
        }
        exception.logIfError()
    }
    
}
