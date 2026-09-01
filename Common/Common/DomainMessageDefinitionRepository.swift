//
//  DomainMessageRepository.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-21.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

protocol DomainMessageDefinitionRepository {
    
    var messages: [MessageCode: MessageDefinition] { get }
    
    func messageDefinitionFromCode(_ code: MessageCode) -> MessageDefinition?
}

/// Default implementations.
extension DomainMessageDefinitionRepository {
    
    func messageDefinitionFromCode(_ code: MessageCode) -> MessageDefinition? {
        
        return messages[code]
    }   
}
