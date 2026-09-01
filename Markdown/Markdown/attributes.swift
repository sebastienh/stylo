//
//  attributes.swift
//  Markdown
//
//  Created by Sebastien hamel on 2019-04-27.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import Common

/// The function parseAttributes parse attributes coming after
/// a container marquer list ":" of at least three and continues to
/// parse until it reach the end of the line or encounter a new colon (":").
func parseAttributes(_ src: String, pos: inout Int, max: Int) -> AttributesBloc? {
    
    // for the moment we only consider the {...} case
    let attributesBloc = parseAttributesBloc(src, pos: &pos, max: max)
    
    if let attributesBloc = attributesBloc {
        
        return attributesBloc
    }
    
    return parseClassesList(src, pos: &pos, max: max)
}


func parseAttributesBloc(_ src: String, pos: inout Int, max: Int) -> AttributesBloc? {
    
    let oldPos = pos
    parseWhitespaces(src, pos: &pos, max: max)
    let firstNonWhitespaceCharacter = pos
    
    // aftet all the spaces, we have two choices:
    // 1. we reached the end
    // 2. we are in front of a class list attributes
    // 3. we are in front of an attributes bloc
    // 4. we are in front of a colon (':')
    if pos >= max {
        return nil
    }
    
    let nextChar = src.charAt(pos)
    
    if let nextChar = nextChar {
        
        if nextChar == §UnicodeCharacter.colon {
            return nil
        }
        
        if nextChar == §UnicodeCharacter.leftCurlyBracket {
            
            let openingCurlyBraquetRange = pos..<pos+1
            var attributes = [Attribute]()
            
            // go beyond the curly braquet
            pos += 1
            
            parseWhitespaces(src, pos: &pos, max: max)
            var char = src.charAt(pos)
            
            while let currentChar = char, currentChar != §UnicodeCharacter.rightCurlyBracket && pos < max {
                
                if currentChar == §UnicodeCharacter.fullStop {
                    
                    let className = parseClassName(src, pos: pos, max: max)
                    
                    if let (indicatorRange, classNameAttributeValueSegment) = className {
                        
                        let classAttribute = Attribute(type: .class, nameString: nil, indicatorRange: indicatorRange, attributeValueSegment: classNameAttributeValueSegment)
                        
                        attributes.append(classAttribute)
                        pos = classNameAttributeValueSegment.valueRange.upperBound
                    }
                    else {
                        
                        // if we failed on this it means it is not well formatted
                        // then we just fail on everything and return nil
                        // reset the position
                        pos = oldPos
                        return nil
                    }
                }
                else if currentChar == §UnicodeCharacter.numberSign {
                    
                    let idName = parseId(src, pos: pos, max: max)
                    
                    if let (indicatorRange, idAttributeValueSegment) = idName {
                        
                        let idAttribute = Attribute(type: .id, nameString: nil, indicatorRange: indicatorRange, attributeValueSegment: idAttributeValueSegment)

                        attributes.append(idAttribute)
                        pos = idAttributeValueSegment.valueRange.upperBound
                    }
                    else {
                        
                        // if we failed on this it means it is not well formatted
                        // then we just fail on everything and return nil
                        // reset the position
                        pos = oldPos
                        return nil
                    }
                }
                else {
                    
                    // we are in the generic case of the form:
                    // name=value or name (since we want to support custom
                    // element name
                    let attributeNameValue = parseKeyValueAttribute(src, pos: pos, max: max)
                    
                    if let keyValueAttribute = attributeNameValue {
                        
                        attributes.append(keyValueAttribute)
                        
                        switch keyValueAttribute.type {
                            
                        case .keyValue:
                            
                            if let closingIndicator = keyValueAttribute.attributeValueSegment.closingQuoteRange {
                                
                                pos = closingIndicator.upperBound
                            }
                            else {
                                    
                                pos = keyValueAttribute.attributeValueSegment.valueRange.upperBound
                            }
                            
                        default:
                            assert(false, "should have received a key value attribute here...")
                            break
                        }
                    }
                    else {
                        
                        let localnameAttribute = parseLocalname(src, pos: pos, max: max)
                        
                        if let localnameAttribute = localnameAttribute {
                            
                            assert(localnameAttribute.type == .elementName)
                            assert(localnameAttribute.nameSegment == nil)
                            assert(localnameAttribute.indicatorRange == nil)
                            attributes.append(localnameAttribute)
                            pos = localnameAttribute.attributeValueSegment.valueRange.upperBound
                        }
                        else {
                            
                            // if we failed on this it means it is not well formatted
                            // then we just fail on everything and return nil
                            // reset the position
                            pos = oldPos
                            return nil
                        }
                    }
                }
                
                parseWhitespaces(src, pos: &pos, max: max)
                char = src.charAt(pos)
            }
            
            if let currentChar = char, currentChar == §UnicodeCharacter.rightCurlyBracket {
                
                let closingCurlyBraquetRange = pos..<pos+1
                
                let attributesBloc = AttributesBloc(type: .fencedAttributes, attributes: attributes, openingCurlyBraquetRange: openingCurlyBraquetRange, closingCurlyBraquetRange: closingCurlyBraquetRange, startPosition: firstNonWhitespaceCharacter)
                
                // go pass the right curly brackets 
                pos += 1
                return attributesBloc
            }
        }
    }
    // reset the position
    pos = oldPos
    return nil
}


