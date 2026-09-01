//
//  CSSReader.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-08.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Common

final class CSSReader: UnicodeStringReader {
    
    var comments: [CSSToken]
    
    override init(sourceString: NSString) {
        
        self.comments = [CSSToken]()
        
        super.init(sourceString: sourceString)
    }
    
    override func scan(_ characterIndex : Int) -> Token {
        
        // update current start index
        currentTokenStartIndex = nextInputCodePoint;
        
        // see http://dev.w3.org/csswg/css-syntax/#next-input-code-point
        var currentCodePoint = consumeNextInputCodePoint()
        
        
        //////////////////////////////////////////////////////////////////////////////////////////////////////////
        // START : COMMENT
        // see http://dev.w3.org/csswg/css-syntax/#consume-comments0
        // note : this simple test should be sufficient since there no
        // rule that is trigged with the "Solidus" code point
        if (currentCodePoint == §UnicodeCharacter.solidus) {
            
            var nextCodePoint = codePointAtLookAhead(1)
            if nextCodePoint == §UnicodeCharacter.asterisk {
            
                reconsumeCodePoint()
                
                var _currentCodePoint = currentCodePoint
                
                while _currentCodePoint == §UnicodeCharacter.solidus
                    && nextCodePoint == §UnicodeCharacter.asterisk {
                    
                    // for the moment, as specified by the standard we return nothing
                    // when consuming comments
                    let commentToken = consumeComments()
                    assert(commentToken is CSSToken)
                    if let commentToken = commentToken as? CSSToken {
                        comments.append(commentToken)
                    }
                    _currentCodePoint = consumeNextInputCodePoint()
                    nextCodePoint = codePointAtLookAhead(1)
                }
                
                // put the token value we are at in the currentCodePoint value
                // to properly evaluate it by the rest of the code.
                currentCodePoint = _currentCodePoint
                
                // reset the token start index.
                currentTokenStartIndex = nextInputCodePoint - 1
            }
        }
        // END :    COMMENT
        //////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        
        // whitespace
        // http://dev.w3.org/csswg/css-syntax/#whitespace
        if UnicodeWhitespace.isUnicodeWhitespace(currentCodePoint) {
            return consumeWhitespaces();
        }
            
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            // START : U+0022 QUOTATION MARK (")
            // Consume a string token
            // see http://dev.w3.org/csswg/css-syntax/#consume-a-string-token
        else if( currentCodePoint == §UnicodeCharacter.quotationMark) {
            return consumeAStringToken(currentCodePoint);
        }
            // END : U+0022 QUOTATION MARK (")
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            
            
            
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            // START : U+0023 NUMBER SIGN (#)
            // see http://dev.w3.org/csswg/css-syntax/#tokenizer-algorithms
        else if(currentCodePoint == §UnicodeCharacter.numberSign) {
            
            let firstNextCodePoint = codePointAtLookAhead(1)
            let secondNextCodePoint = codePointAtLookAhead(2)
            
            // If the next input code point is a name code point
            // or the next two input code points are a valid escape, then:
            if isNameCodePoint(firstNextCodePoint)
                || Unicode.checkIfTwoCodePointsAreAValidEscape(firstNextCodePoint, secondCodePoint: secondNextCodePoint) {
                
                // 1. Create a <hash-token>.
                // Nothing to do : done in accept method.
                
                let thirdNextCodePoint = codePointAtLookAhead(3);
                var type = String()
                
                // 2. If the next 3 input code points would start an identifier, set the <hash-token>’s type flag to "id".
                if (checkIfThreeCodePointsWouldStartAnIdentifier(firstNextCodePoint, secondCodePoint: secondNextCodePoint, thirdCodePoint: thirdNextCodePoint)) {
                    type = "id";
                }
                
                // 3. Consume a name, and set the <hash-token>’s value to the returned string.
                let (formattedString, _) = consumeAName();
                
                return acceptHashToken(§CSTokenId.hashToken, formattedString: formattedString, type: type);
                
            }
            else {
                return acceptTokenId(§CSTokenId.delimToken);
            }
        }
            // END : U+0023 NUMBER SIGN (#)
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            
            
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            // START : U+0024 DOLLAR SIGN ($)
        else if (currentCodePoint == §UnicodeCharacter.dollarSign) {
            
            let nextInputCodePoint = codePointAtLookAhead(1);
            
            if (nextInputCodePoint == §UnicodeCharacter.equalsSign) {
                consumeNextInputCodePoint();
                return acceptTokenId(§CSTokenId.suffixMatchToken);
            } else {
                return acceptTokenId(§CSTokenId.delimToken);
            }
        }
            // END : U+0024 DOLLAR SIGN ($)
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            
            
            
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            // START : U+0027 APOSTROPHE (')
        else if (currentCodePoint == §UnicodeCharacter.apostrophe) {
            return consumeAStringToken(currentCodePoint);
        }
            // END : U+0027 APOSTROPHE (')
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            
            
            
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            // START :  U+0028 LEFT PARENTHESIS (()
            
        else if (currentCodePoint == §UnicodeCharacter.leftParenthesis){
            return acceptTokenId(§CSTokenId.leftParenthesisToken);
        }
            // END :    U+0028 LEFT PARENTHESIS (()
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            
            
            
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            // START :  U+0029 RIGHT PARENTHESIS ())
            
        else if (currentCodePoint == §UnicodeCharacter.rightParenthesis){
            return acceptTokenId(§CSTokenId.rightParenthesisToken);
        }
            
            // END :    U+0029 RIGHT PARENTHESIS ())
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            
            
            
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            // START :  U+002A ASTERISK (*)
            
        else if (currentCodePoint == §UnicodeCharacter.asterisk){
            
            let nextInputCodePoint = codePointAtLookAhead(1);
            // *=
            if (nextInputCodePoint == §UnicodeCharacter.equalsSign) {
                // we consume the '=' sign
                consumeNextInputCodePoint();
                return acceptTokenId(§CSTokenId.substringMatchToken);
            }
            return acceptTokenId(§CSTokenId.delimToken);
        }
            
            // END :    U+002A ASTERISK (*)
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            
            
            
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            // START :  U+002B PLUS SIGN (+)
            
        else if (currentCodePoint == §UnicodeCharacter.plusSign) {
            
            let firstNextCodePoint = codePointAtLookAhead(1);
            let secondNextCodePoint = codePointAtLookAhead(2);
            
            // http://dev.w3.org/csswg/css-syntax/#starts-with-a-number
            if (checkIfThreeCodePointsWouldStartANumber(currentCodePoint, secondCodePoint: firstNextCodePoint, thirdCodePoint: secondNextCodePoint)) {
                
                reconsumeCodePoint();
                // see http://dev.w3.org/csswg/css-syntax/#consume-a-numeric-token
                return consumeANumericToken();
            }
            
            // Otherwise, return a <delim-token> with its value
            // set to the current input code point.
            return acceptTokenId(§CSTokenId.delimToken);
            
        }
            
            // END :    U+002B PLUS SIGN (+)
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            
            
            
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            // START :  U+002C COMMA (,)
            
        else if (currentCodePoint == §UnicodeCharacter.comma) {
            return acceptTokenId(§CSTokenId.commaToken);
        }
            
            // END :    U+002C COMMA (,)
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            
            
            
            
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            // START :  U+002D HYPHEN-MINUS (-)
            
        else if (currentCodePoint == §UnicodeCharacter.hyphenMinus) {
            
            let firstNextCodePoint = codePointAtLookAhead(1);
            let secondNextCodePoint = codePointAtLookAhead(2);
            
            // http://dev.w3.org/csswg/css-syntax/#starts-with-a-number
            if (checkIfThreeCodePointsWouldStartANumber(currentCodePoint, secondCodePoint: firstNextCodePoint, thirdCodePoint: secondNextCodePoint)) {
                reconsumeCodePoint();
                return consumeANumericToken();
            }
                // http://dev.w3.org/csswg/css-syntax/#would-start-an-identifier
            else if (checkIfThreeCodePointsWouldStartAnIdentifier(currentCodePoint, secondCodePoint: firstNextCodePoint, thirdCodePoint: secondNextCodePoint)) {
                reconsumeCodePoint();
                // see http://dev.w3.org/csswg/css-syntax/#consume-a-string-token
                return consumeAnIdentLikeToken();
            }
            else if (firstNextCodePoint == §UnicodeCharacter.hyphenMinus
                && secondNextCodePoint == §UnicodeCharacter.greaterThanSign) {
                consumeEscapedCodePoint();
                consumeEscapedCodePoint();
                return acceptTokenId(§CSTokenId.cdcToken);
            }
            return acceptTokenId(§CSTokenId.delimToken);
        }
            
            // END :    U+002D HYPHEN-MINUS (-)
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            
            
            
            
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            // START :  U+002E FULL STOP (.)
            
        else if (currentCodePoint == §UnicodeCharacter.fullStop) {
            
            let firstNextCodePoint = codePointAtLookAhead(1);
            let secondNextCodePoint = codePointAtLookAhead(2);
            
            if(checkIfThreeCodePointsWouldStartANumber(currentCodePoint, secondCodePoint: firstNextCodePoint, thirdCodePoint: secondNextCodePoint)) {
                reconsumeCodePoint();
                return consumeANumericToken();
            }
            return acceptTokenId(§CSTokenId.delimToken);
            
        }
            
            // END :    U+002E FULL STOP (.)
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            
            
            
            
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            // START :  U+003A COLON (:)
            
        else if (currentCodePoint == §UnicodeCharacter.colon) {
            return acceptTokenId(§CSTokenId.colonToken);
        }
            
            // END :    U+003A COLON (:)
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            
            
            
            
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            // START :  U+003B SEMICOLON (;)
            
        else if (currentCodePoint == §UnicodeCharacter.semiColon) {
            return acceptTokenId(§CSTokenId.semicolonToken);
        }
            
            // END :    U+003B SEMICOLON (;)
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            
            
            
            
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            // START :  U+003C LESS-THAN SIGN (<)
            
        else if (currentCodePoint == §UnicodeCharacter.lessThanSign) {
            
            let nextCodePoint = codePointAtLookAhead(1);
            let secondNextCodePoint = codePointAtLookAhead(2);
            let thirdNextCodePoint = codePointAtLookAhead(3);
            
            if (nextCodePoint == §UnicodeCharacter.exclamationMark
                && secondNextCodePoint == §UnicodeCharacter.hyphenMinus
                && thirdNextCodePoint == §UnicodeCharacter.hyphenMinus) {
                
                consumeNextInputCodePoint();
                consumeNextInputCodePoint();
                consumeNextInputCodePoint();
                
                return acceptTokenId(§CSTokenId.cdoToken);
            }
            
            return acceptTokenId(§CSTokenId.delimToken);
        }
            
            // END :    U+003C LESS-THAN SIGN (<)
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            
            
            
            
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            // START :  U+0040 COMMERCIAL AT (@)
            
        else if (currentCodePoint == §UnicodeCharacter.commercialAt) {
            
            let nextCodePoint = codePointAtLookAhead(1);
            let secondNextCodePoint = codePointAtLookAhead(2);
            let thirdNextCodePoint = codePointAtLookAhead(3);
            
            if (checkIfThreeCodePointsWouldStartAnIdentifier(nextCodePoint, secondCodePoint: secondNextCodePoint, thirdCodePoint: thirdNextCodePoint)) {
                let (name, _) = consumeAName();
                
                return acceptTokenIdAndFormattedString(§CSTokenId.atKeywordToken, formattedStringValue: name);
            }
            
            return acceptTokenId(§CSTokenId.delimToken);
        }
            
            // END :    U+0040 COMMERCIAL AT (@)
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            
            
            
            
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            // START :  U+005B LEFT SQUARE BRACKET ([)
            
        else if (currentCodePoint == §UnicodeCharacter.leftSquareBracket) {
            return acceptTokenId(§CSTokenId.leftSquareBracketToken);
        }
            
            // END :    U+005B LEFT SQUARE BRACKET ([)
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            
            
            
            
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            // START :  U+005C REVERSE SOLIDUS (\)
            
        else if (currentCodePoint == §UnicodeCharacter.reverseSolidus) {
            
            let nextCodePoint = codePointAtLookAhead(1);
            
            if (Unicode.checkIfTwoCodePointsAreAValidEscape(currentCodePoint, secondCodePoint: nextCodePoint)) {
                reconsumeCodePoint();
                return consumeAnIdentLikeToken();
            }
            return acceptTokenId(§CSTokenId.delimToken);
        }
            
            // END :    U+005C REVERSE SOLIDUS (\)
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            
            
            
            
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            // START :  U+005D RIGHT SQUARE BRACKET (])
            
        else if (currentCodePoint == §UnicodeCharacter.rightSquareBracket) {
            
            return acceptTokenId(§CSTokenId.rightSquareBracketToken);
        }
            
            // END :    U+005D RIGHT SQUARE BRACKET (])
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            
            
            
            
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            // START :  U+005E CIRCUMFLEX ACCENT (^)
            
        else if (currentCodePoint == §UnicodeCharacter.circumflexAccent) {
            
            let nextCodePoint = codePointAtLookAhead(1);
            
            if (nextCodePoint == §UnicodeCharacter.equalsSign) {
                consumeNextInputCodePoint();
                return acceptTokenId(§CSTokenId.prefixMatchToken);
            }
            return acceptTokenId(§CSTokenId.delimToken);
        }
            
            // END :    U+005E CIRCUMFLEX ACCENT (^)
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            
            
            
            
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            // START :  U+007B LEFT CURLY BRACKET ({)
            
        else if (currentCodePoint == §UnicodeCharacter.leftCurlyBracket) {
            return acceptTokenId(§CSTokenId.leftCurlyBraceToken);
        }
            
            // END :    U+007B LEFT CURLY BRACKET ({)
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            
            
            
            
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            // START :  U+007D RIGHT CURLY BRACKET (})
            
        else if (currentCodePoint == §UnicodeCharacter.rightCurlyBracket) {
            return acceptTokenId(§CSTokenId.rightCurlyBraceToken);
        }
            
            // END :    U+007D RIGHT CURLY BRACKET (})
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            
            
            
            
            
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            // START :  digit
            
        else if (UnicodeDigit.isUnicodeDigit(currentCodePoint)) {
            reconsumeCodePoint();
            return consumeANumericToken();
        }
            
            // END :    digit
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            
            
            
            
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            // START :  U+0055 LATIN CAPITAL LETTER U (U)
            //          U+0075 LATIN SMALL LETTER U (u)
            
        else if (currentCodePoint == §UnicodeLetter.U || currentCodePoint == §UnicodeLetter.u) {
            
            let nextCodePoint = codePointAtLookAhead(1);
            let secondNextCodePoint = codePointAtLookAhead(2);
            
            if (nextCodePoint == §UnicodeCharacter.plusSign && (UnicodeDigit.isUnicodeDigit(secondNextCodePoint)
                || secondNextCodePoint == §UnicodeCharacter.questionMark)) {
                
                consumeNextInputCodePoint();
                return consumeAUnicodeRangeToken();
            }
            else {
                reconsumeCodePoint();
                return consumeAnIdentLikeToken();
            }
            
        }
            
            // END :    U+0055 LATIN CAPITAL LETTER U (U)
            //          U+0075 LATIN SMALL LETTER U (u)
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            
            
            
            
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            // START :  name-start code point
            
            // see http://dev.w3.org/csswg/css-syntax/#name-start-code-point
        else if (isNameStartCodePoint(currentCodePoint)) {
            
            reconsumeCodePoint();
            return consumeAnIdentLikeToken();
        }
            
            // END :    name-start code point
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            
            
            
            
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            // START :  U+007C VERTICAL LINE (|)
            
        else if (currentCodePoint == §UnicodeCharacter.verticalLine) {
            
            let nextCodePoint = codePointAtLookAhead(1);
            
            if(nextCodePoint == §UnicodeCharacter.equalsSign) {
                consumeNextInputCodePoint();
                return acceptTokenId(§CSTokenId.dashMatchToken);
            }
            else if (nextCodePoint == §UnicodeCharacter.verticalLine) {
                consumeNextInputCodePoint();
                return acceptTokenId(§CSTokenId.columnToken);
            }
            return acceptTokenId(§CSTokenId.delimToken);
        }
            
            // END :    U+007C VERTICAL LINE (|)
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            
            
            
            
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            // START :  U+007E TILDE (~)
            
        else if (currentCodePoint == §UnicodeCharacter.tilde) {
            
            let nextCodePoint = codePointAtLookAhead(1);
            
            if(nextCodePoint == §UnicodeCharacter.equalsSign) {
                consumeNextInputCodePoint();
                return acceptTokenId(§CSTokenId.includeMatchToken);
            }
            return acceptTokenId(§CSTokenId.delimToken);
        }
            
            // END :    U+007E TILDE (~)
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            
            
            
            
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            // START :  EOF
            
        else if (currentCodePoint == §UnicodeCharacter.endOfText) {
            return acceptEof(§CSTokenId.cssEof);
        }
        
        // END :    EOF
        //////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        
        
        
        //////////////////////////////////////////////////////////////////////////////////////////////////////////
        // START :  anything else
        
        return acceptTokenId(§CSTokenId.delimToken);
        
        // END :    anything else
        //////////////////////////////////////////////////////////////////////////////////////////////////////////
    }
    
