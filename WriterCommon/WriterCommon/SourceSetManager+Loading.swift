//
//  SourceSetManager+Loading.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-10-14.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Common
import os
import Igloo
import PathKit

extension SourceSetManager {
    
    func loadRootDirectory(from documentFileWrapper: FileWrapper, topDirectoryItemsMetadata: [DirectoryItemMetadata]) throws {

        guard let documentId = self.documentId else {
            assert(false, "documentId is nil")
            throw NWError.custom(message: "documentId is nil")
        }
        
        let topDirectoryManager = DirectoryManager(sourceSetManager: self, parentId: documentId, name: Constants.Filename.RootDirectoryName, id: documentId)
        
        self.topDirectory = topDirectoryManager
        
        for directoryItemMetadata in topDirectoryItemsMetadata {
            
            try loadDirectoryItem(directoryItemMetadata, documentFileWrapper: documentFileWrapper, parentId: topDirectoryManager.id, originPath: "")
        }
        
        #if DEBUG
        assert(self.textManagersIdsArray == _textManagers.values, "Expected \(self.textManagersIdsArray) received: \(_textManagers.values)")
        #endif
    }
    
    private func loadDirectory(_ directoryMetadata: DirectoryMetadata, documentFileWrapper: FileWrapper, parentId: String, originPath: String) throws {
        
        guard let directoryManager = self.loadDirectoryManager(from: documentFileWrapper, directoryMetadata: directoryMetadata, parentId: parentId, originPath: originPath) else {
            assertionFailure("Error: directoryManager is nil")
            return
        }
        
        try self.putItemAtEnd(directoryManager, ofParentWithId: parentId)
        self.appendDirectoryItemManager(directoryManager, withId: directoryMetadata.id)
        
        let currentDirectoryOriginPath = originPath + directoryMetadata.name + "/"
        
        for directoryItem in directoryMetadata.items {
            try loadDirectoryItem(directoryItem, documentFileWrapper: documentFileWrapper, parentId: directoryMetadata.id, originPath: currentDirectoryOriginPath)
        }
    }
    
    private func loadDirectoryItem(_ directoryItem: DirectoryItemMetadata, documentFileWrapper: FileWrapper, parentId: String, originPath: String) throws {
        
        if let item = directoryItem.item {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG_LOGS_ENABLED && DEBUG
            os_log("Loading directory item", log: Log.WriterCommon.all, type: .debug)
            #endif
            
            switch item {
                
            case .directory(let directoryMetadata):
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG_LOGS_ENABLED && DEBUG
                os_log("Loading directory with name: %@", log: Log.WriterCommon.all, type: .debug, %%directoryMetadata.name)
                #endif
                
                guard let directoryManager = self.loadDirectoryManager(from: documentFileWrapper, directoryMetadata: directoryMetadata, parentId: parentId, originPath: originPath) else {
                    assertionFailure("Error: directoryManager is nil")
                    return
                }
                
                try putItemAtEnd(directoryManager, ofParentWithId: parentId)
                self.appendDirectoryItemManager(directoryManager, withId: directoryMetadata.id)
                
                #if DEBUG
                assert(self.textManagersIdsArray == _textManagers.values, "Expected \(self.textManagersIdsArray) received: \(_textManagers.values)")
                #endif
                
                
                let currentDirectoryOriginPath = originPath + directoryMetadata.name + "/"
                
                for directoryItem in directoryMetadata.items {
                    try loadDirectoryItem(directoryItem, documentFileWrapper: documentFileWrapper, parentId: directoryMetadata.id, originPath: currentDirectoryOriginPath)
                }
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG_LOGS_ENABLED && DEBUG
                        
                os_log("%@ directory content:", log: Log.WriterCommon.all, type: .debug, %%directoryManager.name.value)
                for (index, directoryItem) in directoryManager.directoryItems.enumerated() {
                    os_log("%@. %@ with id: %@ global order: %@", log: Log.WriterCommon.all, type: .debug, %%index, %%directoryItem.name.value, %%directoryItem.id, %%directoryItemManagers.values.index(forKey: directoryItem.id))
                }
                
                #endif
                
            case .file(let fileMetadata):
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG_LOGS_ENABLED && DEBUG
                os_log("Loading file with name: %@", log: Log.WriterCommon.all, type: .debug, %%fileMetadata.name)
                #endif
                
                let textManager = self.loadFile(from: documentFileWrapper, fileMetadata: fileMetadata, parentId: parentId, originPath: originPath)
                
                assert(textManager != nil)
                if let textManager = textManager {
                    try putItemAtEnd(textManager, ofParentWithId: parentId)
                    self.appendDirectoryItemManager(textManager, withId: fileMetadata.id)
                    #if DEBUG
                    assert(self.textManagersIdsArray == _textManagers.values, "Expected \(self.textManagersIdsArray) received: \(_textManagers.values)")
                    #endif
                }
            }
        }
    }
    
    private func loadDirectoryManager(from documentFileWrapper: FileWrapper, directoryMetadata: DirectoryMetadata, parentId: String, originPath: String) -> DirectoryManager? {
        
        let directoryPath = originPath + directoryMetadata.name
        
        guard let _ = documentFileWrapper.fileWrapper(at: directoryPath) else {
            assert(false, "directoryFileWrapper is nil")
            return nil
        }
        
        /// here we convert the "filename" to the name which internally
        /// doesn not contain the exension.
        return DirectoryManager(name: directoryMetadata.name, sourceSetManager: self, directoryMetadata: directoryMetadata, parentId: parentId)
    }
    
