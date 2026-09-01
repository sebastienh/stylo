//
//  CSSStyleSheet.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-18.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common
import CoreImage
import os

// http://dev.w3.org/csswg/cssom/#the-cssstylesheet-interface
//interface CSSStyleSheet : StyleSheet {
//    readonly attribute CSSRule? ownerRule;
//    [SameObject] readonly attribute CSSRuleList cssRules;
//    unsigned long insertRule(DOMString rule, unsigned long index);
//    void deleteRule(unsigned long index);
//};

public final class CSSStyleSheet: StyleSheet, ReplacableChild, Clonable, CustomStringConvertible {
    
    public var description: String {
        var representationString = ""
        for rule in cssRules {
            representationString += rule.description + "\n\n"
        }
        return representationString
    }
    
    public var descriptionWithPositions: String {
        var representationString = ""
        for rule in cssRules {
            representationString += rule.descriptionWithPositions + "\n\n"
        }
        return representationString
    }
    
    var comments: [CSSToken]?
    
    /// readonly attribute CSSRule? ownerRule;
    /// see http://dev.w3.org/csswg/cssom/#dom-cssstylesheet-ownerrule
    var ownerRule: CSSRule?
    
    /// [SameObject] readonly attribute CSSRuleList cssRules;
    /// see http://dev.w3.org/csswg/cssom/#dom-cssstylesheet-cssrules
    public var cssRules: CSSRuleList
    
    public var origin: CSSOrigin
    
    internal let alternate: Bool
    
    public var sourceString: String = ""
    
    public override var sourceStringSegment: SourceStringSegment? {
        get {
            return cssRules.sourceStringSegment
        }
        set {
            assert(false)
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("trying to set the source string segment of the stylesheet.", log: Log.Web.all, type: .debug)
            #endif
        }
    }
    
    /// private cache for array of following sibling selector's 
    /// top compound selector.
    fileprivate var _followingSiblingSelectorsTopCompoundSelectors: [CompoundSelector]?
    
    /// This dynamic property returns all the following siblings 
    /// top element CompoundSelectorm, the value is cached once calculated.
    public var followingSiblingSelectorsTopCompoundSelectors: [CompoundSelector] {
    
        if _followingSiblingSelectorsTopCompoundSelectors == nil {
            
            let followingSiblingsSelectorsTopElementsVisitor = FollowingSiblingsSelectorsTopElementsVisitor()
            _followingSiblingSelectorsTopCompoundSelectors = followingSiblingsSelectorsTopElementsVisitor.process(self)
        }
        return _followingSiblingSelectorsTopCompoundSelectors!
    }
    
    /// private cache for the contains following sibling selector
    fileprivate var _containFollowingSiblingSelectors: Bool?
    
    /// Return true if the StyleSheet contains at least one 
    /// sibling selector of the next sibling or floowing sibling
    /// kind.
    public var containFollowingSiblingSelectors: Bool {
        
        if _followingSiblingSelectorsTopCompoundSelectors == nil {
            
            let followingSiblingsSelectorsTopElementsVisitor = FollowingSiblingsSelectorsTopElementsVisitor()
            _followingSiblingSelectorsTopCompoundSelectors = followingSiblingsSelectorsTopElementsVisitor.process(self)
        }
        return !_followingSiblingSelectorsTopCompoundSelectors!.isEmpty
    }
    
    /// 
    fileprivate var _nextSiblingSelectorTopCompoundSelectors: [CompoundSelector]?
    
    /// Return the top elements compound selector of nextsibling selectors. 
    public var nextSiblingSelectorTopCompoundSelectors: [CompoundSelector]? {
        
        if _nextSiblingSelectorTopCompoundSelectors == nil {
            
            let nextSiblingSelectorsTopElementsVisitor = NextSiblingSelectorsTopElementsVisitor()
            _nextSiblingSelectorTopCompoundSelectors = nextSiblingSelectorsTopElementsVisitor.process(self)
        }
        return _nextSiblingSelectorTopCompoundSelectors!
    }
    
