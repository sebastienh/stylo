//
//  NSURL+CSS.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2016-01-02.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation
import Common

extension String {
    
    func extractStylesheetTitle() -> String {
        
        return self
    }
    
}

extension URL {
    
    func extractId() -> String {
        
        return self.lastPathComponent
    }
    
    func extractStylesheetId() -> String {
        
        // remove the .css
        var stylesheetFilename = extractId()
        stylesheetFilename.removeLast(4)
        return stylesheetFilename
    }
    
    func extractStylesheetTitle() -> String {
     
        return self.deletingPathExtension().lastPathComponent
    }
    
    func extendedTitle() -> String {
        
        return (self as NSURL).deletingPathExtension!.deletingPathExtension().lastPathComponent
    }
    
}
