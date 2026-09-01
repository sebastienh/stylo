//
//  TextManager+Saving.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-10-15.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation

extension TextManager: Saving {

    public var fileWrapperId: String {
        return self.name.value + "." + Constants.FileExtension.markdown
    }
    
    public func createFileWrapper() -> FileWrapper? {
        
        let textData: Data = self.string.data(using: String.Encoding.utf8)!
        let textFileWrapper = FileWrapper(regularFileWithContents: textData)
        textFileWrapper.preferredFilename = fileWrapperId
        return textFileWrapper
    }
}
