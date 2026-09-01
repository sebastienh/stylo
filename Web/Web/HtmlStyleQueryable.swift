//
//  HtmlStyleQueryable.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-02-09.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation
import Common

/// In the case of HTML
public protocol HtmlStyleQueryable {
    
    var bodyBackgroundColor: PlateformColorType? { get }
    
    var h1Color: PlateformColorType? { get }
    
    var h2Color: PlateformColorType? { get }
    
}