    /// private cache for the contains next sibling selector
    fileprivate var _containNextSiblingSelectors: Bool?
    
    /// Return true if the StyleSheet contains at least one
    /// sibling selector of the next sibling or floowing sibling
    /// kind.
    public var containNextSiblingSelectors: Bool {
        
        if _nextSiblingSelectorTopCompoundSelectors == nil {
            
            let nextSiblingSelectorsTopElementsVisitor = NextSiblingSelectorsTopElementsVisitor()
            _nextSiblingSelectorTopCompoundSelectors = nextSiblingSelectorsTopElementsVisitor.process(self)
        }
        return !_nextSiblingSelectorTopCompoundSelectors!.isEmpty
    }
    
    /// FIXME: we should handle the case where there is more than one 
    /// default namespace
    
    private var _defaultNamespace: String?
    
    var defaultNamespace: String? {
    
        // we keep a private variable because it seems that the
        // lazy case is not handled well on copy.
        if let _defaultNamespace = self._defaultNamespace {
            if _defaultNamespace.isEmpty {
                return nil
            }
            return _defaultNamespace
        }
        return nil
    }
    
    public var firstSelectorList: SelectorList? {
        guard let styleRule = self.cssRules.first as? CSSStyleRule else {
            assertionFailure("Error: styleRule is nil")
            return nil
        }
        return styleRule.selectorList
    }
    
    public var firstStyleRule: CSSStyleRule? {
        for cssRule in cssRules {
            if let styleRule = cssRule as? CSSStyleRule {
                return styleRule
            }
        }
        return nil
    }
    
    public var lastTopRule: CSSRule? {
        return cssRules.last
    }
    
    public var commentsCount: Int {
        if let comments = comments {
            return comments.count
        }
        return 0
    }
    
    public var declarationsFromFirstRule: [CSDeclaration]? {
        
        guard let firstStyleRule = self.firstStyleRule else {
            assertionFailure("Error: firstStyleRule is nil")
            return nil
        }
        
        guard let styleDeclaration = firstStyleRule.style else {
            assertionFailure("Error: styleDeclaration is nil")
            return nil
        }
        
        
        return styleDeclaration.propertyStyleDeclarations.map { (property) -> CSDeclaration in
            return property.1
        }
    }
    
    convenience public init(origin: CSSOrigin, href: DOMString?) {
        
        // by default the origin a stylesheet is author
        self.init(alternate: false, href: href, origin: origin)
    }

    convenience public init(origin: CSSOrigin) {
        
        // by default the origin a stylesheet is author
        self.init(alternate: false, href: nil, origin: origin)
    }
    
    init(alternate: Bool, href: DOMString?, origin: CSSOrigin = CSSOrigin.author) {
        cssRules = CSSRuleList()
        self.alternate = alternate
        self.origin = origin
        super.init(type: DOMString("text/css"), href: href)
    }
    
    convenience init(ownerRule: CSSRule?, href: DOMString?, ownerNode: Node?, parentStyleSheet: StyleSheet, title: DOMString, disabled: Bool, alternate: Bool = false, origin: CSSOrigin = CSSOrigin.author) {
        self.init(alternate: alternate, href: href, origin: origin)
        self.ownerRule = ownerRule
        cssRules = CSSRuleList()
    }
    
    /// Method that removes all declarations that applies to a temporary
    /// attributes: color, background-color, etc...
    public func removeTemporaryRules() {
        for cssRule in cssRules {
            if let styleRule = cssRule as? CSSStyleRule {
                if let style = styleRule.style {
                    style.removeTemporaryDeclarations()
                }
            }
        }
    }
    
    public func removeComments(in range: Range<Int>) {
        
        var indexesToRemove = [Int]()
        
        if let comments = comments {
        
            for (index, comment) in comments.enumerated() {
         
                if let commentSourceStringSegment = comment.sourceStringSegment {
                
                    if commentSourceStringSegment.isInside(range: range) {
                        indexesToRemove.append(index)
                    }
                }
            }
            
            assert(indexesToRemove.sorted() == indexesToRemove)
            for index in indexesToRemove.reversed() {
                self.comments?.remove(at: index)
            }
        }
    }
    
