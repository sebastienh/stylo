//
//  Rule.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-31.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common
import os

open class CSRule: CSLanguageObject, CSVisitable, CSTextNode {
    
    override init(sourceStringSegment: SourceStringSegment?) {
        
        super.init(sourceStringSegment: sourceStringSegment)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // 1. Visit the root.
    // 2. Traverse the left subtree.
    // 3. Traverse the right subtree.
    open func accept(_ visitor: CSVisitor) -> NodeInfo {
        
        fatalError("Missing implementation.")
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSTextNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func cssText() -> DOMString {
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Method cssText() -> String must be implemented by subclasses", log: Log.Web.all, type: .error)
        #endif
        
        return ""
    }
}
