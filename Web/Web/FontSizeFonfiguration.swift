//
//  FontSizeFonfiguration.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-23.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

public protocol FontSizeConfiguration {
    
    var mediumFontSizePixelValue: CGFloat { get }
    
    var minimumFontSizePixelValue: CGFloat { get }
    
    var maximumFontSizePixelValue: CGFloat { get }
    
    var defaultFontFamily: CSSFontFamily { get }
}
