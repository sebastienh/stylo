//
//  RenderingType.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-06-22.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation

enum RenderingType {
    
    // this is used to initialize all the string attributes
    case complete
    
    // this is used when the user edit the source string
    // to update the string attributes
    case edit
    
    // this is used when the user put the cursor
    // at a new location in the text
    case selection
    
    // this is used when the user change the flashed
    // elements in highlight mode
    case flash
    
}
