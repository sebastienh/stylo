//
//  CSSSupportedPropertyTable.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-18.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import os

final class CSSSupportedPropertyTable {

    /// Singleton instance.
    static var shared = CSSSupportedPropertyTable()
    
    /// The supported property key should be composed of 
    /// two things : "<LanguageName><ElementName>"
    var supportedPropertyTable: [CSSSupportedElement : Set<CSSProperty>]

    fileprivate init() {
        
        self.supportedPropertyTable = [CSSSupportedElement : Set<CSSProperty>]()
        self.populateSupportedProperties()
    }
    
    func supportedPropertiesForElement(_ namespace: String, elementName: String) -> Set<CSSProperty> {
        
        let _language = language(for: namespace)
        
        // all properties
        let allElementsSupportedProperty = CSSSupportedElement(languageName: §Language.All, elementName: §CoreDOMElementType.All)
        
        let allElementSupportedProperties = self.supportedPropertyTable[allElementsSupportedProperty]
        
        assert(allElementSupportedProperties != nil, "allElementSupportedProperties is nil.")
        if var allElementSupportedProperties = allElementSupportedProperties {
            
            let elementSpecificSupportedProperty = CSSSupportedElement(languageName: §_language, elementName: elementName)
            
            if let elementSpecificSupportedProperties = supportedPropertyTable[elementSpecificSupportedProperty] {
                allElementSupportedProperties.formUnion(elementSpecificSupportedProperties)
            }
            return allElementSupportedProperties
        }
        else {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("allElementSupportedProperties is nil for element: %@.", log: Log.Web.all, type: .error, %%elementName)
            #endif
        }
        return []
    }
    
    fileprivate func language(for namespaceString: String) -> Language {
        
        if let namespace = Namespace(rawValue: namespaceString) {
        
            switch namespace {
            
                case .CSS: return Language.CSS
                case .HTML: return Language.HTML
                case .MATHML: return Language.HTML
                case .MD: return Language.Markdown
                case .SVG: return Language.All
                case .XLINK: return Language.All
                case .XML: return Language.All
                case .XMLNS: return Language.All
            }
        }
        return Language.All
    }
    
    ///
    /// The only supported property is the Color property for now.
    ///
    func temporarySupportedPropertiesForElement(_ languageName: String, elementName: String) -> Set<CSSProperty> {
        
        ///
        return Set<CSSProperty>(arrayLiteral: CSSProperty.color)
    }
    
    fileprivate func populateSupportedProperties() {
        
        let definitionTable = CSSPropertyDefinitionTable.shared
        
        for (_, propertyDefinition) in definitionTable.propertyDefinitionTable {
            
            for elementType in propertyDefinition.domain {
                
                let language: Language
                if let _ = elementType as? CoreDOMElementType {
                    language = Language.All
                }
                else if let _ = elementType as? CSSElementType {
                    language = Language.CSS
                }
                else {
                    
                    language = Language.All
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("ElementType: %@ not supported in CSSSupportedPropertyTable", log: Log.Web.all, type: .error, %%elementType)
                    #endif
                }
                
                let supportedProperty = CSSSupportedElement(languageName: §language, elementName: elementType.name)
                
                if let _ = supportedPropertyTable.index(forKey: supportedProperty) {
                    supportedPropertyTable[supportedProperty]!.insert(propertyDefinition.property)
                }
                else {
                    supportedPropertyTable[supportedProperty] = Set<CSSProperty>()
                    supportedPropertyTable[supportedProperty]!.insert(propertyDefinition.property)
                }
            }
        }
    }
}
