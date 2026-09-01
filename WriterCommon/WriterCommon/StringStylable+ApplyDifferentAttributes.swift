//
//  EditorManager+ApplyDifferentAttributes.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-08-01.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

extension StringStylable {
    
    func applyDifferentAttributes(stylableActionResults: [EditorId: StylableActionResult], fromOriginStringAction stringAction: StringAction) {
        
        assert(Thread.isMainThread)
        guard let stylableActionResult: StylableActionResult = stylableActionResults[self.renderer.id] else {
            assertionFailure("Error: stylableActionResult is nil")
            return
        }
        
        applyDifferentAttributes(stylableActionResult, fromOriginStringAction: stringAction)
    }
    
    func applyDifferentAttributes(_ stylableActionResult: StylableActionResult, fromOriginStringAction stringAction: StringAction) {
        
        guard let renderingProcessingResults = stylableActionResult.renderingProcessingResults else {
            assertionFailure("Error: renderingProcessingResults is nil")
            return
        }

        let nonFocusRenderingProcessingResults = renderingProcessingResults.filter { (result) -> Bool in
            return !result.isFocused
        }
        
        if !nonFocusRenderingProcessingResults.isEmpty {
            textStorage.beginEditing()
            for renderingProcessingResult in nonFocusRenderingProcessingResults {
                self.applySourceAttributes(fromRenderingProcessingResult: renderingProcessingResult)
            }
            textStorage.endEditing()
        }
        
        let focusRenderingProcessingResults = renderingProcessingResults.filter { (result) -> Bool in
            return result.isFocused
        }
        
        for renderingProcessingResult in focusRenderingProcessingResults {
            self.applyFocusAttributes(fromRenderingProcessingResult: renderingProcessingResult, stringAction: stringAction)
        }

        ensureLayout(fromOriginStringAction: stringAction)
    }
    
    private func ensureLayout(fromOriginStringAction stringAction: StringAction) {
        
        switch stringAction {
        case .`init`: fallthrough
        case .edit: fallthrough
        case .flash: fallthrough
        case .focus: fallthrough
        case .refocus:
            break
        case .highlight: fallthrough
        case .clearHighlight: fallthrough
        case .select: fallthrough
        case .changeStyle:
            self._ensureLayout()
        }
    }
    
    private func _ensureLayout() {
        
        assert(textStorage.layoutManagers.count == 1)
        guard let layoutManager = textStorage.layoutManagers.first else {
            assertionFailure("Error: layoutManager is nil")
            return
        }

        assert(layoutManager.textContainers.count == 1)
        guard let textContainer = layoutManager.textContainers.first else {
            assertionFailure("Error: textContainer is nil")
            return
        }

        layoutManager.ensureLayout(for: textContainer)
    }
}