    // see http://dev.w3.org/csswg/css-syntax/#name-start-code-point
    func isNameStartCodePoint(_ codePoint: UniChar) -> Bool {
        
        if UnicodeLetter.isUnicodeLetter(codePoint)
            || Unicode.isNonAsciiCodePoint(codePoint)
            || codePoint == §UnicodeCharacter.lowLine {
            
            return true
        }
        
        return false
    }
    
    // see http://dev.w3.org/csswg/css-syntax/#starts-with-a-number
    func checkIfThreeCodePointsWouldStartANumber(
        _ firstCodePoint: UniChar,
        secondCodePoint: UniChar,
        thirdCodePoint: UniChar) -> Bool {
        
        // U+002B PLUS SIGN (+) or U+002D HYPHEN-MINUS (-)
        if (firstCodePoint == §UnicodeCharacter.plusSign
            || firstCodePoint == §UnicodeCharacter.hyphenMinus) {
            
            // If the second code point is a digit, return true.
            if UnicodeDigit.isUnicodeDigit(secondCodePoint) {
                return true;
            }
                
                // Otherwise, if the second code point is a U+002E FULL STOP (.)
                // and the third code point is a digit, return true.
            else if secondCodePoint == §UnicodeCharacter.fullStop
                && UnicodeDigit.isUnicodeDigit(thirdCodePoint) {
                return true;
            }
            
            // Otherwise, return false.
            return false;
        }
            
            // U+002E FULL STOP (.)
        else if (secondCodePoint == §UnicodeCharacter.fullStop) {
            
            // If the second code point is a digit, return true.
            if UnicodeDigit.isUnicodeDigit(secondCodePoint) {
                return  true;
            }
            
            // Otherwise, return false.
            return false;
        }
            
            // digit
        else if (UnicodeDigit.isUnicodeDigit(firstCodePoint)) {
            return true;
        }
        
        // anything else
        return false;
    }
    
