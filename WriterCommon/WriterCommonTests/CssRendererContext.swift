//
//  CssRendererContext.swift
//  WriterCommonTests
//
//  Created by Sebastien Hamel on 2020-12-31.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
@testable import WriterCommon
import Web
import Common
import os
import Igloo

struct CssRendererContext: RendererContext {
    
    var attributedString: NSAttributedString {
        
        return self.stylesheetStyleStore.attributesStore.attributedString
    }
    
    var document: Document {
        
        return self.stylesheetDocumentStore.document.value!
    }
    
    var string: String
    let dispatcher: StylesheetDocumentDispatcher
    let stylesheetDocumentStore: StylesheetDocumentStore
    var stylesheetStyleStore: StylesheetStyleStore
    
    mutating func applyChange(range: NSRange, insertedString: String, visibleRange: NSRange?) {
        
        var string = self.string
        guard let stringIndexRange = range.stringIndexRange(inString: string) else {
            assertionFailure("Error: stringIndexRange is nil")
            return
        }
        
        string.replaceSubrange(stringIndexRange, with: insertedString)
        self.string = string
        
        let changeLength = insertedString.utf16.count - range.length
        
        // insert a character after the strong tag
        let change = SourceStringChangeDescription(range: range, stringReplacement: insertedString, changeLength: changeLength, targetString: string)
        
        let sourceStringChangedAction = EditableStoreAction.sourceStringChanged(description: change).syncAction
        let result = dispatcher.sync(store: stylesheetDocumentStore, action: sourceStringChangedAction)
        
        guard let documentStoreActionResult = result as? DocumentStoreActionResult else {
            
            let errorString = "Invalid action result expecting DocumentStoreActionResult received: \(String(describing: result))."
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("%@", log: Log.WriterCommon.all, type: .error, %%errorString)
            #endif
            return
        }
        
        let lastCompiledDocument = documentStoreActionResult.lastCompiledDocument!
        
        if documentStoreActionResult.containsCompleteUpdate {
            
            let styleAssemblyStore = StylesheetStyleStore(string: string, focusMode: FocusMode.disabled, resourceComputedStyle: stylesheetStyleStore.resourceComputedStyle)
            
            // apply the style
            dispatcher.sync(store: styleAssemblyStore, action: StylableStoreAction.computeInitialAttributes(visibleTopElements: nil, document: lastCompiledDocument, isFirstResponder: true, selectedRange: nil).syncAction)
            self.stylesheetStyleStore = styleAssemblyStore
        }
        else {
            
            let applyStringChangeAction = StylableStoreAction.applySourceStringChange(change: change, documentResults: documentStoreActionResult.updateDocumentResults!, visibleTopElements: nil, document: lastCompiledDocument, isFirstResponder: true).syncAction
            dispatcher.sync(store: stylesheetStyleStore, action: applyStringChangeAction)
        }
    }
    
}
