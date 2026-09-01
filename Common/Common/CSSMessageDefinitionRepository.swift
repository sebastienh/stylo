//
//  CSSMessageDefinitionRepository.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-19.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation


struct CSSMessageDefinitionRepository : DomainMessageDefinitionRepository {
    
    let messages = [
        
        MessageCode.expectedColonError :
        MessageDefinition(
            domain: MessageDomain.css,
            module: MessageModule.Compiler,
            code: MessageCode.expectedColonError,
            severity: MessageSeverity.Error,
            messageKey: "Expected colon",
            comment: "Message to display when parsing a declaration and expecting a colon but finding something else.",
            messageTable: MessageTable.CSSErrorMessages),
        
        MessageCode.missingSelectorBeforeCombinator :
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.missingSelectorBeforeCombinator,
                severity: MessageSeverity.Error,
                messageKey: "Missing selector before combinator",
                comment: "",
                messageTable: MessageTable.CSSErrorMessages),
        
        MessageCode.missingSelectorAfterCombinator :
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.missingSelectorAfterCombinator,
                severity: MessageSeverity.Error,
                messageKey: "Missing selector after combinator.",
                comment: "Message to display when the user has defined a combinator but there is selector defined on right of it",
                messageTable: MessageTable.CSSErrorMessages),
        
        MessageCode.invalidCompoundSelector :
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.invalidCompoundSelector,
                severity: MessageSeverity.Error,
                messageKey: "Invalid compound selector",
                comment: "Message to display when we parse a compound selector but there is no \"id\" or \"class\" or \"attrib\" or \"pseudo\" defined.",
                messageTable: MessageTable.CSSErrorMessages),
        
        MessageCode.invalidComplexSelector :
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.invalidComplexSelector,
                severity: MessageSeverity.Warning,
                messageKey: "Invalid complex selector",
                comment: "Message to display when we parse a complex selector but there is an error.",
                messageTable: MessageTable.CSSErrorMessages),
        
        MessageCode.missingAttributeNameInAttribSelector :
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.missingAttributeNameInAttribSelector,
                severity: MessageSeverity.Error,
                messageKey: "Missing attribute name",
                comment: "Message to display when we parse an attribute selector but there is no name specified.",
                messageTable: MessageTable.CSSErrorMessages),
        
        MessageCode.missingAttributeValueInAttribSelector :
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.missingAttributeValueInAttribSelector,
                severity: MessageSeverity.Error,
                messageKey: "Missing attribute value",
                comment: "Message to display when we parse an attribute selector but there is no value specified.",
                messageTable: MessageTable.CSSErrorMessages),
        
        
        MessageCode.missingAttributeSelectorRightSquareBracket :
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.missingAttributeSelectorRightSquareBracket,
                severity: MessageSeverity.Error,
                messageKey: "Expected right square bracket",
                comment: "",
                messageTable: MessageTable.CSSErrorMessages),
        
        MessageCode.unsupportedOrInvalidAtRule :
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.unsupportedOrInvalidAtRule,
                severity: MessageSeverity.Error,
                messageKey: "Unsupported or invalid \"At\" rule",
                comment: "",
                messageTable: MessageTable.CSSErrorMessages),
        
        
        
        MessageCode.unexpectedEndOfSelector :
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.unexpectedEndOfSelector,
                severity: MessageSeverity.Error,
                messageKey: "Unexpected end of selector",
                comment: "Message to display when the selector ends prematurely",
                messageTable: MessageTable.CSSErrorMessages),
        
        MessageCode.missingExclamationBeforeImportant :
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.missingExclamationBeforeImportant,
                severity: MessageSeverity.Error,
                messageKey: "Missing exclamation point before important keyword.",
                comment: "Message to display when we specified a declaration as important without the exclamation point.",
                messageTable: MessageTable.CSSErrorMessages),
    
        MessageCode.expectedImportantKeyword :
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.expectedImportantKeyword,
                severity: MessageSeverity.Error,
                messageKey: "Expected important keyword after exclamation point.",
                comment: "Message to display when we specified an exclamation point in a declaration without the \"important\" keyword.",
                messageTable: MessageTable.CSSErrorMessages),
    
        MessageCode.unexpectedCharacterInUnicodeRange :
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.unexpectedCharacterInUnicodeRange,
                severity: MessageSeverity.Error,
                messageKey: "Unexpected character while parsing Unicode range.",
                comment: "Message to display when an unexpected character while parsing unicode range.",
                messageTable: MessageTable.CSSErrorMessages),
       
        MessageCode.unableToConvertNumber :
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.unableToConvertNumber,
                severity: MessageSeverity.Error,
                messageKey: "Unable to convert number.",
                comment: "Message to display when we are unable to convert a number.",
                messageTable: MessageTable.CSSErrorMessages),
        
        MessageCode.unknownColor :
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.unknownColor,
                severity: MessageSeverity.Error,
                messageKey: "Unknown color: \"%@\"",
                comment: "Message to display when we can not find the color keyword in the predefined list.",
                messageTable: MessageTable.CSSErrorMessages),
        
        MessageCode.invalidHexColorValue :
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.invalidHexColorValue,
                severity: MessageSeverity.Error,
                messageKey: "Invalid hex color value: \"%@\"",
                comment: "Message to display when we have an invalid numbers of characters after #, should be 3, 4, 6 or 8",
                messageTable: MessageTable.CSSErrorMessages),
        
        MessageCode.unsupportedColorFunction :
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.unsupportedColorFunction,
                severity: MessageSeverity.Error,
                messageKey: "Unsupported color function: \"%@\"",
                comment: "Message to display we are the color function is unknown.",
                messageTable: MessageTable.CSSErrorMessages),

        MessageCode.unsupportedFunction :
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.unsupportedFunction,
                severity: MessageSeverity.Error,
                messageKey: "Unsupported function: \"%@\"",
                comment: "Message to display we are the function is unknown.",
                messageTable: MessageTable.CSSErrorMessages),
        
        MessageCode.tooManyArgumentsPassedToFunction :
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.tooManyArgumentsPassedToFunction,
                severity: MessageSeverity.Error,
                messageKey: "Too much arguments passed to function.",
                comment: "Message to display when there is too many arguments passed to the function.",
                messageTable: MessageTable.CSSErrorMessages),
        
        MessageCode.notEnoughArgumentsPassedToFunction :
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.notEnoughArgumentsPassedToFunction,
                severity: MessageSeverity.Error,
                messageKey: "Not enough arguments passed to function.",
                comment: "Message to display when there is not enough arguments passed to the function.",
                messageTable: MessageTable.CSSErrorMessages),
        
        MessageCode.invalidArgument :
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.invalidArgument,
                severity: MessageSeverity.Error,
                messageKey: "Invalid argument passed to function: \"%@\"",
                comment: "Message to display when an invalid argument is passed to a function.",
                messageTable: MessageTable.CSSErrorMessages),
        
        MessageCode.noArgumentsPassedToFunction :
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.noArgumentsPassedToFunction,
                severity: MessageSeverity.Error,
                messageKey: "No arguments passed to function",
                comment: "Message to display when there is no arguments passed to the function.",
                messageTable: MessageTable.CSSErrorMessages),
        
        MessageCode.wrongRGBColorRange :
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.wrongRGBColorRange,
                severity: MessageSeverity.Error,
                messageKey: "Color is not in the 0 to 255 range",
                comment: "Message to display when color is not in the 0 to 255 range.",
                messageTable: MessageTable.CSSErrorMessages),
        
        MessageCode.wrongHueComponentRange :
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.wrongHueComponentRange,
                severity: MessageSeverity.Error,
                messageKey: "Hue component is not in the 0 to 360 range",
                comment: "Message to display when hue color component is not in the 0 to 360 range",
                messageTable: MessageTable.CSSErrorMessages),
        
        MessageCode.wrongPercentageColorRange :
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.wrongPercentageColorRange,
                severity: MessageSeverity.Error,
                messageKey: "Color percentage is not in the 0 to 100 range",
                comment: "Message to display when color percentage is not in the 0 to 100 range.",
                messageTable: MessageTable.CSSErrorMessages),
        
        MessageCode.wrongAlphaRange :
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.wrongAlphaRange,
                severity: MessageSeverity.Error,
                messageKey: "Alpha component is not in the 0 to 1 range",
                comment: "Message to display when alpha component is not in the 0 to 1 range.",
                messageTable: MessageTable.CSSErrorMessages),
        
        MessageCode.unsupportedColorAlpha:
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.unsupportedColorAlpha,
                severity: MessageSeverity.Warning,
                messageKey: "Alpha value in color is not supported when set as body background color",
                comment: "Message to display when alpha alpha value is below 1 but ALPHA_COLOR_ENABLED is not enabled.",
                messageTable: MessageTable.CSSErrorMessages),
        
        MessageCode.wrongValueTypePercentageForHSLHueComponent :
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.wrongValueTypePercentageForHSLHueComponent,
                severity: MessageSeverity.Error,
                messageKey: "HSL hue component must be expressed in degrees from 0 to 360 and not in percentage",
                comment: "Message to display when HSL hue component is not expressed in degrees from 0 to 360  but in percentage.",
                messageTable: MessageTable.CSSErrorMessages),
        
        MessageCode.expectingComma :
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.expectingComma,
                severity: MessageSeverity.Error,
                messageKey: "Expecting comma at this position",
                comment: "Message when we are expecting a comma but encountering another character.",
                messageTable: MessageTable.CSSErrorMessages),
        
        MessageCode.unexpectedCharacter :
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.unexpectedCharacter,
                severity: MessageSeverity.Error,
                messageKey: "Unexpected character at this position",
                comment: "Message when we are expecting a comma but encountering another character.",
                messageTable: MessageTable.CSSErrorMessages),
        
        MessageCode.unsupportedFontStyle :
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.unsupportedFontStyle,
                severity: MessageSeverity.Error,
                messageKey: "Unsupported font-style: \"%@\". Should be one of \"normal\", \"italic\" or \"oblique\"",
                comment: "Message to diplsay when the font style is not normal | italic | oblique.",
                messageTable: MessageTable.CSSErrorMessages),
        
        MessageCode.unsupportedFontVariant :
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.unsupportedFontVariant,
                severity: MessageSeverity.Error,
                messageKey: "Unsupported font-variant: \"%@\". Should be one of \"normal\" or \"small-caps\"",
                comment: "Message to diplsay when the font-variant is not normal | small-caps.",
                messageTable: MessageTable.CSSErrorMessages),
        
        MessageCode.unsupportedFontSizeKeyword :
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.unsupportedFontSizeKeyword,
                severity: MessageSeverity.Error,
                messageKey: "Unsupported font-size keyword: \"%@\"",
                comment: "Message to display when the font-size keyword is not supported.",
                messageTable: MessageTable.CSSErrorMessages),
        
        
        MessageCode.unsupportedDimensionUnitForFontSize :
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.unsupportedDimensionUnitForFontSize,
                severity: MessageSeverity.Error,
                messageKey: "Unsupported font-size unit: \"%@\". Supported units are : \"pt\", \"px\" and \"em\"",
                comment: "Message to display when the font-size unit is not supported.",
                messageTable: MessageTable.CSSErrorMessages),
        
        MessageCode.unsupportedNegativeValue :
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.unsupportedNegativeValue,
                severity: MessageSeverity.Error,
                messageKey: "Unsupported font-size value: \"%@\". Value can not be negative",
                comment: "Message to display when the font-size is a negative value.",
                messageTable: MessageTable.CSSErrorMessages),
        
        MessageCode.unsupportedFontWeightKeyword :
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.unsupportedFontWeightKeyword,
                severity: MessageSeverity.Error,
                messageKey: "Unsupported font-weight keyword: \"%@\"",
                comment: "Message to display when the font-weight keyword is not supported.",
                messageTable: MessageTable.CSSErrorMessages),
        
        MessageCode.unsupportedFontWeightValue :
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.unsupportedFontWeightValue,
                severity: MessageSeverity.Error,
                messageKey: "Unsupported font-weight value: \"%@\"",
                comment: "Message to display when the font-weight value is not supported.",
                messageTable: MessageTable.CSSErrorMessages),
        
        MessageCode.unsupportedFontWeightValueType :
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.unsupportedFontWeightValueType,
                severity: MessageSeverity.Error,
                messageKey: "Unsupported font-weight value type(real number): \"%@\"",
                comment: "Message to display when the font-weight value type is not supported. The user used real number instead of integer number ",
                messageTable: MessageTable.CSSErrorMessages),
        
        MessageCode.unsupportedFontStretch :
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.unsupportedFontStretch,
                severity: MessageSeverity.Error,
                messageKey: "Unsupported font-stretch: \"%@\"",
                comment: "Message to diplsay when the font stretch is not supported.",
                messageTable: MessageTable.CSSErrorMessages),
        
        MessageCode.unsupportedTextDecorationStyleKeyword:
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.unsupportedTextDecorationStyleKeyword,
                severity: MessageSeverity.Error,
                messageKey: "Unsupported text-decoration-style keyword: \"%@\"",
                comment: "Message to display when the text-decoration-style keyword is not supported.",
                messageTable: MessageTable.CSSErrorMessages),
        
        MessageCode.noneTextDecorationLineValueMustBeAlone :
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.noneTextDecorationLineValueMustBeAlone,
                severity: MessageSeverity.Error,
                messageKey: "None value should be alone: consider removing: \"%@\"",
                comment: "Message to diplsay when the \"none\" value is accompanied by another value.",
                messageTable: MessageTable.CSSErrorMessages),
        
        MessageCode.unsupportedFontFamily :
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.unsupportedFontFamily,
                severity: MessageSeverity.Error,
                messageKey: "Unsupported font-family: \"%@\"",
                comment: "Message to diplsay when the font stretch is not supported.",
                messageTable: MessageTable.CSSErrorMessages),
        
        MessageCode.unexpectedToken :
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.unexpectedToken,
                severity: MessageSeverity.Error,
                messageKey: "Unexpected token: \"%@\"",
                comment: "Message to display when we encounter an unexpected token when parsing.",
                messageTable: MessageTable.CSSErrorMessages),
        
        MessageCode.invalidDeclaration :
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.invalidDeclaration,
                severity: MessageSeverity.Warning,
                messageKey: "Invalid declaration: \"%@\"",
                comment: "Message to display when a declaration is found invalid for any reason.",
                messageTable: MessageTable.CSSErrorMessages),
        
        MessageCode.invalidPseudoSelectorSyntax :
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.invalidPseudoSelectorSyntax,
                severity: MessageSeverity.Error,
                messageKey: "Invalid pseudo selector syntax: \"%@\"",
                comment: "Message to display when a we find an invalid pseudo selector syntax.",
                messageTable: MessageTable.CSSErrorMessages),
        
        MessageCode.emptyCompoundSelector :
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.emptyCompoundSelector,
                severity: MessageSeverity.Error,
                messageKey: "Compound selector is empty",
                comment: "Message to display when we expect a compound selector but found nothing.",
                messageTable: MessageTable.CSSErrorMessages),
        
        MessageCode.unsupportedProperty:
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.unsupportedProperty,
                severity: MessageSeverity.Error,
                messageKey: "Unsupported or invalid property: \"%@\"",
                comment: "Message to display when the property entered is not supported or invalid.",
                messageTable: MessageTable.CSSErrorMessages),
        
        MessageCode.missingEndSemiColon:
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.missingEndSemiColon,
                severity: MessageSeverity.Error,
                messageKey: "Missing end semi-colon",
                comment: "Message to display when the end semi-colon is missing.",
                messageTable: MessageTable.CSSErrorMessages),
        
        MessageCode.unexpectedFunction:
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.unexpectedFunction,
                severity: MessageSeverity.Error,
                messageKey: "Unexpected function: \"%@\"",
                comment: "Message to display when we encounter a unexpected function.",
                messageTable: MessageTable.CSSErrorMessages),
        
        MessageCode.unexpectedParameter :
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.unexpectedParameter,
                severity: MessageSeverity.Error,
                messageKey: "Unexpected parameter",
                comment: "Message to display when there is more parameters passed to a function than expected.",
                messageTable: MessageTable.CSSErrorMessages),
        
        
        MessageCode.followingSiblingsSelectorMayImpactPerformance :
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.followingSiblingsSelectorMayImpactPerformance,
                severity: MessageSeverity.Warning,
                messageKey: "Following siblings selector may impact performance",
                comment: "Message to display when the user is using following siblings selector.",
                messageTable: MessageTable.CSSErrorMessages),
        
        MessageCode.tooManyDefaultNamespaceDeclarations :
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.tooManyDefaultNamespaceDeclarations,
                severity: MessageSeverity.Warning,
                messageKey: "Ignored default namespace definition. Only one definition is considered",
                comment: "Message to display when the user has declared too much default namespaces.",
                messageTable: MessageTable.CSSErrorMessages),
        
        // NW-136
        MessageCode.invalidPseudoElementSelectorPosition :
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.invalidPseudoElementSelectorPosition,
                severity: MessageSeverity.Warning,
                messageKey: "This selector does not select anything. Invalid position for pseudo elements selector, it should be placed at the end of selector",
                comment: "Message to display when the user has put a pseudo element selector at any other place than the end.",
                messageTable: MessageTable.CSSErrorMessages),
        
        MessageCode.missingNamespaceUri :
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.missingNamespaceUri,
                severity: MessageSeverity.Error,
                messageKey: "Missing URI",
                comment: "Message to display when the uri is missing in a namespace at rule.",
                messageTable: MessageTable.CSSErrorMessages),
        
        MessageCode.unsupportedPseudoElement:
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.unsupportedPseudoElement,
                severity: MessageSeverity.Warning,
                messageKey: "Unsupported pseudo-element: \"%@\"",
                comment: "Message to display when the pseudo-element is not supported.",
                messageTable: MessageTable.CSSErrorMessages),
        
        MessageCode.pseudoClassNotSupported:
            MessageDefinition(
                domain: MessageDomain.css,
                module: MessageModule.Compiler,
                code: MessageCode.pseudoClassNotSupported,
                severity: MessageSeverity.Warning,
                messageKey: "Pseudo-class selector is not supported",
                comment: "Message to display when the user use a pseudo-class.",
                messageTable: MessageTable.CSSErrorMessages),
        
        
    ]
    

    
}