    // FIXME : this method should not be necessary when
    // we will convert the accept token to accept a Token parameter,
    // that it will after populate with common token information.
    func acceptHashToken(_ tokenId: Int, formattedString: String, type: String) -> HashToken {
        
        return HashToken(sourceStringSegment: position(),
                         tokenId: tokenId,
                         rawStringValue: rawStringValue(),
                         formattedString: formattedString,
                         type: type)
    }
    
    // FIXME : this method should not be necessary when
    // we will converted the accept token to accept a Token parameter,
    // that it will after populate with common token information.
    func acceptHashToken(_ tokenId: Int, type: String) -> HashToken {
        
        return HashToken(
            sourceStringSegment: position(),
            tokenId: tokenId,
            rawStringValue: rawStringValue(),
            type: type)
    }
    
    // Consume a numeric token
    // see http://dev.w3.org/csswg/css-syntax/#consume-a-numeric-token
    func consumeANumericToken() -> Token {
        
        let (number, numberSegment) = consumeANumber()
        
        let firstCodePoint = codePointAtLookAhead(1)
        let secondCodePoint = codePointAtLookAhead(2)
        let thirdCodePoint = codePointAtLookAhead(3)
        
        if (checkIfThreeCodePointsWouldStartAnIdentifier(firstCodePoint, secondCodePoint: secondCodePoint, thirdCodePoint: thirdCodePoint)) {
            
            let (unit, nameSegment) =  consumeAName()
            
            // the tokenId is automatically set by this constructor
            return DimensionToken(
                sourceStringSegment: position(),
                numberSegment: numberSegment,
                unitSegment: nameSegment,
                tokenId: §CSTokenId.dimensionToken,
                rawStringValue: rawStringValue(),
                number: number,
                unit: unit)
        }
            
        else if (firstCodePoint == §UnicodeCharacter.percentageSign) {
            consumeNextInputCodePoint()
            
            return acceptNumberToken(§CSTokenId.percentageToken, number: number)
        }
        else {
            
            return acceptNumberToken(§CSTokenId.numberToken, number: number)
        }
        
    }
    
