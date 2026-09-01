//
//  DocumentStoreType.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-04-16.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Web
import Common
import WebKit
import Igloo

enum DocumentStoreAction: ActionType {

    case compileInitialDocument(description: SourceStringChangeDescription)
    case topElementsAroundRange(range: NSRange)
    
}

public protocol DocumentStoreType {
    
    var document: Dynamic<Document?> { get }
    
}
