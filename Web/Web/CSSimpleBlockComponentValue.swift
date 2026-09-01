//
//  CSSLeftCurlyBraceBlockComponentValue.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-30.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common
import os

final class CSSimpleBlockComponentValue: CSComponentValue, CSValueHolder {
    
    typealias ValueType = CSSimpleBlock
    
    var value: CSSimpleBlock
    
    var count: Int {
        
        return value.componentValueList.count
    }
    
    subscript(index: Int) -> CSComponentValue? {
        
        get {
            if index < value.componentValueList.count {
                return value.componentValueList[index]
            }
            return nil
        }
    }
    
    init(value: CSSimpleBlock) {
        
        self.value = value
        super.init(sourceStringSegment: value.sourceStringSegment)
    }

    override func cssText() -> DOMString {
        
        return value.cssText()
    }
    
    override func clone() -> CSComponentValue {
        
        let blockComponentValue = CSSimpleBlockComponentValue(value: value.clone())
        blockComponentValue.messageHandler = value.messageHandler
        return blockComponentValue
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Positionnable protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /// This method translate the position of the fragment using
    // the count from which moving the fragment by adding this count
    // to the start and end index.
    public override func move(_ count: Int) {
        
        self.sourceStringFragment?.move(count)
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("sourceStringSegment: %@", log: Log.Web.all, type: .info, %%String(describing: sourceStringSegment))
        #endif
        self.value.move(count)
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("value.sourceStringSegment: %@", log: Log.Web.all, type: .info, %%String(describing: value.sourceStringSegment))
        #endif
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
        
        if let other = other {
            
            if let other = other as? CSSimpleBlockComponentValue {
            
                if !super.equals(to: other, comparePositions: comparePositions) {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: super are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                if !self.value.equals(to: other.value, comparePositions: comparePositions) {
                
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: value are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
            }
            else {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other value is not CSSimpleBlockComponentValue.", log: Log.Web.all, type: .debug)
                #endif
                return false
            }
        }
        else {
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Not equals: other is nil.", log: Log.Web.all, type: .debug)
            #endif
            return false
        }
        
        return true
    }
}

extension CSSimpleBlockComponentValue : DotStringNode {
    
    func dotString(_ nodeName: String) -> String {
        
        return "\(nodeName) [shape=record, label=\"CSSimpleBlockComponentValue\"];\n"
    }
}