    func acceptNumberToken(_ tokenId: Int, number: Number) -> NumberToken {
        
        return NumberToken(sourceStringSegment: position(), tokenId: tokenId, rawStringValue: rawStringValue(), number: number);
    }
    
    func acceptPourcentageToken(_ tokenId: Int, number: Number) -> PourcentageToken {
        
        return PourcentageToken(sourceStringSegment: position(), tokenId: tokenId, rawStringValue: rawStringValue(), number: number);
    }
    
    
    // see http://dev.w3.org/csswg/css-syntax/#consume-a-name
    func consumeAName() -> (String, SourceStringSegment) {
        
        var name = String()
        
        let startNameIndex = self.nextInputCodePoint
        var codePoint = consumeNextInputCodePoint()
        var nextCodePoint = codePointAtLookAhead(1)
        
        while (true) {
            
            // name code point
            if (isNameCodePoint(codePoint)) {
                
                name.append(codePoint)
            }
            // the stream starts with a valid escape
            else if Unicode.checkIfTwoCodePointsAreAValidEscape(codePoint, secondCodePoint: nextCodePoint) {
                
                let formattedCodePointValue = consumeEscapedCodePoint()
                name.append(formattedCodePointValue)
            }
            // DEVIATION
            else if(codePoint == §UnicodeCharacter.endOfText) {
                
                let nameSegment = SourceStringSegment(startIntegerIndex: startNameIndex, endIntegerIndex: startNameIndex + name.count)
                return (name, nameSegment)
            }
            // anything else
            else {
                reconsumeCodePoint()
                
                let nameSegment = SourceStringSegment(startIntegerIndex: startNameIndex, endIntegerIndex: startNameIndex + name.count)
                return (name, nameSegment)
            }
            
            codePoint = consumeNextInputCodePoint()
            nextCodePoint = codePointAtLookAhead(1)
        }
    }
    
    // see http://dev.w3.org/csswg/css-syntax/#name-code-point
    func isNameCodePoint(_ codePoint: UniChar) -> Bool {
        
        if (isNameStartCodePoint(codePoint)
            || UnicodeDigit.isUnicodeDigit(codePoint)
            || codePoint == §UnicodeCharacter.hyphenMinus) {
            return true;
        }
        return false;
    }
    
    /**
     *  Method to consume comments
     *  see http://dev.w3.org/csswg/css-syntax/#consume-comments0
     */
    func consumeComments() -> Token {
        
        var firstNextInputCodePoint = codePointAtLookAhead(1)
        var secondNextInputCodePoint = codePointAtLookAhead(2)
        
        if (firstNextInputCodePoint == §UnicodeCharacter.solidus
            && secondNextInputCodePoint == §UnicodeCharacter.asterisk) {
            
            // consume the /* characters
            consumeNextInputCodePoint()
            consumeNextInputCodePoint()
            
            while (true) {
                
                firstNextInputCodePoint = codePointAtLookAhead(1)
                secondNextInputCodePoint = codePointAtLookAhead(2)
                
                if (firstNextInputCodePoint == §UnicodeCharacter.asterisk
                    && secondNextInputCodePoint == §UnicodeCharacter.solidus) {
                    
                    consumeNextInputCodePoint()
                    consumeNextInputCodePoint()
                    break
                }
                    
                else if (firstNextInputCodePoint == §UnicodeCharacter.endOfText) {
                    break
                }
                
                consumeNextInputCodePoint()
            }
        }
        
        return acceptTokenId(§CSTokenId.commentToken);
    }
    
