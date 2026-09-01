//
//  StyloDocument+StyloPlugin.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-11-29.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation

extension TextDocument: StyloPlugin {

    public var name: String {
        return "StyloCore"
    }
    
    public var isEdited: Bool {
        
        return isDocumentEdited
    }
    
    public func pluginDidLoad() {
        
        // nothing to do
    }
}
