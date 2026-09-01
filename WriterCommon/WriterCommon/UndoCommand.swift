//
//  UndoCommand.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-11-21.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Common

protocol UndoCommand {
    
    func undo(fromUndoManager undoManager: StyloUndoManager)
    
    func redo(fromUndoManager undoManager: StyloUndoManager)
}
