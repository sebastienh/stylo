//
//  JsonResourceEditorView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-08-11.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon
import StyloCoreMac
import Common
import os

extension JsonResourceEditorView: ResourceEditorFactory {
    
    public class func GetResourceEditorInstance(_ editableManager: AnyEditable, andContentSize contentSize: NSSize) -> ResourceEditorView {
             
             let _textStorage = editableManager.localTextStorage
             
             #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
             os_log("editableManager.localTextStorage size: %d", log: Log.MacWriterCommon.all, type: .debug, editableManager.localTextStorage.length)
             os_log("editableManager.localTextStorage.delegate: %@", log: Log.MacWriterCommon.all, type: .info, %%String(describing: editableManager.localTextStorage.delegate))
             #endif
             
             let layoutManager = ResourceLayoutManager()
             layoutManager.backgroundLayoutEnabled = true
             
             _textStorage.addLayoutManager(layoutManager)
             
             let textContainer = NSTextContainer(containerSize: NSMakeSize(contentSize.width, CGFloat.greatestFiniteMagnitude))
             
             textContainer.widthTracksTextView = true
             textContainer.heightTracksTextView = false
             
             layoutManager.addTextContainer(textContainer)
             
             let resourceEditorView = JsonResourceEditorView(
                     frame: NSMakeRect(0,0, contentSize.width, contentSize.height),
                     textContainer: textContainer, editable: editableManager)
             resourceEditorView.isRichText = false
             resourceEditorView.font = NSFont(name: "Menlo", size: 12.0)
             resourceEditorView.textColor = NSColor.textColor
             resourceEditorView.backgroundColor = NSColor.textBackgroundColor
             layoutManager.allowsNonContiguousLayout = false
             
             resourceEditorView.isAutomaticSpellingCorrectionEnabled = false
             resourceEditorView.isAutomaticTextReplacementEnabled = false
             resourceEditorView.isAutomaticSpellingCorrectionEnabled = false
             resourceEditorView.isContinuousSpellCheckingEnabled = false
             resourceEditorView.isGrammarCheckingEnabled = false
               
             assert(resourceEditorView.textStorage === editableManager.localTextStorage)
             editableManager.register(sourceStringAttributesRenderer: resourceEditorView)
             
             resourceEditorView.alphaValue = 1.0
             resourceEditorView.isVerticallyResizable = true
             resourceEditorView.isHorizontallyResizable = false
             resourceEditorView.maxSize = NSMakeSize(contentSize.width, CGFloat.greatestFiniteMagnitude)
             resourceEditorView.isAutomaticQuoteSubstitutionEnabled = false
             resourceEditorView.isAutomaticDashSubstitutionEnabled = false
             resourceEditorView.usesFontPanel = false
             resourceEditorView.allowsUndo = false
             resourceEditorView.autoresizingMask = .width
             resourceEditorView.listenToDidClikDomInspectableNodeNotifications(editableManager)
             
             resourceEditorView.updateSeletionAttributes(from: editableManager)
             resourceEditorView.bindSelectionAttributes(to: editableManager)
             
             return resourceEditorView
         }
}


final class JsonResourceEditorView: ResourceEditorView {
    
}
