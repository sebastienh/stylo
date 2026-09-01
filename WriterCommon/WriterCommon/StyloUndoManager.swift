//
//  StyloUndoManager.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-11-17.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Common

public class StyloUndoManager: UndoManager {
    
    public override var canRedo: Bool {
        return !redoStack.isEmpty
    }
    
    public override var canUndo: Bool {
        return !undoStack.isEmpty
    }
    
    public override var isUndoing: Bool {
        return _isUndoing
    }

    public override var isRedoing: Bool {
        return _isRedoing
    }
    
    var _isUndoing: Bool = false

    var _isRedoing: Bool = false
    
    var undoStack = Stack<UndoCommand>()
    
    var redoStack = Stack<UndoCommand>()
    
    private weak var textDocument: TextDocument?
    
    private var documentManager: DocumentManager? {
        
        return textDocument?.documentManager
    }
    
    init(textDocument: TextDocument) {
        self.textDocument = textDocument
        super.init()
    }
    
    public override func undo() {
        
        // we call restoreTemporaryDisabledFocusIfNecessary at the of the compilation
        if let undoComand = self.undoStack.safePop() {
        
            self.documentManager?.temporaryDisableFocus()
            
            self._isUndoing = true
            self.redoStack.push(undoComand)
            undoComand.undo(fromUndoManager: self)
            self._isUndoing = false
        }
    }
    
    public override func redo() {
        
        // we call restoreTemporaryDisabledFocusIfNecessary at the of the compilation
        if let redoCommand = self.redoStack.safePop() {
            
            self.documentManager?.temporaryDisableFocus()
            
            self._isRedoing = true
            self.undoStack.push(redoCommand)
            redoCommand.redo(fromUndoManager: self)
            self._isRedoing = false
        }
    }
    
    func registerUndo(_ undo: UndoCommand) {
        undoStack.push(undo)
        self.redoStack.clear()
    }
    
}
