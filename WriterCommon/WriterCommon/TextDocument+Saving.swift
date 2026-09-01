//
//  StyloDocument+Saving.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-10-14.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Common
import os

extension TextDocument {
    
    private var pluginManager: PluginManager? {
        
        return self.documentManager?.pluginManager
    }
    
    func createFileWrapper() throws -> FileWrapper {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("func createFileWrapper() throws -> FileWrapper", log: Log.WriterCommon.all, type: .info)
        #endif
        
        var fileWrappersDictionary = [String: FileWrapper]()
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("projectFileWrapper: %@", log: Log.WriterCommon.all, type: .info, %%projectFileWrapper)
        #endif
        
        if let projectFileWrapper = self.projectFileWrapper {
            fileWrappersDictionary[Constants.Filename.StyloProjectDirectoryName] = projectFileWrapper
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("before createSourcesDirectoryFileWrapper()", log: Log.WriterCommon.all, type: .info, %%projectFileWrapper)
        #endif
        
        guard let rootDirectoryFileWrappersDictionary = createSourcesDirectoryFileWrapper() else {
            assert(false, "rootDirectoryFileWrappersDictionary is nil")
            throw NWError.custom(message: "root directory filewrapper is nil")
        }
        
        fileWrappersDictionary.merge(rootDirectoryFileWrappersDictionary) { (first, second) -> FileWrapper in
            assert(false, "Names conflicts")
            return first
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Creating document directory file wrapper with dictionary", log: Log.WriterCommon.all, type: .info, %%fileWrappersDictionary)
        #endif
        
        let documentDirectoryFileWrapper = FileWrapper(directoryWithFileWrappers: fileWrappersDictionary)
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("File wrapper created: %@", log: Log.WriterCommon.all, type: .info, %%documentDirectoryFileWrapper)
        #endif
        
        documentDirectoryFileWrapper.preferredFilename = self.documentManager!.name.value + ".stylo"
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("File wrapper preferredFilename set to: %@", log: Log.WriterCommon.all, type: .info, %%documentDirectoryFileWrapper.preferredFilename)
        #endif
        
        return documentDirectoryFileWrapper
    }
    
    public var projectFileWrapper: FileWrapper? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("projectFileWrapper for: %@", log: Log.WriterCommon.all, type: .info, %%StyloApplication.shared.productName)
        #endif
        
        var fileWrappersDictionary = [String: FileWrapper]()
        
        #if DEBUG
        guard let data = try? self.metadata?.jsonUTF8Data() else {
            assertionFailure("Error: data is nil")
            return nil
        }
        #else
        guard let data = try? self.metadata?.serializedData() else {
            assertionFailure("Error: data is nil")
            return nil
        }
        #endif
        
        let documentMetadataFileWrapper = FileWrapper(regularFileWithContents: data)
        #if DEBUG
        fileWrappersDictionary[Constants.Filename.StyloProjectFileJsonName] = documentMetadataFileWrapper
        #else
        fileWrappersDictionary[Constants.Filename.StyleFilesDescriptorBinaryName] = documentMetadataFileWrapper
        #endif
        
        #if DEBUG
        fileWrappersDictionary[Constants.Filename.ThemesDirectoryName] = printThemeSetManager.createFileWrapper()
        #endif
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("self.pluginManager: %@", log: Log.WriterCommon.all, type: .info, %%self.pluginManager)
        #endif
        
        assert(self.pluginManager != nil, "Error: self.pluginManager is nil.")
        if let pluginManager = self.pluginManager {
            
            fileWrappersDictionary[Constants.Filename.PluginsDataDirectoryFilename] = pluginManager.createFileWrapper(at: self.fileURL)
        }
        
        let documentDirectoryFileWrapper = FileWrapper(directoryWithFileWrappers: fileWrappersDictionary)
        return documentDirectoryFileWrapper
    }
    
    private func createSourcesDirectoryFileWrapper() -> [String: FileWrapper]? {
        
        assert(sourceSetManager != nil)
        return sourceSetManager?.topFileWrappers
    }
    
    private func createStylesDirectoryFileWrapper() -> FileWrapper? {
        
        /// Styles
        assert(sourceSetManager != nil)
        return styleSetManager?.createFileWrapper()
    }
    
}
