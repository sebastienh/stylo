//
//  TextManager+Loading.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-03-07.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Common
import Igloo
import PromiseKit
import os

extension TextManager {
    
    func loadWritingSessionsMetadata(writingSessionsMetadata: WritingSessionsMetadata, documentStore: StyloDocumentStore) {
        
        let action = StatisticsAction.load(writingSessions: writingSessionsMetadata)
        self.dispatcher.sync(store: documentStore, action: action.syncAction)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: private implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    private func textDocumentTitle(from url: URL) -> String {
        
        // avoid loading any other file than md files
        let lastPathComponent = url.lastPathComponent
        
        // remove the file extension from the last path component to create the title
        return lastPathComponent.slice(0, end: -3)!
    }
    
    private func textDocumentUrl(in directoryUrl: URL) -> URL? {
        
        var url: URL?
        
        do {
            let resourcesURLs = try FileManager.default.contentsOfDirectory(at: directoryUrl, includingPropertiesForKeys: nil, options: .skipsPackageDescendants)
            
            for resourceURL in resourcesURLs {
                if resourceURL.pathExtension == "md" {
                    url = resourceURL
                    break
                }
            }
        }
        catch {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Error loading directory url: %@", log: Log.WriterCommon.all, type: .fault, %%directoryUrl)
            #endif
        }
        return  url
    }
    
    private func string(from sourceDirectoryFileWrapper: FileWrapper) -> String? {
        
        let sourcesFilesFileWrapper = sourceDirectoryFileWrapper.fileWrappers
        
        assert(sourcesFilesFileWrapper != nil)
        if let sourcesFilesFileWrapper = sourcesFilesFileWrapper {
            
            let sourceFileWrapperEntry = sourcesFilesFileWrapper.first
            
            assert(sourceFileWrapperEntry != nil)
            if let sourceFileWrapperEntry = sourceFileWrapperEntry {
                
                let (_, sourceFileFileWrapper) = sourceFileWrapperEntry
                
                assert(sourceFileFileWrapper.isRegularFile)
                
                let sourceData = sourceFileFileWrapper.regularFileContents
                
                assert(sourceData != nil)
                if let sourceData = sourceData {
                    
                    return String(data: sourceData, encoding: String.Encoding.utf8)
                }
                else {
                    
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("TextManager loading sourceData is nil.", log: Log.WriterCommon.all, type: .error)
                    #endif
                }
            }
            else {
                
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("TextManager loading sourceFileWrapperEntry is nil.", log: Log.WriterCommon.all, type: .error)
                #endif
            }
        }
        else {
            
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("TextManager loading sourcesFilesFileWrapper is nil.", log: Log.WriterCommon.all, type: .error)
            #endif
        }
        return nil
    }
    
}
