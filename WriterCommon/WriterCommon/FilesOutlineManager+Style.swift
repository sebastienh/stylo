//
//  FilesOutlineManager+StyleAssemblyDescriptor.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-06-24.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import PromiseKit
import os
import Common

extension FilesOutlineManager {

    public var visibleRanges: [EditorId: NSRange?] {
        
        assert(Thread.isMainThread)
        var visibleRanges: [EditorId: NSRange?] = [:]
        for textId in self.selectedTextItems.values {
            
            guard let editorManager = self.editorManager(forTextWithId: textId) else {
                assertionFailure("Error: editorManager is nil")
                continue
            }
            
            guard let editorId = self.editorIds[textId] else {
                assertionFailure("Error: editorId is nil")
                continue
            }
            
            visibleRanges[editorId] = editorManager.visibleRange
        }
        return visibleRanges
    }
    
    public func applyTextStyle(_ styleManager: StyleManager) -> Promise<Void> {
        
        guard let sourceSetManager = self.sourceSetManager else {
            let errorText = "Error: self.sourceSetManager is nil"
            assertionFailure(errorText)
            return Promise(error: NWError.custom(message: errorText))
        }
        
        let appearance = StyloApplication.shared.computedAppearanceOrDefault
        let currentDescriptor = self.styleAssemblyDescriptor.value
        
        self.styleAssemblyDescriptor.setValue(currentDescriptor.same(forAppearance: appearance), notify: false)
        
        return Promise<Void> { fulfill, reject in
            
            var promises = [Promise<Void>]()
            
            for textManagerId in self.selectedTextItems.values {
                
                guard let itemManager = sourceSetManager.directoryItemManager(withId: textManagerId) else {
                    assertionFailure("Error: item manager is nil for id: \(textManagerId)")
                    continue
                }
                
                guard let textManager = itemManager as? TextManager else {
                    assertionFailure("Error: itemManager is not TextManager")
                    continue
                }
                
                let promise = textManager.setStyleAsync(withStyleManager: styleManager)
                promises.append(promise)
            }
            
            when(resolved: promises).then { _ -> Void in
                fulfill(())
            }.catch { error in
                reject(error)
            }
        }
    }
    
    public func resetHighlight() -> Promise<Void>{
        
        self.setStyleAssemblyApplicationStatusIfNecessary(to: .pending)
        let visibleRanges = self.visibleRanges
        
        return Promise<Void> { fulfill, reject in
            
            self.styleAssembliesSerialQueue.async { [weak self] in
                
                if let _self = self {
                    _self.clearHighlightSelector(visibleRanges: visibleRanges)
                    _self.setStyleAssemblyApplicationStatusIfNecessary(to: .applied)
                    _self.selectorString.setValue(nil)
                    _self.requestClearFocus()
                    fulfill(())
                }
                else {
                    reject(NWError.custom(message: "self is nil"))
                }
            }
        }
    }
    
    ///
    /// Method that assign the style highlight style assembly selector to all
    /// associated text managers's editors using the selectors strings array.
    ///
    public func setHighlightStyleAssembly(withSelectors selectors: [String]) -> Promise<Void> {
        
        self.setStyleAssemblyApplicationStatusIfNecessary(to: .pending)
        
        return Promise<Void> { fulfill, reject in
            
            DispatchQueue.main.async {
                
                self.documentManager.clearFocusRequested(fromFilesOutlineWithId: self.id)
                
                let visibleRanges = self.visibleRanges
                
                self.styleAssembliesSerialQueue.async { [weak self] in
                    
                    let selectorString = selectors.joined(separator: ",")
                    
                    if let _self = self {
                        _self.updateHighlightSelector(to: selectorString, visibleRanges: visibleRanges)
                        _self.selectorString.setValue(selectorString)
                        _self.setStyleAssemblyApplicationStatusIfNecessary(to: .applied)
                        fulfill(())
                    }
                    else {
                        reject(NWError.custom(message: "self is nil"))
                    }
                }
            }
        }
    }
    
    private func clearHighlightSelector(visibleRanges: [EditorId: NSRange?]) {
        
        for textId in self.selectedTextItems.values {
            
            guard let editorManager = self.editorManager(forTextWithId: textId) else {
                assertionFailure("Error: editorManager is nil")
                continue
            }
            
            guard let textManager = self.textManager(forTextWithId: textId) else {
                assertionFailure("Error: textManager is nil")
                continue
            }
            
            guard let document = textManager.document.value else {
                assertionFailure("Error: document is nil")
                return
            }
            
            guard let editorId = self.editorIds[textId] else {
                assertionFailure("Error: editorId is nil")
                continue
            }
            
            guard let editorVisibleRange = visibleRanges[editorId] else {
                assertionFailure("Error: editorVisibleRange is nil")
                continue
            }
            
            let visibleTopElements = textManager.visibleTopElementsIfNecessary(inVisibleRange: editorVisibleRange)
            editorManager.clearHighlight(visibleTopElements: visibleTopElements, document: document, selectedRange: editorManager.selectedRange)
        }
    }
    
