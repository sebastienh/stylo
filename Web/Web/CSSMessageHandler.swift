//
//  CSSErrorHandler.swift
//  ParseUtils
//
//  Created by Sebastien hamel on 2014-12-23.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation


class CSSMessageHandler: MessageHandler {

    let repository: CSSMessageDefinitionRepository
    
    var messageList: [Message]
    
    
    init() {
        self.messageList = [Message]()
        self.repository = CSSMessageDefinitionRepository()
    }
    
    internal func addMessage(code: MessageCode, position: Position, args: [CVarArgType]? = nil) {
        
        if let messageDefinition: MessageDefinition = repository.messageDefinitionFromCode(code
        
            let message = messageFromMessageDefinition(messageDefinition, andPosition: position)
        
            
        }
        else {
            
            fatalError("non existent messsage")
        }
    }
    
    func messageFromMessageDefinition(messageDefinition: MessageDefinition, andPosition position: Position) -> Message {
    
        
        
    }
    
    internal func addMessage(code: MessageCode, position: Position) {
        
        fatalError("Missing implementation.")
    }
    
    internal func reset() {
        messageList.removeAll(keepCapacity: true)
    }
    
    func hasMessage(code: MessageCode) -> Bool {
        
        for message in messageList {
        
            if message.code == code {
                
                return true
            }
        }
        return false
    }
    
    func displayMessages() {
        
        for message in messageList {
            println(message.localizedMessage())
        }
    }
    
    func isEmpty() -> Bool {
        
        return messageList.isEmpty
    }
    
    func hasError() -> Bool {
        
        if numberOfErrorMessages() > 0 {

            return true
        }
        return false
    }
    
    func numberOfErrorMessages() -> Int {
        
        var numberOfErrorMessages: Int = 0
        
        for message in messageList {
            
            if message.messageSeverity == MessageSeverity.Error {
                numberOfErrorMessages++
            }
        }
        
        return numberOfErrorMessages
    }
    
}