/// This function is responsible to parse a class list in the form
/// ::: john author :::
///
/// :::::::::::::::::::
/// where multiple class can be added
func parseClassesList(_ src: String, pos: inout Int, max: Int) -> AttributesBloc? {
    
    parseWhitespaces(src, pos: &pos, max: max)
    let firstNonWhitespaceCharacter = pos
    
    if pos >= max {
        return nil
    }
    
    let nextChar = src.charAt(pos)
    
    if let nextChar = nextChar {
        
        if nextChar == §UnicodeCharacter.colon {
            return nil
        }
        
        var attributesValueSegments = [AttributeValueSegment]()
        var char = src.charAt(pos)
        
        while let currentChar = char,
            currentChar != §UnicodeCharacter.colon
                && currentChar != §UnicodeCharacter.whitespace
                && pos < max {
                    
            let unquotedAttributeValueSegment = parseUnquotedAttributeValue(src, pos: pos, max: max)
            
            if let unquotedAttributeValueSegment = unquotedAttributeValueSegment {
                
                assert(unquotedAttributeValueSegment.openingQuoteRange == nil)
                assert(unquotedAttributeValueSegment.closingQuoteRange == nil)
                attributesValueSegments.append(unquotedAttributeValueSegment)
                pos = unquotedAttributeValueSegment.valueRange.upperBound
            }
            else {
                return nil
            }
            
            parseWhitespaces(src, pos: &pos, max: max)
            char = src.charAt(pos)
        }
        
        // we reach here when we are done with the classes
        let attributes = attributesValueSegments.map { (attributesValueSegment) -> Attribute in
            return Attribute(attributeValueSegment: attributesValueSegment)
        }
        return AttributesBloc(type: .classNamesList, attributes: attributes, startPosition: firstNonWhitespaceCharacter)
    }
    
    return nil
}

func parseKeyValueAttribute(_ src: String, pos: Int, max: Int) -> Attribute? {
    
    let attributeNameIndexes = parseAttributeName(src, pos: pos, max: max)
    
    if let (nameStart, nameEnd) = attributeNameIndexes {
        
        let nameString = src.substring(nameStart, length: nameEnd - nameStart)
        
        assert(nameString != nil)
        if let nameString = nameString {
        
            // we have successfully parsed an attribute name
            // now we need to validate if we are in front of a '='
            let nextCharIndex = nameEnd
            
            if nextCharIndex < max {
                
                let nextChar = src.charAt(nextCharIndex)
                
                if let nextChar = nextChar, nextChar == §UnicodeCharacter.equalsSign {
                    
                    let attributeValueStartIndex = nextCharIndex+1
                    
                    let attributeValueSegment = parseAttributeValue(src, pos: attributeValueStartIndex, max: max)
                    
                    if let attributeValueSegment = attributeValueSegment {
                        
                        // the equal sign range
                        let indicatorRange = nextCharIndex..<nextCharIndex+1
                        
                        return Attribute(type: .keyValue, nameSegment: nameStart..<nameEnd, nameString: nameString, indicatorRange: indicatorRange, attributeValueSegment: attributeValueSegment)
                    }
                }
            }
        }
    }
    return nil
}