    // see http://dev.w3.org/csswg/css-syntax/#consume-a-unicode-range-token
    func consumeAUnicodeRangeToken() -> Token {
        
        var startOfRange = String()
        var endOfRange = String()
        
        // Consume as many hex digits as possible, but no more than 6.
        for  _ in 0..<6 {
            
            let character = consumeNextInputCodePoint();
            
            if (UnicodeHexDigit.isUnicodeHexDigit(character)) {
                
                startOfRange.append(character)
                endOfRange.append(character)
                
            } else if (character == §UnicodeCharacter.questionMark) {
                
                startOfRange.append(§UnicodeCharacter.zero)
                endOfRange.append(§UnicodeCharacter.latinCapitalLetterF)
                
            } else {
                
                // Unexpected character while parsing unicode range
                
                let startOfRangeCodePoint = characterValueFromHexStringValue(startOfRange);
                let endOfRangeCodePoint = characterValueFromHexStringValue(endOfRange);
                
                var unicodeRangeToken = UnicodeRangeToken(
                    sourceStringSegment: position(),
                    rawStringValue: rawStringValue(),
                    startOfRange: startOfRangeCodePoint,
                    endOfRange: endOfRangeCodePoint);
                
                unicodeRangeToken.messageHandler.addMessage(MessageCode.unexpectedCharacterInUnicodeRange)
                
                return unicodeRangeToken
            }
        }
        
        var firstNextInputCodePoint = codePointAtLookAhead(1);
        let secondNextInputCodePoint = codePointAtLookAhead(2);
        
        if (firstNextInputCodePoint == §UnicodeCharacter.hyphenMinus && UnicodeHexDigit.isUnicodeHexDigit(secondNextInputCodePoint)) {
            
            endOfRange = ""
            consumeNextInputCodePoint();
            
            for _ in 0..<6 {
                firstNextInputCodePoint = codePointAtLookAhead(1);
                
                if (UnicodeHexDigit.isUnicodeHexDigit(firstNextInputCodePoint)) {
                    
                    let character = consumeNextInputCodePoint();
                    endOfRange.append(character)
                } else {
                    break;
                }
            }
        } else {
            endOfRange = startOfRange;
        }
        
        let startOfRangeCodePoint = characterValueFromHexStringValue(startOfRange);
        let endOfRangeCodePoint = characterValueFromHexStringValue(endOfRange);
        
        return UnicodeRangeToken(
            sourceStringSegment: position(),
            rawStringValue: rawStringValue(),
            startOfRange: startOfRangeCodePoint,
            endOfRange: endOfRangeCodePoint);
    }
    
    
    // see http://dev.w3.org/csswg/css-syntax/#consume-a-url-token
    func consumeAURLToken() -> Token {
        
        var url = String()
        
        // consume whitespaces but we don't care about the result
        consumeWhitespaces()
        
        var nextInputCodePoint = codePointAtLookAhead(1)
        
        if (nextInputCodePoint == §UnicodeCharacter.endOfText) {
            return acceptTokenIdAndFormattedString(§CSTokenId.urlToken, formattedStringValue: url)
        }
        else if (nextInputCodePoint == §UnicodeCharacter.quotationMark
            || nextInputCodePoint == §UnicodeCharacter.apostrophe) {
            
            consumeNextInputCodePoint();
            let stringToken = consumeAStringToken(nextInputCodePoint);
            
            if (stringToken.tokenId == §CSTokenId.badStringToken) {
                
                // see http://dev.w3.org/csswg/css-syntax/#consume-the-remnants-of-a-bad-url
                consumeTheRemnantsOfABadURL();
                return acceptTokenId(§CSTokenId.badUrlToken);
            }
            
            url = stringToken.formattedStringValue!
            
            // consume whitespaces but we don't care about the result
            consumeWhitespaces()
            
            nextInputCodePoint = codePointAtLookAhead(1);
            
            // If the next input code point is U+0029 RIGHT PARENTHESIS ()) or EOF, consume it and return the <url-token>
            if (nextInputCodePoint == §UnicodeCharacter.rightParenthesis || nextInputCodePoint == §UnicodeCharacter.endOfText) {
                consumeNextInputCodePoint();
                return acceptTokenIdAndFormattedString(§CSTokenId.urlToken, formattedStringValue: url);
            }
                // otherwise, consume the remnants of a bad url, create a <bad-url-token>, and return it.
            else {
                // see http://dev.w3.org/csswg/css-syntax/#consume-the-remnants-of-a-bad-url
                consumeTheRemnantsOfABadURL();
                return acceptTokenId(§CSTokenId.badUrlToken);
            }
        }
        
        while (true) {
            
            let character = consumeNextInputCodePoint();
            
            if (character == §UnicodeCharacter.rightParenthesis || character == §UnicodeCharacter.endOfText) {
                return acceptTokenIdAndFormattedString(§CSTokenId.urlToken, formattedStringValue: url);
            }
            else if (UnicodeWhitespace.isUnicodeWhitespace(character)) {
                
                consumeWhitespaces()
                nextInputCodePoint = codePointAtLookAhead(1);
                
                if (nextInputCodePoint == §UnicodeCharacter.rightParenthesis || nextInputCodePoint == §UnicodeCharacter.endOfText) {
                    consumeNextInputCodePoint();
                    return acceptTokenIdAndFormattedString(§CSTokenId.urlToken, formattedStringValue: url);
                }
                    // otherwise, consume the remnants of a bad url, create a <bad-url-token>, and return it.
                else {
                    
                    // see http://dev.w3.org/csswg/css-syntax/#consume-the-remnants-of-a-bad-url
                    consumeTheRemnantsOfABadURL();
                    return acceptTokenId(§CSTokenId.badUrlToken);
                }
            }
            else if (character == §UnicodeCharacter.quotationMark
                || character == §UnicodeCharacter.apostrophe
                || character == §UnicodeCharacter.leftParenthesis
                || Unicode.isNonPrintableCodePoint(character)) {
                
                // see http://dev.w3.org/csswg/css-syntax/#consume-the-remnants-of-a-bad-url
                consumeTheRemnantsOfABadURL();
                return acceptTokenId(§CSTokenId.badUrlToken);
            }
                // U+005C REVERSE SOLIDUS
            else if (character == §UnicodeCharacter.reverseSolidus) {
                
                nextInputCodePoint = codePointAtLookAhead(1);
                
                if Unicode.checkIfTwoCodePointsAreAValidEscape(character, secondCodePoint: nextInputCodePoint) {
                    consumeEscapedCodePoint()
                }
                else {
                    // see http://dev.w3.org/csswg/css-syntax/#consume-the-remnants-of-a-bad-url
                    consumeTheRemnantsOfABadURL();
                    return acceptTokenId(§CSTokenId.badUrlToken);
                }
            }
            url.append(character)
        }
    }
    
    // see http://dev.w3.org/csswg/css-syntax/#consume-the-remnants-of-a-bad-url
    func consumeTheRemnantsOfABadURL() {
        
        while (true) {
            
            let codePoint = consumeNextInputCodePoint()
            let nextCodePoint = codePointAtLookAhead(1)
            
            if (codePoint == §UnicodeCharacter.rightParenthesis || codePoint == §UnicodeCharacter.endOfText) {
                return;
            }
            else if Unicode.checkIfTwoCodePointsAreAValidEscape(codePoint, secondCodePoint: nextCodePoint) {
                // see http://dev.w3.org/csswg/css-syntax/#consume-an-escaped-code-point
                consumeEscapedCodePoint();
            }
        }
    }
    
    // see http://dev.w3.org/csswg/css-syntax/#consume-an-ident-like-token
    func consumeAnIdentLikeToken() -> Token {
        
        let (name, _) = consumeAName()
        
        let nextInputCodePoint = codePointAtLookAhead(1)
        
        if (isASCIICaseInsensitive(name, matchString: "url")
            && nextInputCodePoint == §UnicodeCharacter.leftParenthesis) {
            consumeNextInputCodePoint()
            return consumeAURLToken()
        }
        else if(nextInputCodePoint == §UnicodeCharacter.leftParenthesis) {
            
            // consume the left parenthesis
            consumeNextInputCodePoint()
            
            // accept the token from the name to the left parenthesis.
            return acceptTokenIdAndFormattedString(§CSTokenId.functionToken, formattedStringValue: name)
        }
        else {
            return acceptTokenIdAndFormattedString(§CSTokenId.identToken, formattedStringValue: name)
        }
        
    }
    
