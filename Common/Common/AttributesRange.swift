//
//  AttributesRange.swift
//  Common
//
//  Created by Sebastien Hamel on 2020-09-08.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import os

public struct AttributesRange: Equatable {
    
    public let attributes: [NSAttributedString.Key: Any]
    
    public let range: NSRange
    
    public let originNodeName: String
    
    public init(_ attributes: [NSAttributedString.Key:Any], _ range: NSRange, _ originNodeName: String) {
        
        self.attributes = attributes
        self.range = range
        self.originNodeName = originNodeName
    }
    
    public static func == (lhs: AttributesRange, rhs: AttributesRange) -> Bool {
        
        if !lhs.attributes.equals(to: rhs.attributes) {
            
            //                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Not equals: attributes are different: %@ vs %@", log: Log.Common.all, type: .debug, %%lhs.attributes, %%rhs.attributes)
            //                #endif
            return false
        }
        if lhs.range != rhs.range {
            
            //                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Not equals: range are different: %@ vs %@", log: Log.Common.all, type: .debug, %%lhs.range, %%rhs.range)
            //                #endif
            return false
        }
        if lhs.originNodeName != rhs.originNodeName {
            
            //                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Not equals: originNodeName are different: %@ vs %@", log: Log.Common.all, type: .debug, %%lhs.originNodeName, %%rhs.originNodeName)
            //                #endif
            return false
        }
        return true
    }
}
