//
//  UnsupportedPropertyModule.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-09-04.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common

/// Module responsible for the handling of unsupported properties.
final class UnsupportedPropertyModule: CSSModule {
    
    /// Singleton instance.
    static var shared = UnsupportedPropertyModule()
    
    fileprivate init() {
        
    }
    
    /// When the property is not supported we return a CSSDOMTokenElement that
    /// will directly attach to the CSSDOMPropertyNameElement value has a child.
    /// All other CSSDOMTokenElement are added one by one has child of each other 
    /// to the parent (first) CSSDOMTokenElement.
    func parsePropertyValueToDOM(_ declaration: CSDeclaration, parentPropertyElement: CSSDOMElement )  {
        
        let unsupportedPropertyParser = CSSDOMUnsupportedPropertyParser(componentValueArray: declaration.propertyValueComponentValueList, parentPropertyElement: parentPropertyElement )
        
        unsupportedPropertyParser.parseUnsupportedPropertyValueToDOM()
    }
    
}
