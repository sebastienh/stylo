//
//  CSSFontFamily.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-25.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common

public enum CSSFontFamily: CSSPropertyValue, Hashable {
    
    case serif
    case sansSerif
    case cursive
    case fantasy
    case monospace
    case custom(String)
    case defaulted(DefaultingType)
    
    public var hashValue: Int {
        
        switch self {
            
            case .serif: return (§CSSFontFamilyKeyword.Serif).hashValue
            case .sansSerif: return (§CSSFontFamilyKeyword.SansSerif).hashValue
            case .cursive: return (§CSSFontFamilyKeyword.Cursive).hashValue  
            case .fantasy: return (§CSSFontFamilyKeyword.Fantasy).hashValue  
            case .monospace: return (§CSSFontFamilyKeyword.Monospace).hashValue
            case .custom(let value) : return value.lowercased().hashValue
            case .defaulted(let defaultingType):
                switch defaultingType {
                    case .Default: return "Default".hashValue
                    case .Inherit: return "Inherit".hashValue
                    case .Initial: return "Initial".hashValue
                    case .Unset: return "Unset".hashValue
                    case .SelectedValue: return "SelectedValue".hashValue
                }
        }
    }
    
    
    func fontFamilyKeywordFromFontFamily() -> DOMString {
        
        switch self {
 
        // genrics font families
        case .serif: return §CSSFontFamilyKeyword.TimesNewRoman
        case .sansSerif: return §CSSFontFamilyKeyword.HelveticaNeue
        case .cursive: return §CSSFontFamilyKeyword.BrushScriptMT
        case .fantasy: return §CSSFontFamilyKeyword.Fantasy
        case .monospace: return §CSSFontFamilyKeyword.CourierNew
        case .custom(let value): return value
        case .defaulted(_): fatalError("Can not deduct font-family value from default value.")
        }
    }
}

public func ==(lhs: CSSFontFamily, rhs: CSSFontFamily) -> Bool {
    
    return lhs.hashValue == rhs.hashValue
}



