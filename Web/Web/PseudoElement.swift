//
//  PseudoElement.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-05.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import os

///
public final class PseudoElement: Element, RangeResolvable {
    
    public unowned let associatedElement: Element
    
    public override var document: Document! {
        get {
            return associatedElement.document
        }
        set {
            assert(false, "this method should not be called on pseudo-element")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("this method should not be called on pseudo-element", log: Log.Web.all, type: .error)
            #endif
        }
    }
    
    public override var inheritingElement: Element? {
        
        return associatedElement
    }
    
    public init(fragment: SourceStringFragment?, localName: DOMString, associatedElement: Element) {
        self.associatedElement = associatedElement
        super.init(fragment: fragment, document: nil, localName: localName)
        self.namespaceURI = §Namespace.MD
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: RangeResolvable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    /// The method resolve the range of the pseudo-element
    /// and returns the element which ranges which contain this.
    @discardableResult
    public func resolveRange(for string: String, withElement element: Element) -> [NSRange]? {
        
        //assert(sourceStringFragment == nil)
        
        if let pseudoType = PseudoSelectorType(rawValue: self.localName) {
        
            switch pseudoType {
            
            case .FirstLetter:
            
                if let (sourceStringFragment, _) = element.resolveFirstLetterSourceStringSegment(in: string) {
            
                    return sourceStringFragment.ranges
                }
            
    //        case §PseudoElementType.FirstLine:
    //
    //            if let (sourceStringFragment, _) = element.resolveFirstLineSourceStringSegment(in: string) {
    //
    //                return sourceStringFragment.ranges
    //            }
            
            // this is for all markdown pseudo elements
            case .tag: fallthrough
//            case .OpeningTag: fallthrough
//            case .ClosingTag: fallthrough
            case .params: fallthrough
            case .label: fallthrough
            case .Destination: fallthrough
            case .Title: fallthrough
            case .text: fallthrough
            case .AttributeValue: fallthrough
            case .AttributeName: fallthrough
            case .AttributeIndicator: fallthrough
            case .ElementName: fallthrough
            case .NotText: fallthrough
            case .linkText: fallthrough
            case .Content:
                if element.hasPseudoElement(with: self.localName) {
                    return element.pseudoElementSourceStringFragment(with: self.localName)?.ranges
                }
            case .highlight: fallthrough
            case .root: fallthrough
            case .fade: fallthrough
            case .flash: fallthrough
            case .focus:
                assertionFailure("Error: \(pseudoType) is not an pseudo element type, it is a pseudo class")
                return nil
            }
        }
        return nil
    }
}
