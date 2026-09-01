//
//  CSSStyleDeclaration.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-21.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common
import QuartzCore
import os

//http://dev.w3.org/csswg/cssom/#cssstyledeclaration
//interface CSSStyleDeclaration {
//    attribute DOMString cssText;
//    readonly attribute unsigned long length;
//    getter DOMString item(unsigned long index);
//    DOMString getPropertySringValue(DOMString property);
//    This function is missing
//    DOMString getPropertyPriority(DOMString property);
//    void setProperty(DOMString property, [TreatNullAs=EmptyString] DOMString value, [TreatNullAs=EmptyString] optional DOMString priority = "");
//    void setPropertyValue(DOMString property, [TreatNullAs=EmptyString] DOMString value);
//    void setPropertyPriority(DOMString property, [TreatNullAs=EmptyString] DOMString priority);
//    DOMString removeProperty(DOMString property);
//    readonly attribute CSSRule? parentRule;
//    [TreatNullAs=EmptyString] attribute DOMString cssFloat;
//};

protocol ICSSStyleDeclaration: class {
    
    var cssText: DOMString { get }
    var parentRule: CSSRule? { get }
}

open class CSSStyleDeclaration: CSSOMLanguageObject, ICSSStyleDeclaration, CustomDebugStringConvertible, CustomStringConvertible, ComputedStyleDeclaration {
    
    public var description: String {
        var representationString = ""
        if propertyStyleDeclarations.count > 0 {
            for (name, declaration) in propertyStyleDeclarations {
                representationString += "\(name): \(declaration.valueString);\n"
            }
        }
        return representationString
    }
    
    public var descriptionWithPositions: String {
        var representationString = ""
        if propertyStyleDeclarations.count > 0 {
            for (name, declaration) in propertyStyleDeclarations {
                representationString += "\(name): \(declaration.valueString)<\(declaration.sourceStringSegment!.stringRepresentation)>;\n"
            }
        }
        return representationString
    }
    
    open var debugDescription: String {
        
        var _debugString = "CSSStyleDeclaration:"

        if properties.count > 0 {
            _debugString += "properties: "
            for (name, value) in properties {
                _debugString += "\(name) : \(value)"
            }
        }
        
        if propertyValues.count > 0 {
            _debugString += "propertyValues: "
            for (name, value) in propertyValues {
                _debugString += "\(name) : \(value)"
            }
        }
        return _debugString
    }
    
    var leftCurlyBrace: Token!
    
    var rightCurlyBrace: Token?
    
    public var styleDeclarationStartIndex: Int? {
        
        return leftCurlyBrace?.startStringIndex
    }
    
    public var rangeExcludingCurlyBraces: NSRange? {
        
        guard let leftCurlyBraceStartIndex = self.leftCurlyBrace?.startStringIndex else {
            assertionFailure("Error: self.leftCurlyBrace is nil")
            return nil
        }
        
        guard let rightCurlyBraceStartIndex = self.rightCurlyBrace?.startStringIndex else {
            // possible see  CssBasicRenderingErrorsTests.testRemoveSecondLeftCurlyBarceFromDoubleCurlyBracesTest()
            return nil
        }
        
        let start = leftCurlyBraceStartIndex+1
        let length = rightCurlyBraceStartIndex-start
        return NSMakeRange(start, length)
    }
    
    /// The cssText attribute must return the result of serializing the declarations.
    var cssText: DOMString {
        
        // TODO : here we need to serialize all the declarations
        // represented by this object
        return ""
    }
    
    var length: Int {

        return properties.count
    }
    
    /// see http://dev.w3.org/csswg/cssom/#dom-cssstyledeclaration-parentrule
    weak var parentRule: CSSRule? {
        didSet {
            self.parent = parentRule
        }
    }
    
    ///
    var properties: [DOMString:DOMString]
    
    /// see http://dev.w3.org/csswg/cssom/#contept_css_declaration_block_parent_css_rule
    var priorities: [DOMString:DOMString]
    
    internal private(set) var propertyStyleDeclarations: [(DOMString, CSDeclaration)]
    
