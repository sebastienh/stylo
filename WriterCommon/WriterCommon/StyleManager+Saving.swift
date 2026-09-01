//
//  StyleManager+Saving.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-02-06.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Common

extension StyleManager: Saving {

    public var fileWrapperId: String {
        return self.id
    }
    
    public func createFileWrapper() -> FileWrapper? {
        
        var fileWrappersDictionary = [String: FileWrapper]()
        
        for stylesheetManager in stylesheetManagers {
            
            // we dont save the user agent stylesheet
            guard stylesheetManager.stylesheet?.origin != .userAgent else {
                continue 
            }
            
            let stylesheetFileWrapper = stylesheetManager.createFileWrapper()
            
            assert(stylesheetFileWrapper.preferredFilename != nil)
            if let preferredFilename = stylesheetFileWrapper.preferredFilename {
                fileWrappersDictionary[preferredFilename] = stylesheetFileWrapper
            }
            else {
                assert(false, "missing implementation")
            }
        }
        
        let styleManagerDirectoryFileWrapper = FileWrapper(directoryWithFileWrappers: fileWrappersDictionary)
        styleManagerDirectoryFileWrapper.preferredFilename = fileWrapperId
        return styleManagerDirectoryFileWrapper
    }
}
