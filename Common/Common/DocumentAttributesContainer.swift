//
//  DocumentAttributesContainer.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-04-11.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation

public protocol DocumentAttributesContainer: class {
    
    var documentAttributes: DocumentAttributes? { get }
    
}