    public subscript(propertyName: String) -> CSDeclaration? {
        get {
            var value: CSDeclaration? = nil
            
            for (_propertyName, _propertyDeclaration) in propertyStyleDeclarations {
                if propertyName == _propertyName {
                    value = _propertyDeclaration
                }
            }
            return  value
        }
    }

    /// Private cssFloat value
    fileprivate var _cssFloat: DOMString?
    
    /// [TreatNullAs=EmptyString]
    /// see http://dev.w3.org/csswg/cssom/#dom-cssstyledeclaration-cssfloat
    var cssFloat: DOMString {
        
        get {
            if _cssFloat == nil {
                return ""
            }
            return _cssFloat!
        }
        
        set(_cssFloat) {
            self._cssFloat = _cssFloat
        }
    }
    /// keep all calculated values
    open var propertyValues: [DOMString: CSSPropertyValueContainer]
    
    /// see CascadingPhaseOrigin
    open var propertyCascadingPhaseOrigins: [DOMString: CascadingPhaseOrigin]
    
    open var allPropertyValuesSpecified: Bool {
        
        if propertyValues.count == 0 {
            return false
        }
        
        for (_, propertyValue) in propertyValues {
            if propertyValue == CSSPropertyValueContainer.none {
                return false
            }
        }
        return true
    }
    
    /// keep all origins
    internal var propertyOrigins: [DOMString: CSSOrigin]

    /// This variable looks at all the properties and if it encounters a 
    /// "display: none" property it returns false (other property may be looked at later). 
    /// It is used in the render tree construction to determine if we need to create
    /// a RenderObject for a specific element.
    open var displayed: Bool {
        
        // FIXME: missing implementation.
//        debugPrint("Should implement the \"displayed\" property.")
        
        return true 
    }
    
    private var ignoredSimpleBlocks: [IgnoredSimpleBlock]
    
    private var invalidDeclarations: [InvalidDeclaration]
    
    public override init(sourceStringSegment: SourceStringSegment?) {
        
        properties = [DOMString: DOMString]()
        priorities = [DOMString: DOMString]()
        propertyStyleDeclarations = [(DOMString, CSDeclaration)]()
        propertyValues = [DOMString: CSSPropertyValueContainer]()
        propertyOrigins = [DOMString: CSSOrigin]()
        propertyCascadingPhaseOrigins = [DOMString: CascadingPhaseOrigin]()
        self.ignoredSimpleBlocks = [IgnoredSimpleBlock]()
        self.invalidDeclarations = [InvalidDeclaration]()
        super.init(sourceStringSegment: sourceStringSegment)
    }
    
    public convenience init(startIndex: Int, endIndex: Int) {
    
        let sourceStringSegment = SourceStringSegment(startIndex: startIndex, endIndex: endIndex)
        
        self.init(sourceStringSegment: sourceStringSegment)
    }
    
    convenience public init() {
        
        self.init(sourceStringSegment: nil)
    }
    
    public func adjustedDeclarationsRange(fromRange declarationsRange: Range<Int>) -> Range<Int> {
        
        // because it can contain -1 and Int.max
        let adjustedDeclarationStart = declarationsRange.lowerBound != -1 ? declarationsRange.lowerBound : 0
        let adjustedDeclarationEnd = declarationsRange.upperBound != Int.max ? declarationsRange.upperBound : self.propertyStyleDeclarations.count
        return adjustedDeclarationStart..<adjustedDeclarationEnd
    }
    
