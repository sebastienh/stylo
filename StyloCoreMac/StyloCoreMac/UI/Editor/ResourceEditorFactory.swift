//
//  ResourceEditorFactory.swift
//  MacWriterCommon
//
//  Created by Sebastien Hamel on 2020-01-02.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Foundation
import WriterCommon

public protocol ResourceEditorFactory: class {
    
    static func GetResourceEditorInstance(_ editableManager: AnyEditable, andContentSize contentSize: NSSize) -> ResourceEditorView
}
