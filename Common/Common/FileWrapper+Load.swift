//
//  FileWrapper+Load.swift
//  Common
//
//  Created by Sebastien Hamel on 2020-04-17.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

extension FileWrapper {
    
    public var string: String? {
        
        assert(self.isRegularFile)
        guard let data = self.regularFileContents else {
            assertionFailure("Error: self.regularFileContents is nil")
            return nil
        }
        guard let sourceString = String(data: data, encoding: .utf8) else {
            assertionFailure("Error: string is not utf8")
            return nil
        }
        return sourceString
    }
    
}
