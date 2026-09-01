//
//  PropertyDefinition.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-17.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common

protocol PropertyDefinition: class {
    
    var property: CSSProperty { get }
    
    var type: CSSValueType { get }
    
    var domain: [ElementType] { get }
    
    var inherited: Bool { get }
}