func parseSingleQuotedAttributeValue(_ src: String, pos: Int, max: Int) -> AttributeValueSegment? {
 
    return parseQuotedAttributeValue(src, pos: pos, max: max, mark: §UnicodeCharacter.apostrophe)
}

func parseDoubleQuotedAttributeValue(_ src: String, pos: Int, max: Int) -> AttributeValueSegment? {
    
    return parseQuotedAttributeValue(src, pos: pos, max: max, mark: §UnicodeCharacter.quotationMark)
}

func parseQuotedAttributeValue(_ src: String, pos: Int, max: Int, mark: UTF16.CodeUnit) -> AttributeValueSegment? {
    
    let firstChar = src.charAt(pos)
    
    assert(firstChar != nil)
    assert(firstChar! == mark)
    if let firstChar = firstChar, firstChar == mark {
        
        var pendingEscape: Int?
        
        for i in pos+1..<max {
            
            let char = src.charAt(i)
            
            if let char = char {
            
                if char == §UnicodeWhitespace.lineFeed {
                    return nil
                }
                else if char == §UnicodeCharacter.reverseSolidus {

                    if pendingEscape == nil {
                        pendingEscape = i
                    }
                    else {
                        pendingEscape = nil
                    }
                }
                else if char == mark {
                    
                    if pendingEscape != nil {
                        pendingEscape = nil
                    }
                    else {
                     
                        // this is the successfull case...
                        // construct the AttributeValueSegment and return it
                        let openingQuoteRange = pos..<pos+1
                        let closingQuoteRange = i..<i+1
                        let valueRange = pos+1..<i
                        let valueString = src.substring(valueRange.lowerBound, length: valueRange.count)
                        
                        assert(valueString != nil)
                        if let valueString = valueString {
                        
                            return AttributeValueSegment(openingQuoteRange: openingQuoteRange, closingQuoteRange: closingQuoteRange, valueRange: valueRange, valueString: valueString)
                        }
                    }
                }
                // followed by zero or more ASCII letters, digits, _, ., :, or -.
                else {
                    
                    pendingEscape = nil
                }
            }
        }
    }
    return nil
}

func parseClassName(_ src: String, pos: Int, max: Int) -> (indicator: Range<Int>, AttributeValueSegment)? {
    
    let fullStopIndex = pos
    
    let fullStop = src.charAt(fullStopIndex)
    
    if fullStop != nil {
        
        let unquotedAttributeValue = parseUnquotedAttributeValue(src, pos: pos+1, max: max)
        
        if let unquotedAttributeValue = unquotedAttributeValue {
         
            let fullStopRange = pos..<pos+1
            return (fullStopRange, unquotedAttributeValue)
        }
    }
    return nil
}

func parseAttributeValue(_ src: String, pos: Int, max: Int) -> AttributeValueSegment? {
    
    let firstChar = src.charAt(pos)
    
    if let firstChar = firstChar {
        
        // single quote: '
        if firstChar == §UnicodeCharacter.apostrophe {
            
            return parseSingleQuotedAttributeValue(src, pos: pos, max: max)
        }
        // double quote: "
        else if firstChar == §UnicodeCharacter.quotationMark {
            
            return parseDoubleQuotedAttributeValue(src, pos: pos, max: max)
        }
        else if UnicodeLetter.isUnicodeLetter(firstChar) {
            
            return parseUnquotedAttributeValue(src, pos: pos, max: max)
        }
    }
    return nil
}


/// > An attribute name consists of an ASCII letter, _, or :,
/// > followed by zero or more ASCII letters, digits, _, ., :, or -.
/// > (Note: This is the XML specification restricted to ASCII. HTML5 is laxer.)
///
/// Note: in this method we parse any valid name we encounter from the position
/// that is given in the pos argument. We do not care of the global value of
/// the attribute definition at all.
///
func parseAttributeName(_ src: String, pos: Int, max: Int) -> (Int, Int)? {
    
    let firstChar = src.charAt(pos)
    
    if let firstChar = firstChar {
    
        // an ASCII letter, _, or :
        if !(UnicodeLetter.isUnicodeLetter(firstChar) || firstChar == §UnicodeCharacter.lowLine || firstChar == §UnicodeCharacter.colon) {
            return nil
        }
        
        // parse the rest of the attribute name
        for i in pos+1..<max {
            
            if let char = src.charAt(i) {
                
                if char == §UnicodeWhitespace.lineFeed {
                    return nil
                }
                
                // followed by zero or more ASCII letters, digits, _, ., :, or -.
                if !(UnicodeLetter.isUnicodeLetter(char)
                    || UnicodeDigit.isUnicodeDigit(char)
                    || char == §UnicodeCharacter.lowLine
                    || char == §UnicodeCharacter.colon) {
                    
                    return (pos, i)
                }
            }
            else {
                
                assert(false, "error: we are below max and the char is nil...")
                return (pos, i)
            }
        }
    }
    return nil
}

