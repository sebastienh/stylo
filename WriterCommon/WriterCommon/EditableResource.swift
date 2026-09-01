//
//  EditableResource.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-05-20.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Web
import Common

///
/// A class representing any document that can be edited. Some documents 
/// may have a SourceStringResource associated with them but not being editable, such
/// resource documents include user agent css.
///
public protocol EditableResource: class {

    /// The resource is dirty when edited.
    var dirty: Bool { get set }
    
    /// Language edited by the resource.
    var editedLanguage: Language { get }
}
