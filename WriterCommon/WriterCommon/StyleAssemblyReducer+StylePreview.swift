//
//  StyleReducer+TextPreviewStyle.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-07-17.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Common
import Web
import os

extension StyleAssemblyReducer {
    
    func createStylePreview(in store: StyleAssemblyStore) {

        switch store.editedLanguage {
        case .CSS:
            createTextStylePreview(in: store)
        case .CCSS:
            createCssStylePreview(in: store)
        default:
            assert(false, "unsupported language")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("unsupported language", log: Log.WriterCommon.all, type: .error)
            #endif
            break
        }
    }

    private func createCssStylePreview(in store: StyleAssemblyStore) {
    
        var backgroundColor: PlateformColorType?
        var propertyNameColor: PlateformColorType?
        var propertyValueColor: PlateformColorType?
        var propertyNameAttributes: [NSAttributedString.Key : Any]?
        
        let cssPreviewStyleElements = createCssPreviewDocumentElements()
        
        assert(cssPreviewStyleElements != nil)
        if let cssPreviewStyleElements = cssPreviewStyleElements {
            
            let filterContext = FilterContext()
            
            let previewDocument = cssPreviewStyleElements[.document] as? Document
            
            assert(previewDocument != nil)
            if let previewDocument = previewDocument, let style = store.style.value {
                
                let resourceComputedStyle = ResourceComputedStyle(styleDefinition: style)
                resourceComputedStyle.computeElementsStyles(document: previewDocument, filterContext: filterContext)
                
                for (elementType, node) in cssPreviewStyleElements {
                    
                    switch elementType {
                        
                    case .propertyName:
                        
                        let element = node as? Element
                        
                        assert(element != nil)
                        if let element = element {
                            
                            if let propertyNameStyle = resourceComputedStyle.computedStyle(forElement:element) {
                                if let value = propertyNameStyle.getCSSPropertyValueContainer(§CSSProperty.color) {
                                    propertyNameColor = value.colorValue().usingColorSpace(NSColorSpace.deviceRGB)
                                }
                                
                                let attributes = TextStylizer.shared.textStyle(from: propertyNameStyle)
                                
                                assert(attributes != nil)
                                if var attributes = attributes {
                                    
                                    attributes.removeValue(forKey: NSAttributedString.Key.foregroundColor)
                                    attributes.removeValue(forKey: NSAttributedString.Key.backgroundColor)
                                    propertyNameAttributes = attributes
                                }
                            }
                        }
                        
                    case .propertyValue:
                        
                        let element = node as? Element
                        
                        assert(element != nil)
                        if let element = element {
                            
                            if let propertyValueStyle = resourceComputedStyle.computedStyle(forElement:element) {
                                if let value = propertyValueStyle.getCSSPropertyValueContainer(§CSSProperty.color) {
                                    propertyValueColor = value.colorValue().usingColorSpace(NSColorSpace.deviceRGB)
                                }
                            }
                        }
                        
                    case .stylesheet:
                        
                        let element = node as? CSSDOMStyleSheetElement
                        
                        assert(element != nil)
                        if let element = element {
                            
                            if let stylesheetStyle = resourceComputedStyle.computedStyle(forElement:element) {
                                if let value = stylesheetStyle.getCSSPropertyValueContainer(§CSSProperty.backgroundColor) {
                                    backgroundColor = value.colorValue().usingColorSpace(NSColorSpace.deviceRGB)
                                }
                            }
                        }
                        
                    case .document:
                        // nothing to do, already handled
                        break
                    }
                }
            }
            
            if let backgroundColor = backgroundColor, let propertyNameColor = propertyNameColor, let propertyValueColor = propertyValueColor, let propertyNameAttributes = propertyNameAttributes {
                
                let cssStylePreview = CssStylePreview(backgroundColor: backgroundColor, propertyNameColor: propertyNameColor, propertyValueColor: propertyValueColor, propertyNameAttributes: propertyNameAttributes)
                store.stylePreview.setValue(cssStylePreview)
            }
        }
    }
    
