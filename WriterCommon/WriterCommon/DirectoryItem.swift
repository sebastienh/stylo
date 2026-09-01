//
//  DirectoryItem.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-07-25.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import Igloo

public protocol DirectoryItem: IdentifiableStoreType {
    
    var isDirectory: Bool { get }
    
}

extension MarkdownDocumentStore: DirectoryItem {
    
    public var isDirectory: Bool {
        return false
    }
}

extension DirectoryStore: DirectoryItem {
    
    public var isDirectory: Bool {
        return true
    }
}