func parseId(_ src: String, pos: Int, max: Int) -> (indicator: Range<Int>, AttributeValueSegment)? {
    
    let numberSignIndex = pos
    
    let numberSign = src.charAt(numberSignIndex)
    
    if numberSign != nil {
        
        let unquotedAttributeValue = parseUnquotedAttributeValue(src, pos: pos+1, max: max)
        
        if let unquotedAttributeValue = unquotedAttributeValue {
            
            let numberSignRange = pos..<pos+1
            return (numberSignRange, unquotedAttributeValue)
        }
    }
    return nil
}

func parseLocalname(_ src: String, pos: Int, max: Int) -> Attribute? {
    
    assert(pos < max)
    let firstChar = src.charAt(pos)
    
    if let firstChar = firstChar {
        
        // an ASCII letter, _, or :
        if !UnicodeLetter.isUnicodeLetter(firstChar) {
            return nil
        }
        
        if pos+1 < max {
            
            for i in pos+1..<max {
                
                let char = src.charAt(i)
                
                if let char = char {
                    
                    if char == §UnicodeWhitespace.lineFeed {
                        return nil
                    }
                    
                    if !(UnicodeLetter.isUnicodeLetter(char)
                        || UnicodeDigit.isUnicodeDigit(char)
                        || char == §UnicodeCharacter.lowLine
                        || char == §UnicodeCharacter.hyphenMinus) {
                        
                        let valueString = src.substring(pos, length: i - pos)
                        
                        assert(valueString != nil)
                        if let valueString = valueString {
                            
                            let attributeValueSegment =  AttributeValueSegment(valueRange: pos..<i, valueString: valueString)
                            return Attribute(type: .elementName, nameString: nil, attributeValueSegment: attributeValueSegment)
                        }
                    }
                    
                    if UnicodeWhitespace.isUnicodeWhitespace(char) {
                        
                        // whitespaces of any kind are not allowed
                        return nil
                    }
                }
                else {
                    
                    assert(false, "error: nil character before max...")
                    return nil
                }
            }
        }
    }
    return nil
}

func parseUnquotedAttributeValue(_ src: String, pos: Int, max: Int) -> AttributeValueSegment? {
    
    // <= because we could be writing it
    assert(pos <= max)
    let firstChar = src.charAt(pos)
    
    if let firstChar = firstChar {
        
        // an ASCII letter, _, or :
        if !UnicodeLetter.isUnicodeLetter(firstChar) {
            return nil
        }
        
        if pos+1 < max {
            
            for i in pos+1...max {
                
                if i == max {
                    
                    // we have reach the maximum
                    let valueString = src.substring(pos, length: max - pos)
                    
                    assert(valueString != nil)
                    if let valueString = valueString {
                    
                        return AttributeValueSegment(valueRange: pos..<max, valueString: valueString)
                    }
                }
                
                let char = src.charAt(i)
                
                if let char = char {
                    
                    if char == §UnicodeWhitespace.lineFeed {
                        return nil
                    }
                    
                    if char == §UnicodeWhitespace.whitespace || char == §UnicodeWhitespace.characterTabulation || char == §UnicodeCharacter.rightCurlyBracket {
                        
                        let valueString = src.substring(pos, length: i - pos)
                        
                        assert(valueString != nil)
                        if let valueString = valueString {
                            
                            return AttributeValueSegment(valueRange: pos..<i, valueString: valueString)
                        }
                    }
                }
                else {
                    
                    assert(false, "error: nil character before max...")
                    return nil
                }
            }
        }
    }
    return nil
}

func parseWhitespaces(_ src: String, pos: inout Int, max: Int) {
    
    while src.charAt(pos, isEqualTo: §UnicodeCharacter.whitespace) {
        pos += 1
    }
}