    private func loadFile(from documentFileWrapper: FileWrapper, fileMetadata: FileMetadata, parentId: String, originPath: String) -> TextManager? {
        
        let filePath = originPath + fileMetadata.name
        
        guard let fileFileWrapper = documentFileWrapper.fileWrapper(at: filePath) else {
            assert(false, "fileFileWrapper is nil")
            return nil
        }
        
        guard let document = self.document else {
            assertionFailure("Error: self.document is nil")
            return nil
        }
        
        guard let styleManager = self.styleManager(fromDocument: document) else {
            assertionFailure("Error: styleManager is nil")
            return nil
        }
        
        let name = self.name(fromFilename: fileMetadata.name)
        let textManager = TextManager(name: name, sourceSetManager: self, fileMetadata: fileMetadata, parentId: parentId, dispatcher: document.documentDispatcher)
        textManager.undoManager = document.undoManager
        
        guard let string = fileFileWrapper.string else {
            assertionFailure("Error: fileFileWrapper.string is nil")
            return nil
        }
        
        textManager.setText(string: string)
        textManager.compileInitialDocument()
        textManager.updateTokenAttributes()
        try? textManager.setStyle(withStyleManager: styleManager, visibleRanges: nil)
        return textManager
    }
    
    func loadTextManagers1(from sourcesDirectoryFileWrapper: FileWrapper, sourceSetMetadata: SourceSetMetadata_1?, document: TextDocument, parentID: String) throws -> [TextManager] {
        
        guard let sourceSetMetadata = sourceSetMetadata else {
            assert(false)
            throw NWError.custom(message: "Error: nil sourceSetMetadata")
        }
        
        let sourcesFileWrappers = sourcesDirectoryFileWrapper.fileWrappers
        
        guard let document = self.document else {
            assertionFailure("Error: self.document is nil")
            throw NWError.custom(message: "Error: self.document is nil")
        }
        
        var textManagers = [TextManager]()
        
        assert(sourcesFileWrappers != nil)
        if let sourcesFileWrappers = sourcesFileWrappers {
        
            for (filename, sourceFileWrapper) in sourcesFileWrappers {
            
                let id = filename.substringWithoutFileExtension
                
                guard let sourceMetadata = sourceSetMetadata.sources[id] else {
                    assert(false)
                    throw NWError.custom(message: "Error: sourceMetadata with id: \(id) is nil")
                }
                
                let title = self.title1(from: id, sourceMetadata: sourceMetadata)
                
                // We are calling the constructor from here only because it is
                // for loading an old file format. All TextManager creation methods should
                // normally go through the DirectoryManager
                let textManager = TextManager(title: title, id: UUID().uuidString, sourceSetManager: self, parentID: parentID, dispatcher: document.documentDispatcher)
                textManager.undoManager = document.undoManager
                
                guard let styleManager = self.styleManager(fromDocument: document) else {
                    assertionFailure("Error: styleManager is nil")
                    continue
                }
                
                guard let string = sourceFileWrapper.string else {
                    assertionFailure("Error: fileFileWrapper.string is nil")
                    continue
                }
                
                textManager.setText(string: string)
                textManager.compileInitialDocument()
                try? textManager.setStyle(withStyleManager: styleManager, visibleRanges: nil)
                
                let documentStore = document.documentManager?.documentStore
                
                assert(documentStore != nil)
                if let documentStore = documentStore, sourceMetadata.hasWritingSessions {
                    textManager.loadWritingSessionsMetadata(writingSessionsMetadata: sourceMetadata.writingSessions, documentStore: documentStore)
                }
               
                textManagers.append(textManager)
            }
        }
        
        return textManagers
    }
  
    private func order1(from id: String, sourceMetadata: SourceMetadata_1?) -> UInt32 {
        
        if let sourceMetadata = sourceMetadata {
            
            return sourceMetadata.order
        }
        else if let order = self.order(from: id) {
            
            return UInt32(order)
        }
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Error while generating order", log: Log.WriterCommon.all, type: .error)
        #endif
        return 0
    }
    
    private func title1(from id: String, sourceMetadata: SourceMetadata_1?) -> String {
        
        if let sourceMetadata = sourceMetadata {
            
            return sourceMetadata.title
        }
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Error while generating title from id: %@ and sourceMetadata: %@", log: Log.WriterCommon.all, type: .error, %%id, %%sourceMetadata)
        #endif
        return id
    }
    
    /// here we convert the "filename" to the name which internally
    /// doesn not contain the exension.
    private func name(fromFilename filename: String) -> String {
        
        let resolvedPath = Path(filename)
        return resolvedPath.lastComponentWithoutExtension
    }
    
    private func styleManager(fromDocument: TextDocument) -> StyleManager? {
        
        guard let document = self.document else {
            assertionFailure("Error: self.document is nil")
            return nil
        }
        
        guard let styleManager = document.selectedStyleManager else {
            assertionFailure("Error: styleManager is nil")
            return nil
        }
        
        return styleManager
    }
    
}