    private func updateHighlightSelector(to selectorString: String, visibleRanges: [EditorId: NSRange?]) {
        
        for textId in self.selectedTextItems.values {
            
            guard let sourceSetManager = self.sourceSetManager else {
                let errorText = "Error: self.sourceSetManager is nil"
                assertionFailure(errorText)
                continue
            }
            
            guard let editorId = self.editorIds[textId] else {
                assertionFailure("Error: self.editorIds[\(textId)] is nil")
                continue
            }
            
            guard let itemManager = sourceSetManager.directoryItemManager(withId: textId) else {
                assertionFailure("Error: item manager is nil for id: \(textId)")
                continue
            }
            
            guard let textManager = itemManager as? TextManager else {
                assertionFailure("Error: itemManager is not TextManager")
                continue
            }
            
            guard let document = textManager.document.value else {
                assertionFailure("Error: document is nil")
                continue
            }
            
            guard let editorManager = textManager.editorManagers.values[editorId] else {
                assertionFailure("Error: editorManager is nil")
                continue
            }
            
            guard let editorVisibleRange = visibleRanges[editorId] else {
                assertionFailure("Error: editorVisibleRange is nil")
                continue
            }
            
            let visibleTopElements = textManager.visibleTopElementsIfNecessary(inVisibleRange: editorVisibleRange)
            editorManager.highlight(with: selectorString, visibleTopElements: visibleTopElements, document: document, selectedRange: editorManager.selectedRange)
        }
    }
   
    public func applyAppearance(_ appearance: AppearanceMode) {
        
        self.setStyleAssemblyApplicationStatusIfNecessary(to: .pending)
        let currentDescriptor = self.styleAssemblyDescriptor.value
        let targetAppearanceStyleAssemblyDescriptor = currentDescriptor.same(forAppearance: appearance)
        setStyleAssemblyDescriptor(targetAppearanceStyleAssemblyDescriptor, visibleRanges: self.visibleRanges)
        self.setStyleAssemblyApplicationStatusIfNecessary(to: .applied)
    }
    
    public func applyAppearanceAsync(_ appearance: AppearanceMode) -> Promise<Void> {
        
        let currentDescriptor = self.styleAssemblyDescriptor.value
        let targetAppearanceStyleAssemblyDescriptor = currentDescriptor.same(forAppearance: appearance)
        return setStyleAssemblyDescriptorAsync(targetAppearanceStyleAssemblyDescriptor)
    }
    
    private func setStyleAssemblyApplicationStatusIfNecessary(to newStatus: StyleUpdateStatus) {
        
        guard let sourceSetManager = self.sourceSetManager else {
            assertionFailure("Error: self.sourceSetManager is nil")
            return
        }
        
        if sourceSetManager.needsToDisplayWorkingOverlay(forTextWithIds: self.textIds) {
            self.styleAssemblyApplicationStatus.setValue(newStatus)
        }
    }
    
    @discardableResult
    private func setStyleAssemblyDescriptorAsync(_ styleAssemblyDescriptor: StyleAssemblyDescriptor) -> Promise<Void> {
        
        self.setStyleAssemblyApplicationStatusIfNecessary(to: .pending)
        let visibleRanges = self.visibleRanges
        
        return Promise<Void> { fulfill, reject in
            
            self.styleAssembliesSerialQueue.async { [weak self] in
                if let _self = self {
                    _self.setStyleAssemblyDescriptor(styleAssemblyDescriptor, visibleRanges: visibleRanges)
                    _self.setStyleAssemblyApplicationStatusIfNecessary(to: .applied)
                    fulfill(())
                }
                else {
                    reject(NWError.custom(message: "self is nil"))
                }
            }
        }
    }
    
    private func setStyleAssemblyDescriptor(_ styleAssemblyDescriptor: StyleAssemblyDescriptor, visibleRanges: [EditorId: NSRange?]) {
        
        #if DEBUG && DEBUG_LOGS_ENABLED
        let type = styleAssemblyDescriptor.isPermanent ? "permanent" : "temporary"
        let startTime = Date()
        debugPrint("setStyleAssemblyDescriptor start time for \(type) style assembly: \(startTime)")
        #endif
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("setStyleAssemblyDescriptor -> styleAssemblyDescriptor: %@ != self.styleAssemblyDescriptor.value: %@", log: Log.WriterCommon.all, type: .info, %%styleAssemblyDescriptor, %%self.styleAssemblyDescriptor.value)
        #endif
        
        guard styleAssemblyDescriptor != self.styleAssemblyDescriptor.value else {
            return
        }
        
        self.styleAssemblyDescriptor.setValue(styleAssemblyDescriptor)
        
        guard let sourceSetManager = self.sourceSetManager else {
            let errorText = "Error: self.sourceSetManager is nil"
            assertionFailure(errorText)
            return
        }
        
        for textManagerId in self.selectedTextItems.values {
            
            guard let editorId = self.editorIds[textManagerId] else {
                assertionFailure("Error: self.editorIds[\(textManagerId)] is nil")
                continue
            }
            
            guard let itemManager = sourceSetManager.directoryItemManager(withId: textManagerId) else {
                assertionFailure("Error: item manager is nil for id: \(textManagerId)")
                continue
            }
            
            guard let textManager = itemManager as? TextManager else {
                assertionFailure("Error: itemManager is not TextManager")
                continue
            }
            
            guard let editorVisibleRange = visibleRanges[editorId] else {
                assertionFailure("Error: editorVisibleRange is nil")
                continue
            }
            
            textManager.setStyleAssemblyDescriptor(styleAssemblyDescriptor, forEditorId: editorId, visibleRange: editorVisibleRange)
        }
    }
}
