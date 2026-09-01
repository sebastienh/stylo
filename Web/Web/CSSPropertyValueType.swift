//
//  CSSPropertyValueType.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-17.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

protocol CSSPropertyValueType {
 
    associatedtype PropertyValueType
    
    static func valueFromKeyword(_ string: String) -> PropertyValueType?
    
}
