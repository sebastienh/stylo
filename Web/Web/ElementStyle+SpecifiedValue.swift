//
//  ElementStyle+SpecifiedValue.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-01-15.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation
import Common
import os

extension String {
    var isCustomPropertyName: Bool {
        return self.starts(with: "--")
    }
}

extension ElementStyle {
    
    private var inheritingElement: Element? {
        
        guard let associatedElement = associatedElement else {
            assertionFailure("Error: associatedElement is nil")
            return nil
        }
        
        // The inheriting element is the parent element in the element case.
        return associatedElement.inheritingElement
    }
    
    /// Compute the specifed values for each supported property
    /// of the element.
    ///
    /// A specified value can be relative or absolute but any defaulting
    /// has been resolved at this stage.
    ///
    /// > The computed value is the result of resolving the specified value
    /// > as defined in the “Computed Value” line of the property definition
    /// > table, generally absolutizing it in preparation for inheritance.
    ///
    /// see http://dev.w3.org/csswg/css-cascade-4/#specified-value
    func computeSpecifiedValues(filterContext: FilterContext) {
        
        if !specifiedValues.allPropertyValuesSpecified {
            
            let propertyDefinitionTable = CSSPropertyDefinitionTable.shared
            
            // here we need the dependency graph. This dependencies graph will
            // allow me to compute the value for each custom property.
            // [css-variables](https://drafts.csswg.org/css-variables/#cycles)
                
            // if we have nothing here it means we have no locally defined custom property.
            // so we dont need to resolve anything
            guard let directedDependencyGraph = self.cascadedStyle.localPropertiesDirectedDependencyGraph else {
                return
            }
            
            let (insideCycle, outsideCycle) = self.cascadedStyle.customPropertiesInsideOutsideCycles(fromdirectedDependencyGraph: directedDependencyGraph)
            
            // this is for all local custom properties
            // like
            // ``` css
            //      --custom-property: blue;
            //      --other-custom-property: var(--property, defaultValue);
            // ```
            resolveCustomPropertiesDefinitionsComponentValues(localPropertiesDirectedDependencyGraph: directedDependencyGraph, insideCycle: insideCycle, outsideCycle: outsideCycle, filterContext: filterContext)
            
            for (propertyName, cascadedValue) in cascadedStyle.propertyValues {
                
                // we dont evaluate here the value of custom properties because
                // at this point we dont know what type it should resolve to. We will know
                // this at resolve time (below) for the property that use this
                // custom property. But at this stage we must resolve all the
                // var(...) that are contained here from inheriting elements.
                if let property = CSSProperty(rawValue: propertyName) {
                    
                    let value: CSSPropertyValueContainer = {
                        if cascadedValue.isUnresolvedCustomValueProperty {
                            
                            // this is for all properties that use custom properties
                            // like
                            // ``` css
                            //      color: var(--custom-color);
                            // ```
                            // at this point all custom property dependencies
                            // have been resolved.
                            guard !insideCycle.contains(propertyName) else {
                                return CSSPropertyValueContainer.error
                            }
                            return resolveVarFunctionPropertyValue(property: property, fromValueContainer: cascadedValue, filterContext: filterContext)
                        }
                        return cascadedValue
                    }()
                    
                    // if cascaded value is nil we need to resort to default or inherit
                    // value to get the value.
                    switch value {
                    case .unsupported:
                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                        os_log("Associated value for property: %@ is error.", log: Log.Web.all, type: .error, %%(§property))
                        #endif
                        
                    case .error: fallthrough
                    case .none:
                        
                        // could be inherit or initial case :
                        if propertyDefinitionTable.isInheritedProperty(property) {
                            
                            let inheritedPropertyValue = inheritedValue(property, filterContext: filterContext)
                            
                            assert(!inheritedPropertyValue.isRelative(), "Inherited value can not be relative.")
                            
                            specifiedValues.setCSSPropertyValueContainer(§property, value: inheritedPropertyValue, cascadingPhase: .inherited)
                        }
                        else {
                            
                            specifiedValues.setCSSPropertyValueContainer(§property, value: propertyDefinitionTable.initialValueForProperty(property), cascadingPhase: .defaulted)
                        }
                        
                    default:
                        
                        assert(!value.isUnresolvedCustomValueProperty, "Error: isUnresolvedCustomProperty should have been handled at this point")
                        if cascadedValue.isExplicitlyDefaulting() {
                            
                            guard let resolvedDefault = computeExplicitDefaultingValue(property, defaultingType: value.defaultingType(), filterContext: filterContext) else {
                                assertionFailure("Error: resolvedDefault is nil")
                                specifiedValues.setCSSPropertyValueContainer(§property, value: propertyDefinitionTable.initialValueForProperty(property), cascadingPhase: .defaulted)
                                continue
                            }
                            
                            // here we assign cascaded because the value, even if it's a default one
                            // has been defined by the user explicitely for this property
                            specifiedValues.setCSSPropertyValueContainer(propertyName, value: resolvedDefault, cascadingPhase: .cascaded)
                        }
                        else {
                            specifiedValues.setCSSPropertyValueContainer(propertyName, value: value, cascadingPhase: .cascaded)
                        }
                    }
                }
                else if !propertyName.isCustomPropertyName {
                    
                    assert(false, "Property: \(propertyName) not supported.")
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("Property: %@ not supported.", log: Log.Web.all, type: .error, %%propertyName)
                    #endif
                }
            }
            
            #if DEBUG
                
                // validate all values are filled
                for (_, value) in specifiedValues.propertyValues {
                    
                    switch value {
                        
                    case .none:
                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                        os_log("None value found after computeSpecifiedValues() method executed.", log: Log.Web.all, type: .error)
                        #endif
                        
                    default:
                        break
                    }
                }
            #endif
        }
    }
    
