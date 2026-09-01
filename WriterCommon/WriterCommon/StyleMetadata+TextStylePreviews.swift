//
//  StyleMetadata+TextStylePreviews.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2021-01-05.
//  Copyright © 2021 Textually Inc. All rights reserved.
//

import Foundation

extension StyleMetadata {
    
    var containsStylePreviews: Bool {
        
        return !self.stylePreviews.isEmpty
    }
    
}
