//
//  Editable+setStyle.swift
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
    
    ///
    /// Get the computed appearance and forward call to:
    /// setStyle(withStyleManager styleManager: StyleManager, forAppearance appearance: AppearanceMode)
    ///
    public func setStyle(withStyleManager styleManager: StyleManager, visibleRanges: [EditorId : NSRange?]?) throws {
        
        guard let computedAppearance = StyloApplication.shared.computedAppearance.value else {
            assertionFailure("Error: computedAppearance is nil")
            return
        }
        
        try setStyle(withStyleManager: styleManager, forAppearance: computedAppearance, visibleRanges: visibleRanges)
    }
    
    ///
    /// Async version
    ///
    @discardableResult
    public func setStyleAsync(withStyleManager styleManager: StyleManager) -> Promise<Void> {
        
        guard let computedAppearance = StyloApplication.shared.computedAppearance.value else {
            assertionFailure("Error: computedAppearance is nil")
            return Promise(error: NWError.custom(message: "Error: computedAppearance is nil"))
        }
        
        return setStyleAsync(withStyleManager: styleManager, forAppearance: computedAppearance)
    }
    
    ///
    /// This method is responsible for setting up permanent style
    /// and the temporary styles chain according to the registered
    /// style assemblies.
    ///
    /// Note: at this point styledStoreManagers dictionary may be empty
    /// in this case we should register the permanent style assembly
    /// corresponding to the appearance.
    ///
    /// @precondition: an EditableStore is initialized
    ///
    /// @postcondition: at least one permanent style assembly is setup
    /// in the styledStoreManagers dictionary.
    ///
    private func setStyle(withStyleManager styleManager: StyleManager, forAppearance appearance: AppearanceMode, visibleRanges: [EditorId : NSRange?]?) throws {
        
        self.styleManager.setValue(styleManager)
        var previousDescriptors = collectPreviousDescriptors()

        if previousDescriptors.isEmpty {
            previousDescriptors.append(styleManager.currentAppearanceSourceDescriptor)
        }
        
        try self.registerStyleAssemblies(previousStyleAssemblyDescriptors: previousDescriptors, forAppearance: appearance, visibleRanges: visibleRanges)
        for (_, editorManager) in self.editorManagers.values {
            editorManager.didSetStyle()
        }
    }
    
    /// Async version
    private func setStyleAsync(withStyleManager styleManager: StyleManager, forAppearance appearance: AppearanceMode) -> Promise<Void> {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("setStyleAsync(withStyleManager: %@, appearance: %@)", log: Log.WriterCommon.all, type: .info, %%styleManager, %%appearance)
        #endif
        
        return Promise<Void> { fulfill, reject in
            
            var previousDescriptors = collectPreviousDescriptors()
            if styleManager.id != self.styleManager.value?.id {
                self.styleManager.setValue(styleManager)
            }
            
            if previousDescriptors.isEmpty {
                previousDescriptors.append(styleManager.currentAppearanceSourceDescriptor)
            }
            
            firstly {
                self.registerStyleAssembliesAsync(previousStyleAssemblyDescriptors: previousDescriptors, forAppearance: appearance)
            }.then {
                for (_, editorManager) in self.editorManagers.values {
                    editorManager.didSetStyle()
                }
                fulfill(())
            }.catch { error in
                assertionFailure("Error: \(error)")
                reject(error)
            }
        }
    }
    
    private func registerStyleAssemblies(previousStyleAssemblyDescriptors: [StyleAssemblyDescriptor], forAppearance appearance: AppearanceMode, visibleRanges: [EditorId: NSRange?]?) throws {
        
        for descriptor in previousStyleAssemblyDescriptors {
            
            let descriptorForAppearance = descriptor.same(forAppearance: appearance)
            try registerStyleAssemblyIfNecessary(withDescriptor: descriptorForAppearance, visibleRanges: visibleRanges)
        }
    }
    
    private func registerStyleAssembliesAsync(previousStyleAssemblyDescriptors: [StyleAssemblyDescriptor], forAppearance appearance: AppearanceMode) -> Promise<Void> {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("registerStyleAssembliesAsync(previousStyleAssemblyDescriptors: %@, appearance: %@)", log: Log.WriterCommon.all, type: .info, %%previousStyleAssemblyDescriptors, %%appearance)
        #endif
        
        var promises: [Promise<Void>] = []
        
        return Promise<Void> { fulfill, reject in
        
            for descriptor in previousStyleAssemblyDescriptors {
                
                let descriptorForAppearance = descriptor.same(forAppearance: appearance)
                let promise = registerStyleAssemblyIfNecessaryAsync(withDescriptor: descriptorForAppearance)
                promises.append(promise)
            }
            
            when(resolved: promises).then { _ -> Void in
                fulfill(())
            }.catch { error in
                reject(error)
            }
        }
    }
    
    ///
    /// This method removes all the styledStoreManagers and returns
    /// the previously registered style assemblies descriptors
    /// in order to be able to reregister the style assemblies that
    /// were registered before
    ///
    private func collectPreviousDescriptors() -> [StyleAssemblyDescriptor] {
        
        var previousDescriptors: [StyleAssemblyDescriptor] = []
        for (_, editorManager) in self.editorManagers.values {
            previousDescriptors.append(editorManager.styleAssemblyDescriptor)
        }
        return previousDescriptors
    }
}
