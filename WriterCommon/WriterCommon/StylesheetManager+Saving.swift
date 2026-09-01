//
//  StylesheetManager+Saving.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-03-09.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation

extension StylesheetManager {
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: FileWrapper implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func createFileWrapper() -> FileWrapper {
        
        let textData: Data = self.string.data(using: String.Encoding.utf8)!
        
        let textFileWrapper = FileWrapper(regularFileWithContents: textData)
        
        // we use the order in the style to name the specific stylesheet
        // since it gives us an indication of the order of the stylesheet
        // in the style.
        textFileWrapper.preferredFilename = self.id + "." + Constants.FileExtension.css
        
        return textFileWrapper
    }
    
}
