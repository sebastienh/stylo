//
//  SourceSetManager+Saving.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-10-15.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation

extension SourceSetManager {
    
    public var topFileWrappers: [String: FileWrapper]? {
        
        guard let topDirectory = self.topDirectory else {
            assertionFailure("Error: self.topDirectory is nil")
            return nil
        }
        
        return  topDirectory.topLevelFileWrappers
    }
    
}
