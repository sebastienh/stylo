//
//  UserAgent+FontSize.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-23.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common

extension UserAgent : FontSizeConfiguration {
    
    public var mediumFontSizePixelValue: CGFloat {
        
        return 16.0
    }
    
    public var minimumFontSizePixelValue: CGFloat {
    
        return 5.0
    }
    
    public var maximumFontSizePixelValue: CGFloat {
        
        // this value has been deducted fomr Page
        // behaviour
        // FIXME: we must use a dynamic way of doing this since
        // it can change
        return 135.0
    }
    
    public var defaultFontFamily: CSSFontFamily {
        
        return CSSFontFamily.custom(§CSSFontFamilyKeyword.HelveticaNeue)
    }
}
