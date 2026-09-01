//
//  MessageCodeIdentifier.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-19.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation


// Common : 1000
// CSS : 3XXX

public enum MessageCode: Int {
    
    // Common
    case ok = 0000
    
    // CSS
    case missingSelectorBeforeCombinator = 1001
    case missingSelectorAfterCombinator = 1002
    case invalidCompoundSelector = 1003
    case missingAttributeNameInAttribSelector = 1004
    case missingAttributeValueInAttribSelector = 1056
    case missingAttributeSelectorRightSquareBracket = 1005
    case unsupportedOrInvalidAtRule = 1057
    case unexpectedEndOfSelector = 1006
    case expectedColonError = 1007
    case expectedImportantKeyword = 1008
    case unexpectedCharacterInUnicodeRange = 1009
    case unableToConvertNumber = 1010
    case unknownColor = 1011
    case invalidHexColorValue = 1012
    case unsupportedColorFunction = 1013
    case unsupportedFunction =  1014
    case tooManyArgumentsPassedToFunction = 1015
    case notEnoughArgumentsPassedToFunction = 1016
    case invalidArgument = 1053
    case noArgumentsPassedToFunction = 1017
    case wrongRGBColorRange = 1018
    case wrongPercentageColorRange = 1019
    case wrongAlphaRange = 1020
    case missingExclamationBeforeImportant = 1021
    case wrongValueTypePercentageForHSLHueComponent = 1022
    case expectingComma = 1023
    case unexpectedCharacter = 1024
    case unsupportedFontStyle = 1025
    case unsupportedFontVariant = 1026
    case unsupportedFontSizeKeyword = 1027
    case unsupportedDimensionUnitForFontSize = 1028
    case unsupportedNegativeValue = 1029
    case unsupportedFontWeightKeyword = 1030
    case unsupportedFontWeightValue = 1031
    case unsupportedFontWeightValueType = 1041
    case unsupportedFontStretch = 1032
    case noneTextDecorationLineValueMustBeAlone = 1033
    case unsupportedFontFamily = 1034
    case unexpectedToken = 1035
    case invalidDeclaration = 1036
    case invalidPseudoSelectorSyntax = 1037
    case emptyCompoundSelector = 1038
    case unsupportedProperty = 1048
    case missingEndSemiColon = 1049
    case unexpectedFunction =  1040
    case unsupportedTextDecorationStyleKeyword = 1042
    case missingNamespaceUri = 1050
    case unsupportedPseudoElement = 1051
    case pseudoClassNotSupported = 1052
    case invalidComplexSelector = 1054
    case wrongHueComponentRange = 1055
    
    // function
    case unexpectedParameter = 1039
    case unsupportedColorAlpha = 1047
    
    // color 
    
    case invalidPropertyValue = 1043
    case followingSiblingsSelectorMayImpactPerformance = 1044
    case tooManyDefaultNamespaceDeclarations = 1045
    case invalidPseudoElementSelectorPosition = 1046
    
    // DOM
    case errorGettingStyleSheet = 2001
    
   
}
