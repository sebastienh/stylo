//
//  FailableResource.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2016-01-17.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation
import Common
import Web

public protocol FailableResource: class {
    
    var errors: [Message] { get }
    
    var issuesCount: Int { get }
    
    /// Variable that is set every time the style changed in order
    /// to force a error style creation.
    var needAllErrorStyleRecomputation: Bool { get set }
    
    /// This is the model used when constructing the error style.
    var allErrorsStyleModel: CSSStyle? { get }
    
    /// This is the style used for error highligting, it is changed
    /// every time the style is changed.
    var errorStyle: StyleDefinition? { get set }
    
    subscript(index: Int) -> Message { get }
    
}








