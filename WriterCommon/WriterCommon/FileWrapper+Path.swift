//
//  FileWrapper+Path.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-07-26.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation

extension FileWrapper {
    
    func fileWrapper(at path: String) -> FileWrapper? {
        
        var currentFileWrapper = self
        let components = path.components(separatedBy: "/")
        
        // going down in the filewrapper
        for component in components {
            
            // childFileWrappers is a Dictionary
            guard let childFileWrappers = currentFileWrapper.fileWrappers else {
                assert(false)
                return nil
            }
            
            guard let componentFileWrapper = childFileWrappers[component] else {
                return nil
            }
            currentFileWrapper = componentFileWrapper
        }
        return currentFileWrapper
    }
}
