//
//  PseudoElementType.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-11.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common

public enum PseudoSelectorType: String {
    
//    case Unsupported = "unsupported"

    // those two are not supported anymore, they are used
    // to insert content.
//    case Before = "before"
//    case After = "after"
//    case FirstLine = "first-line"
    case flash
    case focus
    case fade
    case highlight
    case root
    case FirstLetter = "first-letter"
    case tag
    case AttributeValue = "attr-value"
    case ElementName = "element-name"
    case AttributeName = "attr-name"
    case AttributeIndicator = "attr-indicator"
    case linkText = "link-text"
//    case OpeningTag = "opening-tag"
//    case ClosingTag = "closing-tag"
    case params
    case label
    case text
    case Title = "title"
    case Destination = "destination"
    case NotText = "not-text"
    case Content = "content"
//    case Selection = "selection"
    
    
    var isPseudoElementSelector: Bool {
        
        switch self {
        case .FirstLetter: fallthrough
        case .tag: fallthrough
        case .AttributeValue: fallthrough
        case .ElementName: fallthrough
        case .AttributeName: fallthrough
        case .AttributeIndicator: fallthrough
        case .params: fallthrough
        case .label: fallthrough
        case .text: fallthrough
        case .Title: fallthrough
        case .Destination: fallthrough
        case .NotText: fallthrough
        case .linkText: fallthrough
        case .Content:
            return true
        case .flash: fallthrough
        case .focus: fallthrough
        case .fade: fallthrough
        case .highlight: fallthrough
        case .root:
            return false
        }
    }
    
    var isEphemeral: Bool {
        switch self {
        case .flash: fallthrough
        case .focus: fallthrough
        case .fade:
            return true
        case .highlight: fallthrough
        case .FirstLetter: fallthrough
        case .tag: fallthrough
        case .AttributeValue: fallthrough
        case .ElementName: fallthrough
        case .AttributeName: fallthrough
        case .AttributeIndicator: fallthrough
        case .params: fallthrough
        case .label: fallthrough
        case .text: fallthrough
        case .Title: fallthrough
        case .Destination: fallthrough
        case .NotText: fallthrough
        case .linkText: fallthrough
        case .Content:
            return false
        case .root:
            return false
        }
    }
    
    var order: Int {

        switch self {
//        case .FirstLine:
//            return 5
        case .FirstLetter:
            return 4
        case .tag:
            return 3
//        case .OpeningTag:
//            return 1
//        case .ClosingTag:
//            return 2
        case .params:
            return 6
        case .label:
            return 7
        case .Title:
            return 9
        case .AttributeValue:
            return 10
        case .ElementName:
            return 11
        case .AttributeName:
            return 12
        case .AttributeIndicator:
            return 13
        case .text:
            return 14
        case .Destination:
            return 15
        case .linkText:
            return 16
        case .NotText:
            return 20
        case .Content:
            return 21
        case .focus:
            return 22
        case .flash:
            return 23
        case .highlight:
            return 24
        case .fade:
            return 25
        case .root:
            return 26
        }
    }
    
    var selectorType: RightmostSelectorType {
        
        switch self {
            
//        case .Before: return RightmostSelectorType.generic
//        case .After: return RightmostSelectorType.generic
//        case .FirstLine: return RightmostSelectorType.generic
        case .FirstLetter: return RightmostSelectorType.generic
        case .tag: return RightmostSelectorType.generic
        default: return RightmostSelectorType.pseudoElement(§self)
            
        }
    }
    
    /// A filtering selector can take an element a tell us which 
    /// element to select. This is the case for after and before.
    /// Basically a filtering pseudo element is a kind of symbolic 
    /// link or reference to a real element that's why we can remove it 
    /// once it's filtering job is done.
    var filteringPseudo: Bool {
        
        switch self {
            
//        case .After: return true
//        case .Before: return true
        default: return false
        }
    }
    
    func filter(_ element: Element) -> Element? {
        
        switch self {
            
//        case .After:
//            
//            if let lastElementChild = element.lastElementChild {
//                
//                return lastElementChild
//            }
//            
//            return nil
//            
//        case .Before:
//            
//            if let firstElementChild = element.firstElementChild {
//                
//                return firstElementChild
//            }
//            
//            return nil
            
        default:
            
            debugPrint("Not a filtering pseudo element type")
            return nil
        }
    }
}
