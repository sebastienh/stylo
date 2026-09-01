//
//  CSSStyleSheetContainer.swift
//  Web
//
//  Created by Sebastien hamel on 2015-05-27.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

protocol CSSStyleSheetResourceDocument: Hashable {
    
    var styleSheet: CSSStyleSheet { get }
    
}