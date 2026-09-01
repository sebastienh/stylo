//
//  EditorSelectionChangeEvent.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-11-04.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

public struct FocusedEditorChangeEvent {
    
    public enum Reason {
        case edit
        case moveCursor
        case mouseDown
    }
    
    let editorId: EditorId
    let reason: Reason
    
    public init(editorId: EditorId, reason: Reason) {
        self.editorId = editorId
        self.reason = reason
    }
}