    ///
    /// Method that tries to get the value from the parent cascaded value
    /// until the parent is reached in which case the initial value is returned.
    /// see http://dev.w3.org/csswg/css-cascade-4/#inheriting
    ///
    func inheritedValue(_ property: CSSProperty, filterContext: FilterContext) -> CSSPropertyValueContainer {
        
        // The inheriting element is the parent element in the element case.
        guard let inheritingElementStyle = self.inheritingElementStyle(filterContext: filterContext) else {
            return CSSPropertyDefinitionTable.shared.initialValueForProperty(property)
        }
                
        guard let inheritedValue = inheritingElementStyle.rawComputedStyle.getCSSPropertyValueContainer(§property) else {
            return CSSPropertyDefinitionTable.shared.initialValueForProperty(property)
        }
        
        return inheritedValue
    }
    
    ///
    /// We have a different function for custom property inherited value because
    /// we are not garanteed to find it in the parent and we may need
    /// recursively call it for inheriting parent.
    ///
    func inheritedCustomPropertyValueComponents(_ customProperty: String, filterContext: FilterContext) -> [CSComponentValue]?  {
        
        guard let inheritingElementStyle = self.inheritingElementStyle(filterContext: filterContext) else {
            return CSSPropertyDefinitionTable.shared.initialValueForProperty(customProperty).resolvedComponentsValues
        }
        
        return inheritingElementStyle.valueComponents(forCustomProperty: customProperty, filterContext: filterContext)
    }
    
