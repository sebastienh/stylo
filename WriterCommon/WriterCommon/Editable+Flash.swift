//
//  Editable+Flash.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-07-16.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Common
import PromiseKit
import Igloo
import Web
import os

#if os(OSX)
import Cocoa
#elseif os(iOS)
import UIKit
#endif


extension Editable {
    
    public func flashAttributes(forEditorWithId editorId: EditorId, inRange range: NSRange) -> [AttributesRange]? {
        
        guard let textManager = self as? TextManager else {
            assertionFailure("Error: flash attributes not supported")
            return nil
        }
        
        guard let document = textManager.document.value else {
            assertionFailure("Error: document is nil")
            return nil
        }
        
        guard let editorManager = self.editorManagers.values[editorId] else {
            assertionFailure("Error: editorManager is nil")
            return nil
        }
        
        guard let actionResult: ActionResult = dispatcher.sync(store: self.editableStore, action: DocumentStoreAction.topElementsAroundRange(range: range).syncAction) else {
            assertionFailure("Error: actionResult is nil")
            return nil
        }
        
        guard let documentStoreActionResult: DocumentStoreActionResult = actionResult as? DocumentStoreActionResult else {
            assertionFailure("Error: documentStoreActionResult is nil")
            return nil
        }
        
        guard let topElementsAroundRange: ContiguousArray<Element> = documentStoreActionResult.topElementsAroundRange else {
            assertionFailure("Error: topElementsAroundRange is nil")
            return nil
        }
        
        return editorManager.flashAttributes(inRange: range, topElements: topElementsAroundRange, document: document)
    }
    
}
