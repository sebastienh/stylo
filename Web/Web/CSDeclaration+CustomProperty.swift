//
//  CSDeclaration+CustomProperty.swift
//  Web
//
//  Created by Sebastien Hamel on 2020-08-12.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Common

extension CSDeclaration {
    
    ///
    /// extract an array of local dependencies from custom properties,
    /// here we dont care about anything that is not defined in this
    /// element so we are passed an array containing all custom properties
    /// defined locally so that we can construct the dependencies graph only
    /// for these and remove the others.
    ///
    /// ``` css
    ///     body {
    ///         --color: var(--blue);
    ///         --blue: blue;
    ///     }
    /// ```
    /// would give us:
    ///
    /// "color" -> "blue"
    ///
    /// ``` css
    ///     body {
    ///         --color: var(--blue);
    ///         --blue: var(--other);
    ///         --other: var(--blue)
    ///     }
    /// ```
    /// Would give us (which has a cycle)
    ///
    /// In this function we return an array like this:
    ///
    /// | custom property | default value | value | parent |
    /// | ----            |  ----         | ---   |  ----  |
    /// |
    ///
    func updateLocalDependenciesGraph(fromLocalProperties localProperties: [String: DependencyNode]) {
        
        assert(localProperties.index(forKey: self.propertyName) != nil)
        for propertyComponentValue in self.propertyValueComponentValueList {
            
            if let functionComponentValue = propertyComponentValue as? CSFunctionComponentValue {
                if functionComponentValue.isVarFunction {
                    functionLocalDependenciesGraph(fromFunction: functionComponentValue, localProperties: localProperties, parentCustomPropertyName: self.propertyName)
                    }
                // else
                // nothing to do.
            }
        }
    }
    
    /// Method that recursively computes the dependencies graphs
    /// for a function (which may contain one or more function....
    ///
    /// ``` css
    ///     body {
    ///         --red: red;
    ///         --blue: blue;
    ///         --green: green;
    ///         --other: rgb(var(var(--mixed-red)), var(--green), var(--blue));
    ///         --mixed-red: var(--red);
    ///     }
    /// ```
    ///
    /// or
    ///
    /// ``` css
    /// body {
    ///    background-color: var(--books-bg, var(--arts-bg));
    /// }
    /// ```
    ///
    /// or
    ///
    /// ``` css
    /// body {
    ///    --background-color: var(var(--books-bg), var(--arts-bg));
    /// }
    /// ```
    ///
    ///
    private func functionLocalDependenciesGraph(fromFunction function: CSFunctionComponentValue, localProperties: [String: DependencyNode], parentCustomPropertyName: String) {
        
        guard function.isVarFunction else {
            assertionFailure("Error: function is not a var function")
            return
        }
        
        guard let customPropertyName = function.customPropertyName else {
            assertionFailure("Error: customPropertyName is nil")
            return
        }
        
        // test if the custom property value is a local one, otherwise we
        // don't need to add it to the dependencies graph.
        if let functionLocalPropertyNameDependencyNode = localProperties[customPropertyName] {
            
            guard let parentDependencyNode = localProperties[parentCustomPropertyName] else {
                assertionFailure("Error: parentDependencyNode is nil")
                return
            }
            
            parentDependencyNode.addDependency(to: functionLocalPropertyNameDependencyNode)
        }
        
        if let defaultValue = function.defaultValue {
            
            if let topLevelVarFunctions = defaultValue.topLevelVarFunctions {
                
                for topLevelVarFunction in topLevelVarFunctions {
                    
                    functionLocalDependenciesGraph(fromFunction: topLevelVarFunction, localProperties: localProperties, parentCustomPropertyName: parentCustomPropertyName)
                }
            }
        }
    }
}
