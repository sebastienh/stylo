//
//  Processor.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2016-01-14.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation
import os

/// The role of the Processor is to process some sort of
/// document and to act as a interface between the documentcomputedstyle
/// and the rendering engine in the DocumentManager.
class Processor : Hashable {
    
    var hashValue: Int {
        
        return UInt(bitPattern: ObjectIdentifier(self)).hashValue
    }
    
    init() {
        
    }
    
}

func ==(lhs: Processor, rhs: Processor) -> Bool {
    
    assert(false, "Missing subclass implementation.")
    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
    os_log("Missing subclass implementation.", log: Log.WriterCommon.all, type: .error)
    #endif
    return false
}
