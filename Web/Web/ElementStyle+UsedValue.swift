////
////  ElementStyle+UsedValue.swift
////  Web
////
////  Created by Sébastien Hamel on 2015-04-21.
////  Copyright (c) 2015 NM. All rights reserved.
////
//
//import Foundation
//import Common
//
//extension ElementStyle {
//
//    /// The used value is the result of taking the computed value and completing any remaining calculations
//    /// to make it the absolute theoretical value used in the layout of the document. If the property does
//    /// not apply to this element, then the element has no used value for that property.
//    ///
//    /// see http://dev.w3.org/csswg/css-cascade-4/#used
//    func computeUsedStyle() {
//
//        for (propertyName, rawComputedPropertyValue) in rawComputedStyle.propertyValues {
//
//            computeUsedValue(propertyName, rawComputedPropertyValue: rawComputedPropertyValue)
//        }
//    }
//
//    func usedValueForProperty(propertyName: DOMString) -> CSSPropertyValueContainer? {
//
//        if let usedValue = usedStyle.getCSSPropertyValueContainer(propertyName) {
//
//            return usedValue
//        }
//
//        return nil
//    }
//
//    //////////////////////////////////////////////////////////////////////////////////////////////////////////
//    //                                  MARK: Private methods
//    //////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    private func computeUsedValue(propertyName: DOMString, rawComputedPropertyValue: CSSPropertyValueContainer) {
//
//        if let property = CSSProperty(rawValue: propertyName) {
//
//            switch rawComputedPropertyValue {
//
//            case .Error:
//                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
//                os_log("Raw computed value for property: \(§property) is error.", log: Log.Web.all, type: .error)
//                #endif
//
//            case .Unsupported:
//                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
//                os_log("Raw computed value for property: \(§property) is unsupported.", log: Log.Web.all, type: .error)
//                #endif
//
//            case .None:
//                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
//                os_log("Cannot compute used value from None rawComputedValue.", log: Log.Web.all, type: .error)
//                #endif
//
//            default:
//
//                // by default we simply put the rawComputedValue as used value
//                usedStyle.setCSSPropertyValueContainer(propertyName, value: rawComputedPropertyValue)
//            }
//        }
//        else {
//            fatalError("Property: \(propertyName) not supported.")
//        }
//    }
//
//
//}

