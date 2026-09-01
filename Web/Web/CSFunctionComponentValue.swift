//
//  FunctionBlockComponentValue.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-30.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common
import os

final class CSFunctionComponentValue: CSComponentValue, CSValueHolder {
    
    typealias ValueType = CSFunction
    
    /// Contains the name of the function without the left parenthesis
    var value: CSFunction
    
    var functionType: CSFunctionType? {
        return CSFunctionType(rawValue: value.name.lowercased())
    }
    
    init(value: CSFunction) {
        
        self.value = value
        super.init(sourceStringSegment: value.sourceStringSegment)
    }
    
    override func clone() -> CSFunctionComponentValue {
        
        let functionClone = value.clone()
        functionClone.messageHandler = self.messageHandler 
        return CSFunctionComponentValue(value: functionClone)
    }
    
    override func isTokenId(_ tokenId: Int) -> Bool {
        
        if §CSTokenId.functionToken == tokenId {
            
            return true
        }
        return false
    }
 
    override func cssText() -> DOMString {
        
        return value.cssText()
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Positionnable protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /// This method translate the position of the fragment using
    // the count from which moving the fragment by adding this count
    // to the start and end index.
    public override func move(_ count: Int) {
        
        self.sourceStringSegment?.move(count)
        self.value.move(count)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
        
        if let other = other {
        
            if let other = other as? CSFunctionComponentValue {
                
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
                os_log("Not equals: other is not CSFunctionComponentValue.", log: Log.Web.all, type: .debug)
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

extension CSFunctionComponentValue : DotStringNode {
    
    func dotString(_ nodeName: String) -> String {
        
        return "\(nodeName) [shape=record, label=\"CSFunctionComponentValue\"];\n"
    }
}
