//
//  ErrorMessage.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2016-01-17.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation
import Common

public struct ErrorMessage {
    
    let message: Message

    var type: MessageSeverity {
        
        return message.messageSeverity
    }
    
    var localizedMessage: String {
        
        return message.localizedMessage
    }
}
