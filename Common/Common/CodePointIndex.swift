//
//  CodePointIndex.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-10-26.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation
import os

//public struct CodePointIndex: ExpressibleByNilLiteral, Equatable {
//    
//    public var integerIndex: Int
//    
//    public var lineNumber: Int?
//    
//    var endOfText: Bool
//    
//    var description: String {
//        
//        return "\nIndex: \(integerIndex)\n"
//        
//    }
//    
//    public static var EndOfText = CodePointIndex(integerIndex: Int.max, endOfText: true)
//    
//    public init(integerIndex: Int, endOfText: Bool = false, lineNumber: Int? = nil, offset: Int? = nil) {
//        
//        self.integerIndex = integerIndex
//        self.endOfText = endOfText
//        self.lineNumber = lineNumber
//    }
//    
//    public init(nilLiteral: ()) {
//        
//        self.integerIndex = -1
//        self.endOfText = false
//    }
//    
//    func isAfter(_ otherCodePointIndex: CodePointIndex) -> Bool {
//        
//        return self.integerIndex > otherCodePointIndex.integerIndex
//    }
//    
//    func isBefore(_ otherCodePointIndex: CodePointIndex) -> Bool {
//        
//        return self.integerIndex < otherCodePointIndex.integerIndex
//    }
//    
//    public func sameLineCodePointOffsetBy(_ offset: Int) -> CodePointIndex {
//        
//        return CodePointIndex(
//            integerIndex: integerIndex + offset,
//            lineNumber: lineNumber)
//    }
//    
//    //////////////////////////////////////////////////////////////////////////////////////////////////////////
//    //                                  MARK: EquatableLanguageObject protocol  implementation
//    //////////////////////////////////////////////////////////////////////////////////////////////////////////
//    
//    public func equals(to other: Any?) -> Bool {
//        
//        if let other = other {
//        
//            if let other = other as? CodePointIndex {
//            
//                if integerIndex != other.integerIndex {
//                    
//                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
//                    os_log("Not equals: integerIndex are different: integerIndex: %d and other: %d", log: Log.Common.all, type: .debug, integerIndex, other.integerIndex)
//                    #endif
//                    return false
//                }
//                
//                if lineNumber != other.lineNumber {
//                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
//                    os_log("Not equals: lineNumber are different.", log: Log.Common.all, type: .debug)
//                    #endif
//                    return false
//                }
//                
//                if endOfText != other.endOfText {
//                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
//                    os_log("Not equals: endOfText are different.", log: Log.Common.all, type: .debug)
//                    #endif
//                    return false
//                }
//            }
//            else {
//                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
//                os_log("Not equals: other is not CodePointIndex.", log: Log.Common.all, type: .debug)
//                #endif
//                return false
//            }
//        }
//        else {
//            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
//            os_log("Not equals: other is nil.", log: Log.Common.all, type: .debug)
//            #endif
//            return false
//        }
//        return true
//    }
//}
//
//extension CodePointIndex: Int {
//
//    public var stringAbsoluteCodePointIndex: Int {
//    
//        return self
//    }
//}
//
//extension CodePointIndex: IntegerConvertible {
//    
//    public var integerValue: Int {
//        
//        return integerIndex
//    }
//}
//
//extension CodePointIndex: Hashable {
//    
//    public var hashValue: Int {
//        
//        var _hashValue: Int = integerIndex.hashValue
//        
//        if let lineNumber = lineNumber {
//            
//            _hashValue ^= lineNumber.hashValue
//        }
//        
//        return _hashValue
//    }
//}
//
//public func ==(lhs: CodePointIndex, rhs: CodePointIndex) -> Bool {
//    
//    return lhs.equals(to: rhs)
//}
