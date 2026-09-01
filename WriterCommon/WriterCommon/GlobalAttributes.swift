//
//  GlobalAttributes.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-04-26.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Common

public struct GlobalAttributes {
    
    public var documentAttributes: DocumentAttributes
    
    public var backgroundColor: PlateformColorType? {
        
        return documentAttributes.backgroundColor
    }
    
    public var caretColor: PlateformColorType? {
        
        return documentAttributes.caretColor
    }
    
    public var stylePreview: StylePreview
    
    public var selectedTextAttributes: [NSAttributedString.Key : Any]
    
}
