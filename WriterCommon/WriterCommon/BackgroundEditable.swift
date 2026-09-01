//
//  BackgroundEditable.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-10-06.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Igloo
import Common
import Web
import os

public protocol BackgroundEditable: class {
    
    /// This function is responsible to backup the actual state
    /// of the editor. We use the the backed up state to
    /// restore what we need when the background editing is done.
    ///
    func beginBackgroundEditing()
    
    /// Make sure the state it is restored properly after background
    /// editing.
    func endBackgroundEditing(withVisibleTopElements visibleTopElements: ContiguousArray<Element>, document: Document, visibleCharacterRange: NSRange)
    
}
