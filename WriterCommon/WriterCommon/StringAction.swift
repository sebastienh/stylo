//
//  StringAction.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-10-26.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Common

///
public indirect enum StringAction {
    
    case `init`
    case changeStyle
    case flash(range: NSRange)
    case refocus(range: NSRange)
    case focus(range: NSRange, originStringAction: StringAction)
    case highlight
    case clearHighlight
    case edit(change: SourceStringChangeDescription)
    case select(range: NSRange)
}
