//
//  TextManager+PlainMarkdownExportable.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-06-10.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation

extension TextManager: PlainMarkdownExportable {
    
    public var plainMarkdownString: String {
        
        // simply return the text we have
        return self.string
    }
}
