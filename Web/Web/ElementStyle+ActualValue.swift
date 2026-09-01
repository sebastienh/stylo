////
////  ElementStyle+ActualValues.swift
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
//
//    /// A used value is in principle ready to be used, but a user agent may not be able to make use of the
//    /// value in a given environment. For example, a user agent may only be able to render borders with
//    /// integer pixel widths and may therefore have to approximate the used width. Also, the font size of an
//    /// element may need adjustment based on the availability of fonts or the value of the font-size-adjust
//    /// property. The actual value is the used value after any such adjustments have been made.
//    ///
//    /// see http://dev.w3.org/csswg/css-cascade-4/#actual
//    func computeActualStyle() {
//
//        for (propertyName, usedPropertyValue) in usedStyle.propertyValues {
//
//            computeActualValue(propertyName, usedPropertyValue: usedPropertyValue)
//        }
//    }
//
//    //////////////////////////////////////////////////////////////////////////////////////////////////////////
//    //                                  MARK: Private methods
//    //////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    private func computeActualValue(propertyName: DOMString, usedPropertyValue: CSSPropertyValueContainer) {
//
//        if let property = CSSProperty(rawValue: propertyName) {
//
//            switch usedPropertyValue {
//
//            case .Error:
//                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
//                os_log("Used property value for property: \(§property) is error.", log: Log.Web.all, type: .error)
//                #endif
//
//            case .Unsupported:
//                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
//                os_log("Used property value for property: \(§property) is unsupported.", log: Log.Web.all, type: .error)
//                #endif
//
//            case .None:
//                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
//                os_log("Cannot compute used value from None usedPropertyValue.", log: Log.Web.all, type: .error)
//                #endif
//
//            default:
//
//                // by default we simply put the usedPropertyValue as actual value
//                actualStyle.setCSSPropertyValueContainer(propertyName, value: usedPropertyValue)
//            }
//        }
//        else {
//            fatalError("Property: \(propertyName) not supported.")
//        }
//
//    }
//
//}

