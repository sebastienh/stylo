//
//  StyloDocument+SourceTextCSSStyle.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2015-10-26.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Web
import Common
import PromiseKit
import os

extension TextDocument {
    
    private var applicationDefaultStyleSetMetadata: StyleSetMetadata? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("StyloApplication.shared.StyleSetMetadataDirectoryPath: %@", log: Log.WriterCommon.all, type: .info, %%StyloApplication.shared.StyleSetMetadataDirectoryPath.absoluteString)
        #endif
        
        do {
            let data = try! Data(contentsOf: StyloApplication.shared.StyleSetMetadataDirectoryPath)
            let loadedMetadata = String(bytes: data, encoding: .utf8)
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("loadedMetadata: %@", log: Log.WriterCommon.all, type: .info, %%loadedMetadata)
            #endif
            
            return try StyleSetMetadata(jsonUTF8Data: data)
        }
        catch let error {
            assertionFailure("Error: error while loading application default style set metadata: \(error)")
            return nil
        }
    }
    
    var applicationDefaultStylesFileWrapper: FileWrapper? {
        
        let url = StyloApplication.shared.URLForTextSourceStylesDirectoryPath
        return try? FileWrapper(url: url)
    }
    
    func createEmptyStyleSet() -> StyleSetManager {
        
        return StyloApplication.shared.applicationTextStyleSetManager
    }
    
    func loadStyleSet1(from documentFileWrapper: FileWrapper, viewingMode: Bool = false, styleSetMetadata: StyleSetMetadata_1?) -> StyleSetManager {
    
        let stylesFileWrapper = documentFileWrapper.fileWrappers?[Constants.Filename.StylesDirectoryName]
        
        // old stylo document case
        if let stylesFileWrapper = stylesFileWrapper, let styleSetMetadata = styleSetMetadata {
            stylesLoadedFromOldStyloDocument = true
            return loadStyleSetFromStylesFileWrapper1(from: documentFileWrapper, stylesFileWrapper: stylesFileWrapper, viewingMode: viewingMode, styleSetMetadata: styleSetMetadata)
        }
        else {
            
            assert(styleSetMetadata == nil)
            // In this case the styles can only be in the net.textually.stylo.plugin.editor.style
            // directory and/or in the application styles directory, also managed by the StyleEditorPlugin.
            // So here we test if the net.textually.stylo.plugin.editor.style directory is defined,
            // if yes we load the style editor plugin with all the styles in this directory, we may or may not
            // enable style editing based on the fact that the style editor plugin is enabled or not, but,
            // it's still the Style editor plugin responsability to load the load the styles for the
            // this document.
            
            // Solution:
            // The StyleSetManager should be able to load from anywhere as it is now, The StyleEditorPlugin
            // responsability should be to modify the content of this StyleSetManager, not to load it.
            // But it can write.
            
            // TODO:
            //   1. implement loading from the ...plugin.editor.style directory (load old Nodio opened document)
            //   2. implement save to the ...plugin.editor.style directory (save old Stylo opened document)
            
            // loading from the ...plugin.editor.style directory (load Nodio that saved old Stylo document)
            // test if the styles are in the ...plugin.editor.style directory
            if let (stylesFileWrapper, styleSetMetadata) = self.styleEditorPluginStylesFileWrapper(in: documentFileWrapper) {
                
                // defaulting to loading from the application bundle
                // TODO: implement loading from the application directory.
                // Remember: the StyleEditorPlugin migh have been used to edit a file
                // so we want to load both the file specific styles
                // plus the ones from the application, which might have been created
                // by the style editor plugin, or not.
                return loadStyleSetFromStylesFileWrapper(from: documentFileWrapper, stylesFileWrapper: stylesFileWrapper, viewingMode: false, styleSetMetadata: styleSetMetadata)
            }
            // there is no styles, we are opening a nodio document.
            else {
                    
                return StyloApplication.shared.applicationTextStyleSetManager
            }
        }
    }
    
    private func loadStyleSetFromProjectDirectory1(from documentFileWrapper: FileWrapper, styleSetMetadata: StyleSetMetadata_1?) -> StyleSetManager? {
        
        let styleSetManager = StyleSetManager.Create(document: self)
        let styloProjectDirectoryFileWrapper = documentFileWrapper.fileWrappers?[Constants.Filename.StyloProjectDirectoryName]
        
        if let styloProjectDirectoryFileWrapper = styloProjectDirectoryFileWrapper {
            
            assert(styloProjectDirectoryFileWrapper.isDirectory)
            let styloProjectDirectoryContentFileWrapper = styloProjectDirectoryFileWrapper.fileWrappers
            
            assert(styloProjectDirectoryContentFileWrapper != nil)
            if let styloProjectDirectoryContentFileWrapper = styloProjectDirectoryContentFileWrapper {
                
                // we found the project.json else we will try for the binary version
                guard let stylesFileWrapper = styloProjectDirectoryContentFileWrapper[Constants.Filename.StylesDirectoryName] else {
                    
                    return nil
                }
                
                return loadStyleSetFromStylesFileWrapper1(from: documentFileWrapper, stylesFileWrapper: stylesFileWrapper, viewingMode: false, styleSetMetadata: styleSetMetadata)
            }
        }
        return styleSetManager
    }
    
    private func loadStyleSetFromStylesFileWrapper1(from documentFileWrapper: FileWrapper, stylesFileWrapper: FileWrapper, viewingMode: Bool = false, styleSetMetadata: StyleSetMetadata_1?) -> StyleSetManager {
        
        let styleSetManager = StyleSetManager.Create(document: self)
        if !viewingMode {
            
            styleSetManager.loadAllStylesWithStyle1(stylingManager: currentCssSourceStyle, from: stylesFileWrapper, styleSetMetadata: styleSetMetadata)
        }
        else {
            styleSetManager.loadAllStylesWithStyle1(stylingManager: nil, from: stylesFileWrapper, styleSetMetadata: styleSetMetadata)
        }
        return styleSetManager
    }

    func loadStyleSetFromStylesFileWrapper(from documentFileWrapper: FileWrapper, stylesFileWrapper: FileWrapper, viewingMode: Bool = false, styleSetMetadata: StyleSetMetadata?) -> StyleSetManager {
        
        let styleSetManager = StyleSetManager.Create(document: self)
        if !viewingMode {
            
            styleSetManager.loadAllStylesWithStyle(stylingManager: currentCssSourceStyle, from: stylesFileWrapper, styleSetMetadata: styleSetMetadata)
        }
        else {
            styleSetManager.loadAllStylesWithStyle(stylingManager: nil, from: stylesFileWrapper, styleSetMetadata: styleSetMetadata)
        }
        return styleSetManager
    }
    
    func style(with id: String) -> StyleManager? {
        
        return styleSetManager?.styleById(id)
    }
    
    public func styleManager(with id: String) -> StyleManager? {
        
        return styleSetManager?.styleManagerById(id)
    }

    public func addStyleManager() -> StyleManager? {
        
        assert(styleSetManager != nil)
        return styleSetManager?.addStyleManager()
    }
    
    public func delete(styleManager: StyleManager) {
        
        if let newSelectedStyleManager = styleSetManager?.deleteStyleManager(styleManager: styleManager) {
            
            fatalError("We should allow to delete used style.")
            // textManager.setStyleAsync(withStyleManager: newSelectedStyleManager)
        }
    }
    
    private func styleEditorPluginStylesFileWrapper(in documentFileWrapper: FileWrapper) -> (FileWrapper, StyleSetMetadata)? {
        
        guard let styloProjectDirectoryFileWrapper = documentFileWrapper.fileWrappers?[Constants.Filename.StyloProjectDirectoryName] else {
            assertionFailure("Error: styloProjectDirectoryFileWrapper is nil")
            return nil
        }
        
        assert(styloProjectDirectoryFileWrapper.isDirectory)
        guard let pluginsDirectoryFileWrapper = styloProjectDirectoryFileWrapper.fileWrappers?[Constants.Filename.PluginsDataDirectoryFilename] else {
            // we consider that we should have a plugins directory, might not be true in fact..
            assertionFailure("Error: pluginsDirectory is nil")
            return nil
        }
        
        guard let styleEditorPluginFileWrapper = pluginsDirectoryFileWrapper.fileWrappers?[§TextuallyPlugin.editorStyle] else {
            return nil
        }
        
        guard let stylesFileWrapper = styleEditorPluginFileWrapper.fileWrappers?[Constants.Filename.StylesDirectoryName] else {
            assertionFailure("Error: styles file wrapper is nil")
            return nil
        }
        
        guard let stylesSetMetadataFileWrapper = styleEditorPluginFileWrapper.fileWrappers?[Constants.Filename.DocumentStylesMetadataJsonName] else {
            assertionFailure("Error: styles file wrapper is nil")
            return nil
        }
        
        guard let jsonData = stylesSetMetadataFileWrapper.regularFileContents else {
            assertionFailure("Error: jsonData is nil")
            return nil
        }
        
        
        guard let styleSetMetadata = try? StyleSetMetadata(jsonUTF8Data: jsonData) else {
            assertionFailure("Error: styleSetMetadata returned nil")
            return nil
        }
        
        return (stylesFileWrapper, styleSetMetadata)
    }
    
    private func styleEditorPluginStylesFileWrapper1(in documentFileWrapper: FileWrapper) -> (FileWrapper, StyleSetMetadata_1)? {
        
        guard let styloProjectDirectoryFileWrapper = documentFileWrapper.fileWrappers?[Constants.Filename.StyloProjectDirectoryName] else {
            assertionFailure("Error: styloProjectDirectoryFileWrapper is nil")
            return nil
        }
        
        assert(styloProjectDirectoryFileWrapper.isDirectory)
        guard let pluginsDirectoryFileWrapper = styloProjectDirectoryFileWrapper.fileWrappers?[Constants.Filename.PluginsDataDirectoryFilename] else {
            // we consider that we should have a plugins directory, might not be true in fact..
            assertionFailure("Error: pluginsDirectory is nil")
            return nil
        }
        
        guard let styleEditorPluginFileWrapper = pluginsDirectoryFileWrapper.fileWrappers?[§TextuallyPlugin.editorStyle] else {
            return nil
        }
        
        guard let stylesFileWrapper = styleEditorPluginFileWrapper.fileWrappers?[Constants.Filename.StylesDirectoryName] else {
            assertionFailure("Error: styles file wrapper is nil")
            return nil
        }
        
        guard let stylesSetMetadataFileWrapper = styleEditorPluginFileWrapper.fileWrappers?[Constants.Filename.DocumentStylesMetadataJsonName] else {
            assertionFailure("Error: styles file wrapper is nil")
            return nil
        }
        
        guard let jsonData = stylesSetMetadataFileWrapper.regularFileContents else {
            assertionFailure("Error: jsonData is nil")
            return nil
        }
        
        
        guard let styleSetMetadata = try? StyleSetMetadata_1(jsonUTF8Data: jsonData) else {
            return nil
        }
        
        return (stylesFileWrapper, styleSetMetadata)
    }
    
}
