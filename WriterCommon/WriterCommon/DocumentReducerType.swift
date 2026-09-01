//
//  DocumentReducerType.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-04-16.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Igloo

public protocol DocumentReducerType {
    
//    func updateStyleRootChildElements<S: Store & DocumentStoreType>(store: S)
    
}

extension DocumentReducerType {
    
//    public func updateStyleRootChildElements<S: Store & DocumentStoreType>(store: S) {
//
//        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
//        os_log("start updating style root child elements.", log: Log.WriterCommon.all, type: .info)
//        #endif
//
//        guard let document = store.document.value else {
//            assertionFailure("Error: store.document is nil")
//            return
//        }
//
//        // update styleRootChildElements
//        store.styleRootChildElements.setValue(document.styleRoot.childrenWithSourceStringFragment)
//
//        #if DEBUG
//            if let styleRootChildElements = store.styleRootChildElements.value {
//                for styleRootChildElement in styleRootChildElements {
//                    assert(styleRootChildElement.document != nil)
//                }
//            }
//        #endif
//    }
    
}
