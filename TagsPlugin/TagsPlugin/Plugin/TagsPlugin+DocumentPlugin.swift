//
//  TagsPlugin+DocumentPlugin.swift
//  TagsPlugin
//
//  Created by Sebastien Hamel on 2020-06-04.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Foundation
import WriterCommon
import Common
import os

extension TagsPlugin: DocumentPlugin {
    
    var isEdited: Bool {
        return false
    }
    
    var isDraft: Bool {    
        return false
    }
    
    // This is the initial step to loading a plugin.
    public func pluginDidLoad() {
        
        // nothing to do
    }
    
    public func documentDidLoad() {
        
        // nothing to do
    }
    
    func documentWillClose() {
        
        // nothing to do
    }
    
    func documentWillSave() {
        // nothing to do
    }
    
    func documentDidSave() {
        
        // nothing to do
    }
}
