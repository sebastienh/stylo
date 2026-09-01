//
//  EditorUndoCommand.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-11-21.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Common

struct EditorUndoCommand: UndoCommand, CustomDebugStringConvertible {
    
    var debugDescription: String {
        return "from: \(sourceString) to: \(destinationChange)"
    }
    
    let sourceString: String
    
    let destinationChange: SourceStringChangeDescription
    
    var redoChange: SourceStringChangeDescription {
        return destinationChange
    }
    
    var undoChange: SourceStringChangeDescription? {
        
        let stringValueBefore = sourceString
        let range = NSMakeRange(destinationChange.range.location, destinationChange.utf16SubsequenceReplacement.count)
        
        guard let stringReplacement = stringValueBefore.substringWithUTF16Range(destinationChange.range) else {
            assertionFailure("Error: wrong range: \(destinationChange.range)")
            return nil
        }
        
        let changeLength = stringReplacement.utf16.count - range.length
        
        return SourceStringChangeDescription(range: range, stringReplacement: stringReplacement, changeLength: changeLength, targetString: sourceString)
    }
    
    private weak var editable: AnyEditable?
    
    private let editorId: EditorId
    
    init(sourceString: String, destinationChange: SourceStringChangeDescription, editable: AnyEditable, editorId: EditorId) {
        
        self.sourceString = sourceString
        self.destinationChange = destinationChange
        
        #if DEBUG
        var sourceString = self.sourceString
        sourceString.update(withSourceStringChangeDescription: destinationChange)
        assert(sourceString == destinationChange.targetString)
        #endif
        
        self.editable = editable
        self.editorId = editorId
    }
    
    func undo(fromUndoManager undoManager: StyloUndoManager) {
    
        guard let undoChange = self.undoChange else {
            assertionFailure("Error: undoChange is nil")
            return
        }
        assert(editable?.string == destinationChange.targetString)
        editable?.applyEdit(withChangeDescription: undoChange, forEditorWithId: editorId, undoManager: undoManager, updateAll: true)
        assert(undoChange.targetString == editable?.string)
        assert(editable?.string == sourceString)
    }
    
    func redo(fromUndoManager undoManager: StyloUndoManager) {
        
        assert(editable?.string == sourceString)
        editable?.applyEdit(withChangeDescription: self.redoChange, forEditorWithId: editorId, undoManager: undoManager, updateAll: true)
        assert(self.redoChange.targetString == editable?.string)
        assert(editable?.string == destinationChange.targetString)
    }
}

