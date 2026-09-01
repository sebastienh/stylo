//
//  CSSParsingError.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-12-23.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import os

public struct Message: Hashable {

    public static func == (lhs: Message, rhs: Message) -> Bool {
        
        if lhs.code != rhs.code {
            return false
        }
        if lhs.domain != rhs.domain {
            return false
        }
        if lhs.messageKey != rhs.messageKey {
            return false
        }
        if lhs.messageSeverity != rhs.messageSeverity {
            return false
        }
        if lhs.comment != rhs.comment {
            return false
        }
        if lhs.uuid != rhs.uuid {
            return false
        }
        if lhs.module != rhs.module {
            return false
        }
        if lhs.table != rhs.table {
            return false
        }
        if lhs.fragment != nil && rhs.fragment == nil {
            return false
        }
        if rhs.fragment != nil && lhs.fragment == nil {
            return false
        }
        if let fragment1 = rhs.fragment, let fragment2 = lhs.fragment, !fragment1.equals(to: fragment2) {
            return false
        }
        
        return true
    }
    
    public var hashValue: Int {
        
        return uuid.hashValue
    }
    
    /// Message definition
    public let code: MessageCode
    public let domain: MessageDomain
    public let messageKey: String
    public let messageSeverity: MessageSeverity
    public let comment: String
    public let args: [CVarArg]?
    public let uuid: String
    public let module: MessageModule
    public let table: MessageTable
    
    public var fragment: SourceStringFragment?
    
    /// Message dependencies: those are the first degree dependencies
    /// I do not incude here the dependencies of the dependencies.
    var messageDependencies: Array<Message>
    
    /// Message propagation: those are the first level of propagation
    /// of the error.
    var messagePropagation: Array<Message>
    
    public var localizedMessage: String {
        
        if let args = args {
            
            let localizedString = NSLocalizedString(self.messageKey, tableName: domain.tableFromDomain(), comment: self.comment)
            
            return String(format: localizedString, arguments: args)
        }
        else {
            return NSLocalizedString (
                self.messageKey,
                tableName: String("CSS"),
                comment: self.comment)
        }
    }
    
    public static func CreateMessage(_ code: MessageCode, args: [CVarArg]? = nil) -> Message {
    
        let stringArgs: [String]? = {
           
            if let args = args {
                var stringArgs = [String]()
                for arg in args {
                    stringArgs.append(arg as! String)
                }
                return stringArgs
            }
            return nil
        }()
        
        let repository = MessageDefinitionRepository.shared
        
        if let domain = domainFromCode(code) {
            
            if let messageDefinition: MessageDefinition = repository.messageDefinitionFromDomain(domain, andCode: code) {
                
                let message = messageFromMessageDefinition(
                    messageDefinition,
                    args: stringArgs)
                
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("message: %@", log: Log.WriterCommon.all, type: .info, %%message.localizedMessage)
                #endif
                
                return message
            }
            else {
                
                fatalError("Can not get message definition from domain \(domain) and code \(code)")
            }
        }
        else {
            
            fatalError("Can not get domain from code \(code)")
        }
    }
    
    static func messageFromMessageDefinition(_ messageDefinition: MessageDefinition, args: [String]? = nil) -> Message {
        
        return Message(
            definition: messageDefinition,
            args: args)
    }
    
    static func domainFromCode(_ code: MessageCode) -> MessageDomain? {
        
        let intValue = §code
        
        let domainCode = (intValue / 1000) * 1000
        
        return MessageDomain(rawValue: domainCode)
    }
    
    init(message: Message) {
        
        self.init(domain: message.domain, module: message.module, code: message.code, severity: message.messageSeverity, messageKey: message.messageKey, comment: message.comment, messageTable: message.table, args: message.args)
    }
    
    init(definition: MessageDefinition) {
        
        self.init(definition: definition, args: nil)
    }
    
    fileprivate init(definition: MessageDefinition, args: [CVarArg]? = nil) {
        
        self.init(domain: definition.domain, module: definition.module, code: definition.code, severity: definition.severity, messageKey: definition.messageKey, comment: definition.comment, messageTable: definition.messageTable, args: args)
    }
    
    fileprivate init(domain: MessageDomain, module: MessageModule, code: MessageCode, severity: MessageSeverity, messageKey: String, comment: String, messageTable: MessageTable, args: [CVarArg]? = nil) {
        
        self.domain = domain
        self.code = code
        self.messageKey = messageKey
        self.messageSeverity = severity
        self.comment = comment
        self.args = args
        self.uuid = UUID().uuidString
        self.module = module
        self.table = messageTable
        
        // init variables
        self.messageDependencies = Array<Message>()
        self.messagePropagation = Array<Message>()
        
//        super.init()
    }
    
    
    mutating public func addMessageDependency(_ dependency: Message) {
        
        messageDependencies.append(dependency)
    }
    
    mutating func addMessagePropagation(_ propagationMessage: Message) {
        
        messagePropagation.append(propagationMessage)
    }
    
    public func logError() {
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("%@", log: Log.Common.all, type: .debug, self.localizedMessage)
        #endif
    }
}