    public func moveComments(by count: Int) {
        
        if let comments = comments {

            for i in 0..<comments.count {

                assert(comments[i].sourceStringSegment != nil)
                self.comments?[i].move(count)
            }
        }
    }
    
    public func addComments(from otherStylesheet: CSSStyleSheet) {

        if let comments = otherStylesheet.comments {

            self.comments?.append(contentsOf: comments)
        }
    }
    
    func addAllComments(from commentsCollection: [CSSToken]) {

        self.comments?.append(contentsOf: commentsCollection)
    }
    
    public func removeAllComments() {
        
        self.comments?.removeAll(keepingCapacity: true)
    }
    
    public func updateElementIdAttributeSelectorValue(withElementId elementId: String) {
        
        let singleErrorStyleRule = cssRules.last as! CSSStyleRule
        let complexSelector = singleErrorStyleRule.selectorList?[0]
        
        assert(complexSelector != nil)
        if let complexSelector = complexSelector {
        
            let compoundSelector = complexSelector.compoundSelectorList[0]
            let attribSelector = compoundSelector[0] as! AttribSelector
        
            #if DEBUG
            assert(attribSelector.attribName!.stringValue! == §DomAttributeString.ElementId)
            #endif
        
            attribSelector.changeAttributeValueWith(elementId)
        }
        else {
            
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("complexSelector is nil in updateElementIdAttributeSelectorValue.", log: Log.Web.all, type: .error)
            #endif
        }
    }
    
    private func updateDefaultNamespace() {
        
        for cssRule in cssRules {
            // NW-241: We take the first one
            if let namespaceRule = cssRule as? CSSNamespaceRule {
                if namespaceRule.isDefault {
                    let uri = namespaceRule.namespaceURI
                    self._defaultNamespace = uri
                }
            }
        }
        
        _defaultNamespace = ""
    }
    
    // now we need to update the value of the error-id in the attribute selector
    public func updateErrorIdAttributeSelectorValue(withErrorId errorId: String) {
        
        #if DEBUG
            // validate first rule
        if let styleSheetStyleRule = self.firstStyleRule {
                
            let firstRuleComplexSelector = styleSheetStyleRule.selectorList![0]
            let firstRuleCompoundSelector = firstRuleComplexSelector?.compoundSelectorList[0]
            
            assert(firstRuleCompoundSelector != nil)
            if let firstRuleCompoundSelector = firstRuleCompoundSelector {

                let firstRuleTypeSelector = firstRuleCompoundSelector[0] as! TypeSelector
                assert(firstRuleTypeSelector.typeNameString! == "css-style-sheet")
            }
        }
        #endif
        
        for rule in cssRules {
            replaceMessageIdAttribute(in: rule, with: errorId)
        }
    }
    
    private func replaceMessageIdAttribute(in rule: CSSRule, with messageId: String) {
        
        if let styleRule = rule as? CSSStyleRule {
            
            if let complexSelector = styleRule.selectorList?[0] {
                
                if let compoundSelector = complexSelector.compoundSelectorList.first {
                    
                    if let attribSelector = compoundSelector[0] as? AttribSelector {
                        
                        let stringValue = attribSelector.attribName!.stringValue!
                        
                        if attribSelector.attribValue != nil
                            && attribSelector.attribMatch != nil
                            && stringValue == §DomAttributeString.MessageId {
                            
                            attribSelector.changeAttributeValueWith(messageId)
                        }
                    }
                }
            }
        }
    }
    
    /// NW-149
    func namespaceFromPrefix(_ prefixValue: String) -> String? {
        for cssRule in cssRules {
            if let namespaceRule = cssRule as? CSSNamespaceRule {
                if namespaceRule.prefix == prefixValue {
                    return namespaceRule.namespaceURI
                }
            }
        }
        return nil
    }
    
