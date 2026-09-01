//
//  CSSTokenCompositor.swift
//  Web
//
//  Created by Sébastien Hamel on 2016-09-24.
//  Copyright © 2016 NM. All rights reserved.
//

import Foundation
import Common

protocol CSSTokenCompositor: Token {
    
    var token: CSSToken { get set }
}

extension CSSTokenCompositor {
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Token protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    var tokenId: Int {
        return token.tokenId
    }
    
    var rawStringValue: String {
        get {
            return token.rawStringValue
        }
        set {
            token.rawStringValue = newValue
        }
    }
    
    var formattedStringValue: String? {
        return token.formattedStringValue
    }
    
    var stringRepresentation: String {
        return token.stringRepresentation
    }
    
    var sourceStringSegment: SourceStringSegment? {
        return token.sourceStringSegment
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CustomStringConvertible protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    var description: String {
        return token.description
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Positionnable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    var sourceStringFragment: SourceStringFragment? {
        
        get {
            return token.sourceStringFragment
        }
        set {
            token.sourceStringFragment = newValue 
        }
    }
    
    /// This method translate the position of the fragment using
    // the count from which moving the fragment by adding this count
    // to the start and end index.
    public mutating func move(_ count: Int) {

        self.sourceStringFragment?.move(count)
        self.token.move(count)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: MessageContainer protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    var messageHandler: MessageHandler {
        get {
            return self.token.messageHandler
        }
        set {
            self.token.messageHandler = newValue
        }
    }
    
    var allMessages: OrderedSet<Message> {
        return token.allMessages
    }
    
    mutating func addMessage(_ code: MessageCode, args: [CVarArg]?) -> Message {
        return token.messageHandler.addMessage(code, args: args)
    }
    
    mutating func addMessage(_ code: MessageCode, args: [CVarArg]?, fromMessage messageDependency: Message) -> Message {
        return token.messageHandler.addMessage(code, args: args)
    }
    
    func displayMessages() {
        token.displayMessages()
    }
    
    func isEmpty() -> Bool {
        return token.isEmpty()
    }
    
    func hasErrors() -> Bool {
        return token.hasErrors()
    }
    
    func numberOfErrorMessages() -> Int {
        return token.numberOfErrorMessages()
    }
    
    mutating func reset() {
        token.messageHandler.reset()
    }
}
