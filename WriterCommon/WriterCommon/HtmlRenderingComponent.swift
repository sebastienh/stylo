//
//  HtmlRenderingComponent.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2015-12-23.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

public enum HtmlRenderingComponentError: Error {
    
    case elementNotFoundInWebView
    case nilComponent
    case nilLeafElements
    case nilDocument
}

public protocol HtmlRenderingComponent: class {
    
    func loadString(_ string: String)
    
    func reload()
    
}
