//
//  FontFamilyConfiguration.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-27.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

protocol FontFamilyConfiguration: class {
    
    func updateFontFamiliesComponents()
    
    func fontFamilyCodeFromStringArray(_ strings: [String]) -> String?
    
//    func fontFromFontFamilyCode(code: CSSFontFamilyKeyword) -> NSFont 
}
