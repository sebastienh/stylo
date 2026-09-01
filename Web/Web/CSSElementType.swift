//
//  CSSElementLocalName.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-01-11.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation
import Common

public enum CSSElementType : String, ElementType {

//    case StyleSheet = "style-sheet"
//    case AtKeywork = "at-keywork"
//    case Identifier = "identifier"
    case CSSStyleSheet = "css-style-sheet"
    case Before = "before"
    case After = "after"
    case FirstLine = "first-line"
    case FirstLetter = "first-letter"
    case StyleRule = "css-style-rule"
    case UnrecognizedAtRule = "unrecognized-at-rule"
    case InvalidNamespaceRule = "css-invalid-namespace-rule"
    case NamespaceRule = "css-namespace-rule"
    case NamespacePrefix = "namespace-prefix"
    case NamespaceURI = "namespace-uri"
    case WQNameSelectorPrefix = "wqname-prefix"
    case AtRuleName = "at-rule-name"
    case StyleDeclarationBlock = "style-declaration-block"
    case StyleDeclaration = "declaration-block"
    case IgnoredSimpleBlock = "ignored-block"
    case Declaration = "css-declaration"
    case InvalidDeclaration = "invalid-css-declaration"
    case ImportantDeclaration = "important-declaration"
    case SelectorList = "selector-list"
    case ComplexSelector = "complexe-selector"
    case InvalidComplexSelector = "invalid-complex-selector"
    case CompoundSelector = "compound-selector"
    case PropertyName = "property-name"
    case PropertyValueBlock = "property-value-block"
    case PropertyValue = "property-value"
    case Selection = "selection"
    case Property = "property"
    case Length = "length"
    case Percentage = "percentage"
    
    
    // Function types
    case Function = "function"
    case FunctionStart = "function-start"
    case FunctionParameter = "function-parameter"
    
    case SelectorCombinator = "selector-combinator"
    
    case Id = "id"
    case Class = "class"
    case AttributeName = "attribute-name"
    case AttributeValue = "attribute-value"
    case Attribute = "attribute"
    case AttributeMatch = "attribute-match"
    case AttributeFlags = "attribute-flags"
    case Ident = "ident"
    case HashValue = "hash-value"
    
    case ElementName = "element-name"
    case ClassSelector = "class-selector"
    case IdSelector = "id-selector"
    case InvalidCompoundSelector = "invalid-compound-selector"
    case AttributeSelector = "attribute-selector"
    case TypeSelector = "type-selector"
    case PseudoClassSelector = "pseudo-class-selector"
    case PseudoElementSelector = "pseudo-element-selector"
    case FucntionalPseudoClassSelector = "functional-pseudo-class-selector"
    
    
    case RealNumber = "real-number"
    case IntegerNumber = "integer-number"
    
    
    case Error = "error"
    
    // properties
    case FontFamilyName = "font-family-name"
    case ColorValue = "color-value"
    
    case ColorHash = "color-hash"
    case ColorKeyword = "color-keyword"
    case Token = "css-token"
    
    case FontSizeValue = "font-size-value"
    case FontSizeKeyword = "font-size-keyword"
    case FontSizeLength = "font-size-length"
    case FontSizePercentage = "font-size-percentage"
    
    
    case TextDecorationLineValue = "text-decoration-line-value"
    case TextDecorationLineKeyword = "text-decoration-line-keyword"
    case TextDecorationStyleValue = "text-decoration-style-value"
    
    case FontWeightValue = "font-weight-value"
    case FontStyleValue = "font-style-value"
    
    public var name: String {
        
        return self.rawValue
    }
    
    public var hashValue: Int {
        
        get {
            return self.rawValue.hashValue
        }
    }
    
    public static func allValues() -> [ElementType] {
        
        return [
            CSSElementType.CSSStyleSheet,
//            CSSElementType.Token
        ]
    }
    
}

public func ==(lhs: CSSElementType, rhs: CSSElementType) -> Bool {
    
    return lhs.rawValue == rhs.rawValue
}
