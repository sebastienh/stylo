//
//  FocusType.swift
//  Web
//
//  Created by Sebastien Hamel on 2020-09-02.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

public enum FocusType: Equatable {
    
    case bloc
    case paragraph
    case sentence
    case flash(flashedRange: NSRange?)
    
    public var isFlash: Bool {
        switch self {
        case .bloc: fallthrough
        case .paragraph: fallthrough
        case .sentence:
            return false
        case .flash:
            return true
        }
    }
    
    public var isParagraphOrSentence: Bool {
        switch self {
        case .bloc:
            return false
        case .paragraph: fallthrough
        case .sentence:
            return true
        case .flash:
            return false
        }
    }
    
    public var flashedRange: NSRange? {
        switch self {
        case .flash(let focusedRange):
            return focusedRange
        default:
            return nil
        }
    }
    
}
