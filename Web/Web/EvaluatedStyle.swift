//
//  EvaluatedStyle.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-02-14.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation
import Common

class EvaluatedStyle: GetStyleUtils {
    
    private var pseudoElementsStyles: [String: [PseudoClassesOptions: EvaluatedStyle]] = [:]
    
    private(set) var pseudoElements: [PseudoElement] = []
    
    internal let userLevelStyle: RawComputedStyle
    
    internal let userAgentLevelStyle: RawComputedStyle
    
    /// [SameObject] readonly attribute CSSStyleDeclaration cascadedStyle;
    /// see http://dev.w3.org/csswg/cssom/#dom-getstyleutils-cascadedstyle
    let cascadedStyle: RawComputedStyle
    
    /// [SameObject] readonly attribute CSSStyleDeclaration specified value
    /// see http://dev.w3.org/csswg/css-cascade-4/#specified-value
    let specifiedValues: RawComputedStyle
    
    /// [SameObject] readonly attribute CSSStyleDeclaration defaultStyle;
    /// The default style comes from the computed value
    /// see http://dev.w3.org/csswg/cssom/#dom-getstyleutils-defaultstyle
    let defaultStyle: RawComputedStyle
    
    /// [SameObject] readonly attribute CSSStyleDeclaration rawComputedStyle;
    /// see http://dev.w3.org/csswg/cssom/#dom-getstyleutils-rawcomputedstyle
    let rawComputedStyle: RawComputedStyle
    
    //    internal var _usedStyle: CSSStyleDeclaration?
    //
    //    /// [SameObject] readonly attribute CSSStyleDeclaration usedStyle;
    //    /// see http://dev.w3.org/csswg/cssom/#dom-getstyleutils-usedstyle
    let usedStyle: RawComputedStyle
    
    private var _pseudosElement: [String: PseudoElement] = [:]
    
    #if CONCURENT_RENDERING
    private let lock = ReadWriteLock()
    #endif
    
    init() {
        
        self.usedStyle = RawComputedStyle()
        self.defaultStyle = RawComputedStyle()
        self.userAgentLevelStyle = RawComputedStyle()
        self.userLevelStyle = RawComputedStyle()
        self.cascadedStyle = RawComputedStyle()
        self.rawComputedStyle = RawComputedStyle()
        self.specifiedValues = RawComputedStyle()
    }
    
    func hasStyle(forPseudoElementWithName pseudoElementName: String) -> Bool {
        
        #if CONCURENT_RENDERING
        lock.readLock()
        #endif
        let value = self.pseudoElementsStyles[pseudoElementName] != nil
        #if CONCURENT_RENDERING
        lock.unlock()
        #endif
        return value
    }
    
    func pseudoElementStyle(withName name: String, pseudoClassesOptions: PseudoClassesOptions) -> ComputedStyleDeclaration? {
        
        #if CONCURENT_RENDERING
        lock.readLock()
        #endif
        let value = self.pseudoElementsStyles[name]?[pseudoClassesOptions]?.rawComputedStyle
        #if CONCURENT_RENDERING
        lock.unlock()
        #endif
        return value
    }
    
    func setEvaluatedStyle(_ evaluatedStyle: EvaluatedStyle, for pseudo: PseudoElement, pseudoClassesOptions: PseudoClassesOptions) {
        
        #if CONCURENT_RENDERING
        lock.writeLock()
        #endif
        if self.pseudoElementsStyles[pseudo.localName] == nil {
            self.pseudoElementsStyles[pseudo.localName] = [:]
        }
        
        self.pseudoElementsStyles[pseudo.localName]?[pseudoClassesOptions] = evaluatedStyle
        self._pseudosElement[pseudo.localName] = pseudo
        self.upatePseudoElements()
        #if CONCURENT_RENDERING
        lock.unlock()
        #endif
    }
    
    private func upatePseudoElements() {

        self.pseudoElements = _pseudosElement.sorted { (first, second) -> Bool in
            
            guard let firstPseudoType = PseudoSelectorType(rawValue: first.key) else {
                assertionFailure("Error: firstPseudoType is nil")
                return true
            }
            guard let secondPseudoType = PseudoSelectorType(rawValue: second.key) else {
                assertionFailure("Error: secondPseudoType is nil")
                return true
            }
            return firstPseudoType.order < secondPseudoType.order
        }.map { (arg) -> PseudoElement in
            return arg.value
        }
    }
    
}
