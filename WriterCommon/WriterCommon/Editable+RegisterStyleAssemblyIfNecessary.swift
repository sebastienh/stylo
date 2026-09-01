//
//  Editable+registerStyleAssemblyIfNecessary.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-04-20.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Common
import PromiseKit
import Igloo
import Web
import os

extension Editable {

    /// ************************************************* ///
    /// Stylable store and and temporary style management ///
    /// ************************************************* ///
    
    ///
    /// This method is responsible for creating a StyledStoreManager for
    /// the descriptor if it does not exist.
    ///
    /// @precondition: styleManager is not nil
    /// @precondition: editableManager has been created
    ///
    func registerStyleAssemblyIfNecessary(withDescriptor descriptor: StyleAssemblyDescriptor, visibleRanges: [EditorId: NSRange?]?) throws {

        guard let styleManager = styleManager.value else {
            assertionFailure("Error: styleManager.value is nil")
            return
        }
        
        let styleAssemblyStore = styleManager.registerStyleAssemblyIfNecessary(forStyleAssemblyDescriptor: descriptor)
        try updateStyledStoreManagers(forStyleAssemblyStore: styleAssemblyStore, withDescriptor: descriptor, visibleRanges: visibleRanges)
        assert(styleManager.styleAssemblies[descriptor] != nil)
    }
    
    /// Async version
    func registerStyleAssemblyIfNecessaryAsync(withDescriptor descriptor: StyleAssemblyDescriptor) -> Promise<Void> {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("registerStyleAssemblyIfNecessaryAsync(withDescriptor: %@", log: Log.WriterCommon.all, type: .info, %%descriptor)
        #endif
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("ObjectIdentifier: %@, attempt to register a styledStoreManager with descriptor with key %@.", log: Log.WriterCommon.all, type: .info, %%ObjectIdentifier(self), %%descriptor)
        #endif
        
        guard let styleManager = styleManager.value else {
            assertionFailure("Error: styleManager.value is nil")
            return Promise(error: NWError.custom(message: "Error: styleManager.value is nil"))
        }
        
        return Promise<Void> { fulfill, reject in
            firstly { () -> Promise<StyleAssemblyStore> in
                styleManager.registerStyleAssemblyIfNecessaryAsync(forStyleAssemblyDescriptor: descriptor)
            }.then { styleAssemblyStore -> Promise<Void> in
                return self.createStyledStoreManagersAsync(forStyleAssemblyStore: styleAssemblyStore, withDescriptor: descriptor)
            }.then { _ in
                fulfill(())
            }.catch { error in
                reject(error)
            }
        }
    }

    private func createStyledStoreManagersAsync(forStyleAssemblyStore styleAssemblyStore: StyleAssemblyStore, withDescriptor descriptor: StyleAssemblyDescriptor) -> Promise<Void> {
        
        guard let document = editableStore.document.value else {
            assertionFailure("Error: document is nil")
            return Promise(error: NWError.custom(message: "Error: document is nil"))
        }
        
        var promises: [Promise<Void>] = []
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("createStyledStoreManagersAsync -> editorManagers: %@", log: Log.WriterCommon.all, type: .info, %%ObjectIdentifier(self), %%self.editorManagers)
        #endif
        
        for (editorId, editorManager) in self.editorManagers.values {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("createStyledStoreManagersAsync -> editorId: %@", log: Log.WriterCommon.all, type: .info, %%editorId)
            #endif
            
            let promise = Promise<Void> { fulfill, reject in
                
                firstly {
                    self.visibleTopElementsIfNecessaryAsync(forEditorWithId: editorId)
                }.then { visibleTopElements in
                    return editorManager.updateStyledStoreManagerAsync(fromStyleAssemblyStore: styleAssemblyStore, document: document, withDescriptor: descriptor, visibleTopElements: visibleTopElements)
                }.then {
                    fulfill(())
                }.catch { error in
                    reject(error)
                }
            }
            
            promises.append(promise)
        }
        
        return Promise<Void> { fulfill, reject in
            
            when(resolved: promises).then { _ -> Void in
                fulfill(())
            }.catch { error in
                reject(error)
            }
        }
    }
    
    public func updateStyledStoreManagers(forStyleAssemblyStore styleAssemblyStore: StyleAssemblyStore, withDescriptor descriptor: StyleAssemblyDescriptor, visibleRanges: [EditorId: NSRange?]?) throws {
        
        guard let document = editableStore.document.value else {
            assertionFailure("Error: document is nil for editableStore.sourceString: \(editableStore.sourceString)")
            return
        }
        
        for (editorId, editorManager) in self.editorManagers.values {
            
            let editorVisibleRange = visibleRanges?[editorId] ?? nil
            
            let visibleTopElements = self.visibleTopElementsIfNecessary(inVisibleRange: editorVisibleRange)
            try editorManager.updateStyledStoreManager(fromStyleAssemblyStore: styleAssemblyStore, document: document, withDescriptor: descriptor, visibleTopElements: visibleTopElements)
        }
    }
}
    
