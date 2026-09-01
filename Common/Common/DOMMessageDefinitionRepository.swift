//
//  DOMMessageDefinitionRepository.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-02.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation



struct DOMMessageDefinitionRepository : DomainMessageDefinitionRepository {
    
    let messages = [
        
        MessageCode.errorGettingStyleSheet :
            MessageDefinition(
                domain: MessageDomain.dom,
                module: MessageModule.Compiler,
                code: MessageCode.errorGettingStyleSheet,
                severity: MessageSeverity.Error,
                messageKey: "Error while getting style sheet at URL : %s",
                comment: "Message to display when we get an error trying to resolve an URL to get the content of a CSS style sheet.",
                messageTable: MessageTable.DOMErrorMessages),

    ]
}
