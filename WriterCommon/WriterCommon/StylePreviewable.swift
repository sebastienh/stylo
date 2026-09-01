//
//  StylePreviewable.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-07-16.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Common
import Web

public protocol StylePreviewable {
    
    var stylePreview: Dynamic<StylePreview?> { get }
    
}

