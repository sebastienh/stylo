//
//  UnknownPropertyModule.swift
//  Web
//
//  Created by Sebastien Hamel on 2020-12-14.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Common

/// Module responsible for the handling of unsupported properties.
final class UnknownPropertyModule: CSSModule {
    
    /// Singleton instance.
    static var shared = UnknownPropertyModule()
    
    fileprivate init() {
        
    }
    
    /// When the property is not supported we return a CSSDOMTokenElement that
    /// will directly attach to the CSSDOMPropertyNameElement value has a child.
    /// All other CSSDOMTokenElement are added one by one has child of each other
    /// to the parent (first) CSSDOMTokenElement.
    func parsePropertyValueToDOM(_ declaration: CSDeclaration, parentPropertyElement: CSSDOMElement )  {
        
        let unsupportedPropertyParser = CSSDOMUnknownPropertyParser(componentValueArray: declaration.propertyValueComponentValueList, parentPropertyElement: parentPropertyElement )
        
        unsupportedPropertyParser.parseUnknownPropertyValueToDOM()
    }
    
}
