//
//  FocusMode.swift
//  Web
//
//  Created by Sebastien Hamel on 2020-09-02.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

public enum FocusMode: Equatable {
    
    case disabled
    case enabled(focusType: FocusType)
    
    public var stringValue: String {
        
        switch self {
        case .disabled:
            return "disabled"
        case .enabled(let focusType):
            switch focusType {
            case .bloc:
                return "bloc"
            case .paragraph:
                return "paragraph"
            case .sentence:
                return "sentence"
            case .flash:
                return "disabled"
            }
        }
    }
    
    public static func from(_ string: String) -> FocusMode {
        switch string {
        case "disabled":
            return .disabled
        case "sentence":
            return .enabled(focusType: .sentence)
        case "paragraph":
            return .enabled(focusType: .paragraph)
        case "bloc":
            return .enabled(focusType: .bloc)
        default:
            assertionFailure("Error: unrecognized focus mode: \(string)")
            return .disabled
        }
    }
    
    public var focusType: FocusType? {
        switch self {
        case .disabled:
            return nil
        case .enabled(let focusType):
            return focusType
        }
    }
    
}
