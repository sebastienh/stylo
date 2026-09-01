////
////  FocusOptions.swift
////  WriterCommon-mac
////
////  Created by Sebastien Hamel on 2020-07-25.
////  Copyright © 2020 Textually Inc. All rights reserved.
////
//
//import Foundation
//
//
//
///// In this dictionary we keep each possible combination,
///// of focus that we handle
/////
//public struct FocusOptions: OptionSet, Hashable, CustomStringConvertible {
//    
//    private enum EphemeralType: Int {
//        case focus = 1
//    }
//    
//    public var description: String {
//        
//        var string = "ephemeralOptions"
//        
//        if self.isEmpty {
//            string += "empty"
//            return string
//        }
//        for option in self.elements {
//            
//            guard let ephemeralType: EphemeralType = EphemeralType(rawValue: option.rawValue) else {
//                assertionFailure("Error: unsupported option: \(option)")
//                string += ":unsupported"
//                continue
//            }
//            
//            switch ephemeralType {
//            case .focus:
//                string += ":focus"
//            }
//        }
//        return string
//    }
//    
//    public let rawValue: Int
//    
//    public static let focus = PseudoClassesOptions(rawValue: EphemeralType.focus.rawValue)
//    
//    public static let empty: PseudoClassesOptions = []
//    
//    public init(rawValue: Int) {
//        self.rawValue = rawValue
//    }
//}
//
//fileprivate extension OptionSet where RawValue: FixedWidthInteger {
//
//    var elements: AnySequence<Self> {
//        var remainingBits = rawValue
//        var bitMask: RawValue = 1
//        return AnySequence {
//            return AnyIterator {
//                while remainingBits != 0 {
//                    defer { bitMask = bitMask &* 2 }
//                    if remainingBits & bitMask != 0 {
//                        remainingBits = remainingBits & ~bitMask
//                        return Self(rawValue: bitMask)
//                    }
//                }
//                return nil
//            }
//        }
//    }
//}
