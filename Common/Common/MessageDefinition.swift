//
//  MessageDefinition.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-19.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

struct MessageDefinition {
    
    let domain: MessageDomain
    let module: MessageModule 
    let code: MessageCode
    let severity: MessageSeverity
    let messageKey: String
    let comment: String
    let messageTable: MessageTable
    
    init(domain: MessageDomain, module: MessageModule, code: MessageCode, severity: MessageSeverity, messageKey: String, comment: String, messageTable: MessageTable) {
        self.domain = domain
        self.module = module
        self.code = code
        self.severity = severity
        self.messageKey = messageKey
        self.comment = comment
        self.messageTable = messageTable
    }
    
}
