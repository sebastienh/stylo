//
//  ConcurentRenderer.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-06-22.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Web
import Common
import os
import NaturalLanguage

fileprivate let zero = NSNumber(value: 0)

protocol ConcurentRenderer: Renderer {

    associatedtype DocumentType: Document
    
    var contentStringLock: ReadWriteLock { get }
    
    var resourceComputedStyle: ComputedStyle { get }
    
    /// This variable is used if the element is the element responsible
    /// for setting the document attributes. In the HTML case it is the "body"
    /// element and in the CSS case it is the "stylesheet" element.
    var documentAttributes: [NSAttributedString.Key : Any]? { get set }
    
    var documentBackgroundColor: PlateformColorType? { get }
    
    var documentCaretColor: PlateformColorType? { get }
    
    var contentString: StylableString { get }
    
    var document: DocumentType { get }
    
    var deletedNodes: ContiguousArray<Node>? { get set }
    
    var renderingType: RenderingType { get }
    
    var stringChange: SourceStringChangeDescription? { get }
    
    var selectionRange: NSRange? { get }
    
    var editedRange: NSRange? { get }
    
    var focusType: FocusType? { get }
    
    var filterContext: FilterContext { get set }
    
    var renderedTopElements: ContiguousArray<Element>?  { get }
    
    var renderingContext: RenderingContext { get }
    
    var isFirstResponder: Bool? { get }

    
    ///
    /// The elements parameter contains the top elements that needs to be
    /// rendered. So implementer of this method should call func accept(...) on each element
    /// and not func acceptSingle(...)
    ///
    
    func paintDocumentElement(element: Element)
    
    func paintTextElement(element: Element, updateType: PaintingUpdateType, attributesOperations: inout AttributesOperations)
    
    func paintPseudoElements(element: Element, updateType: PaintingUpdateType, exclusionRanges: inout [NSRange], attributesOperations: inout AttributesOperations)
    
    func erasePseudoElements(element: Element, exclusionRanges: inout [NSRange], attributesOperations: inout AttributesOperations)
    
    func paragraphApply(attributes: [NSAttributedString.Key : AnyObject]?, to range: NSRange)
    
    func update(attributes: [NSAttributedString.Key : Any]?, in range: NSRange, from element: Element, updateType: PaintingUpdateType, removeBackgroundColor: Bool, attributesOperations: inout AttributesOperations)
    
    func remove(attributes: [NSAttributedString.Key : Any]?, in range: NSRange, from element: Element, attributesOperations: inout AttributesOperations)
    
    func eraseNodes(nodes: ContiguousArray<Node>, attributesOperations: inout AttributesOperations)
    
    func removeFontAttributeIfSame(attributes: inout [NSAttributedString.Key : Any])
    
    func removeBackgroundAttributeIfSame(attributes: inout [NSAttributedString.Key : Any])
    
    func removeBackgroundAttributeIfNecessary(attributes: [NSAttributedString.Key : Any]) -> [NSAttributedString.Key : Any]
    
}

extension ConcurentRenderer {
    
    var isFirstResponder: Bool? {
        return renderingContext.isFirstResponder
    }
    
    var renderingType: RenderingType {
        return renderingContext.renderingType
    }
    
    var stringChange: SourceStringChangeDescription? {
        return renderingContext.stringChangeDescription
    }
    
    var selectionRange: NSRange? {
        return renderingContext.selectionRange
    }
    
    var filterContext: FilterContext {
        return renderingContext.filterContext
    }
    
    var editedRange: NSRange? {
        
        if let selectionRange = self.selectionRange {
            return selectionRange
        }
        else if let stringChange = self.stringChange {
            return stringChange.range
        }
        return nil
    }

    private func pseudoStyle(for pseudoElement: PseudoElement, with element: Element) -> ComputedStyleDeclaration? {
        
        return resourceComputedStyle.computedStyle(forPseudoElement: pseudoElement, withElement: element, filterContext: self.filterContext)
    }
    
    private func style(for element: Element) -> ComputedStyleDeclaration? {
        
        return resourceComputedStyle.computedStyle(forElement: element, filterContext: self.filterContext)
    }
    
    private func attributes(for element: Element) -> [[NSAttributedString.Key: Any]]? {
        
        return resourceComputedStyle.attributes(for: element, filterContext: self.filterContext)
    }
    