    public func removePropertyDeclarations(inRange range: Range<Int>) {
    
        for _ in range {
            self.propertyStyleDeclarations.remove(at: range.lowerBound)
        }
    }
    
    
    /// Declaration range value method returns the range of
    /// declarations to be recompiled. The range can start at -1
    /// since we could edit inside a style declaration before the first
    /// declaration.
    public func declarationsRange(aroundChangeDescription description: SourceStringChangeDescription) -> Range<Int>?  {
        
        #if DEBUG
        assert(self.allPropertyStyleDeclarationsAreOrdererByPosition())
        #endif
        
        var _lastLowerDeclarationIndexBeforeChangeLowerBound: Int?
        var _lastLowerDeclarationIndexBeforeChangeUpperBound: Int?
        
        let changeRange = description.range
        let propertiesCount = self.propertyStyleDeclarations.count
        
        for  (declarationIndex ,(_, declaration)) in self.propertyStyleDeclarations.enumerated() {

            guard let startDeclarationIndex = declaration.sourceStringSegment?.startIndex else {
                assertionFailure("Error: sourceStringSegment is nil")
                continue
            }
            // we use the endSemiColonToken end index because the declaration
            // ends at the end of the component values before the semo colon.
            guard let endDeclarationIndex = declaration.endSemiColonToken?.endStringIndex else {
                assertionFailure("Error: sourceStringSegment is nil")
                continue
            }
            
            // special case when the change is before all declarations
            if changeRange.upperBound <= startDeclarationIndex && declarationIndex == 0 {
                let lowerBound = -1
                let upperBound = min(2, self.propertyStyleDeclarations.count)
                return lowerBound..<upperBound
            }
            // special case when the change is after all declarations
            if endDeclarationIndex <= changeRange.lowerBound && declarationIndex == propertiesCount-1 {
                let lowerBound = max(0, propertiesCount-2)
                let upperBound = Int.max
                return lowerBound..<upperBound
            }
            
            // if declaration low index is below change lowest index
            if startDeclarationIndex <= changeRange.lowerBound {
                _lastLowerDeclarationIndexBeforeChangeLowerBound = declarationIndex
            }
            
            // if declaration high index is above change
            // we keep only the first one
            if changeRange.upperBound < endDeclarationIndex, _lastLowerDeclarationIndexBeforeChangeUpperBound == nil {
                _lastLowerDeclarationIndexBeforeChangeUpperBound = declarationIndex
                break
            }
        }
        
        guard let lastLowerDeclarationIndexBeforeChangeLowerBound = _lastLowerDeclarationIndexBeforeChangeLowerBound, let lastLowerDeclarationIndexBeforeChangeUpperBound = _lastLowerDeclarationIndexBeforeChangeUpperBound else {
            assertionFailure("Error: not found the declarations")
            return nil
        }
        
        let lowerBound = max(0, lastLowerDeclarationIndexBeforeChangeLowerBound-2)
        let upperBound = min(lastLowerDeclarationIndexBeforeChangeUpperBound+2, self.propertyStyleDeclarations.count)
        return lowerBound..<upperBound
    }

    public func declaration(atIndex index: Int) -> CSDeclaration? {
        
        guard index < self.propertyStyleDeclarations.count else {
            assertionFailure("Error: index out of range")
            return nil
        }
        
        guard index >= 0 else {
            return nil
        }
        
        let (_, declaration) = self.propertyStyleDeclarations[index]
        return declaration
    }

    public func declarationEndStringIndex(atDeclarationIndex index: Int) -> Int? {
        
        guard index < self.propertyStyleDeclarations.count else {
            assertionFailure("Error: index out of range")
            return nil
        }
        
        let (_, declaration) = self.propertyStyleDeclarations[index]
        return declaration.endStringIndex
    }
    
    public func declarationStartIndex(atIndex index: Int) -> Int? {
        
        guard index < self.propertyStyleDeclarations.count else {
            assertionFailure("Error: index out of range")
            return nil
        }
        
        let (_, declaration) = self.propertyStyleDeclarations[index]
        return declaration.startStringIndex
    }
    
    public func nextDeclarationStartIndexAfterDeclaration(atIndex index: Int) -> Int? {
        
        let nextDeclarationIndex = index+1
        
        guard nextDeclarationIndex < self.propertyStyleDeclarations.count else {
            assertionFailure("Error: index out of range")
            return nil
        }
        
        let (_, declaration) = self.propertyStyleDeclarations[nextDeclarationIndex]
        return declaration.startStringIndex
    }
    
    private func allPropertyStyleDeclarationsAreOrdererByPosition() -> Bool {
        var lastFinalPosition = -1
        for  (_, declaration) in self.propertyStyleDeclarations {
            guard let startStringIndex = declaration.startStringIndex else {
                assertionFailure("Error: startStringIndex is nil")
                return false
            }

            if startStringIndex < lastFinalPosition {
                return false
            }
            
            guard let endStringIndex = declaration.endStringIndex else {
                assertionFailure("Error: endStringIndex is nil")
                return false
            }
            
            lastFinalPosition = endStringIndex
        }
        return true
    }
    
