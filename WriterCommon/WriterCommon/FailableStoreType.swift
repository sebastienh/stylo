//
//  FailableStoreType.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-01-01.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Common

public enum FailableStoreState {
    
    case singleError(messageId: String)
    case allError
    case source
    
}

public protocol FailableStoreType {
    
    var errorMessages: DynamicArray<Message> { get }
    
    var storeState: Dynamic<FailableStoreState> { get }
}
