//
//  StyleSetManager+UndoManager.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-08-18.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

extension StyleSetManager {
    
    func setUndoManager(_ undoManager: UndoManager) {
        for styleManager in self.styleManagers.values {
            styleManager.undoManager = undoManager
        }
    }
}
