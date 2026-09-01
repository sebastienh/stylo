//
//  MessageHandler.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-19.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation


public struct MessageHandler {
    
    public init() {
        
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: public implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////

    public var allMessages: OrderedSet<Message> = OrderedSet<Message>()
    
    public mutating func addMessages(_ messages: OrderedSet<Message>) {
        
        for message in messages {
            
            addMessage(message)
        }
    }
    
    public mutating func addMessage(_ message: Message) {
        
        allMessages.append(message)
    }
    
    @discardableResult
    public mutating func addMessage(_ code: MessageCode, args: [CVarArg]? = nil) -> Message {
        
        let message = Message.CreateMessage(code, args: args)
        
        allMessages.append(message)
        
        return message 
    }

    
    func displayMessages() {
        
        for message in allMessages {
            
            print(message.localizedMessage)
        }
    }
    
    func isEmpty() -> Bool {
        
        return allMessages.isEmpty
    }
    
    func hasMessage(with code: MessageCode) -> Bool {
        
        for message in allMessages {
            if message.code == code {
                return true
            }
        }
        return false
    }
    
    func hasMessages() -> Bool {
        
        return hasErrors() || hasWarnings()
    }
    
    func hasErrors() -> Bool {
        
        if numberOfMessages(with: MessageSeverity.Error) > 0 {
            
            return true
        }
        return false
    }
    
    func hasWarnings() -> Bool {
        
        if numberOfMessages(with: MessageSeverity.Warning) > 0 {
            
            return true
        }
        return false
    }
    
    func numberOfMessages(with severity: MessageSeverity) -> Int {
        
        var numberOfErrorMessages: Int = 0
        
        for message in allMessages {
            
            if message.messageSeverity == severity {
                
                numberOfErrorMessages += 1
            }
        }
        
        return numberOfErrorMessages
    }
    
    public mutating func reset() {
        
        allMessages.removeAll(keepingCapacity: true)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: private implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    fileprivate func hasMessage(_ code: MessageCode) -> Bool {
        
        for message in allMessages {
            
            if message.code == code {
                
                return true
            }
        }
        return false
    }
    
}
