//
//  StyloDocument+SourceSet.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-10-14.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation

extension TextDocument {
    
    func createSourceSet(styleId: String) throws -> SourceSetManager {
        
        guard let documentManager = self.documentManager else {
            assert(false, "documentManager is nil")
            throw NWError.custom(message: "documentManager is nil")
        }
        
        let sourceSetManager = SourceSetManager(document: self)
        
        let topDirectory = DirectoryManager(sourceSetManager: sourceSetManager, parentId: documentManager.id, name: Constants.Filename.RootDirectoryName, id: documentManager.id)
        sourceSetManager.topDirectory = topDirectory
        
        guard let directoryManager = sourceSetManager.addGroup(withTitle: Constants.Filename.FilesDirectoryName) else {
            assertionFailure("Error: error while adding top directory")
            return sourceSetManager
        }
        
        guard let textManager = directoryManager.addEmptyTextManager(document: self) else {
            assertionFailure("Error: textManager is nil")
            return sourceSetManager
        }
        
        sourceSetManager.appendDirectoryItemManager(textManager, withId: textManager.id)
        try sourceSetManager.putItemAtEnd(textManager, ofParentWithId: directoryManager.id)
        return sourceSetManager
    }
    
    func createSourceSet(from string: String, styleId: String) throws -> SourceSetManager {
        
        guard let documentManager = self.documentManager else {
            assert(false, "documentManager is nil")
            throw NWError.custom(message: "documentManager is nil")
        }
        
        let sourceSetManager = SourceSetManager(document: self)
        let topDirectory = DirectoryManager(sourceSetManager: sourceSetManager, parentId: documentManager.id, name: Constants.Filename.RootDirectoryName, id: documentManager.id)
        sourceSetManager.topDirectory = topDirectory
        
        guard let directoryManager = sourceSetManager.addGroup(withTitle: Constants.Filename.FilesDirectoryName) else {
            assertionFailure("Error: error while adding top directory")
            return sourceSetManager
        }
        
        guard let textManager = directoryManager.addTextManager(document: self, string: string) else {
            assertionFailure("Error: textManager is nil")
            return sourceSetManager
        }
        
        sourceSetManager.appendDirectoryItemManager(textManager, withId: textManager.id)
        try sourceSetManager.putItemAtEnd(textManager, ofParentWithId: directoryManager.id)
        return sourceSetManager
    }
    
    func loadSourceSet1(from documentFileWrapper: FileWrapper, sourceSetMetadata: SourceSetMetadata_1?) throws -> SourceSetManager? {
        
        guard let documentManager = self.documentManager else {
            assert(false, "documentManager is nil")
            throw NWError.custom(message: "documentManager is nil")
        }
        
        let sourceSetManager = SourceSetManager(document: self)
        let sourcesFileWrapper = documentFileWrapper.fileWrappers?[Constants.Filename.SourcesDirectoryName]
        let topDirectory = DirectoryManager(sourceSetManager: sourceSetManager, parentId: documentManager.id, name: Constants.Filename.RootDirectoryName, id: documentManager.id)
        
        sourceSetManager.topDirectory = topDirectory
        
        assert(sourcesFileWrapper != nil)
        if let sourcesFileWrapper = sourcesFileWrapper {
        
            guard let directoryManager = sourceSetManager.addGroup(withTitle: Constants.Filename.FilesDirectoryName) else {
                assertionFailure("Error: error while adding top directory")
                return sourceSetManager
            }
            
            let textManagers = try sourceSetManager.loadTextManagers1(from: sourcesFileWrapper, sourceSetMetadata: sourceSetMetadata, document: self, parentID: directoryManager.id)
            
            assert(textManagers.count == 1)
            if let textManager = textManagers.first {
                sourceSetManager.addDirectoryItemManager(textManager, withId: textManager.markdownDocumentStore.identifier, atEndOfParentWithId: directoryManager.id)
                try sourceSetManager.putItemAtEnd(textManager, ofParentWithId: directoryManager.id)
            }
        }
        return sourceSetManager
    }
    
    @discardableResult
    func loadSourceSet(from documentFileWrapper: FileWrapper, sourceSetMetadata: SourceSetMetadata?) throws -> SourceSetManager? {
        
        guard let sourceSetMetadata = sourceSetMetadata else {
            assert(false)
            throw NWError.custom(message: "Error: sourceSetMetadata is nil")
        }
        
        let sourceSetManager = SourceSetManager(document: self, sourceSetMetadata: sourceSetMetadata)
        
        try sourceSetManager.loadRootDirectory(from: documentFileWrapper, topDirectoryItemsMetadata: sourceSetMetadata.items)
        
        return sourceSetManager
    }
}
