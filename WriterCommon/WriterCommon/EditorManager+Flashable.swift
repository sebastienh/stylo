//
//  EditorManager+Flashable.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-11-15.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Common
import PromiseKit
import Igloo
import Web
import os

extension EditorManager {
    
    public func flashAttributes(inRange range: NSRange, topElements: ContiguousArray<Element>, document: Document) -> [AttributesRange]? {
        
        let applyFlashAction = StylableStoreAction.flash(topElements: topElements, range: range, document: document)
        
        guard let result: ActionResult = dispatcher.sync(store: styledStoreManager.styledStore, action: applyFlashAction.syncAction) else {
            assertionFailure("Error: result is nil")
            return nil
        }
        
        guard let applyFlashResult: StylableActionResult = result as? StylableActionResult else {
            assertionFailure("Error: applyFocusResult is nil")
            return nil
        }
        
        guard let attributes: [RenderingProcessingResult.AttributeAction: [AttributesRange]] = applyFlashResult.attributes else {
            assertionFailure("Error: attributes is nil")
            return nil
        }
        
        guard let addedAttributes = attributes[.add] else {
            assertionFailure("Error: addedAttributes is nil")
            return nil
        }
        
        return addedAttributes
    }
    
    public func clearFlashAttributes() {
        
        self.renderer.removeFlash()
    }
    
}
