//
//  Element+Rendering.swift
//  Web
//
//  Created by Sebastien Hamel on 2020-10-25.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

extension Element {
    
    public func defaultRenderingOptions(filterContext: FilterContext) -> PseudoClassesOptions? {
        
        let pseudoClassesOptions = filterContext.pseudoClassesOptions(forElement: self)
        var elementDefaultOptions = filterContext.defaultPseudoClassesOptions(forElement: self)
        
        if let focusType = filterContext.focusType, !elementDefaultOptions.isEmpty && elementDefaultOptions != pseudoClassesOptions {
            switch focusType {
            case .bloc: fallthrough
            case .flash:
                return nil
            case .paragraph:
                switch self {
                case is HTMLLIElement:
                    // stylo : #957: in li element case we want
                    // the same behavior as in sentence focus mode:
                    // one line
                    return elementDefaultOptions
                case is HTMLCodeElement: fallthrough
                case is HTMLParagraphElement: fallthrough
                default:
                    return nil
                }
            case .sentence:
                switch self {
                case is HTMLQuoteElement: fallthrough
                case is HTMLLIElement: fallthrough
                case is HTMLParagraphElement:
                    if pseudoClassesOptions.contains(.highlight) {
                        elementDefaultOptions.formUnion(.highlight)
                    }
                case is HTMLCodeElement:
                    // no element below...
                    break
                case let htmlElement as HTMLElement:
                    // we can not draw a part of these elements in focus
                    // and the rest not...
                    if !htmlElement.isBlock {
                       return nil
                    }
                default:
                    break
                }
            
                return elementDefaultOptions
            }
        }
        return nil
    }
    
    public func logRendering(filterContext: FilterContext) {
        
        let pseudoClassesOptions = filterContext.pseudoClassesOptions(forElement: self)
        let defaultOptions = self.defaultRenderingOptions(filterContext: filterContext)
        
        var logString = "\n+++++++++++++++++++++++++++++++\n"
        
        if let markdownElement = self as? MarkdownElement {
            
            logString += "\(markdownElement.localName) text: \(markdownElement.textValue)\n"
            logString += "\(markdownElement.localName) pseudoClassesOptions: \(pseudoClassesOptions)\n"
            logString += "\(markdownElement.localName) defaultOptions: \(defaultOptions)\n"
        }
        if let blockquote = self as? HTMLQuoteElement {

            logString += "blockquote text: \(blockquote.textValue)\n"
            logString += "blockquote pseudoClassesOptions: \(pseudoClassesOptions)\n"
            logString += "blockquote defaultOptions: \(defaultOptions)\n"
        }
        if let ol = self as? HTMLOListElement {

            logString += "ol text: \(ol.textValue)\n"
            logString += "ol pseudoClassesOptions: \(pseudoClassesOptions)\n"

            let focusedRange = filterContext.focusedRange(forElement: ol)
            logString += "ol focusedRange: \(focusedRange)\n"
            logString += "ol defaultOptions: \(defaultOptions)\n"
        }

        if let p = self as? HTMLParagraphElement {

            logString += "p text: \(p.textValue)\n"
            logString += "p pseudoClassesOptions: \(pseudoClassesOptions)\n"

            let focusedRange = filterContext.focusedRange(forElement: p)
            logString += "p focusedRange: \(focusedRange)\n"
            logString += "p defaultOptions: \(defaultOptions)\n"
        }

        if self.localName == "strong" {
            
            logString += "strong text: \(self.textValue)\n"
            logString += "strong pseudoClassesOptions: \(pseudoClassesOptions)\n"
            logString += "strong defaultOptions: \(defaultOptions)\n"
        }

        if let ul = self as? HTMLUListElement {
            
            logString += "ul text: \(ul.textValue)\n"
            logString += "ul pseudoClassesOptions: \(pseudoClassesOptions)\n"

            let focusedRange = filterContext.focusedRange(forElement: ul)
            logString += "ul focusedRange: \(focusedRange)\n"
            logString += "ul defaultOptions: \(defaultOptions)\n"
        }

        if let li = self as? HTMLLIElement {
            
            logString += "li text: \(li.textValue)\n"
            logString += "li pseudoClassesOptions: \(pseudoClassesOptions)\n"

            let focusedRange = filterContext.focusedRange(forElement: li)
            logString += "li focusedRange: \(focusedRange)\n"
            logString += "li defaultOptions: \(defaultOptions)\n"
        }
        
        logString += "+++++++++++++++++++++++++++++++"
        
        print(logString)
    }

    
}