    private func createTextStylePreview(in store: StyleAssemblyStore) {
        
        let filterContext = FilterContext()
        
        let textPreviewDocumentElements = createTextPreviewDocumentElements()
        var attributesValue = [TextStylePreview.Element: [NSAttributedString.Key : Any]]()
        
        assert(textPreviewDocumentElements != nil)
        if let textPreviewDocumentElements = textPreviewDocumentElements {
            
            let previewDocument = textPreviewDocumentElements.previewDocument
            let elements = textPreviewDocumentElements.elements
            
            if let style = store.style.value {
                
                let resourceComputedStyle = ResourceComputedStyle(styleDefinition: style)
                resourceComputedStyle.computeElementsStyles(document: previewDocument, filterContext: filterContext)
                
                // handle the body, because we want to know the background color
                
                let node = elements[.body]
                
                let bodyElement = node as? Element
                
                var documentBackgroundColor: PlateformColorType?
                
                assert(bodyElement != nil)
                if let bodyElement = bodyElement {
                    
                    if let style = resourceComputedStyle.computedStyle(forElement:bodyElement) {
                        
                        let attributes = TextStylizer.shared.textStyle(from: style)
                        
                        assert(attributes != nil)
                        if let attributes = attributes {
                            
                            attributesValue[.body] = attributes
                            
                            if let backgroundColorValue = attributes[NSAttributedString.Key.backgroundColor] as? PlateformColorType {
                                documentBackgroundColor = backgroundColorValue
                            }
                        }
                    }
                }
                
                for (elementType, node) in elements {
                    
                    let element = node as? Element
                    
                    assert(element != nil)
                    if let element = element {
                        
                        let style = resourceComputedStyle.computedStyle(forElement:element)
                        
                        assert(style != nil)
                        if let style = style {
                            
                            switch elementType {
                                
                            case .body:
                                break
                                
                            default:
                                
                                let attributes = TextStylizer.shared.textStyle(from: style)
                                
                                assert(attributes != nil)
                                if var attributes = attributes {
                                    
                                    if let backgroundColorValue = attributes[NSAttributedString.Key.backgroundColor] as? PlateformColorType {
                                    
                                        if let documentBackgroundColor = documentBackgroundColor, backgroundColorValue == documentBackgroundColor {
                                            attributes.removeValue(forKey: NSAttributedString.Key.backgroundColor)
                                        }
                                    }
                                    attributesValue[elementType] = attributes
                                }
                                
                                if let tagElement = elementType.correspondingTagElement {
                                
                                    if let pseudoElements = resourceComputedStyle.pseudoElements(for: element, filterContext: filterContext), !pseudoElements.isEmpty {
                                        
                                        for pseudoElement in pseudoElements {
                                        
                                            if pseudoElement.localName == §PseudoSelectorType.tag {
                                            
                                                let pseudoElementComputedStyle = resourceComputedStyle.computedStyle(forPseudoElement: pseudoElement, withElement: element)
                                        
                                                let pseudoAttributes = TextStylizer.shared.textStyle(from: pseudoElementComputedStyle)
                                            
                                                assert(pseudoAttributes != nil)
                                                if var pseudoAttributes = pseudoAttributes {
                                                    
                                                    if let backgroundColorValue = pseudoAttributes[NSAttributedString.Key.backgroundColor] as? PlateformColorType {
                                                        
                                                        if let documentBackgroundColor = documentBackgroundColor, backgroundColorValue == documentBackgroundColor {
                                                            pseudoAttributes.removeValue(forKey: NSAttributedString.Key.backgroundColor)
                                                        }
                                                    }
                                                    
                                                    attributesValue[tagElement] = pseudoAttributes
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                let textStylePreview = TextStylePreview(attributesValue: attributesValue)
                store.stylePreview.setValue(textStylePreview)
            }
        }
    }
    
    private func createCssPreviewDocumentElements() -> [CssPreviewStyleElement: Node]? {
        
        var elements = [CssPreviewStyleElement: Node]()
        
        let previewDocument = CSSDOMDocument.Create()
        let stylesheet: CSSDOMStyleSheetElement? = previewDocument.styleSheet
        
        assert(stylesheet != nil)
        if let stylesheet = stylesheet {
            
            elements[.document] = previewDocument
            elements[.stylesheet] = stylesheet
            
            elements[.propertyName] = CSSDOMElement(segment: nil, document: previewDocument, localName: §CSSElementType.PropertyName)
            elements[.propertyValue] = CSSDOMElement(segment: nil, document: previewDocument, localName: §CSSElementType.PropertyValue)
            
            var exception = Exception()
            let propertyName = elements[.propertyName]
            
            assert(propertyName != nil)
            if let propertyName = propertyName {
                stylesheet.appendChild(propertyName, exception: &exception)
                if exception.logIfError() {
                    return nil
                }
            }
            
            let propertyValue = elements[.propertyValue]
            
            assert(propertyValue != nil)
            if let propertyValue = propertyValue {
                stylesheet.appendChild(propertyValue, exception: &exception)
                if exception.logIfError() {
                    return nil
                }
            }
            
            return elements
        }
        return nil
    }
    
    private func createTextPreviewDocumentElements() -> (previewDocument: Document, elements: [TextStylePreview.Element: Node])? {
        
        var elements = [TextStylePreview.Element: Node]()
        
        let previewDocument = HtmlDocument.Create(nil)
        let body: HTMLBodyElement? = previewDocument?.body
        
        assert(previewDocument != nil)
        assert(body != nil)
        if let previewDocument = previewDocument, let body = body {
        
            elements[.body] = body
            elements[.h1] = HTMLHeadingElement(document: previewDocument, localName: "h1")
            elements[.h2] = HTMLHeadingElement(document: previewDocument, localName: "h2")
            elements[.h3] = HTMLHeadingElement(document: previewDocument, localName: "h3")
            elements[.h4] = HTMLHeadingElement(document: previewDocument, localName: "h4")
            elements[.h5] = HTMLHeadingElement(document: previewDocument, localName: "h5")
            elements[.h6] = HTMLHeadingElement(document: previewDocument, localName: "h6")
            elements[.p] = HTMLParagraphElement(document: previewDocument)
            elements[.hr] = HTMLHRElement(document: previewDocument)
            elements[.blockquote] = HTMLQuoteElement(document: previewDocument)
            elements[.code] = HTMLCodeElement(document: previewDocument, isInline: false)
            
            var exception = Exception()
            let h1 = elements[.h1] as? Element
            
            assert(h1 != nil)
            if let h1 = h1 {
                h1.setPseudoElementSourceStringFragment(with: §PseudoSelectorType.tag, to: SourceStringSegment(range: NSMakeRange(0, 1)))
                body.appendChild(h1, exception: &exception)
                if exception.logIfError() {
                    return nil
                }
            }
            
            let h2 = elements[.h2] as? Element
            
            assert(h2 != nil)
            if let h2 = h2 {
                h2.setPseudoElementSourceStringFragment(with: §PseudoSelectorType.tag, to: SourceStringSegment(range: NSMakeRange(0, 2)))
                body.appendChild(h2, exception: &exception)
                if exception.logIfError() {
                    return nil
                }
            }

            let h3 = elements[.h3] as? Element
            
            assert(h3 != nil)
            if let h3 = h3 {
                h3.setPseudoElementSourceStringFragment(with: §PseudoSelectorType.tag, to: SourceStringSegment(range: NSMakeRange(0, 3)))
                body.appendChild(h3, exception: &exception)
                if exception.logIfError() {
                    return nil
                }
            }
            
            let h4 = elements[.h4] as? Element
            
            assert(h4 != nil)
            if let h4 = h4 {
                h4.setPseudoElementSourceStringFragment(with: §PseudoSelectorType.tag, to: SourceStringSegment(range: NSMakeRange(0, 4)))
                body.appendChild(h4, exception: &exception)
                if exception.logIfError() {
                    return nil
                }
            }
            
            let h5 = elements[.h5] as? Element
            
            assert(h5 != nil)
            if let h5 = h5 {
                h5.setPseudoElementSourceStringFragment(with: §PseudoSelectorType.tag, to: SourceStringSegment(range: NSMakeRange(0, 5)))
                body.appendChild(h5, exception: &exception)
                if exception.logIfError() {
                    return nil
                }
            }
            
            let h6 = elements[.h6] as? Element
            
            assert(h6 != nil)
            if let h6 = h6 {
                h6.setPseudoElementSourceStringFragment(with: §PseudoSelectorType.tag, to: SourceStringSegment(range: NSMakeRange(0, 6)))
                body.appendChild(h6, exception: &exception)
                if exception.logIfError() {
                    return nil
                }
            }
            
            let p = elements[.p]
            
            assert(p != nil)
            if let p = p {
                body.appendChild(p, exception: &exception)
                if exception.logIfError() {
                    return nil
                }
            }
            
            let hr = elements[.hr]
            assert(hr != nil)
            if let hr = hr {
                body.appendChild(hr, exception: &exception)
                if exception.logIfError() {
                    return nil
                }
            }
            
            let blockquote = elements[.blockquote]
            assert(blockquote != nil)
            if let blockquote = blockquote {
                body.appendChild(blockquote, exception: &exception)
                if exception.logIfError() {
                    return nil
                }
            }
            
            let code = elements[.code]
            assert(code != nil)
            if let code = code {
                body.appendChild(code, exception: &exception)
                if exception.logIfError() {
                    return nil
                }
            }
            
            return (previewDocument, elements)
        }
        return nil
    }
    
}
