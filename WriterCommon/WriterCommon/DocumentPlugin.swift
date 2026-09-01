//
//  DocumentPlugin.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-09-05.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation

public protocol DocumentPlugin {
    
    var documentManager: DocumentManager { get }
    
    var isEdited: Bool { get }
        
    var isDraft: Bool { get }
    
    init(documentManager: DocumentManager)
    
    /// This is the first method called in the plugin, directly
    /// after the document initialized.
    func documentDidLoad()
    
    func documentWillClose()
    
    func documentWillSave()
    
    func documentDidSave()
    
}
