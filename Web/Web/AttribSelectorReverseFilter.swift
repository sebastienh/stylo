//
//  AttribSelectorReverseFilter.swift
//  Web
//
//  Created by Sebastien Hamel on 2020-09-10.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

struct AttribSelectorReverseFilter: ReverseFilter {

    let attribFlags: AttribFlags?
    
    let attribName: AttribName?
    
    let attribMatch: AttribMatch?
    
    let attribValue: AttribValue?
    
    let matchAttributeName: String
    
    func filterSelection(_ selection: SelectorSelection, styleSheet: CSSStyleSheet?, filterContext: FilterContext) -> [SelectorSelection]? {
        
        func getCaseSensitivityValue() -> Bool {
            
            let caseSensitivityFlag: Bool
            
            if let attribFlags = attribFlags {
                
                if attribFlags.ident.rawIdent == "i" {
                    caseSensitivityFlag = true
                }
                else {
                    caseSensitivityFlag = false
                }
            }
            else {
                caseSensitivityFlag = false
            }
            return caseSensitivityFlag
        }
        
        func attributeMacth(_ elementAttributeValue: DOMString, matchValue: DOMString, matchType: MatchType) -> Bool {
            
            switch matchType {
                
                // |=
            //
            case .DashMatch:
                
                let attributeValueParts = elementAttributeValue.explode("-")
                
                for valuePart in attributeValueParts {
                    if matchValue == valuePart {
                        return true
                    }
                }
                return false
                
            // =
            case .EqualMatch:
                
                if elementAttributeValue == matchValue {
                    return true
                }
                return false
                
            // ~=
            // an E element whose foo attribute value is a list of whitespace-separated values,
            // one of which is exactly equal to bar
            case .IncludeMatch:
                
                let attributeValueParts = elementAttributeValue.components(separatedBy: CharacterSet.whitespaces)
                
                for valuePart in attributeValueParts {
                    if matchValue == valuePart {
                        return true
                    }
                }
                return false
                
            // ^=
            case .PrefixMatch:
                
                if elementAttributeValue.hasPrefix(matchValue) {
                    return true
                }
                return false
                
            // *=
            // E[foo*="bar"]
            // an E element whose foo attribute value contains the substring bar
            case .SubstringMatch:
                
                if let _ = elementAttributeValue.range(of: matchValue, options: .regularExpression) {
                    return true
                }
                return false
                
            // $=
            case .SuffixMatch:
                
                if elementAttributeValue.hasSuffix(matchValue) {
                    return true
                }
                return false
                
            }
        }
        
        // make sure we find the requested attribute first...
        let elementAttribute = selection.elementToEvaluate.attributes.getNamedItem(matchAttributeName)
        
        // if we have found one and the element namespace match the attribute name namespace...
        if let elementAttribute = elementAttribute, isAttributeInAttributeNameSelectorNamespace(self.attribName!.wqnamePrefix, attribute: elementAttribute, styleSheet: styleSheet){
            
            let elementAttributeValue = elementAttribute.value
            
            if let attribMatch = self.attribMatch {
                
                if let attributeValue = self.attribValue {
                    
                    if let matchAttributeValue = attributeValue.stringValue {
                        
                        if attributeMacth(elementAttributeValue, matchValue: matchAttributeValue, matchType: attribMatch.matchType) {
                            
                            return [selection.create(fromNewElementToEvaluate: selection.elementToEvaluate)]
                        }
                    }
                }
            }
                // if there is no match we simply want to get the element
                // if the attribute is there, in this case we simply add it
                // to the filtered list of elements.
                // FIXME: Here we "should" also care about case sensitivity
            else {
                
                // we need to call this method (selection.create) always because it will se the matchedElement
                // in case it is needed.
                return [selection.create(fromNewElementToEvaluate: selection.elementToEvaluate)]
            }
        }
        return nil
    }
    
    ///
    /// [Attribute selectors and namespaces](https://drafts.csswg.org/selectors-4/#attrnmsp)
    ///
    func isAttributeInAttributeNameSelectorNamespace(_ wqnamePrefix: WQNamePrefix?, attribute: Attr, styleSheet: CSSStyleSheet?) -> Bool {
        
        // Four cases:
        //
        
        // 1. ns|E : elements with name E in namespace ns
        if let wqnamePrefix = wqnamePrefix, !wqnamePrefix.universal && !wqnamePrefix.empty {
            
            if let prefixValue = wqnamePrefix.prefixValue {
                
                if let namespaceURI = attribute.namespaceURI {
                    
                    if let selectorSelectedNamespace = styleSheet?.namespaceFromPrefix(prefixValue) {
                        
                        if selectorSelectedNamespace == namespaceURI {
                            
                            //
                            return true
                        }
                        return false
                    }
                    else {
                        
                        // we did not find any namespace with this name in the stylesheet
                        return false
                    }
                }
                else {
                    
                    // elements with no namespace are rejected
                    return false
                }
            }
        }
            
            // 2. *|E : elements with name E in any namespace, including those without a namespace
        else if let wqnamePrefix = wqnamePrefix, wqnamePrefix.universal {
            
            return true
        }
            
            // 3. |E : elements with name E without a namespace
        else if let wqnamePrefix = wqnamePrefix, wqnamePrefix.empty {
            
            if attribute.namespaceURI != nil {
                return false
            }
            return true
        }
            
            // 4. In keeping with the Namespaces in the XML recommendation, default namespaces
            // do not apply to attributes, therefore attribute selectors without a namespace
            // component apply only to attributes that have no namespace (equivalent to |attr).
        else if wqnamePrefix == nil {
            
            if attribute.namespaceURI != nil {
                return false
            }
            return true
        }
        return false
    }
    

}
