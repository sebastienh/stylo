//
//  QueryableHtmlDocument.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-05-01.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation

public protocol QueryableHtmlDocument {
    
    func bounds(for elementId: String) throws -> NSRect
    
    func firstWebDisplayedElementIndex() -> String?

}

