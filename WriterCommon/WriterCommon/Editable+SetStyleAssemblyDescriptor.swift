//
//  Editable+SetStyleAssemblyDescriptor.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-06-01.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Common
import PromiseKit
import Igloo
import Web
import os

extension Editable {

    public func setStyleAssemblyDescriptor(_ descriptor: StyleAssemblyDescriptor, forEditorId editorId: EditorId, visibleRange: NSRange? = nil) {
        
        guard let renderer = self.editorManagers.values[editorId]?.renderer else {
            assertionFailure("Error: self.renderers[\(editorId)] is nil")
            return
        }
        
        setStyleAssemblyDescriptor(descriptor, forRenderer: renderer, visibleRange: visibleRange)
    }
    
    ///
    /// This method is reponsible to creating the StyledStoreManager and add
    /// an entry to the styledStoreManagers dictionary:
    ///
    /// var styledStoreManagers: [StyleAssemblyDescriptor: StyledStoreManager<StylableStore>] { get set }
    ///
    /// @precondition:
    ///
    private func setStyleAssemblyDescriptor(_ descriptor: StyleAssemblyDescriptor, forRenderer renderer: SourceStringAttributesRenderer, visibleRange: NSRange?) {
        assert(self.styleManager.value != nil)
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("descriptor: %@.", log: Log.WriterCommon.all, type: .info, %%descriptor.key)
        #endif
        
        guard let editorManager = self.editorManagers.values[renderer.id] else {
            assertionFailure("Error: editorManager is nil")
            return
        }
        
        guard editorManager.styleAssemblyDescriptor != descriptor else {
            return
        }
        
        guard let styleManager = self.styleManager.value else {
            assertionFailure("Error: styleManager is nil")
            return
        }
        
        guard let document = editableStore.document.value else {
            assertionFailure("Error: document is nil")
            return
        }
        
        editorManager.removeFlash()
        
        let visibleTopElements = self.visibleTopElementsIfNecessary(inVisibleRange: visibleRange)
        let styleAssemblyStore = styleManager.registerStyleAssemblyIfNecessary(forStyleAssemblyDescriptor: descriptor)
        
        compilationQueue.sync {
            try? editorManager.updateStyledStoreManager(fromStyleAssemblyStore: styleAssemblyStore, document: document, withDescriptor: descriptor, visibleTopElements: visibleTopElements)
        }
    }
}
