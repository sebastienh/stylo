//
//  RenderingContext.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-07-22.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Web
import Common

struct RenderingContext {

    let contentString: StylableString
    
    let stringChangeDescription: SourceStringChangeDescription?
    
    let renderingType: RenderingType
    
    let focusType: FocusType?
    
    let visibleTextRange: NSRange?
    
    let selectionRange: NSRange?
    
    let filterContext: FilterContext
    
    let isFirstResponder: Bool?
    
    init(contentString: StylableString, stringChangeDescription: SourceStringChangeDescription? = nil, focusType: FocusType? = nil, renderingType: RenderingType = .edit, visibleTextRange: NSRange? = nil, selectionRange: NSRange? = nil, filterContext: FilterContext, isFirstResponder: Bool? = nil) {
        
        self.contentString = contentString
        self.stringChangeDescription = stringChangeDescription
        self.focusType = focusType
        self.renderingType = renderingType
        self.visibleTextRange = visibleTextRange
        self.selectionRange = selectionRange
        self.filterContext = filterContext
        self.isFirstResponder = isFirstResponder
    }
}
