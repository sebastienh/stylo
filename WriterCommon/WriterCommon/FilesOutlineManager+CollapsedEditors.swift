//
//  FilesOutlineManager+CollapsedEditors.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-08-23.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation

extension FilesOutlineManager {
    
    public func isTextManagerCollapsed(with textManagerId: String) -> Bool {
        
        return collapsedEditorItems.contains(textManagerId)
    }
    
    public func uncollapseTextEditor(with textManagerId: String) throws {
        
        guard let dispatcher = self.dispatcher else {
            assertionFailure("Error: self.dispatcher is nil")
            return
        }
        
        try dispatcher.online(store: self.filesOutlineStore, action: FilesOutlineAction.editorUncollapsed(id: textManagerId))
    }
    
    public func collapseTextEditor(with textManagerId: String) throws {
        
        guard let dispatcher = self.dispatcher else {
            assertionFailure("Error: self.dispatcher is nil")
            return
        }
        
        try dispatcher.online(store: self.filesOutlineStore, action: FilesOutlineAction.editorCollapsed(id: textManagerId))
    }
}