    public func clearDeclarationsData() {
        
        self.properties.removeAll(keepingCapacity: true)
        self.priorities.removeAll(keepingCapacity: true)
    }
    
    public func updateDeclarationsData(computePropertyValues: Bool) {
        
        for (_, declaration) in self.propertyStyleDeclarations {
        
            // we compute the property value only if we are asked to do it,
            // since out framework it will most probably be computed by the
            // CSS DOM Creator Visitor, except for Pseudo CSS user agent source files
            // which are not displayed.
            if computePropertyValues {
                
                // compute the property declaration value
                // we don't need to know if it's a supported property
                // since it will be handled by the computeAndSetPropertyValue()
                // method.
                declaration.computeAndSetPropertyValue()
            }
            
            let priority: String = {
                return declaration.importantFlag ? "important" : ""
            }()
                
            self.setProperty(declaration.propertyName,
                value: declaration.valueString, priority: priority)
         
            // set the parent cssstyledeclaration
            declaration.parent = self
        }
    }
    
    public func propertyCascadingPhaseOrigin(forPropertyWithName name: String) -> CascadingPhaseOrigin? {
        
        return propertyCascadingPhaseOrigins[name]
    }
    
    func addIgnoredBlockComponent(simpleBlockComponent: CSSimpleBlockComponentValue) {
        
        let ignoredSimpleBlock = IgnoredSimpleBlock(value: simpleBlockComponent)
        ignoredSimpleBlocks.append(ignoredSimpleBlock)
    }
    
    open func extractLastColor() -> CIColor? {
        
        for (name, declaration) in propertyStyleDeclarations {
            
            if name.equalsIgnoreCase(§CSSProperty.color) {
                return declaration.value?.ciColorValue()
            }
        }
        return nil
    }
    
    public func removeTemporaryDeclarations() {
        
        var declarations: [(DOMString, CSDeclaration)] = []
        for declaration in propertyStyleDeclarations {
            
            if declaration.0 != §CSSProperty.color
            && declaration.0 != §CSSProperty.backgroundColor
            && declaration.0 != §CSSProperty.textDecorationColor
            && declaration.0 != §CSSProperty.textDecorationLine
            && declaration.0 != §CSSProperty.textDecorationStyle {
                declarations.append(declaration)
            }
        }
        
        self.propertyStyleDeclarations = declarations
    }
    
    func clone() -> CSSStyleDeclaration {
        
        let styleDeclarationClone = CSSStyleDeclaration()
        styleDeclarationClone.properties = self.properties
        styleDeclarationClone.priorities = self.priorities
        
        var clonedPropertyValues = [DOMString: CSSPropertyValueContainer]()
        for (key, value) in self.propertyValues {
            clonedPropertyValues[key] = value
        }
        
        styleDeclarationClone.propertyValues = clonedPropertyValues
        
        var ignoredSimpleBlocksClone = [IgnoredSimpleBlock]()
        
        for ignoredSimpleBlock in self.ignoredSimpleBlocks {
            ignoredSimpleBlocksClone.append(ignoredSimpleBlock.clone())
        }
        
        styleDeclarationClone.ignoredSimpleBlocks = ignoredSimpleBlocksClone
        
        for invalidDeclaration in self.invalidDeclarations {   
            styleDeclarationClone.invalidDeclarations.append(invalidDeclaration.clone())
        }
        
//        let propertyValueEvaluator = CSSPropertyEvaluator.shared
        
        for (key, declaration) in propertyStyleDeclarations {
            
            let declarationClone = declaration.clone()
            declarationClone.value = CSSPropertyEvaluator.parsePropertyValue(declaration)
            
            styleDeclarationClone.propertyStyleDeclarations.append((key, declaration.clone()))

            if propertyValues[key] == nil {
                let value = declaration.value
                styleDeclarationClone.propertyValues[key] = value
            }
            else {
                
                let value = self.propertyValues[key]
                styleDeclarationClone.propertyValues[key] = value
            }
        }
        styleDeclarationClone.propertyOrigins = self.propertyOrigins
        styleDeclarationClone.propertyCascadingPhaseOrigins = self.propertyCascadingPhaseOrigins
        return styleDeclarationClone
    }
    
