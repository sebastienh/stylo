//
//  TypeSelectorReverseFilter.swift
//  Web
//
//  Created by Sebastien Hamel on 2020-09-10.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

struct TypeSelectorReverseFilter: ReverseFilter {

    let typeName: String?
    
    let wqNamePrefixValue: WQNamePrefixValue?
    
    func filterSelection(_ selection: SelectorSelection, styleSheet: CSSStyleSheet?, filterContext: FilterContext) -> [SelectorSelection]? {
        
        if let typeName = self.typeName {
            if selection.elementToEvaluate.localName == typeName {
                if isElementInTypeSelectorNamespace(element: selection.elementToEvaluate, styleSheet: styleSheet) {
                    return [selection.create(fromNewElementToEvaluate: selection.elementToEvaluate)]
                }
            }
        }
        else {
            
            if isElementInTypeSelectorNamespace(element: selection.elementToEvaluate, styleSheet: styleSheet) {
                return [selection.create(fromNewElementToEvaluate: selection.elementToEvaluate)]
            }
        }
        return nil
    }
    
    ///
    /// [Namespaces in Elemental Selectors](https://drafts.csswg.org/selectors-4/#type-nmsp)
    ///
    func isElementInTypeSelectorNamespace(element: Element, styleSheet: CSSStyleSheet?) -> Bool {
        
        // Four cases:
        //
        
        // 1. ns|E : elements with name E in namespace ns
        if let wqNamePrefixValue = wqNamePrefixValue, !wqNamePrefixValue.universal && !wqNamePrefixValue.empty {
            
            if let prefixValue = wqNamePrefixValue.prefixValue {
                
                if let namespaceURI = element.namespaceURI {
                    
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
        else if let wqNamePrefixValue = wqNamePrefixValue, wqNamePrefixValue.universal {
            
            return true
        }
            
        // 3. |E : elements with name E without a namespace
        else if let wqNamePrefixValue = wqNamePrefixValue, wqNamePrefixValue.empty {
            
            if let _ = element.namespaceURI {
                return false
            }
            return true
        }
            
        // 4. E : if no default namespace has been declared for selectors, this is equivalent
        // to *|E. Otherwise it is equivalent to ns|E where ns is the default namespace.
        else if wqNamePrefixValue == nil {
            
            if let ns = styleSheet?.defaultNamespace {
                
                if let namespaceURI = element.namespaceURI {
                    
                    if ns == namespaceURI {
                        //
                        return true
                    }
                    return false
                }
                else {
                    // elements with no namespace are rejected
                    return false
                }
            }
                
            // if no default namespace has been declared for selectors, this is equivalent
            // to *|E.
            else {
                return true
            }
        }
        return false
    }
}