    // see http://dev.w3.org/csswg/css-syntax/#ascii-case-insensitive
    func isASCIICaseInsensitive(_ name: String, matchString: String) -> Bool {
        
        return name.lowercased() == matchString.lowercased()
    }
    
    // "Consume as much whitespace as possible.
    // Return a <whitespace-token>."
    // see http://dev.w3.org/csswg/css-syntax/#whitespace
    @discardableResult
    func consumeWhitespaces() -> Token {
        
        var nextInputCodePoint = codePointAtLookAhead(1)
        
        while (UnicodeWhitespace.isUnicodeWhitespace(nextInputCodePoint)) {
            consumeNextInputCodePoint();
            nextInputCodePoint = codePointAtLookAhead(1)
        }
        
        return acceptTokenId(§CSTokenId.whitespaceToken)
    }
    
    // see http://dev.w3.org/csswg/css-syntax/#consume-a-string-token
    func consumeAStringToken(_ endingCodePoint: UniChar) -> Token {
        
        // we have consumed a " code point, now we try to parse the string
        // value.
        
        var formattedStringValue = String()
        
        while (true) {
            
            let codePoint = consumeNextInputCodePoint();
            
            if(codePoint == §UnicodeCharacter.endOfText || codePoint == endingCodePoint) {
                
                return acceptTokenIdAndFormattedString(§CSTokenId.stringToken, formattedStringValue: formattedStringValue);
            }
            else if(codePoint == §UnicodeCharacter.lineFeed) {
                reconsumeCodePoint();
                return acceptTokenIdAndFormattedString(§CSTokenId.badStringToken, formattedStringValue: formattedStringValue);
            }
            else if(codePoint == §UnicodeCharacter.reverseSolidus) {
                
                let nextCodePoint = codePointAtLookAhead(1);
                
                if(nextCodePoint == §UnicodeCharacter.endOfText) {
                    acceptTokenId(§CSTokenId.cssEof);
                }
                else if(nextCodePoint == §UnicodeCharacter.lineFeed) {
                    consumeNextInputCodePoint();
                }
                    // it is a valid escape
                    // see http://dev.w3.org/csswg/css-syntax/#check-if-two-code-points-are-a-valid-escape
                else {
                    
                    // TODO calculate the code point value and happened this
                    // value to the calculatedStringValueof the eventual CSToken
                    let formattedCodePointValue = consumeEscapedCodePoint()
                    formattedStringValue.append(formattedCodePointValue)
                }
            }
            else {
                formattedStringValue.append(codePoint)
            }
        }
    }
    
    // see http://dev.w3.org/csswg/css-syntax/#would-start-an-identifier
    func checkIfThreeCodePointsWouldStartAnIdentifier(_ firstCodePoint: UniChar, secondCodePoint: UniChar, thirdCodePoint: UniChar) -> Bool {
        
        // U+002D HYPHEN-MINUSv
        if (firstCodePoint == §UnicodeCharacter.hyphenMinus) {
            
            if(isNameStartCodePoint(secondCodePoint)
                || secondCodePoint == §UnicodeCharacter.hyphenMinus
                || Unicode.checkIfTwoCodePointsAreAValidEscape(secondCodePoint, secondCodePoint: thirdCodePoint)) {
                return true;
            }
            
            return false;
        }
            
            // name-start code point
        else if (isNameStartCodePoint(firstCodePoint)) {
            return true;
        }
            
            // U+005C REVERSE SOLIDUS (\)
        else if(firstCodePoint == §UnicodeCharacter.reverseSolidus) {
            
            if (Unicode.checkIfTwoCodePointsAreAValidEscape(firstCodePoint, secondCodePoint: secondCodePoint)) {
                return true;
            }
            return false;
        }
        // anything else
        return false;
    }
    
    // http://dev.w3.org/csswg/css-syntax/#consume-a-number
    func consumeANumber() -> (Number, SourceStringSegment) {
        
        var stringRepresentation = String()
        
        // 1. Initially set repr to the empty string and type to "integer".
        var numberType = NumberType.integer
        
        var numberStartIndex = self.currentTokenStartIndex
        
        var nextCodePoint = codePointAtLookAhead(1);
        
        // 2. If the next input code point is U+002B PLUS SIGN (+)
        // or U+002D HYPHEN-MINUS (-),
        if (nextCodePoint == §UnicodeCharacter.plusSign
            || nextCodePoint == §UnicodeCharacter.hyphenMinus) {
            
            // consume it and append it to repr.
            consumeNextInputCodePoint()
            stringRepresentation.append(nextCodePoint)
            // update the next input code point since we have consumed
            // the last one.
            nextCodePoint = codePointAtLookAhead(1);
        }
        
        // 3. While the next input code point is a digit, consume it and append it to repr.
        while (UnicodeDigit.isUnicodeDigit(nextCodePoint)) {
            consumeNextInputCodePoint();
            stringRepresentation.append(nextCodePoint)
            nextCodePoint = codePointAtLookAhead(1);
        }
        
        var secondNextCodePoint = codePointAtLookAhead(2);
        
        // 4. If the next 2 input code points are U+002E FULL STOP (.) followed by a digit, then:
        if(nextCodePoint == §UnicodeCharacter.fullStop
            && UnicodeDigit.isUnicodeDigit(secondNextCodePoint)) {
            
            // 1. Consume them.
            // 2. Append them to repr.
            consumeNextInputCodePoint();
            stringRepresentation.append(nextCodePoint)
            consumeNextInputCodePoint();
            stringRepresentation.append(secondNextCodePoint)
            
            // 3. Set type to "number".
            numberType = NumberType.real
            
            // repoint next input code point to the next codepoint.
            nextCodePoint = codePointAtLookAhead(1);
            
            // 4. While the next input code point is a digit, consume it and append it to repr.
            while (UnicodeDigit.isUnicodeDigit(nextCodePoint)) {
                consumeNextInputCodePoint();
                stringRepresentation.append(nextCodePoint)
                nextCodePoint = codePointAtLookAhead(1);
            }
        }
        
        nextCodePoint = codePointAtLookAhead(1);
        secondNextCodePoint = codePointAtLookAhead(2);
        let thirdNextCodePoint = codePointAtLookAhead(3);
        
        // 5. If the next 2 or 3 input code points are U+0045 LATIN CAPITAL LETTER E (E)
        // or U+0065 LATIN SMALL LETTER E (e), optionally followed by U+002D HYPHEN-MINUS (-)
        // or U+002B PLUS SIGN (+), followed by a digit, then:
        
        if (nextCodePoint == §UnicodeCharacter.latinCapitalLetterE || nextCodePoint == §UnicodeCharacter.latinSmallLetterE) {
            
            if ((secondNextCodePoint == §UnicodeCharacter.plusSign || secondNextCodePoint == §UnicodeCharacter.hyphenMinus)
                && UnicodeDigit.isUnicodeDigit(thirdNextCodePoint)) {
                
                // 1. Consume them.
                // 2. Append them to repr.
                consumeNextInputCodePoint();
                stringRepresentation.append(nextCodePoint)
                consumeNextInputCodePoint();
                stringRepresentation.append(secondNextCodePoint)
                consumeNextInputCodePoint();
                stringRepresentation.append(thirdNextCodePoint)
                
                // 3. Set type to "number".
                numberType = NumberType.real
                
                // repoint next input code point to the next codepoint.
                nextCodePoint = codePointAtLookAhead(1);
                
                // 4. While the next input code point is a digit, consume it and append it to repr.
                while (UnicodeDigit.isUnicodeDigit(nextCodePoint)) {
                    consumeNextInputCodePoint();
                    stringRepresentation.append(nextCodePoint)
                    nextCodePoint = codePointAtLookAhead(1);
                }
            }
                
                // there is no U+002D HYPHEN-MINUS (-) or U+002B PLUS SIGN (+)
            else if (UnicodeDigit.isUnicodeDigit(secondNextCodePoint)) {
                // 1. Consume them.
                // 2. Append them to repr.
                consumeNextInputCodePoint();
                stringRepresentation.append(nextCodePoint)
                
                consumeNextInputCodePoint();
                stringRepresentation.append(secondNextCodePoint)
                
                // 3. Set type to "number".
                numberType = NumberType.real
                
                // repoint next input code point to the next codepoint.
                nextCodePoint = codePointAtLookAhead(1);
                
                // 4. While the next input code point is a digit, consume it and append it to repr.
                while (UnicodeDigit.isUnicodeDigit(nextCodePoint)) {
                    consumeNextInputCodePoint();
                    stringRepresentation.append(nextCodePoint)
                    nextCodePoint = codePointAtLookAhead(1);
                }
            }
        }
        
        let numberSegment = SourceStringSegment(startIntegerIndex: numberStartIndex, endIntegerIndex: numberStartIndex + stringRepresentation.length)
        
        // 6. Convert repr to a number, and set the value to the returned value.
        // see http://dev.w3.org/csswg/css-syntax/#convert-a-string-to-a-number
        return (convertAStringToANumber(stringRepresentation as NSString, type: numberType), numberSegment)
    }
    
