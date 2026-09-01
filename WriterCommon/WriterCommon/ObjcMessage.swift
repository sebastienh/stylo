//
//  ObjcMessage.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-12-02.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import Common

@objc class ObjcMessage: NSObject {
    
    let error: Message
    
    init(error: Message) {
        self.error = error
    }
}
