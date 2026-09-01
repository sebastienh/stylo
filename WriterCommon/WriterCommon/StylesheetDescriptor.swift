//
//  StylesheetDescriptor.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-04-08.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Web

enum CssStylesheetDescriptor: String {
    
    case commonSource = "common-source"
    case commonErrors = "common-errors"
    case commonError = "common-error"
    case sourceDark = "source-dark"
    case sourceLight = "source-light"
    case cssErrorsDark = "errors-dark"
    case cssErrorsLight = "errors-light"
    case cssErrorDark = "error-dark"
    case cssErrorLight = "error-light"
    
    static var cssStylesTypes: [CssStylesheetDescriptor] {
        return [.commonSource, commonErrors, .commonError, .sourceDark, .sourceLight, .cssErrorsDark, .cssErrorsLight, .cssErrorDark, .cssErrorLight]
    }
    
    var origin: CSSOrigin {
        switch self {
        case .sourceDark: fallthrough
        case .sourceLight: fallthrough
        case .cssErrorsDark: fallthrough
        case .cssErrorsLight: fallthrough
        case .cssErrorDark: fallthrough
        case .cssErrorLight:
            return .user
        case .commonSource: fallthrough
        case .commonErrors: fallthrough
        case .commonError:
            return .author
        }
    }
    
    func same(forAppearance appearance: AppearanceMode) -> CssStylesheetDescriptor {
        
        switch self {
        case .commonSource:
            return .commonSource
        case .commonErrors:
            return .commonErrors
        case .commonError:
            return .commonError
        case .sourceDark:
            return .sourceLight
        case .sourceLight:
            return .sourceDark
        case .cssErrorsDark:
            return .cssErrorsLight
        case .cssErrorsLight:
            return .cssErrorsDark
        case .cssErrorDark:
            return .cssErrorLight
        case .cssErrorLight:
            return .cssErrorDark
        }
    }
}
