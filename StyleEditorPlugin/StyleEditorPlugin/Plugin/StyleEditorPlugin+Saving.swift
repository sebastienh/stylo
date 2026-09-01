//
//  StyleEditorPlugin+Saving.swift
//  StyleEditorPlugin
//
//  Created by Sebastien Hamel on 2019-12-31.
//  Copyright © 2019 Sebastien hamel. All rights reserved.
//

import Foundation
import WriterCommon
import Common

extension StyleEditorPlugin: Saving {
    
    var fileWrapperId: String {
        return self.name
    }
    
    func createFileWrapper() -> FileWrapper? {
        
        guard let styloDocument = self.styloDocument else {
            assertionFailure("Error: self.styloDocument is nil")
            return nil
        }
        
        guard StyloApplication.shared.styleEditorPluginCanWrite || styloDocument.stylesLoadedFromOldStyloDocument else {
            return nil
        }
        
        guard let styleSetManager = self.styleSetManager else {
            assertionFailure("Error: self.styleSetManager is nil")
            return nil
        }
        
        guard let fileWrapper = styleSetManager.createFileWrapper() else {
            assertionFailure("Error: createFileWrapper returned nil")
            return nil
        }
        
        guard let data = try? styleSetManager.metadata.jsonUTF8Data() else {
            assertionFailure("Error: data is nil")
            return nil
        }
    
        let stylesMetadataFileWrapper = FileWrapper(regularFileWithContents: data)
        
        let pluginDirectoryFileWrapper = FileWrapper(directoryWithFileWrappers: [Constants.Plugin.StylesDirectoryName: fileWrapper, WriterCommon.Constants.Filename.DocumentStylesMetadataJsonName: stylesMetadataFileWrapper])
        pluginDirectoryFileWrapper.preferredFilename = self.fileWrapperId
        self.isEdited = false
        return pluginDirectoryFileWrapper
    }
    
    /// The FileWrapper we receive here is our own file wrapper
    /// rooted at the plugin directory StyleAudioPlugin
    public func fileWrapper(fromCurrentFileWrapper fileWrapper: FileWrapper) -> FileWrapper? {
        
        if self.mode == .write {
            guard let newFileWrapper = createFileWrapper() else {
                assertionFailure("Error: newFileWrapper is nil")
                self.isEdited = false
                return fileWrapper
            }
            
            return newFileWrapper
        }
        return fileWrapper
    }
}
