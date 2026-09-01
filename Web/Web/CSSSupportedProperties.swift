//
//  CSSSupportedPropertiesProtocol.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-16.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

public protocol CSSElementProperties {
    
    ///
    /// Method that use the calculated CSSSupportedPropertyTable to get all
    /// the element supported properties.
    ///
    var supportedProperties: Set<CSSProperty> { get }
    
    ///
    /// Method that use the calculated CSSSupportedPropertyTable to get all
    /// the element temporary supported properties.
    ///
    /// Note: temporary supported properties are properties that can be set using 
    /// the addTemporaryAttribute of NSLayoutManager.
    ///
    var temporarySupportedProperties: Set<CSSProperty> { get }
}