    // Convert a string to a number
    // see http://dev.w3.org/csswg/css-syntax/#convert-a-string-to-a-number
    /**
     see http://dev.w3.org/csswg/css-syntax/#convert-a-string-to-a-number
     
     :test:
     
     */
    func convertAStringToANumber(_ rawString: NSString, type: NumberType) -> Number {

        var index: Int = 0
        
        var s: Double = 1;
        
        var nextCodePointOption: UniChar?  = rawString.character(at: index)
        index += 1
        
        if let nextCodePoint = nextCodePointOption {
            
            // 2. If the next input code point is U+002B PLUS SIGN (+)
            // or U+002D HYPHEN-MINUS (-),
            if (nextCodePoint == §UnicodeCharacter.plusSign
                || nextCodePoint == §UnicodeCharacter.hyphenMinus) {
                
                if (nextCodePoint == §UnicodeCharacter.hyphenMinus) {
                    s = -1;
                }
                // otherwise the default value take into account
                // the default plus sign if there is nothing.
                
                // update the next input code point since we have consumed
                // the last one.
                nextCodePointOption = rawString.character(at: index)
                index += 1
            }
        }
        // string to contain the integral part of the number
        var integralStringNumberPart = String()
        
        while let nextCodePoint = nextCodePointOption {
            
            // 3. While the next input code point is a digit, consume it and append it to repr.
            if UnicodeDigit.isUnicodeDigit(nextCodePoint) {
                integralStringNumberPart.append(nextCodePoint)
                if index < rawString.length {
                    nextCodePointOption = rawString.character(at: index)
                    index += 1
                }
                else {
                    nextCodePointOption = nil
                }
            } else {
                break
            }
        }
        
        var i: Double = 0
        
        // convert  the integral part to a number
        if let number = createIntegerNumberFromString(integralStringNumberPart){
            
            i = Double(number)
        }
        else {
            
            // Unable to convert number
            var number = Number(sourceStringSegment: position())
            number.messageHandler.addMessage(MessageCode.unableToConvertNumber)
            return number
        }
        
        var secondNextCodePointOption: unichar?
        
        if index < rawString.length {
            
            secondNextCodePointOption = rawString.character(at: index)
            index += 1
        }
        
        // declare a fractional part.
        var f: Double = 0;
        var d: Double = 0;
        
        if let nextCodePoint = nextCodePointOption {
            
            if let secondNextCodePoint = secondNextCodePointOption {
                
                // 4. If the next 2 input code points are U+002E FULL STOP (.) followed by a digit, then:
                if nextCodePoint == §UnicodeCharacter.fullStop
                    && UnicodeDigit.isUnicodeDigit(secondNextCodePoint)  {
                    
                    var fractionalStringNumberPart = String()
                    
                    // update the next input code point to point to the first digit
                    nextCodePointOption = secondNextCodePointOption
                    
                    while let nextCodePointPossibleDigit = nextCodePointOption {
                        
                        // 3. While the next input code point is a digit, consume it and append it to repr.
                        if UnicodeDigit.isUnicodeDigit(nextCodePointPossibleDigit) {
                            fractionalStringNumberPart.append(nextCodePointPossibleDigit)
                            d += 1
                            if index < rawString.length {
                                nextCodePointOption = rawString.character(at: index)
                                index += 1
                            }
                            else {
                                nextCodePointOption = nil
                            }
                        } else {
                            break
                        }
                    }
                    
                    if let number = createIntegerNumberFromString(fractionalStringNumberPart){
                        
                        f = Double(number)
                    }
                    else {
                        
                        var number = Number(sourceStringSegment: position())
                        number.messageHandler.addMessage(MessageCode.unableToConvertNumber)
                        return number
                    }
                }
            }
        }
        
        // update second next code point
        if index < rawString.length {
            
            secondNextCodePointOption = rawString.character(at: index)
            index += 1
        }
        else {
            
            secondNextCodePointOption = nil
        }
        
        // update third next code point
        var thirdNextCodePointOption: unichar? = nil
        
        if index < rawString.length {
            
            thirdNextCodePointOption = rawString.character(at: index)
            index += 1
        }
        
        // 5. If the next 2 or 3 input code points are U+0045 LATIN CAPITAL LETTER E (E)
        // or U+0065 LATIN SMALL LETTER E (e), optionally followed by U+002D HYPHEN-MINUS (-)
        // or U+002B PLUS SIGN (+), followed by a digit, then:
        
        var t: Int = 1
        
        var exponentPart: Double = 0
        
        if let exponenentSignCharacter = nextCodePointOption {
            
            if let secondNextCodePoint = secondNextCodePointOption {
                
                if (exponenentSignCharacter == §UnicodeCharacter.latinCapitalLetterE
                    || exponenentSignCharacter == §UnicodeCharacter.latinSmallLetterE) {
                    
                    if let thirdNextCodePoint = thirdNextCodePointOption {
                        
                        
                        if ((secondNextCodePoint == §UnicodeCharacter.plusSign
                            || secondNextCodePoint == §UnicodeCharacter.hyphenMinus)
                            && UnicodeDigit.isUnicodeDigit(thirdNextCodePoint)) {
                            
                            // now we can look at the exponent sign
                            if (secondNextCodePoint == §UnicodeCharacter.hyphenMinus) {
                                t = -1;
                            }
                            
                            var exponentStringNumberPart = String()
                            
                            nextCodePointOption = thirdNextCodePointOption;
                            
                            while let nextCodePoint = nextCodePointOption {
                                
                                // 4. While the next input code point is a digit, consume it and append it to repr.
                                if UnicodeDigit.isUnicodeDigit(nextCodePoint) {
                                    exponentStringNumberPart.append(nextCodePoint)
                                    if index < rawString.length {
                                        
                                        nextCodePointOption = rawString.character(at: index)
                                        index += 1
                                    }
                                    else {
                                        
                                        nextCodePointOption = nil
                                    }
                                } else {
                                    break
                                }
                            }
                            
                            if let integerValue = createIntegerNumberFromString(exponentStringNumberPart) {
                                
                                exponentPart = Double(integerValue)
                            }
                            else {
                                
                                // Unexpected character while parsing unicode range
                                var number = Number(sourceStringSegment: position())
                                number.messageHandler.addMessage(MessageCode.unableToConvertNumber)
                                return number
                            }
                        }
                            // there is no U+002D HYPHEN-MINUS (-) or U+002B PLUS SIGN (+)
                        else if (UnicodeHexDigit.isUnicodeHexDigit(secondNextCodePoint)) {
                            
                            var exponentStringNumberPart = String()
                            
                            // start from the second input code point
                            nextCodePointOption = secondNextCodePointOption;
                            
                            while let nextCodePoint = nextCodePointOption {
                                
                                // 4. While the next input code point is a digit, consume it and append it to repr.
                                if UnicodeDigit.isUnicodeDigit(nextCodePoint) {
                                    exponentStringNumberPart.append(nextCodePoint)
                                    if index < rawString.length {
                                        nextCodePointOption = rawString.character(at: index)
                                        index += 1
                                    }
                                    else {
                                        nextCodePointOption = nil
                                    }
                                } else {
                                    break
                                }
                            }
                            
                            // convert  the integral part to a number
                            if let number = createIntegerNumberFromString(exponentStringNumberPart){
                                
                                exponentPart = Double(number)
                            }
                            else {
                                
                                // Unable to convert number
                                var number = Number(sourceStringSegment: position())
                                number.messageHandler.addMessage(MessageCode.unableToConvertNumber)
                                return number
                            }
                        }
                    }
                        // there is no U+002D HYPHEN-MINUS (-) or U+002B PLUS SIGN (+)
                    else if (UnicodeDigit.isUnicodeDigit(secondNextCodePoint)) {
                        
                        var exponentStringNumberPart = String()
                        
                        // start from the second input code point
                        nextCodePointOption = secondNextCodePointOption;
                        
                        while let nextCodePoint = nextCodePointOption {                            
                            
                            // 4. While the next input code point is a digit, consume it and append it to repr.
                            if UnicodeDigit.isUnicodeDigit(nextCodePoint) {
                                exponentStringNumberPart.append(nextCodePoint)
                                if index < rawString.length {
                                    
                                    nextCodePointOption = rawString.character(at: index)
                                    index += 1
                                }
                                else {
                                    nextCodePointOption = nil
                                }
                            } else {
                                break
                            }
                        }
                        
                        // convert  the integral part to a number
                        if let number = createIntegerNumberFromString(exponentStringNumberPart){
                            
                            exponentPart = Double(number)
                        }
                        else {
                            
                            // Unable to convert number
                            var number = Number(sourceStringSegment: position())
                            number.messageHandler.addMessage(MessageCode.unableToConvertNumber)
                            return number
                        }
                    }
                }
            }
        }
        
        let ten = Double(10)
        
        let powerTenD: Double = Double(pow(ten,d))
        let powerTenExponentPart: Double = Double(pow(ten, exponentPart))
        
        let double: Double = Double(f*(1/powerTenD))
        
        let firstPart: Double = Double(i) + double
        
        switch (type) {
            
        case .integer:
            if t > 0 {
                return Number(numberType: NumberType.integer, value: (s*(firstPart))*powerTenExponentPart)
            } else {
                return Number(numberType: NumberType.integer, value: (s*(firstPart))*1/powerTenExponentPart)
            }
        case .real:
            if t > 0  {
                return Number(numberType: NumberType.real, value: (s*(firstPart))*powerTenExponentPart)
            } else {
                return Number(numberType: NumberType.real, value: (s*(firstPart))*1/powerTenExponentPart)
            }
            
        case .nil:
            
            var number = Number(sourceStringSegment: position())
            number.messageHandler.addMessage(MessageCode.unableToConvertNumber)
            return number
        }
    }
    
    func acceptEof(_ tokenId: Int) -> Token {
        
        // the end position starts and end to the same token index.
        let endPosition = SourceStringSegment(startIndex: currentTokenStartIndex, endIndex: currentTokenStartIndex)
        
        return CSSToken(
            sourceStringSegment: endPosition,
            tokenId: tokenId,
            rawStringValue: "EOF")
    }
    
    @discardableResult
    func acceptTokenId(_ tokenId: Int) -> Token {
        
        return CSSToken(
            sourceStringSegment: position(),
            tokenId: tokenId,
            rawStringValue: rawStringValue())
    }
    
    @discardableResult
    func acceptTokenIdAndFormattedString(_ tokenId: Int, formattedStringValue: String) -> Token {
        
        return CSSToken(
            sourceStringSegment: position(),
            tokenId: tokenId,
            rawStringValue: rawStringValue(),
            formattedStringValue: formattedStringValue)
    }
}
