//
//  ThemeStore.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-11-15.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Common
import PromiseKit
import Igloo
import Web

public typealias ThemeId = String

protocol ThemeType {
    
}

public enum PrintThemeType: String, ThemeType, CaseIterable, SourceType {
    
    case previewLight = "preview-light.stencil"
    case previewDark = "preview-dark.stencil"
    case pdf = "pdf.stencil"
    case word = "word.stencil"
    
    public var stylesheetDescriptor: String {
        switch self {
        case .previewLight:
            return "preview.light"
        case .previewDark:
            return "preview.dark"
        case .pdf:
            return "pdf"
        case .word:
            return "word"
        }
    }
    
    public var source: Bool {
        switch self {
        case .previewDark: fallthrough
        case .previewLight: fallthrough
        case .pdf: fallthrough
        case .word:
            return false
        }
    }
    
    public var print: Bool {
        switch self {
        case .pdf: fallthrough
        case .word:
            return true
        default:
            return false
        }
    }
    
    var styleType: StyleType {
        switch self {
        case .previewDark: fallthrough
        case .previewLight:
            return .preview
        case .pdf: fallthrough
        case .word:
            return .printing
        }
    }
    
    var isDark: Bool {
        
        switch self {
        case .previewDark:
            return true
        default:
            return false
        }
    }
    
    var isLight: Bool {
        
        switch self {
        case .previewLight: fallthrough
        case .pdf: fallthrough
        case .word:
            return true
        default:
            return false
        }
    }
    
    static var preview: [PrintThemeType] {
        return [.previewLight, .previewDark]
    }
}

public final class ThemeStore: Store, IdentifiableStoreType {

    public typealias ReducerType = ThemeReducer
    
    /// Reference to the associated reducer
    public let reducer: ThemeReducer
    
    /// Unique identifier
    public let identifier: String = UUID().uuidString

    public let name: String
    
    public var styles = Dictionary<ThemeId, StyleAssemblyStore>()
    
    public var pendingRequests = Queue<SourceStringChangeDescription>()
    
    subscript(themeId: ThemeId) -> StyleAssemblyStore {
        return styles[themeId]!
    }
    
    init(name: String) {
        self.name = name
        self.reducer = ThemeReducer()
    }
}