    /// replace the rule at a given index with the specified rule
    public func replaceRule(at index: Int, with rule: CSSRule) {
        
        deleteRule(at: index)
        insertRule(rule, at: index)
        updateDefaultNamespace()
    }
    
    /// unsigned long insertRule(DOMString rule, unsigned long index);
    /// see http://dev.w3.org/csswg/cssom/#dom-cssstylesheet-insertrule
    func insertRule(_ rule: DOMString, index: Int) -> Int {
        
        // TODO : create a basic rule from the rule String

        // return insertRule(rule: CSSRule , index: Int)
        
        fatalError("Missing implementation.")
    }
    
    /// unsigned long insertRule(DOMString rule, unsigned long index);
    /// see http://dev.w3.org/csswg/cssom/#dom-cssstylesheet-insertrule
    @discardableResult
    public func insertRule(_ rule: CSSRule, at index: Int) -> Int {

        willModifyStyleSheet()
        defer {
            didModifyStyleSheet()
        }
        rule.parentStyleSheet = self
        let index = cssRules.addItemAtIndex(rule, index: index)
        updateDefaultNamespace()
        return index
    }
    
    /// unsigned long insertRule(DOMString rule, unsigned long index);
    /// see http://dev.w3.org/csswg/cssom/#dom-cssstylesheet-insertrule
    @discardableResult
    func insertRule(_ rule: CSSRule) -> Int {
        
        willModifyStyleSheet()
        defer {
            didModifyStyleSheet()
        }
        
        rule.parentStyleSheet = self
        cssRules.addItem(rule)
        
        // return the index of the last inserted item
        updateDefaultNamespace()
        return cssRules.length - 1
    }
    
    /// void deleteRule(unsigned long index);
    /// see http://dev.w3.org/csswg/cssom/#dom-cssstylesheet-deleterule
    public func deleteRule(at index: Int) {

        willModifyStyleSheet()
        defer {
            didModifyStyleSheet()
        }
        
        if index < cssRules.length {
            cssRules.deleteRuleAtIndex(index)
        }
        updateDefaultNamespace()
    }
    