    private func pseudoAttributes(for pseudoElement: PseudoElement, withElement element: Element) -> [[NSAttributedString.Key: Any]]? {
    
        return resourceComputedStyle.pseudoAttributes(for: pseudoElement, withElement: element, filterContext: self.filterContext)
    }
    
    /// Method that paint the document element which would be body
    /// in HTML.
    ///
    /// Since the document element will never
    ///
    func paintDocumentElement(element: Element) {
        
        func updateDocumentAttributes(_ attributes: [NSAttributedString.Key: Any]) {
            documentAttributes = attributes
            contentStringLock.withWriteLock {
                contentString.documentAttributes = DocumentAttributes(attrs: attributes)
            }
        }
        
        if let documentAttributes = self.attributes(for: element), !documentAttributes.isEmpty {
            updateDocumentAttributes(documentAttributes.first!)
        }
        else {
            let computedStyle: ComputedStyleDeclaration? = {
                guard let style = self.style(for: element) else {
//                    assertionFailure("Error: style was nil")
                    self.resourceComputedStyle.evaluateEphemeralStyle(for: element, filterContext: self.filterContext)
                    return self.style(for: element)
                }
                return style
            }()
                        
            if let documentAttributes = TextStylizer.shared.textStyle(from: computedStyle, element: element) {
                
                let decorationAttributes = TextStylizer.shared.textDecorationStyle(from: computedStyle, element: element)
                
                if let decorationAttributes = decorationAttributes, documentAttributes.count > 0 {
                    
                    resourceComputedStyle.updateAttributes(for: element, with: documentAttributes, andDecorationAttributes: decorationAttributes, filterContext: self.filterContext)
                    updateDocumentAttributes(documentAttributes)
                }
            }
        }
    }
    
    ///
    /// This method does the painting for the element as would the
    /// normal paintTextElement(...) method except that this method
    /// will consider any ephemeral style that could apply to certain ranges.
    ///
    /// For now the method only supports focus.
    ///
    func paintTextElement(element: Element, updateType: PaintingUpdateType = .add, attributesOperations: inout AttributesOperations) {
    
//        #if DEBUG
//        if self.filterContext.highlightSelectors != nil && self.filterContext.pseudoClassesOptions(forElement: element).isEmpty {
//            assertionFailure("Error: can not have empty pseudo classes options in highlight mode.")
//        }
//        element.logRendering(filterContext: self.filterContext)
//        #endif
        
        var exclusionRanges = [NSRange]()
        
        self.resourceComputedStyle.evaluateEphemeralStyle(for: element, filterContext: self.filterContext)
        paintTextElement(element: element, updateType: updateType, exclusionRanges: &exclusionRanges, attributesOperations: &attributesOperations)
        let pseudoClassesOptions = self.filterContext.pseudoClassesOptions(forElement: element)
        
        if let elementDefaultOptions = element.defaultRenderingOptions(filterContext: self.filterContext) {
            
            self.filterContext.updatePseudoClassesOptions(forElement: element, with: elementDefaultOptions)
            self.resourceComputedStyle.evaluateEphemeralStyle(for: element, filterContext: self.filterContext)
            paintTextElement(element: element, updateType: updateType, exclusionRanges: &exclusionRanges, attributesOperations: &attributesOperations)
            
            // restore old options
            self.filterContext.updatePseudoClassesOptions(forElement: element, with: pseudoClassesOptions)
        }
    }
    
    private func paintTextElement(element: Element, updateType: PaintingUpdateType = .add, exclusionRanges: inout [NSRange], attributesOperations: inout AttributesOperations) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("paintTextElement called for element: %@ with classes: %@", log: Log.WriterCommon.all, type: .info, %%element.localName, %%element.classListString)
        #endif
        
