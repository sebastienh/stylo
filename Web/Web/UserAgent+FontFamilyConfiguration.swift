//
//  UserAgent+FontFamilyConfiguration.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-27.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import os

#if os(OSX)
    import Cocoa
#elseif os(iOS)
    import UIKit
#endif

extension UserAgent: FontFamilyConfiguration {
    
    func updateFontFamiliesComponents() {
        
        let fontFamiliesArray = availablePlateformFontFamilies()

        for fontFamily in fontFamiliesArray {
    
            let values = fontFamily.explode(" ")
    
            let lowercaseValues = values.map({ (value: String) -> String in
                return value.lowercased()
            })
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("adding fontFamilyName: %@", log: Log.Web.all, type: .info, %%fontFamily)
            #endif
            
            fontFamilies.updateValue(lowercaseValues, forKey: fontFamily)
        }
        
        // handle generic font families
        fontFamilies.updateValue([§CSSFontGenericFamily.Serif], forKey: §CSSFontGenericFamily.Serif)
        fontFamilies.updateValue([§CSSFontGenericFamily.SansSerif], forKey: §CSSFontGenericFamily.SansSerif)
        fontFamilies.updateValue([§CSSFontGenericFamily.Monospace], forKey: §CSSFontGenericFamily.Monospace)
        fontFamilies.updateValue([§CSSFontGenericFamily.Fantasy], forKey: §CSSFontGenericFamily.Fantasy)
        fontFamilies.updateValue([§CSSFontGenericFamily.Cursive], forKey: §CSSFontGenericFamily.Cursive)
    }
    
    func fontFamilyCodeFromStringArray(_ strings: [String]) -> String? {
        
        let joinedLowercaseStrings = strings.joined(separator: "").lowercased()
        
        for (fontFamilyName, values) in self.fontFamilies {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("fontFamilyName: %@", log: Log.Web.all, type: .info, %%fontFamilyName)
            os_log("values.count: %@", log: Log.Web.all, type: .info, %%values.count)
            os_log("strings.count: %@", log: Log.Web.all, type: .info, %%strings.count)
            #endif
            
            if values.count == strings.count {

                if joinedLowercaseStrings == values.joined(separator: "") {
                    
                    return fontFamilyName
                }
            }
        }
        
        return nil
    }
    
    public func customFontFamilyFromFontGenericFontFamily(_ fontFamily: CSSFontFamily) -> CSSFontFamily {
        
        switch fontFamily {
        case .serif:
            return CSSFontFamily.custom(§CSSFontFamilyKeyword.TimesNewRoman)
        case .sansSerif:
            return CSSFontFamily.custom(§CSSFontFamilyKeyword.HelveticaNeue)
        case .cursive:
            return CSSFontFamily.custom(§CSSFontFamilyKeyword.BrushScriptMT)
        case .fantasy:
            return CSSFontFamily.custom(§CSSFontFamilyKeyword.Fantasy)
        case .monospace:
            return CSSFontFamily.custom(§CSSFontFamilyKeyword.CourierNew)
        default:
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Not a generic font family.", log: Log.Web.all, type: .error)
            #endif
        }
        assert(false, "Not a generic font family, returning Helvetica Neue.")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Not a generic font family, returning Helvetica Neue.", log: Log.Web.all, type: .error)
        #endif
        return CSSFontFamily.custom(§CSSFontFamilyKeyword.HelveticaNeue)
    }
    
    fileprivate func availablePlateformFontFamilies() -> [String] {
        
        #if os(OSX)
        let fontManager = NSFontManager.shared
        var fontFamilies: [String] = []
        for fontFamilyName in fontManager.availableFontFamilies {
            
            fontFamilies.append(fontFamilyName)
            for member in fontManager.availableMembers(ofFontFamily: fontFamilyName)! {
                guard let memberName = member.first as? String else {
                    assertionFailure("Error: memberName is nil")
                    continue
                }
                fontFamilies.append(memberName)
            }
        }
        return fontFamilies
        
        #elseif os(iOS)

            var fontNames = [String]()
            
            // List all fonts on iPhone
            let fontFamilyNames = UIFont.familyNames
            
            for fontFamilyName in fontFamilyNames {
                
                fontNames.append(contentsOf: UIFont.fontNames(forFamilyName: fontFamilyName))
            }
            
            return fontNames
            
        #endif
    }
    
    
}
