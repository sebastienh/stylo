//
//  CSFunctionComponentValue+Var.swift
//  Web
//
//  Created by Sebastien Hamel on 2020-08-12.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Common
import os

extension CSFunctionComponentValue {

    var isVarFunction: Bool {
        
        guard let functionType = self.functionType else {
            return false
        }
        return functionType == .var
    }

    var firstCommaIndex: Int? {
        for (index, component) in value.componentValueList.enumerated() {
            if component.isTokenId(§CSTokenId.commaToken) {
                return index
            }
        }
        return nil
    }
    
    ///
    /// var(--variable, red, blue)
    ///
    ///   .functionToken,
    ///   .identToken,       <----
    ///   .commaToken,
    ///   .whitespaceToken,
    ///   .identToken,
    ///   .commaToken,
    ///   .whitespaceToken,
    ///   .identToken,
    ///   .rightParenthesisToken,
    ///
    ///
    var customPropertyName: String? {
        
        guard self.isVarFunction else {
            assertionFailure("Error: calling default value on non var function")
            return nil
        }
        
        for component in value.componentValueList {
            
            if component.isTokenId(§CSTokenId.identToken) {
                guard let preservedComponentValue = component as? CSPreservedTokenComponentValue else {
                    assertionFailure("Error: preservedComponentValue is nil for ident token")
                    return nil
                }
                return preservedComponentValue.rawStringValue
            }
            else if component.isTokenId(§CSTokenId.commaToken) {
                // if we encounter a comma without having returned it is because
                // we have a function of this kind:
                // var( , ...) which does not contain a default value
                return nil
            }
        }
        return nil
    }
    
    ///
    /// In this method we return everything between the first
    /// comma and the right parenthesis.
    ///
    /// var(--variable, red, blue)
    ///
    ///   .functionToken,
    ///   .identToken,
    ///   .commaToken,
    ///   .whitespaceToken,       <----
    ///   .identToken,            <----
    ///   .commaToken,            <----
    ///   .whitespaceToken,       <----
    ///   .identToken,            <----
    ///   .rightParenthesisToken,
    ///
    ///
    var defaultValue: ArraySlice<CSComponentValue>? {
        
        guard self.isVarFunction else {
            assertionFailure("Error: calling default value on non var function")
            return nil
        }
        
        guard let firstCommaIndex = self.firstCommaIndex else {
            // without a comma we know there is no default value
            return nil
        }
        
        return self.value.componentValueList[firstCommaIndex+1..<self.value.componentValueList.count]
    }
}

extension ArraySlice where Element == CSComponentValue {
    
    var topLevelVarFunctions: [CSFunctionComponentValue]? {
        
        var varFunctions: [CSFunctionComponentValue] = []
        
        for component in self {
            
            if let function = component as? CSFunctionComponentValue, function.isVarFunction {
                varFunctions.append(function)
            }
        }
        
        return !varFunctions.isEmpty ? varFunctions : nil
    }
}
