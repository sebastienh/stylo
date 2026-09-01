//
//  CSSStyleRule.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-21.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common
import os

//http://dev.w3.org/csswg/cssom/#cssstylerule
//interface CSSStyleRule : CSSRule {
//    attribute DOMString selectorText;
//    [SameObject, PutForwards=cssText] readonly attribute CSSStyleDeclaration style;
//};

protocol ICSSStyleRule : ICSSRule {
    
    var selectorText: DOMString { get set }
    
    // FIXME : this should not be optional
    var style: CSSStyleDeclaration? { get }
    
}

public final class CSSStyleRule: CSSRule, ICSSStyleRule, ReplacableChild, StyleRuleIdentifiable {
    
    public override var description: String {
        var representationString = ""
        representationString += selectorText
        representationString += " {\n"
        representationString += style?.description ?? ""
        representationString += "\n}"
        return representationString
    }
    
    public override var descriptionWithPositions: String {
        
        var representationString = ""
        representationString += self.selectorTextWithPositions
        representationString += " {\n"
        representationString += style?.descriptionWithPositions ?? ""
        representationString += "\n}"
        return representationString
    }
    
    private var _selectorText: String?
    
    private var _selectorTextWithPositions: String?
    
    /// attribute DOMString selectorText;
    /// see http://dev.w3.org/csswg/cssom/#dom-cssstylerule-selectortext
    var selectorText: DOMString {
        get {
            if let _selectorText = self._selectorText {
                return _selectorText
            }
            if let selectors = selectorList {
                return selectors.selectorText
            }
            return  ""
        }
        
        set(selectorText) {
            self._selectorText = selectorText
        }
    }
    
    var selectorTextWithPositions: DOMString {
        get {
            if let _selectorTextWithPositions = self._selectorTextWithPositions {
                return _selectorTextWithPositions
            }
            if let selectors = self.selectorList {
                return selectors.selectorTextWithPositions
            }
            return  ""
        }
        
        set(selectorText) {
            self._selectorText = selectorText
        }
    }
    
    /// [SameObject, PutForwards=cssText] readonly attribute CSSStyleDeclaration style;
    /// see http://dev.w3.org/csswg/cssom/#dom-cssstylerule-style
    public var style: CSSStyleDeclaration? {
        didSet {
            updatePosition()
        }
    }
    
    public var selectorList: SelectorList? {
        didSet {
            updatePosition()
        }
    }
    
    public init(styleSheet: CSSStyleSheet) {
    
        super.init(cssText: "", type: CSSRuleType.style_rule, parentStyleSheet: styleSheet)
    }
    
    init(cssText: DOMString, styleSheet: CSSStyleSheet) {
        
        super.init(cssText: cssText, type: CSSRuleType.style_rule, parentStyleSheet: styleSheet)
    }

    override init(cssText: DOMString, type: CSSRuleType, parentStyleSheet: CSSStyleSheet?, parentRule: CSSRule? = nil) {

        super.init(cssText: cssText, type: type, parentStyleSheet: parentStyleSheet, parentRule: parentRule)
    }
    

   public func onlyEditedSelectors(description: SourceStringChangeDescription) -> Bool {
       
       guard let sourceStringFragment = self.selectorList?.sourceStringFragment else {
           assertionFailure("Error: styleRule.selectorList?.sourceStringFragment is nil")
           return false
       }
       
       guard let fragmentRange = sourceStringFragment.range else {
           assertionFailure("Error: fragmentRange is nil")
           return false
       }
       
       guard let relativePosition = description.range.relativePosition(from: fragmentRange) else {
           assertionFailure("Error: relativePosition is nil")
           return false
       }
       
       switch relativePosition {
       case .before:
           assertionFailure("Error: we are supposed to be exclusively inside the rule")
           return true
       case .partiallyBefore: fallthrough
       case .contains: fallthrough
       case .inside:
           return true
       case .partiallyAfter: fallthrough
       case .same: fallthrough
       case .after:
           return false
       }
   }
    
    public func onlyEditedDeclarations(description: SourceStringChangeDescription) -> Bool {
        
        guard let range = self.style?.rangeExcludingCurlyBraces else {
            // it's possible to not have curly brace at the end.
            return false
        }
        
        guard let relativePosition = description.range.relativePosition(from: range) else {
            assertionFailure("Error: relativePosition is nil")
            return false
        }
        
        switch relativePosition {
        case .before:
            return false
        case .partiallyBefore:
            // we may be between the selectors and the style declaration
            // see test: FullStylesheetTexts.testChange5()
            return false
        case .contains: fallthrough
        case .same: fallthrough
        case .inside:
            return true
        case .partiallyAfter: fallthrough
        case .after:
            return false
        }
    }
    
