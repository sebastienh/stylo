//
//  Message+Clonable.swift
//  Common
//
//  Created by Sébastien Hamel on 2018-04-29.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation

extension Message: Clonable {
    
    public typealias ClonableType = Message
    
    public func clone() -> Message {
        
        let message = Message.CreateMessage(self.code, args: self.args)
        return Message(message: message)
    }
}
