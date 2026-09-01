//
//  DirectoryManager+Saving.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-07-26.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation

extension DirectoryManager: Saving {
    
    var topLevelFileWrappers: [String: FileWrapper] {
        
        var fileWrappersDictionary = [String: FileWrapper]()
        
        for directoryItemId in self.directoryStore.directoryItemsIds {
            
            let directoryItemManager = self.sourceSetManager?.directoryItemManager(withId: directoryItemId)
            
            assert(directoryItemManager != nil)
            if let directoryItemManager = directoryItemManager {
                
                let directoryItemManagerFileWrapper = directoryItemManager.createFileWrapper()
                fileWrappersDictionary[directoryItemManager.fileWrapperId] = directoryItemManagerFileWrapper
            }
        }
        return fileWrappersDictionary
    }
    
    public var fileWrapperId: String {
        
        return self.name.value
    }
    
    public func createFileWrapper() -> FileWrapper? {

        let sourcesDirectoryFileWrapper = FileWrapper(directoryWithFileWrappers: self.topLevelFileWrappers)
        sourcesDirectoryFileWrapper.preferredFilename = fileWrapperId
        return sourcesDirectoryFileWrapper
    }
}
