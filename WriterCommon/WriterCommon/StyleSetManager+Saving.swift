//
//  StyleSetManager+Saving.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-02-06.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation

extension StyleSetManager: Saving {
    
    public var fileWrapperId: String {
        return "styles"
    }
    
    private var fileWrappersDictionary: [String: FileWrapper] {
        
        var fileWrappersDictionary = [String: FileWrapper]()
        
        for styleManager in styleManagers {
            
            guard let styleManagerDirectoryFileWrapper = styleManager.createFileWrapper() else {
                assertionFailure("Error: createFileWrapper returned nil")
                continue
            }
            
            fileWrappersDictionary[styleManagerDirectoryFileWrapper.preferredFilename!] = styleManagerDirectoryFileWrapper
        }
        return fileWrappersDictionary
    }
    
    public func createFileWrapper() -> FileWrapper? {
        
        let styleSetManagerFileWrapper = FileWrapper(directoryWithFileWrappers: self.fileWrappersDictionary)
        styleSetManagerFileWrapper.preferredFilename = fileWrapperId
        return styleSetManagerFileWrapper
    }
    
    public func fileWrapper(fromCurrentFileWrapper fileWrapper: FileWrapper) -> FileWrapper? {
        assertionFailure("Error: missing implementation")
        return nil
    }
}
