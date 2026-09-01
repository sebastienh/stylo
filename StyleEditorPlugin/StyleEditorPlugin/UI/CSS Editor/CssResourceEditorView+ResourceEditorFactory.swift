//
//  CssResourceEditorView+Builder.swift
//  StyleEditorPlugin
//
//  Created by Sebastien Hamel on 2020-01-02.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Foundation
import StyloCoreMac
import WriterCommon
import Cocoa

extension CssResourceEditorView: ResourceEditorFactory {
    
    static func GetResourceEditorInstance(_ editableManager: AnyEditable, andContentSize contentSize: NSSize) -> ResourceEditorView {
        fatalError("not implemented because we want the window to be passed")
    }
    
    public class func GetResourceEditorInstance(_ editableManager: AnyEditable, andContentSize contentSize: NSSize, window: NSWindow?) -> ResourceEditorView {
        
        let id: EditorId = UUID().uuidString
        
        let _textStorage = editableManager.textStorage(forEditorWithId: id)
        
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
        
        assert(editableManager.editedLanguage == .CSS || editableManager.editedLanguage == .CCSS)
        let resourceEditorView: CssResourceEditorView = CssResourceEditorView(id: id,
            frame: NSMakeRect(0,0, contentSize.width, contentSize.height),
            textContainer: textContainer, editable: editableManager)
        
        resourceEditorView.addAutocompletionSupport(for: editableManager.editedLanguage, window: window)
        layoutManager.allowsNonContiguousLayout = false
        resourceEditorView.isAutomaticSpellingCorrectionEnabled = false
        resourceEditorView.isAutomaticTextReplacementEnabled = false
        resourceEditorView.isAutomaticSpellingCorrectionEnabled = false
        resourceEditorView.isContinuousSpellCheckingEnabled = false
        resourceEditorView.isGrammarCheckingEnabled = false
        
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
        return resourceEditorView
    }
    
}