    func item(_ index: Int) -> DOMString? {
        
        var valueIndex: Int = 0
        
        for value in properties.values {
            
            if valueIndex == index {
                return value
            }
            valueIndex += 1
        }
        return nil
    }
    
    func getPropertySringValue(_ property: DOMString) -> DOMString? {
        
        return properties[property]
    }
    
    // FIXME: revisit this method
    func getPropertyPriority(_ property: DOMString) -> DOMString? {
        
        assert(false, "missing implementation.")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("getPropertyPriority(...) missing implementation.", log: Log.Web.all, type: .error)
        #endif
        return nil
    }
    
    /// We use this method to keep the reader information already calculated.
    /// We will use the component values in order to parse the values later on.
    //    func setPropertyComponentValues(property: DOMString, components: [CSComponentValue]) {
    //
    //        componentValues.updateValue(components, forKey: property)
    //
    //    }
    
    public func setCSSPropertyValueContainer(_ propertyName: DOMString, value: CSSPropertyValueContainer) {
        
        propertyValues[propertyName] = value
    }
    
    // [TreatNullAs=EmptyString] DOMString value
    // [TreatNullAs=EmptyString] optional DOMString priority
    func setProperty(_ property: DOMString, value: DOMString , priority: DOMString  = "") {
        
        properties.updateValue(value, forKey: property)
        priorities.updateValue(priority, forKey: property)
    }
    
    // [TreatNullAs=EmptyString] DOMString priority
    func setPropertyPriority(_ propertyName: DOMString , priority: DOMString) {
        
        priorities[propertyName] = priority
    }

    func insertPropertyDeclaration(_ propertyName: DOMString, declaration: CSDeclaration, atIndex index: Int) {
        
        let clone = declaration.clone()
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("declaration parent: %@", log: Log.Web.all, type: .info, String(describing: declaration.parent))
        #endif
        assert(clone.equals(to: declaration, comparePositions: true))
        propertyStyleDeclarations.insert((propertyName, clone), at: index)
    }
    
    
    func appendPropertyDeclaration(_ propertyName: DOMString, declaration: CSDeclaration) {
        
        let clone = declaration.clone()
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("declaration parent: %@", log: Log.Web.all, type: .info, String(describing: declaration.parent))
        #endif
        assert(clone.equals(to: declaration, comparePositions: true))
        propertyStyleDeclarations.append((propertyName, clone))
    }
    
    func addInvalidPropertyDeclaration(_ declaration: InvalidDeclaration) {
        
        let clone = declaration.clone()
        #if DEBUG
        assert(clone.equals(to: declaration, comparePositions: true))
        #endif
        invalidDeclarations.append(clone)
    }
    
    open func getCSSPropertyValueContainer(_ property: DOMString) -> CSSPropertyValueContainer? {
        
        return propertyValues[property]
    }
    
    open func setCSSPropertyValueContainer(_ propertyName: DOMString, value: CSSPropertyValueContainer, cascadingPhase: CascadingPhaseOrigin) {
        
        #if DEBUG
            validatePropertyValueContainer(value, forPropertyName: propertyName)
        #endif
            
        propertyValues[propertyName] = value
        propertyCascadingPhaseOrigins[propertyName] = cascadingPhase
    }
    
    open func setPropertyOrigin(_ propertyName: DOMString, origin: CSSOrigin) {
        
        assert(propertyOrigins[propertyName] == nil, "Overriding existing property origin.")
        
        propertyOrigins[propertyName] = origin
    }
    
    open func getPropertyOrigin(_ propertyName: DOMString) -> CSSOrigin? {
        
        return propertyOrigins[propertyName]
    }
    
    func removeProperty(_ propertyName: DOMString) -> DOMString? {
        
        return properties.removeValue(forKey: propertyName)
    }
    
