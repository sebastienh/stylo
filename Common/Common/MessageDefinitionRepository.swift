//
//  MessageDefinitionRepository.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-19.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

final class MessageDefinitionRepository {
    
    
    let messagesDomains = [MessageDomain.css : CSSMessageDefinitionRepository()]
    
    /// Singleton instance.
    static var shared = MessageDefinitionRepository()
    
    fileprivate init() {
        
    }
    
    func messageDefinitionFromDomain(_ domain: MessageDomain, andCode code: MessageCode) -> MessageDefinition? {
            
        if let domainMessages = messagesDomains[domain] {
        
            return domainMessages.messageDefinitionFromCode(code)
        }
        
        return nil
    }
}
