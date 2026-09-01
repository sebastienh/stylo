//
//  Error.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-10-06.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import PromiseKit
import Igloo

public enum NWError: Error {
    
    case nilAttributesStore
    case nilDocumentFragment
    case nilResourceComputedStyle
    case nilDocument
    case nilDocumentUpdateResult
    case nilDocumentBody
    case nilStyleRootChildElements
    case unableToLoad(url: URL)
    case nilEditableManager
    case unableToLoadFile(file: String)
    case nilSourceString
    case nilMarkdownTokens
    case nilStylesheet
    case nilVisibleRange
    case nilAddedRange
    case unhandledActionType(actionType: ActionType)
    case unhandledStoreType(storeId: String)
    case nilStyle
    case errorApplyingAttributes(description: String)
    case nilHtmlSerializedString
    case htmlPreviewNotVisible
    case nilHtmlPreviewStyle
    case errorGeneratingAttributedString
    case nilAttributedString
    case wrongResultType
    case errorCreatingStyleMetadata
    case invalidDocumentFormat
    case nilStyleAssembly
    case custom(message: String)
}

//
//struct NWError: Error {
//
//    struct XMLParsingError: Error {
//        ///         enum ErrorKind {
//        ///             case invalidCharacter
//        ///             case mismatchedTag
//        ///             case internalError
//        ///         }
//        ///
//        ///         let line: Int
//        ///         let column: Int
//        ///         let kind: ErrorKind
//        ///     }
//
//        enum ErrorKind {
//            case nilAttributesStore
//            case nilDocumentFragment
//            case nilResourceComputedStyle
//            case nilDocument
//            case nilStyleRootChildElements
//            case unableToLoad(url: URL)
//            case nilEditableManager
//            case unableToLoadFile(file: String)
//            case nilSourceString
//            case nilMarkdownTokens
//            case nilStylesheet
//            case nilVisibleRange
//            case nilAddedRange
//            case unhandledActionType(action: ActionType)
//            case unhandledStoreType(storeId: String)
//            case nilStyle
//            case errorApplyingAttributes(description: String)
//        }
//}