    func printPropertyValues() {
        
        debugPrint("Property values:")
        
        for (property, propertyValue) in propertyValues {
            
            debugPrint("Property: \(property), property value: \(propertyValue)")
            
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Positionnable protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /// This method translate the position of the fragment using
    // the count from which moving the fragment by adding this count
    // to the start and end index.
    public func move(_ count: Int) {
        
        self.sourceStringFragment?.move(count)
        
        self.leftCurlyBrace.move(count)
        self.rightCurlyBrace?.move(count)
        
        for i in 0..<propertyStyleDeclarations.count {
            
            let (name, styleDeclaration) = propertyStyleDeclarations[i]
            styleDeclaration.move(count)
            
            propertyStyleDeclarations[i] = (name, styleDeclaration)
        }
        
        for i in 0..<ignoredSimpleBlocks.count {
            ignoredSimpleBlocks[i].move(count)
        }
        
        for i in 0..<invalidDeclarations.count {
            invalidDeclarations[i].move(count)
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public func equals(to other: Any?) -> Bool {
        
        return equals(to: other, comparePositions: false)
    }
    
    open override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
    
        if let other = other {
        
            if let other = other as? CSSStyleDeclaration {
            
                if !super.equals(to: other, comparePositions: comparePositions) {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: super are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                if self.length != other.length {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: style declaration lenght is different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                if self.propertyStyleDeclarations.count != other.propertyStyleDeclarations.count {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: property style declarations count is different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                for (index, (_, declaration)) in self.propertyStyleDeclarations.enumerated() {
                    
                    let (_, otherDeclaration) = other.propertyStyleDeclarations[index]
                    
                    if !declaration.equals(to: otherDeclaration, comparePositions: comparePositions) {
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: declarations are different.", log: Log.Web.all, type: .debug)
                        #endif
                        return false
                    }
                }
                
                if self.properties.count != other.properties.count {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: properties.count are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                for key in self.properties.keys {
                    
                    let selfValue = self.properties[key]
                    let otherValue = other.properties[key]
                    
                    if selfValue != otherValue {
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: properties.key are different.", log: Log.Web.all, type: .debug)
                        #endif
                        return false
                    }
                }
                
                if self.propertyCascadingPhaseOrigins.count != other.propertyCascadingPhaseOrigins.count {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: propertyCascadingPhaseOrigins.count are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                for key in self.propertyCascadingPhaseOrigins.keys {
                    
                    let selfValue = self.propertyCascadingPhaseOrigins[key]
                    let otherValue = other.propertyCascadingPhaseOrigins[key]
                    
                    if selfValue != otherValue {
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: propertyCascadingPhaseOrigins.key are different.", log: Log.Web.all, type: .debug)
                        #endif
                        return false
                    }
                }
                
                
                if self.propertyOrigins.count != other.propertyOrigins.count {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: propertyOrigins.count are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                for key in self.propertyOrigins.keys {
                    
                    let selfValue = self.propertyOrigins[key]
                    let otherValue = other.propertyOrigins[key]
                    
                    if selfValue != otherValue {
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: propertyOrigins.key are different.", log: Log.Web.all, type: .debug)
                        #endif
                        return false
                    }
                }
                
                if self.priorities.count != other.priorities.count {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: priorities.count are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                for key in self.priorities.keys {
                    
                    let selfValue = self.priorities[key]
                    let otherValue = other.priorities[key]
                    
                    if selfValue != otherValue {
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: priorities.key are different.", log: Log.Web.all, type: .debug)
                        #endif
                        return false
                    }
                }
                
                if self.ignoredSimpleBlocks.count != other.ignoredSimpleBlocks.count {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: ignoredSimpleBlocks count is different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                for i in 0..<self.ignoredSimpleBlocks.count {
                    
                    let simpleBlock = self.ignoredSimpleBlocks[i]
                    let otherSimpleBlock = other.ignoredSimpleBlocks[i]
                    
                    if !simpleBlock.equals(to: otherSimpleBlock, comparePositions: comparePositions) {
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: otherSimpleBlock element are different.", log: Log.Web.all, type: .debug)
                        #endif
                        return false
                    }
                }
                
                if self.invalidDeclarations.count != other.invalidDeclarations.count {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: invalidDeclarations count is different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                for i in 0..<self.invalidDeclarations.count {
                    
                    let invalidDeclaration = self.invalidDeclarations[i]
                    let otherInvalidDeclaration = other.invalidDeclarations[i]
                    
                    if !invalidDeclaration.equals(to: otherInvalidDeclaration, comparePositions: comparePositions) {
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: invalidDeclaration element are different.", log: Log.Web.all, type: .debug)
                        #endif
                        return false
                    }
                }
            }
            else {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not CSSStyleDeclaration.", log: Log.Web.all, type: .debug)
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
    //                                  MARK: Compilable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override open var minimalCompilationUnit: CSSOMLanguageObject {
        
        return self
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CommonTreeOperable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias ChildNodeType = CSDeclaration
    
    func childIndexForChild(_ child: CSDeclaration) -> Int? {
        
        assert(false, "Missing implementation.")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("childIndexForChild(...) missing implementation.", log: Log.Web.all, type: .error)
        #endif
        return nil
    }
    
    override open func deleteAllChildren() {
        
        properties.removeAll(keepingCapacity: true)
        priorities.removeAll(keepingCapacity: true)
        propertyStyleDeclarations.removeAll(keepingCapacity: true)
        propertyValues.removeAll(keepingCapacity: true)
        propertyOrigins.removeAll(keepingCapacity: true)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSSVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override open func accept(_ visitor: CSSVisitor) {
        
        if let nodeInfo = visitor.visit(self) {
        
            visitor.push(nodeInfo)
        }
        
        for (_ , declaration) in propertyStyleDeclarations {
            
            declaration.accept(visitor)
        }
        
        for ignoredBlock in self.ignoredSimpleBlocks {
            
            ignoredBlock.accept(visitor)
        }
        
        for invalidDeclaration in invalidDeclarations {
            
            invalidDeclaration.accept(visitor)
        }
        
        visitor.pop()
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Private
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    fileprivate func validatePropertyValueContainer(_ value: CSSPropertyValueContainer, forPropertyName propertyName: DOMString) {
     
        if let property = CSSProperty(rawValue: propertyName) {
            
            switch property {
                
            case .caretColor:
                switch value {
                case .customValue: fallthrough
                case .caretColor:
                    break
                case .none:
                    break
                default:
                    assert(false)
                }
                
            case .color:
                
                switch value {
                case .customValue: fallthrough
                case .color:
                    break
                case .none:
                    break
                
                default:
                    assert(false)
                }
                
            case .backgroundColor:
                
                switch value {
                case .customValue: fallthrough
                case .backgroundColor:
                    break
                case .none:
                    break
                default:
                    assert(false)
                }
                
            case .textDecorationColor:
                
                switch value {
                case .customValue: fallthrough
                case .textDecorationColor:
                    break
                case .none:
                    break
                default:
                    assert(false)
                }
                
            case .textDecorationLine:
                
                switch value {
                case .customValue: fallthrough
                case .textDecorationLine:
                    break
                case .none:
                    break
                default:
                    assert(false)
                }
                
            case .textDecorationStyle:
                
                switch value {
                case .customValue: fallthrough
                case .textDecorationStyle:
                    break
                case .none:
                    break
                default:
                    assert(false)
                }
                
            case .fontFamily:
                
                switch value {
                case .customValue: fallthrough
                case .fontFamily(_):
                    break
                case .none:
                    break
                default:
                    assert(false)
                }
                
            case .fontSize:
                
                switch value {
                case .customValue: fallthrough
                case .fontSize(_):
                    break
                case .none:
                    break
                default:
                    assert(false)
                }
                
            case .fontWeight:
                
                switch value {
                case .customValue: fallthrough
                case .fontWeight(_):
                    break
                case .none:
                    break
                default:
                    assert(false)
                }
                
            case .fontStyle:
                
                switch value {
                case .customValue: fallthrough
                case .fontStyle(_):
                    break
                case .none:
                    break
                default:
                    assert(false)
                }
            }
        }
    }
}