    private func inheritingElementStyle(filterContext: FilterContext) -> ElementStyle? {
        
        return self.inheritingElementStyle
        
        // The inheriting element is the parent element in the element case.
//        guard let inheritingElement = self.inheritingElement else {
//            return nil
//        }
//
//        return resourceComputedStyle.elementStyle(forElement: inheritingElement, filterContext: filterContext)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///                                  MARK: Private methods
    //////////////////////////////////////////////////////////////////////////////////////////////////////////

    ///
    /// This method will resolve all custom properties to
    /// a CSSPropertyValueContainer.resolvedCustom with their
    /// corresponding component values. These component values
    /// will then be usable in resolveCustomPropertyValue(...)
    /// method.
    ///
    /// This method resolves the custom element component valus. We are in the
    /// compute value phase and are going down the tree meaning that
    /// at this point all custom properties from the inherited parent
    /// elments have been resolved to their components values.
    ///
    /// In this method we also take care of self references:
    ///
    /// ``` css
    ///     :root {
    ///         --main-color: #c06;
    ///         --accent-background: linear-gradient(to top, var(--main-color), white);
    ///     }
    /// ```
    ///
    /// Cycle detection: This function should handle the resolution of cycle detection
    /// rendering effectively the custom property to its guaranteed invalid value.
    ///
    /// Default value: And defaults should also be handled here if a resolved main value
    /// endup being the guaranteed invalid value and this default value is defined.
    ///
    private func resolveCustomPropertiesDefinitionsComponentValues(localPropertiesDirectedDependencyGraph: [String: DependencyNode]?, insideCycle: Set<String>, outsideCycle: Set<String>, filterContext: FilterContext) {
        
        guard let localPropertiesDirectedDependencyGraph = localPropertiesDirectedDependencyGraph else {
            // if the localPropertiesDirectedDependencyGraph is nil or empty
            // it means there is nothing to resolve.
            return
        }
        
        guard !localPropertiesDirectedDependencyGraph.isEmpty else {
            // if the localPropertiesDirectedDependencyGraph is nil or empty
            // it means there is nothing to resolve.
            return
        }
        
        assignGaranteedInvalidValue(toCustomProperties: insideCycle)
        assignValidComponentValues(toCustomProperties: outsideCycle, directedDependencyGraph: localPropertiesDirectedDependencyGraph, filterContext: filterContext)
    }
    
    ///
    /// This method calls assignValidComponentValues(...) for all the custom properties in
    /// customProperties set.
    ///
    private func assignValidComponentValues(toCustomProperties customProperties: Set<String>, directedDependencyGraph: [String: DependencyNode], filterContext: FilterContext) {
    
        for customProperty in customProperties {
            if customProperty.isCustomPropertyName {
                assignValidComponentValues(toCustomProperty: customProperty, directedDependencyGraph: directedDependencyGraph, filterContext: filterContext)
            }
        }
    }
    
    ///
    /// This method resovle all the component values that should
    /// pertain to a custom property. We are in the situation:
    ///
    /// ``` css
    ///     --custom-property: var(--other);
    /// ```
    /// and we want the `--custom-property` value to be populated with
    /// all component values necessary to resolve its value when
    /// we know the type we want.
    ///
    private func assignValidComponentValues(toCustomProperty customProperty: String, directedDependencyGraph: [String: DependencyNode], filterContext: FilterContext) {
    
        var evaluationStack = buildPropertiesEvaluationStack(forCustomProperty: customProperty, using: directedDependencyGraph)
        
        while !evaluationStack.isEmpty {
            
            let localCustomProperty = evaluationStack.pop()
            
            guard let customPropertyValue = self.cascadedStyle.propertyValues[localCustomProperty] else {
                assertionFailure("Error: customPropertyValue is nil")
                continue
            }
            
            if !customPropertyValue.isResolvedComponentValuesCustomProperty {
                resolveComponentValues(forLocalCustomProperty: localCustomProperty, filterContext: filterContext)
            }
        }
    }
    
    ///
    /// This method is the final method that resolve a local custom property
    /// components values. At this point all local dependencies have been
    /// resolved already and we may depend on inherited custom properties
    /// but them also, should have been resolved.
    ///
    /// In this method we have something like this:
    ///
    /// ``` css
    ///     --custom: var(--other, var(--default));
    /// ```
    /// where if either `--other` or `--default` is a local
    /// custom property, it has been solved.
    ///
    private func resolveComponentValues(forLocalCustomProperty localCustomProperty: String, filterContext: FilterContext) {
        
        guard let customPropertyValue = self.cascadedStyle.getCSSPropertyValueContainer(localCustomProperty) else {
            assertionFailure("Error: customPropertyValue is nil")
            return
        }
        
        guard let customDeclaration = customPropertyValue.customValueDeclaration else {
            assertionFailure("Error: customDeclaration is nil")
            // assign to invalid
            self.cascadedStyle.setCSSPropertyValueContainer(localCustomProperty, value: CSSPropertyValueContainer.resolvedCustom([CSSPropertyDefinitionTable.shared.guaranteedInvalidValue]))
            return
        }
        
        guard let finalComponentValues = resolveComponentValues(customDeclaration.propertyValueComponentValueList, filterContext: filterContext) else {
            assertionFailure("Error: finalComponentValues is nil")
            self.cascadedStyle.setCSSPropertyValueContainer(localCustomProperty, value: CSSPropertyValueContainer.resolvedCustom([CSSPropertyDefinitionTable.shared.guaranteedInvalidValue]))
            return
        }
        
        self.cascadedStyle.setCSSPropertyValueContainer(localCustomProperty, value:  CSSPropertyValueContainer.resolvedCustom(finalComponentValues))
    }
    
    ///
    /// This method evaluated the component values of a var(...) function.
    ///
    ///
    private func evaluateVarFunction(_ varFunction: CSFunctionComponentValue, filterContext: FilterContext) -> [CSComponentValue]? {
        
        guard let primaryValue = self.evaluatePrimaryVarValue(varFunction, filterContext: filterContext) else {
            assertionFailure("Error: var function primary value is nil")
            return nil
        }
        
        if primaryValue.isGuaranteedInvalidValue {
            
            if let defaultValue = evaluateDefaultVarValue(varFunction, filterContext: filterContext) {
                return defaultValue
            }
            return primaryValue
        }
        
        return primaryValue
    }
    
    private func evaluatePrimaryVarValue(_ varFunction: CSFunctionComponentValue, filterContext: FilterContext) -> [CSComponentValue]? {
        
        guard let customPropertyName = varFunction.customPropertyName else {
            assertionFailure("Error: customPropertyName is nil")
            return nil
        }
        
        return self.valueComponents(forCustomProperty: customPropertyName, filterContext: filterContext)
    }
    
    private func evaluateDefaultVarValue(_ varFunction: CSFunctionComponentValue, filterContext: FilterContext) -> [CSComponentValue]? {
        
        guard let defaultValue = varFunction.defaultValue else {
            return nil
        }
        
        return resolveComponentValues(Array(defaultValue), filterContext: filterContext)
    }
    
    func valueComponents(forCustomProperty customProperty: String, filterContext: FilterContext) -> [CSComponentValue]? {
        
        if let propertyValue = self.cascadedStyle.propertyValues[customProperty] {
            assert(propertyValue.isResolvedComponentValuesCustomProperty)
            return propertyValue.resolvedComponentsValues
        }
        else {
            return self.inheritedCustomPropertyValueComponents(customProperty, filterContext: filterContext)
        }
    }
    
    ///
    /// In this method we use the directedDependencyGraph to build the
    /// order in which we should evaluate the components value so that
    /// they are always available when we need them when evaluating a
    /// specific custom property value.
    ///
    /// Note: at this point the customProperty is not part of a cycle.
    ///
    private func buildPropertiesEvaluationStack(forCustomProperty customProperty: String, using directedDependencyGraph: [String: DependencyNode]) -> Stack<String> {
        
        var localDependencies = Stack<String>()
        
        guard let startingNode = directedDependencyGraph[customProperty] else {
            assertionFailure("Error: startingNode is nil")
            return localDependencies
        }
        
        // here we do a bfs to gather the dependencies at a same
        // level first.
        
        var bfsQueue = Queue<DependencyNode>()
        bfsQueue.enqueue(startingNode)
        
        while !bfsQueue.isEmpty {
            
            guard let node = bfsQueue.dequeue() else {
                assertionFailure("Error: cannot be nil")
                continue
            }
            
            localDependencies.push(node.name)
            
            for dependency in node.dependencies {
                bfsQueue.enqueue(dependency)
            }
        }
        
        return localDependencies
    }
    
    ///
    /// This method assign the guaranteed invalid value to all
    /// custom properties that are passed in customProperties array.
    /// They are assumed to be in a custom property cycle.
    ///
    private func assignGaranteedInvalidValue(toCustomProperties customProperties: Set<String>) {
        
        for customProperty in customProperties {
            if customProperty.isCustomPropertyName {
                self.cascadedStyle.setCSSPropertyValueContainer(customProperty, value:  CSSPropertyValueContainer.resolvedCustom([CSSPropertyDefinitionTable.shared.guaranteedInvalidValue]))
            }
        }
    }
     
    ///
    /// Here we resolve a custom property value. We have something like this
    /// to evaluate and know the final value:
    ///
    /// ``` css
    /// p {
    ///     color: var(--default-color);
    /// }
    /// ```
    ///
    /// In this case we must look at the inheriting element for the value.
    /// We must remember that the var may be use for partial property value:
    /// like this:
    ///
    /// ``` css
    ///     :root {
    ///         --red: 43
    ///     }
    ///
    ///     p {
    ///         color: #var(--red)FCAF;
    ///     }
    ///
    ///     :root, :root:lang(en) {
    ///         --external-link: "external link";
    ///     }
    ///     :root:lang(de) {
    ///         --external-link: "externer Link";
    ///     }
    ///
    ///     a[href^="http"]::after {
    ///         content: " (" var(--external-link) ")"
    ///     }
    /// ```
    ///
    /// This leads to a CSComponentValue substitution algorithm. And custom compilation
    /// at evaluation time. Here.
    ///
    private func resolveVarFunctionPropertyValue(property: CSSProperty, fromValueContainer value: CSSPropertyValueContainer, filterContext: FilterContext) -> CSSPropertyValueContainer {
        
        assert(value.isUnresolvedCustomValueProperty)
        resolveCustomValueComponentValues(forProperty: property, filterContext: filterContext)
        
        guard let resolvedComponentsPropertyValue = self.cascadedStyle.propertyValues[§property] else {
            assertionFailure("Error: customPropertyValue is nil")
            self.cascadedStyle.setCSSPropertyValueContainer(§property, value: CSSPropertyValueContainer.error)
            return CSSPropertyDefinitionTable.shared.initialValueForProperty(property)
        }
        
        assert(resolvedComponentsPropertyValue.isResolvedComponentValuesCustomProperty)
        guard let componentsValues = resolvedComponentsPropertyValue.resolvedComponentsValues else {
            assertionFailure("Error: no declaration associated with the custom property...")
            return CSSPropertyDefinitionTable.shared.initialValueForProperty(property)
        }
        
        guard let propertyValue = CSSPropertyEvaluator.parsePropertyValue(property, componentValues: componentsValues) else {
            return CSSPropertyValueContainer.error
        }
        return propertyValue
    }
    
    ///
    /// This is the method that evaluates a custom value property of the form:
    ///
    /// ``` css
    ///     color: var(--custom-property);
    /// ```
    ///
    /// At this point, all local and inherited custom properties definitions
    /// of the form:
    ///
    /// ``` css
    ///     --custom-property: ...;
    /// ```
    ///
    /// have been resolved.
    ///
    /// Still, we have not yet computed possible cycles in which
    /// this particular variable may be involved. So, we need to make
    /// sure this is done. And if there is no
    ///
    /// So we can just replace all values as needed and
    /// build the final component values for particular property.
    ///
    ///
    private func resolveCustomValueComponentValues(forProperty property: CSSProperty, filterContext: FilterContext) {
    
        guard let customPropertyValue = self.cascadedStyle.propertyValues[§property] else {
            assertionFailure("Error: customPropertyValue is nil")
            self.cascadedStyle.setCSSPropertyValueContainer(§property, value: CSSPropertyValueContainer.error)
            return
        }
        
        guard let customDeclaration = customPropertyValue.customValueDeclaration else {
            assertionFailure("Error: customDeclaration is nil")
            // assign to invalid
            self.cascadedStyle.setCSSPropertyValueContainer(§property, value: CSSPropertyValueContainer.error)
            return
        }
        
        guard let finalComponentValues = resolveComponentValues(customDeclaration.propertyValueComponentValueList, filterContext: filterContext) else {
            assertionFailure("Error: finalComponentValues is nil")
            self.cascadedStyle.setCSSPropertyValueContainer(§property, value: CSSPropertyValueContainer.error)
            return
        }
        
        self.cascadedStyle.setCSSPropertyValueContainer(§property, value:  CSSPropertyValueContainer.resolvedCustom(finalComponentValues))
    }
        
    private func resolveComponentValues(_ values: [CSComponentValue], filterContext: FilterContext) -> [CSComponentValue]? {
        
         var finalComponentValues: [CSComponentValue] = []
         
         for propertyValueComponentValue in values {
             
             if let functionComponentValue = propertyValueComponentValue as? CSFunctionComponentValue, functionComponentValue.isVarFunction {
                 
                guard let componentValues = self.evaluateVarFunction(functionComponentValue, filterContext: filterContext) else {
                     assertionFailure("Error: no componentValues for function :\(functionComponentValue)")
                     continue
                 }
                 
                 finalComponentValues.append(contentsOf: componentValues)
             }
             else {
                 // leave the component unchanged
                 finalComponentValues.append(propertyValueComponentValue)
             }
         }
        return finalComponentValues
    }
    
    private func computeExplicitDefaultingValue(_ property: CSSProperty, defaultingType: DefaultingType, filterContext: FilterContext) -> CSSPropertyValueContainer? {
        
        let propertyDefinitionTable = CSSPropertyDefinitionTable.shared
        
        switch defaultingType {
            
        /// see http://dev.w3.org/csswg/css-cascade-4/#default
        case .Default:
            
            return rollBackCascade(property, filterContext: filterContext)
            
        /// see http://dev.w3.org/csswg/css-cascade-4/#inherit
        case .Inherit:
            
            return inheritedValue(property, filterContext: filterContext)
            
        /// see http://dev.w3.org/csswg/css-cascade-4/#initial
        case .Initial:
            
            return propertyDefinitionTable.initialValueForProperty(property)
            
        /// see http://dev.w3.org/csswg/css-cascade-4/#inherit-initial
        case .Unset:
            
            // if it is an inherited property, this is treated as inherit,
            if propertyDefinitionTable.isInheritedProperty(property) {
                
                return inheritedValue(property, filterContext: filterContext)
            }
                // if it is not, this is treated as initial.
            else {
                
                return propertyDefinitionTable.initialValueForProperty(property)
            }
        case .SelectedValue:
            
            if let associatedElement = associatedElement as? CSSDOMSelectableValueElement {
                
                if let propertyValue = associatedElement.propertyValue, validatePropertyValueContainer(propertyValue, forPropertyName: property.rawValue) {
                    
                    return propertyValue
                }
                else {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS))
                    os_log("associatedElement is nil.", log: Log.Web.all, type: .error)
                    #endif
                    return inheritedValue(property, filterContext: filterContext)
                }
            }
            else {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS))
                os_log("associatedElement is not of type CSSDOMSelectableValueElement", log: Log.Web.all, type: .error)
                #endif
                return inheritedValue(property, filterContext: filterContext)
            }
        }
    }
    
    private func validatePropertyValueContainer(_ value: CSSPropertyValueContainer, forPropertyName propertyName: DOMString) -> Bool {
        
        if let property = CSSProperty(rawValue: propertyName) {
            
            switch property {
                
            case .caretColor:
                
                switch value {
                    
                case .color: return true
                case .none: return true
                default:
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS))
                    os_log("Trying to assing wrong value to color.", log: Log.Web.all, type: .error)
                    #endif
                    return false
                }
                
            case .color:
                
                switch value {
                    
                case .color: return true
                case .none: return true
                default:
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS))
                    os_log("Trying to assing wrong value to color.", log: Log.Web.all, type: .error)
                    #endif
                    return false
                }
                
            case .backgroundColor:
                
                switch value {
                    
                case .color:return true
                case .none:return true
                default:
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS))
                    os_log("Trying to assing wrong value to color.", log: Log.Web.all, type: .error)
                    #endif
                    return false
                }
                
            case .textDecorationColor:
                
                switch value {
                    
                case .color:return true
                case .none:return true
                default:
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS))
                    os_log("Trying to assing wrong value to textDecorationColor.", log: Log.Web.all, type: .error)
                    #endif
                    return false
                }
                
            case .textDecorationLine:
                
                switch value {
                    
                case .textDecorationLine:return true
                case .none:return true
                default:
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS))
                    os_log("Trying to assing wrong value to textDecorationLine.", log: Log.Web.all, type: .error)
                    #endif
                    return false
                }
                
            case .textDecorationStyle:
                
                switch value {
                    
                case .textDecorationStyle: return true
                case .none: return true
                default:
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS))
                    os_log("Trying to assing wrong value to textDecorationStyle.", log: Log.Web.all, type: .error)
                    #endif
                    return false
                }
                
            case .fontFamily:
                
                switch value {
                    
                case .fontFamily(_): return true
                case .none: return true
                default:
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS))
                    os_log("Trying to assing wrong value to fontFamily.", log: Log.Web.all, type: .error)
                    #endif
                    return false
                }
                
            case .fontSize:
                
                switch value {
                    
                case .fontSize(_):return true
                case .none:return true
                default:
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS))
                    os_log("Trying to assing wrong value to font-size.", log: Log.Web.all, type: .error)
                    #endif
                    return false
                }
                
            case .fontWeight:
                
                switch value {
                    
                case .fontWeight(_):return true
                case .none:return true
                default:
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS))
                    os_log("Trying to assing wrong value to font-weight.", log: Log.Web.all, type: .error)
                    #endif
                    return false
                }
                
            case .fontStyle:
                
                switch value {
                    
                case .fontStyle(_):return true
                case .none:return true
                default:
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS))
                    os_log("Trying to assing wrong value to font-style.", log: Log.Web.all, type: .error)
                    #endif
                    return false
                }
            }
        }
        
        return false
    }
    
    private func rollBackCascade(_ property: CSSProperty, filterContext: FilterContext) -> CSSPropertyValueContainer? {
        
        let propertyDefinitionTable = CSSPropertyDefinitionTable.shared
        
        let cascadedValueOrigin = cascadedStyle.getPropertyOrigin(§property)
        
        assert(cascadedValueOrigin != nil)
        if let cascadedValueOrigin = cascadedValueOrigin {
            
            switch cascadedValueOrigin {
                
            case .author:
                
                if let userValue = userLevelStyle.getCSSPropertyValueContainer(§property) {
                    
                    return userValue
                }
                // FIXME: if there is no user agnet applicable value we return the initial value
                // we should verify this behavior but it seems the right one since after
                // this stage there should be a value for each supported property.
                else {
                    
                    return propertyDefinitionTable.initialValueForProperty(property)
                }
                
            // Rolls back the cascade to the user-agent level
            case .user:
                
                if let userAgentValue = userAgentLevelStyle.getCSSPropertyValueContainer(§property) {
                    
                    return userAgentValue
                }
                // FIXME: if there is no user agnet applicable value we return the initial value
                // we should verify this behavior but it seems the right one since after
                // this stage there should be a value for each supported property.
                else {
                    
                    return propertyDefinitionTable.initialValueForProperty(property)
                }
                
            // equivalent to "unset"
            case .userAgent:
                
                //  if it is an inherited property, this is treated as inherit,
                if propertyDefinitionTable.isInheritedProperty(property) {
                    
                    return inheritedValue(property, filterContext: filterContext)
                }
                // if it is not, this is treated as initial.
                else {
                    
                    return propertyDefinitionTable.initialValueForProperty(property)
                }
            }
        }
        else {
            
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("cascadedValueOrigin is nil.", log: Log.Web.all, type: .error)
            #endif
        }
        
        // by default we return the initial value for the property.
        return propertyDefinitionTable.initialValueForProperty(property)
    }
}

extension Array where Element == CSComponentValue {
    
    var isGuaranteedInvalidValue: Bool {
        
        guard self.count == 1 else {
            return false
        }
        
        guard let componentValue = self.first else {
            assertionFailure("Error: componentValue is false")
            return false
        }
        
        guard let preservedComponentValue = componentValue as? CSPreservedTokenComponentValue else {
            return false
        }
        
        guard preservedComponentValue.isTokenId(§CSTokenId.stringToken) else {
            return false
        }
        
        return preservedComponentValue.rawStringValue.isEmpty
    }
}
