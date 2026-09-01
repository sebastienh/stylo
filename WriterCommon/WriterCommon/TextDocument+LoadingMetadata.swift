//
//  StyloDocument+Loading.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-10-12.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation

extension TextDocument {
    
    func loadMetadata1(from documentFilesWrapper: FileWrapper) throws -> DocumentMetadata_1? {
        
        let documentMetadata = try self.loadDocumentMetadata1(from: documentFilesWrapper)
    
        if let documentMetadata = documentMetadata {
            
            self.updateDocumentMetadata1(from: documentMetadata)
            return documentMetadata
        }
        return nil 
    }

    func loadMetadata(from documentFilesWrapper: FileWrapper) throws -> DocumentMetadata? {
        
        let documentMetadata = try self.loadDocumentMetadata(from: documentFilesWrapper)
        
        if let documentMetadata = documentMetadata {
            
            self.updateDocumentMetadata(from: documentMetadata)
            return documentMetadata
        }
        return nil
    }
    
    func loadDocumentMetadata(from documentFileWrapper: FileWrapper) throws -> DocumentMetadata? {
        
        let styloProjectDirectoryFileWrapper = documentFileWrapper.fileWrappers?[Constants.Filename.StyloProjectDirectoryName]
        
        if let styloProjectDirectoryFileWrapper = styloProjectDirectoryFileWrapper {
            
            assert(styloProjectDirectoryFileWrapper.isDirectory)
            let styloProjectDirectoryContentFileWrapper = styloProjectDirectoryFileWrapper.fileWrappers
            
            assert(styloProjectDirectoryContentFileWrapper != nil)
            if let styloProjectDirectoryContentFileWrapper = styloProjectDirectoryContentFileWrapper {
                
                let filesDescriptorFileWrapper = styloProjectDirectoryContentFileWrapper[Constants.Filename.StyloProjectFileJsonName]
                
                // we found the project.json else we will try for the binary version
                if let filesDescriptorFileWrapper = filesDescriptorFileWrapper {
                    
                    let content = filesDescriptorFileWrapper.regularFileContents
                    
                    assert(content != nil)
                    if let content = content {
                        
                        return try DocumentMetadata(jsonUTF8Data: content)
                    }
                }
                else {
                    
                    let filesDescriptorFileWrapper = styloProjectDirectoryContentFileWrapper[Constants.Filename.StyleFilesDescriptorBinaryName]
                    
                    assert(filesDescriptorFileWrapper != nil)
                    if let filesDescriptorFileWrapper = filesDescriptorFileWrapper {
                        
                        let content = filesDescriptorFileWrapper.regularFileContents
                        
                        assert(content != nil)
                        if let content = content {
                            
                            return try DocumentMetadata(serializedData: content)
                        }
                    }
                    
                }
            }
        }
        return nil
    }
    
    func loadDocumentMetadata1(from documentFileWrapper: FileWrapper) throws -> DocumentMetadata_1? {
        
        let styloProjectDirectoryFileWrapper = documentFileWrapper.fileWrappers?[Constants.Filename.StyloProjectDirectoryName]
        
        if let styloProjectDirectoryFileWrapper = styloProjectDirectoryFileWrapper {
            
            assert(styloProjectDirectoryFileWrapper.isDirectory)
            let styloProjectDirectoryContentFileWrapper = styloProjectDirectoryFileWrapper.fileWrappers
            
            assert(styloProjectDirectoryContentFileWrapper != nil)
            if let styloProjectDirectoryContentFileWrapper = styloProjectDirectoryContentFileWrapper {
            
                guard let filesDescriptorFileWrapper: FileWrapper = {
                    if styloProjectDirectoryContentFileWrapper[Constants.Filename.OldStyloProjectFileJsonName] != nil {
                        return styloProjectDirectoryContentFileWrapper[Constants.Filename.OldStyloProjectFileJsonName]
                    }
                    else if let projectFile = styloProjectDirectoryContentFileWrapper[Constants.Filename.StyloProjectFileJsonName] {
                        return projectFile
                    }
                    else {
                        return styloProjectDirectoryContentFileWrapper[Constants.Filename.StyleFilesDescriptorBinaryName]
                    }
                }() else {
                    assertionFailure("Error: filesDescriptorFileWrapper is nil")
                    return nil
                }
                    
                let content = filesDescriptorFileWrapper.regularFileContents
                
                assert(content != nil)
                if let content = content {
                    
                    return try DocumentMetadata_1(jsonUTF8Data: content)
                }
            }
        }
        return nil
    }
    
    private func updateDocumentMetadata1(from documentMetadata: DocumentMetadata_1) {
        
        self.originReleaseVersion = documentMetadata.releaseVersion
    }

    private func updateDocumentMetadata(from documentMetadata: DocumentMetadata) {
        
        self.originReleaseVersion = documentMetadata.releaseVersion
    }

}
