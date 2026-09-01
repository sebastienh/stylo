//
//  MessageContainer.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-09-23.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation

public protocol MessageContainer {
    
    var messageHandler: MessageHandler { get set }
    
    var allMessages: OrderedSet<Message> { get }
    
    func messageWithCode(_ messageCode: MessageCode) -> Message?
    
    mutating func add(_ message: Message)
    
    mutating func addMessages(_ messages: OrderedSet<Message>)
    
    mutating func addMessage(_ code: MessageCode, args: [CVarArg]?) -> Message
    
    mutating func addMessage(_ code: MessageCode, args: [CVarArg]?, fromMessages messageDependencies: Array<Message>) -> Message
    
    mutating func addMessage(_ code: MessageCode, args: [CVarArg]?, fromMessage messageDependency: Message) -> Message
    
    func displayMessages()
    
    func isEmpty() -> Bool
    
    func hasMessage(with code: MessageCode) -> Bool
    
    func hasMessages() -> Bool
    
    func hasWarnings() -> Bool 
    
    func hasErrors() -> Bool
    
    func numberOfErrorMessages() -> Int

    mutating func reset()
}

extension MessageContainer {
    
    public var allMessages: OrderedSet<Message> {
        
        return messageHandler.allMessages
    }
    
    public mutating func addMessages(_ messages: OrderedSet<Message>) {
        
        messageHandler.addMessages(messages)
    }
    
    public func hasMessage(with code: MessageCode) -> Bool {
        
        return messageHandler.hasMessage(with: code)
    }
    
    public func messageWithCode(_ messageCode: MessageCode) -> Message? {
        
        for message in messageHandler.allMessages {
            
            if message.code == messageCode {
                
                return message
            }
        }
        return nil
    }
    
    public mutating func add(_ message: Message) {
        
        messageHandler.addMessage(message)
    }
    
    @discardableResult
    public mutating func addMessage(_ code: MessageCode, args: [CVarArg]? = nil) -> Message {
        
        return messageHandler.addMessage(code, args: args)
    }
    
    @discardableResult
    public mutating func addMessage(_ code: MessageCode, args: [CVarArg]?, fromMessages messageDependencies: Array<Message>) -> Message {
        
        var message = addMessage(code, args: args)
        
        for var messageDependency in messageDependencies {
            
            message.addMessageDependency(messageDependency)
            messageDependency.addMessagePropagation(message)
        }
        
        return message
    }
    
    @discardableResult
    public mutating func addMessage(_ code: MessageCode, args: [CVarArg]?, fromMessage messageDependency: Message) -> Message {
        
        var message = addMessage(code, args: args)
        
        message.addMessageDependency(messageDependency)
        
        return message
    }
    
    public func displayMessages() {
        
        messageHandler.displayMessages()
    }
    
    public func isEmpty() -> Bool {
        
        return messageHandler.isEmpty()
    }
    
    public func hasMessages() -> Bool {
        
        return messageHandler.hasMessages()
    }
    
    public func hasWarnings() -> Bool {
        
        return messageHandler.hasWarnings()
    }
    
    public func hasErrors() -> Bool {
        
        return messageHandler.hasErrors()
    }
    
    public func numberOfErrorMessages() -> Int {
        
        return messageHandler.numberOfMessages(with: MessageSeverity.Error)
    }
    
    public mutating func reset() {
        
        messageHandler.reset()
    }
    
    
}