    public func replaceAllColorsWith(_ color: CIColor) {
        
        willModifyStyleSheet()
        defer {
            didModifyStyleSheet()
        }
        
        for rule in cssRules {
            
            if let styleRule = rule as? CSSStyleRule {
                if let styleDeclaration = styleRule.style {
                    
                    for (name, declaration) in styleDeclaration.propertyStyleDeclarations {
                        if name.equalsIgnoreCase(§CSSProperty.color) {
                            declaration.value = CSSPropertyValueContainer.color(CSSColor.custom(color))
                        }
                    }
                    
                    for key in styleDeclaration.propertyValues.keys {
                        if key == §CSSProperty.color {
                            styleDeclaration.propertyValues[key] = CSSPropertyValueContainer.color(CSSColor.custom(color))
                        }
                    }
                }
            }
        }
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {

        if let other = other {
        
            if let other = other as? CSSStyleSheet {
            
                if !super.equals(to: other, comparePositions: comparePositions) {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: super are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                if !self.cssRules.equals(to: other.cssRules) {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: cssRules are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                if origin != other.origin {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: origin are different, origin: %@, other origin: %@.", log: Log.Web.all, type: .debug, %%origin, %%other.origin)
                    #endif
                    return false
                }
                
                if self.alternate != other.alternate {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: alternate are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                if let selfDefaultNamepspace = self.defaultNamespace {
                    
                    if let otherDefaultNamepspace = other.defaultNamespace {
                        
                        if selfDefaultNamepspace != otherDefaultNamepspace {
                            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                            os_log("Not equals: defaultNamespace are different.", log: Log.Web.all, type: .debug)
                            #endif
                            return false
                        }
                    }
                    else {
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: other defaultNamespace is nil.", log: Log.Web.all, type: .debug)
                        #endif
                        return false
                    }
                }
                else {
                    if other.defaultNamespace != nil {
                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                        os_log("Not equals: other defaultNamespace is not nil.", log: Log.Web.all, type: .debug)
                        #endif
                        return false
                    }
                }
            }
            else{
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Not equals: other is not CSSStyleSheet.", log: Log.Web.all, type: .debug)
                #endif
                return false
            }
        }
        else {

            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Not equals: other is nil.", log: Log.Web.all, type: .debug)
            #endif
            return false
        }
        return true
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Positionnable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func move(_ count: Int) {
    
        for rule in cssRules {
            
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("before move rule: %@, sourceStringSegment: %@", log: Log.Web.all, type: .info, %%rule.type, %%String(describing: rule.sourceStringSegment))
            #endif
            rule.move(count)
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("after move rule: %@, sourceStringSegment: %@", log: Log.Web.all, type: .info, %%rule.type, %%String(describing: rule.sourceStringSegment))
            #endif
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Clonable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public typealias ClonableType = CSSStyleSheet
    
    public func clone() -> CSSStyleSheet.ClonableType {
    
        let clone = CSSStyleSheet(alternate: alternate, href: href, origin: self.origin)
        clone.title = self.title
        clone.sourceString = self.sourceString
        clone.cssRules = self.cssRules.clone(clone)
        clone.comments = self.comments
        return clone
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ReplacableChild protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public typealias ReplacableChildNodeType = CSSStyleRule
    
    /// Replace the oldChild with the newChild at the same position
    /// that was taken by the oldChild.
    public func replaceOldChildWithNewChild(_ oldChild: CSSStyleRule, newChild: CSSStyleRule) {
        
        replaceRule(oldChild, newRule: newChild)
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
    
    typealias CommonTreeNodeType = CSSRule
    
    func childIndexForChild(_ child: CSSRule) -> Int? {
        
        assert(false, "Missing implementation.")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("childIndexForChild(...) missing implementation.", log: Log.Web.all, type: .error)
        #endif
        return nil
    }
    
    override public func deleteAllChildren() {
        
        willModifyStyleSheet()
        defer {
            didModifyStyleSheet()
        }
        cssRules.deleteAllRules()
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSSVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override public func accept(_ visitor: CSSVisitor) {

        if let nodeInfo = visitor.visit(self), nodeInfo.visitChildren {
        
            visitor.push(nodeInfo)
            
            // the prelude is visited by the selector parser
            // while visiting this node in the upper call to "let nodeInfo = visitor.visit(self)"
            // BUT : in the DotStringVisitor we want to print out the prelude :
            for rule in cssRules {
                
                rule.accept(visitor)
            }
            
            visitor.pop()
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Hashable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override public var hashValue: Int {
        
        // FIXME: Test the proformance of this hash and make sure it is not
        // too slow in critical operations.
        
        return UInt(bitPattern: ObjectIdentifier(self)).hashValue
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Private implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    fileprivate func replaceRule(_ oldRule: CSSRule, newRule: CSSRule) {
        
        willModifyStyleSheet()
        defer {
            didModifyStyleSheet()
        }
        
        var ruleToReplaceIndex: Int?
        
        for (index, rule) in cssRules.rules.enumerated() {
            if rule == oldRule {
                ruleToReplaceIndex = index
            }
        }
        
        if let ruleToReplaceIndex = ruleToReplaceIndex {
            
            cssRules.deleteRuleAtIndex(ruleToReplaceIndex)
            cssRules.addItemAtIndex(newRule, index: ruleToReplaceIndex)
        }
    }
    
    fileprivate func willModifyStyleSheet() {
        
        _containFollowingSiblingSelectors = nil
        _followingSiblingSelectorsTopCompoundSelectors = nil
    }
    
    fileprivate func didModifyStyleSheet() {
        
        // nothing to do
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                  MARK: Equatable protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////

/// Implementation of == required by Equatable
func ==(lhs: CSSStyleSheet, rhs: CSSStyleSheet) -> Bool {

    return lhs.equals(to: rhs)
}