    override func clone(_ parentStyleSheet: CSSStyleSheet?, parentRule: CSSRule? = nil) -> CSSRule {
        
        let styleRuleClone = CSSStyleRule(cssText: self.cssText, type: self.type, parentStyleSheet: parentStyleSheet, parentRule: parentRule)
        
        styleRuleClone.selectorList = self.selectorList?.clone(styleRuleClone)
        styleRuleClone.style = self.style?.clone()
        styleRuleClone.sourceStringFragment = self.sourceStringFragment
        
        return styleRuleClone
    }
    
    public func updatePosition() {
        
        if let style = style {
            
            if let selectorListSegment = selectorList?.sourceStringSegment, let stylePosition = style.sourceStringSegment  {

                self.sourceStringSegment = SourceStringSegment(startIndex: selectorListSegment.startIndex, endIndex: stylePosition.endIndex)
            }
            else if let stylePosition = style.sourceStringSegment {
                    
                self.sourceStringSegment = SourceStringSegment(startIndex: stylePosition.startIndex, endIndex: stylePosition.endIndex)
            }
        }
        else if let selectorList = selectorList {
            
            if let sourceStringSegment = selectorList.sourceStringSegment {
            
                self.sourceStringSegment = sourceStringSegment
            }
        }
        
        #if DEBUG
        if let sourceStringSegment = self.sourceStringSegment {
            sourceStringSegment.validate()
        }
        #endif
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Positionnable protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /// This method translate the position of the fragment using
    // the count from which moving the fragment by adding this count
    // to the start and end index.
    public override func move(_ count: Int) {
        
        self.sourceStringFragment?.move(count)
        
        if let selectorList = selectorList {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("before move selectorList: %@, sourceStringSegment: %@", log: Log.Web.all, type: .info, %%String(describing: selectorList.sourceStringSegment))
            #endif
            
            selectorList.move(count)
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("after move selectorList: %@, sourceStringSegment: %@", log: Log.Web.all, type: .info, %%String(describing: selectorList.sourceStringSegment))
            #endif
        }
        
        if let style = style {
            style.move(count)
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
     
        if let other = other {
        
            if let other = other as? CSSStyleRule {
            
                if !super.equals(to: other, comparePositions: comparePositions) {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: CSSRule are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                if let selfSelectorList = self.selectorList {
   
                    if !selfSelectorList.equals(to: other.selectorList, comparePositions: comparePositions) {
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: selectorList are different.", log: Log.Web.all, type: .debug)
                        #endif
                        return false
                    }
                }
                else {
                    
                    if other.selectorList != nil {
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: other selectorList is not nil.", log: Log.Web.all, type: .debug)
                        #endif
                        return false
                    }
                }
                
                if let style = self.style {
                    
                    if !style.equals(to: other.style, comparePositions: comparePositions) {
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: style are different.", log: Log.Web.all, type: .debug)
                        #endif
                        return false
                    }
                }
                else {
                    
                    if other.style != nil {
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: other style is not nil.", log: Log.Web.all, type: .debug)
                        #endif
                        return false
                    }
                }
            }
            else {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not CSSStyleRule.", log: Log.Web.all, type: .debug)
                #endif
                return false
            }
        }
        else {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Not equals: other is nil.", log: Log.Web.all, type: .debug)
            #endif
            return false
        }
        return true 
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ReplacableChild protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public typealias ReplacableChildNodeType = CSSStyleDeclaration
    
    /// Replace the oldChild with the newChild at the same position
    /// that was taken by the oldChild.
    public func replaceOldChildWithNewChild(_ oldChild: CSSStyleDeclaration, newChild: CSSStyleDeclaration) {
        
        style = newChild
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Compilable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override public var minimalCompilationUnit: CSSOMLanguageObject {
        
        return self
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CommonTreeOperable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias CommonTreeNodeType = CSSStyleDeclaration
    
    func childIndexForChild(_ child: CSSStyleDeclaration) -> Int? {
        
        assert(false, "Missing implementation.")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("childIndexForChild(...) missing implementation.", log: Log.Web.all, type: .error)
        #endif
        return nil
    }
    
    override public func deleteAllChildren() {
        
        self.style = nil
        self.selectorList = nil
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: StyleRuleIdentifiable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    private var _identity: StyleRuleIdentity?
    
    var identity: StyleRuleIdentity {
        
        if let _identity = _identity {
            return _identity
        }
        _identity = StyleRuleIdentity.create(from: self)
        return _identity!
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSSVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override public func accept(_ visitor: CSSVisitor) {
        
        if let nodeInfo = visitor.visit(self) , nodeInfo.visitChildren {
        
            visitor.push(nodeInfo)
        
            if let selectorList = selectorList {

                selectorList.accept(visitor)
            }
        
            if let style = style {
            
                style.accept(visitor)
            }
        
            visitor.pop()
        }
    }
}




