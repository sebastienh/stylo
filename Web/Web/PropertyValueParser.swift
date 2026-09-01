//
//  PropertyValueParser.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-09-18.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

protocol PropertyValueParser: class {
    
    associatedtype PropertyValueType: CSSPropertyValue
    
    /// Method used to parse the property value and append the value to the
    /// property-value DOM element. It doesn't return anything contrary to the
    /// parsePropertyValue() -> CSSPropertyValueContainer? method since it appends the result of
    /// the parsing process to the DOM tree.
    func parsePropertyValueDom()
    
    
    func parsePropertyValue() -> PropertyValueType?
    
}