        if let computedStyle = self.style(for: element) {
            
            
            
            
//            #if DEBUG
//            let evaluatedStyle = self.resourceComputedStyle.elementStyle(forElement: element, filterContext: self.filterContext)
//            print("evaluatedStyle: \(evaluatedStyle.)")
//            #endif
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Computing attributes for element: %@", log: Log.WriterCommon.all, type: .info, %%element.localName)
            let textDecorationAttributes = TextStylizer.shared.textDecorationStyle(from: computedStyle, element: element)
            os_log("Computed textDecorationAttributes for element: %@: %@", log: Log.WriterCommon.all, type: .debug, %%element.localName, %%String(describing: textDecorationAttributes))
            #endif
            
            assert(self.documentBackgroundColor != nil)
            let attributes = self.textAttributes(for: element, computedStyle: computedStyle, documentBackgroundColor: self.documentBackgroundColor)
            
            // just making sure
            assert(attributes != nil)
            assert(attributes!.count == 2)
            if let attributes = attributes, attributes.count > 0 {
                
                /// We paint the pseudo-elements after the element to make sure the element
                /// has updated the text decoration attributes before the pseudo-elements
                /// paint themselves.
                paintPseudoElements(element: element, updateType: updateType, exclusionRanges: &exclusionRanges, attributesOperations: &attributesOperations)

                var textAttributes: [NSAttributedString.Key: Any] = attributes.first!!
   
                if let textDecorationAttributes = attributes.last! {
                    textAttributes.merge(textDecorationAttributes) { (first, second) -> Any in
                        assertionFailure("Error: merging should not be necessary!")
                        return first
                    }
                }

                if !textAttributes.isEmpty {
                    
                    // paint childs
                    if element.textChilds.count > 0 {
                        
                        for textChild in element.textChilds {
                            if let sourceStringFragment = textChild.sourceStringFragment {
                                let ranges = sourceStringFragment.ranges
                                
                                if let ephemeralRanges = self.filterContext.ephemeralRanges(forElement: element, fromRanges: ranges) {
                                
                                    for range in ephemeralRanges {
                                        paintRange(range: range, element: element, textAttributes: textAttributes, updateType: updateType, exclusionRanges: &exclusionRanges, attributesOperations: &attributesOperations)
                                    }
                                }
                            }
                        }
                    }
                    
                    // paint tag region
                    if element.hasPseudoElement(with: §PseudoSelectorType.NotText) {
                        
                        let tagFragment = element.pseudoElementSourceStringFragment(with: §PseudoSelectorType.NotText)
                        
                        assert(tagFragment != nil)
                        if let tagFragment = tagFragment {
                            
                            let ranges = tagFragment.ranges
                            
                            // just making sure
                            if ranges.count > 0  {
                                
                                if let ephemeralRanges = self.filterContext.ephemeralRanges(forElement: element, fromRanges: ranges) {
                                
                                    for range in ephemeralRanges {
                                        
                                        paintRange(range: range, element: element, textAttributes: textAttributes, updateType: updateType, exclusionRanges: &exclusionRanges, attributesOperations: &attributesOperations)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func paintRange(range: NSRange, element: Element, textAttributes: [NSAttributedString.Key : Any], updateType: PaintingUpdateType = .add, exclusionRanges: inout [NSRange], attributesOperations: inout AttributesOperations) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Handling range %@ with text value: %@", log: Log.WriterCommon.all, type: .debug, %%range, %%String(describing: contentString.string[range.location..<range.location + range.length]))
        #endif
        
        if !exclusionRanges.isEmpty {
            
            let elementSpecificRanges = rangesMinusImpactedRange(for: element, range: range, exclusionRanges: exclusionRanges)
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("impacted by pseudo...", log: Log.WriterCommon.all, type: .info)
            #endif
            
            for elementSpecificRange in elementSpecificRanges {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("pseudo impacted remaining range: %@ with text value: %@", log: Log.WriterCommon.all, type: .info, %%elementSpecificRange, %%String(describing: contentString.string[elementSpecificRange.location..<elementSpecificRange.location + elementSpecificRange.length]))
                #endif
                
                update(attributes: textAttributes, in: elementSpecificRange, from: element, updateType: updateType, removeBackgroundColor: false, attributesOperations: &attributesOperations)
                recordElementExclusionRange(for: element, range: elementSpecificRange, in: &exclusionRanges)
            }
        }
        else {
            update(attributes: textAttributes, in: range, from: element, updateType: updateType, removeBackgroundColor: false, attributesOperations: &attributesOperations)
            recordElementExclusionRange(for: element, range: range, in: &exclusionRanges)
        }
    }
    
    public func paintPseudoElements(element: Element, updateType: PaintingUpdateType = .add, exclusionRanges: inout [NSRange], attributesOperations: inout AttributesOperations) {
        
        if let pseudoElements = self.resourceComputedStyle.pseudoElements(for: element, filterContext: self.filterContext), !pseudoElements.isEmpty {
            
            for pseudoElement in pseudoElements {
                
                contentStringLock.readLock()
                let pseudoRanges = pseudoElement.resolveRange(for: contentString.string, withElement: element)
                contentStringLock.unlock()
                
                guard let pseudoElementComputedStyle = self.pseudoStyle(for: pseudoElement, with: element) else {
                    assertionFailure("Error: pseudoElementComputedStyle is nil")
                    continue
                }
                
                assert(self.documentBackgroundColor != nil)
                let attributes = self.pseudoTextAttributes(for: pseudoElement, withElement: element, computedStyle: pseudoElementComputedStyle, documentBackgroundColor: self.documentBackgroundColor)
                
                assert(attributes != nil)
                assert(attributes!.count == 2)
                if let attributes = attributes, attributes.count > 0 {
                    
                    let textAttributes = attributes[§ResourceComputedStyle.AttributesType.text]
                    
                    if let pseudoRanges = pseudoRanges, pseudoRanges.count > 0 {
                        
                        if let ephemeralRanges = self.filterContext.ephemeralRanges(forElement: element, fromRanges: pseudoRanges) {
                        
                            for range in ephemeralRanges {
                                
                                let nonImpactedRanges = rangesMinusImpactedRange(for: pseudoElement, range: range, exclusionRanges: exclusionRanges)
                                
                                guard !nonImpactedRanges.isEmpty else {
                                    continue
                                }
                                
                                // here we pass the element and not the pseudo element
                                // since logic in the update method is based on the element
                                // not the associated pseudo-element
                                update(attributes: textAttributes, in: range, from: element, updateType: updateType, attributesOperations: &attributesOperations)
                                recordElementExclusionRange(for: element, range: range, in: &exclusionRanges)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func erasePseudoElements(element: Element, exclusionRanges: inout [NSRange], attributesOperations: inout AttributesOperations) {
        
        if let pseudoElements = resourceComputedStyle.pseudoElements(for: element, filterContext: self.filterContext), !pseudoElements.isEmpty {
            
            for pseudoElement in pseudoElements {
                
                contentStringLock.readLock()
                let pseudoRanges = pseudoElement.resolveRange(for: contentString.string, withElement: element)
                contentStringLock.unlock()
                let pseudoElementComputedStyle = self.pseudoStyle(for: pseudoElement, with: element)
                let textAttributes = TextStylizer.shared.textStyle(from: pseudoElementComputedStyle, element: pseudoElement)
                
                if let textAttributes = textAttributes, textAttributes.count > 0 {
                    
                    if let pseudoRanges = pseudoRanges, pseudoRanges.count > 0 {
                        
                        for range in pseudoRanges {
                            
                            if !exclusionRanges.isEmpty {
                                
                                let elementSpecificRanges = rangesMinusImpactedRange(for: element, range: range, exclusionRanges: exclusionRanges)
                                
                                for elementSpecificRange in elementSpecificRanges {
                                    
                                    remove(attributes: textAttributes, in: elementSpecificRange, from: element, attributesOperations: &attributesOperations)
                                    recordElementExclusionRange(for: element, range: elementSpecificRange, in: &exclusionRanges)
                                }
                            }
                            else {
                                
                                remove(attributes: textAttributes, in: range, from: element, attributesOperations: &attributesOperations)
                                recordElementExclusionRange(for: element, range: range, in: &exclusionRanges)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func paragraphApply(attributes: [NSAttributedString.Key : AnyObject]?, to range: NSRange) {
        
        // http://stackoverflow.com/questions/25007289/swift-editing-uitextview-from-inside-callback-crashes-app
        contentStringLock.withWriteLock {
            if let attributes = attributes, contentString.isValidRange(range) {
                
                // remove backgroundColor attribute if same as background
                let _attributes = removeBackgroundAttributeIfNecessary(attributes: attributes)
                
                contentString.addAttributes(_attributes, range: range)
            }
        }
    }
    
    func update(attributes: [NSAttributedString.Key : Any]?, in range: NSRange, from element: Element, updateType: PaintingUpdateType, removeBackgroundColor: Bool = true, attributesOperations: inout AttributesOperations) {
        
        // http://stackoverflow.com/questions/25007289/swift-editing-uitextview-from-inside-callback-crashes-app
        if var attributes = attributes {
            
            contentStringLock.withReadLock {
                assert(contentString.isValidRange(range))
            }
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("removeBackgroundColor is $$", log: Log.WriterCommon.all, type: .debug, %%removeBackgroundColor)
            #endif
            if removeBackgroundColor {
                
                // remove backgroundColor attribute if same as background
                removeBackgroundAttributeIfSame(attributes: &attributes)
            }
            
            if renderingType != .complete {

                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                contentStringLock.withReadLock {
                    os_log("self.permanentAttributesString.length: %d", log: Log.WriterCommon.all, type: .debug, self.contentString.length)
                    os_log("requested location: %d", log: Log.WriterCommon.all, type: .debug, range.location)
                }
                #endif

                let totalRange = self.totalRange(fromElement: element, range: range)

                // This optimisation must be kept.
                contentStringLock.readLock()
                let differentAttributesRanges = contentString.differentAttributesRanges(in: totalRange, from: attributes)
                contentStringLock.unlock()
                
                if !differentAttributesRanges.isEmpty {

                    for range in differentAttributesRanges {
                        updateDifferentRange(attributes: attributes, in: range, from: element, updateType: updateType, attributesOperation: &attributesOperations)
                    }
                }
                else {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    contentStringLock.withReadLock {
                        assert(contentString.isValidRange(range))
                        os_log("attributes are not different.", log: Log.WriterCommon.all, type: .info)
                        assert(range.location >= 0 && range.location <= contentString.length)
                        os_log("Current attributes: %@", log: Log.WriterCommon.all, type: .info, %%contentString.attributes(at: range.location, effectiveRange: nil))
                        os_log("Tempted new attributes: %@", log: Log.WriterCommon.all, type: .info, %%attributes)
                    }
                    #endif
                }
            }
            else {
                
                let totalRange = self.totalRange(fromElement: element, range: range)
                updateDifferentRange(attributes: attributes, in: totalRange, from: element, updateType: updateType, attributesOperation: &attributesOperations)
            }
        }
        else {
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("there is no attributes.", log: Log.WriterCommon.all, type: .error)
            #endif
        }
    }
    
    func updateDifferentRange(attributes: [NSAttributedString.Key : Any], in range: NSRange, from element: Element, updateType: PaintingUpdateType, attributesOperation: inout AttributesOperations) {
        
        #if false
        if let attributesRecorder = contentString as? AttributedStringChangeRecorder {
            os_log("string attributes before: %@", log: Log.WriterCommon.all, type: .info, %%attributesRecorder.debugAttributesString)
        }
        #endif
        
        switch updateType {
            
        case .add:
            
            contentStringLock.withWriteLock {
                contentString.addAttributes(attributes, range: range)
            }
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Added attributes in range: %@ attributes: %@", log: Log.WriterCommon.all, type: .info, %%range, %%attributes)
            #endif
            attributesOperation.addedAttributes.append(AttributesRange(attributes, range, element.localName))
            
        case .set:
            contentStringLock.withWriteLock {
                contentString.setAttributes(attributes, range: range)
            }
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Added attributes: %@ in range: %@", log: Log.WriterCommon.all, type: .info, %%attributes, %%totalRange)
            #endif
            attributesOperation.setAttributes.append(AttributesRange(attributes, range, element.localName))
        }
        
        #if false
        if let attributesRecorder = contentString as? AttributedStringChangeRecorder {
            os_log("string attributes after: %@", log: Log.WriterCommon.all, type: .info, %%attributesRecorder.debugAttributesString)
        }
        #endif
    }
    
    func removeTextDecorationAttributes(attributes: [NSAttributedString.Key : Any]?, in range: NSRange, from element: Element, attributesOperation: inout AttributesOperations) {
        
        // http://stackoverflow.com/questions/25007289/swift-editing-uitextview-from-inside-callback-crashes-app
        if let attributes = attributes {

            contentStringLock.withWriteLock {
                assert(contentString.isValidRange(range))
                for attribute in attributes {

                    let key = attribute.key
                    if contentString.containsAttribute(key, in:  range) {

                        contentString.removeAttribute(key, range: range)
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Removed attributes: %@ in range: %@", log: Log.WriterCommon.all, type: .info, %%attributes, %%range)
                        #endif
                        attributesOperation.deletedAttributes.append(AttributesRange([attribute.key: attribute.value], range, element.localName))
                    }
                }
            }
        }
        else {
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("there is no attributes.", log: Log.WriterCommon.all, type: .info)
            #endif
        }
    }
    
    func remove(attributes: [NSAttributedString.Key : Any]?, in range: NSRange, from element: Element, attributesOperations: inout AttributesOperations) {
        
        // http://stackoverflow.com/questions/25007289/swift-editing-uitextview-from-inside-callback-crashes-app
        if var attributes = attributes {

            contentStringLock.withReadLock {
                assert(contentString.isValidRange(range))
            }
            
            // remove backgroundColor attribute if same as background
            removeBackgroundAttributeIfSame(attributes: &attributes)
            removeFontAttributeIfSame(attributes: &attributes)

            for attribute in attributes {

                let key = attribute.key

                //                if contentString.containsAttribute(key, in:  range) {
                contentStringLock.withWriteLock {
                    contentString.removeAttribute(key, range: range)
                }
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Removed attributes: %@ in range: %@", log: Log.WriterCommon.all, type: .info, %%attributes, %%range)
                #endif
                attributesOperations.deletedAttributes.append(AttributesRange([attribute.key: attribute.value], range, element.localName))
                //                }
            }
        }
        else {
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("there is no attributes.", log: Log.WriterCommon.all, type: .info)
            #endif
        }
    }
    
    func eraseNodes(nodes: ContiguousArray<Node>, attributesOperations: inout AttributesOperations) {
        
        for node in nodes {
            eraseNode(node: node, attributesOperations: &attributesOperations)
        }
    }
    
    /// Simply remove all the attributes this nodes added to the contentString.
    private func eraseNode(node: Node, attributesOperations: inout AttributesOperations) {
        
        if let element = node as? Element {
            
            var exclusionRanges = [NSRange]()
            
            erasePseudoElements(element: element, exclusionRanges: &exclusionRanges, attributesOperations: &attributesOperations)
            
            let computedStyle = self.style(for: element)
            
            assert(computedStyle != nil)
            if let computedStyle = computedStyle {
                
                let textAttributes = TextStylizer.shared.textStyle(from: computedStyle, element: element)
                
                if let ranges = element.sourceStringFragment?.ranges {
                    
                    // just making sure
                    if let textAttributes = textAttributes, textAttributes.count > 0 && ranges.count > 0  {
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Removing attributes for element named: %@ with classes: %@", log: Log.WriterCommon.all, type: .info, %%element.localName, %%element.classListString)
                        #endif
                        
                        for range in ranges {
                            
                            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                            os_log("Removing attributes in range: %@", log: Log.WriterCommon.all, type: .info, %%NSStringFromRange(range))
                            #endif
                            
                            if !exclusionRanges.isEmpty {
                                
                                let elementSpecificRanges = rangesMinusImpactedRange(for: element, range: range, exclusionRanges: exclusionRanges)
                                
                                for elementSpecificRange in elementSpecificRanges {
                                    
                                    remove(attributes: textAttributes, in: elementSpecificRange, from: element, attributesOperations: &attributesOperations)
                                }
                            }
                            else {
                                remove(attributes: textAttributes, in: range, from: element, attributesOperations: &attributesOperations)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func removeBackgroundAttributeIfSame(attributes: inout [NSAttributedString.Key : Any]) {
        
        if let backgroundColor = attributes[NSAttributedString.Key.backgroundColor] as? PlateformColorType {
            
            guard let documentBackgroundColor = self.documentBackgroundColor else {
                assertionFailure("Error: self.documentBackgroundColor is nil")
                return
            }
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("backgroundColor == documentBackgroundColor: %@", log: Log.WriterCommon.all, type: .info, %%(backgroundColor == documentBackgroundColor))
            #endif
            if backgroundColor == documentBackgroundColor {
                attributes.removeValue(forKey: NSAttributedString.Key.backgroundColor)
            }
        }
    }
    
    func removeFontAttributeIfSame(attributes: inout [NSAttributedString.Key : Any]) {
        
        if let font = attributes[NSAttributedString.Key.font] as? PlateformFontType {
            
            if let documentFont = self.documentAttributes?[NSAttributedString.Key.font] as? PlateformFontType {
                
                if font == documentFont {
                    attributes.removeValue(forKey: NSAttributedString.Key.font)
                }
            }
            else {
                assert(false, "documentAttributes is nil")
            }
        }
    }
    
    func removeBackgroundAttributeIfNecessary(attributes: [NSAttributedString.Key : Any]) -> [NSAttributedString.Key : Any] {
        
        if let backgroundColor = attributes[NSAttributedString.Key.backgroundColor] as? PlateformColorType {
            
            if let documentBackgroundColor = self.documentAttributes?[NSAttributedString.Key.backgroundColor] as? PlateformColorType {
                
                if backgroundColor == documentBackgroundColor {
                    var _attributes = attributes
                    _attributes.removeValue(forKey: NSAttributedString.Key.backgroundColor)
                    return _attributes
                }
            }
            else {
                assert(false, "documentAttributes is nil")
            }
        }
        return attributes
    }
    
    /// Add an entry in the list of impacted elements by pseudo-elements ranges.
    private func recordElementExclusionRange(for element: Element, range: NSRange, in exclusionRanges: inout [NSRange]) {
        
        exclusionRanges.append(range)
    }
    
    private func rangesMinusImpactedRange(for element: Element, range: NSRange, exclusionRanges: [NSRange]) -> [NSRange] {
        
        return range.substractsRanges(exclusionRanges)
    }
    
    ///
    /// This method returns an array of array of attributes:
    /// [text,decoration] each of which might be nil but in practice
    /// only the second might be nil ( in case of permanent only rendering)
    ///
    private func textAttributes(for element: Element, computedStyle: ComputedStyleDeclaration, documentBackgroundColor: PlateformColorType?) -> [[NSAttributedString.Key : Any]?]? {
        
        if let existingTextAttributes = self.attributes(for: element) {
            return existingTextAttributes
        }
        else {
            
            let textAttributes = TextStylizer.shared.textStyle(from: computedStyle, element: element, documentBackgroundColor: documentBackgroundColor)
            
            let decorationAttributes = TextStylizer.shared.textDecorationStyle(from: computedStyle, element: element)
            
            assert(textAttributes != nil)
            assert(decorationAttributes != nil)
            if let textAttributes = textAttributes, let decorationAttributes = decorationAttributes {
                
                resourceComputedStyle.updateAttributes(for: element, with: textAttributes, andDecorationAttributes: decorationAttributes, filterContext: self.filterContext)
                return [textAttributes, decorationAttributes]
            }
        }
        return nil
    }
    
    ///
    /// This method returns an array of array of attributes:
    /// [text,decoration] each of which might be nil but in practice
    /// only the second might be nil ( in case of permanent only rendering)
    ///
    private func pseudoTextAttributes(for pseudoElement: PseudoElement, withElement element: Element, computedStyle: ComputedStyleDeclaration, documentBackgroundColor: PlateformColorType?) -> [[NSAttributedString.Key : Any]?]? {
        
        if let existingTextAttributes = self.pseudoAttributes(for: pseudoElement, withElement: element) {
            return existingTextAttributes
        }
        else {
            
            let textAttributes = TextStylizer.shared.textStyle(from: computedStyle, element: pseudoElement, documentBackgroundColor: documentBackgroundColor)
            
            let decorationAttributes = TextStylizer.shared.textDecorationStyle(from: computedStyle, element: pseudoElement)
            
            assert(textAttributes != nil)
            assert(decorationAttributes != nil)
            if let textAttributes = textAttributes, let decorationAttributes = decorationAttributes {
                
                resourceComputedStyle.updatePseudoAttributes(for: pseudoElement, withElement: element, with: textAttributes, andDecorationAttributes: decorationAttributes, filterContext: self.filterContext)
                return [textAttributes, decorationAttributes]
            }
        }
        return nil
    }
}

