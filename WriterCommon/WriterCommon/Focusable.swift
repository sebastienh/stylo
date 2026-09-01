//
//  Focusable.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-10-30.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Web
import Common

protocol Focusable {
    
    var isFocused: Bool { get }
    
    var focusType: Dynamic<FocusType?> { get }
    
    var temporaryAttributedRange: NSRange? { get }
    
    func clearFocusedRange()
    
    func updateFocusAttributes(forVisibleTopElements visibleTopElements: ContiguousArray<Element>, document: Document, originStringAction stringAction: StringAction)
    
    func clearFocusAttributes()
    
    func changeFocusMode(_ focusMode: FocusMode)
    
    func clearPreviousFocusStateIfNecessary()
    
    func setApplicationFocusType()
    
}
