//
//  Number.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-11.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common

enum NumberType {
    case real
    case integer
    case `nil`
}

struct Number: MessageContainer, Positionnable, Equatable, Hashable {
    
    let numberType: NumberType
    
    let value: Double
    
    var hashValue: Int {
        
        return value.hashValue
    }
    
    var string: String? {
        
        switch self.numberType {
            
        case .integer:
            
            return String(value)
            
        case .real:
            
            return String(value)
            
        case .nil:
            
            return nil
        }
        
    }
    
    /// Convert the Number value to CGFloat
    var cgFloat: CGFloat? {
        
        switch self.numberType {
            
        case .integer:
            
            return CGFloat(value)
            
        case .real:
            
            return CGFloat(value)
            
        case .nil:
            
            return nil
        }
    }
    
    var int: Int? {
        
        switch self.numberType {
            
        case .integer:
            
            return Int(value)
            
        case .real:
            
            return Int(value)
            
        case .nil:
            
            return nil
        }
    }
    
    init(numberType: NumberType, value: Double, sourceStringSegment: SourceStringSegment? = nil) {
        
        self.numberType = numberType
        self.value = value
        self.sourceStringFragment = sourceStringSegment
        self.messageHandler = MessageHandler()
    }

    init(sourceStringSegment: SourceStringSegment? = nil) {
        
        self.numberType = NumberType.nil
        self.value = 0
        self.sourceStringFragment = sourceStringSegment
        self.messageHandler = MessageHandler()
    }
    

    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Positionnable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    var sourceStringFragment: SourceStringFragment?
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: MessageContainer protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    var messageHandler: MessageHandler
   
}

func ==(lhs: Number, rhs: Number) -> Bool {
    
    if lhs.numberType != rhs.numberType {
        return false
    }
    if lhs.value != rhs.value {
        return false
    }
    return true
}

