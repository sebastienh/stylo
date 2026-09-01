//
//  LineStreamReader.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-11.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common

open class UnicodeStringReader: StringReader {
    
    // This variable keeps the position in the current input string
    // of the next code point position in the string as a location
    // value.
    // see http://dev.w3.org/csswg/css-syntax/#next-input-code-point
    var nextInputCodePoint: Int
    
    // In order to construct character range to be returned to the
    // parser we must keep a reference to the start of the current
    var currentTokenStartIndex: Int
    
    // this variable keeps the length value of the stringInputStream variable
    // resulting from [stringInputStream length].
    var stringInputStreamLength: Int
    
    let sourceString: NSString
    
    init(sourceString: NSString) {
        
        self.sourceString = sourceString
        self.nextInputCodePoint = 0
        self.currentTokenStartIndex = 0
        self.stringInputStreamLength = sourceString.length
    }
    
    
    func scan(_ characterIndex : Int) -> Token {
        
        fatalError("Missing subclass implementation")
    }
    
    final func acceptToken<T : Token>( _ token: inout T) -> T {
        
        token.rawStringValue = rawStringValue()
        return token
    }
    
    final func position() -> SourceStringSegment {
        
        return SourceStringSegment(startIndex: currentTokenStartIndex, endIndex: nextInputCodePoint)
    }
    
    final func rawStringValue() -> String {
        
        return sourceString.substring(with: NSMakeRange(currentTokenStartIndex, nextInputCodePoint - currentTokenStartIndex)) as String
    }
    
    // consume the next input code point
    @discardableResult
    func consumeNextInputCodePoint() -> unichar {
        
        if (nextInputCodePoint < stringInputStreamLength ) {
            
            nextInputCodePoint += 1
            
            return sourceString.character(at: nextInputCodePoint - 1)
        }
        return UnicodeCharacter.endOfText.rawValue
    }
    
    // backoff the scanner to the previous token
    func reconsumeCodePoint() {
        
        nextInputCodePoint -= 1
    }
    
    func advanceCodePoint() {
        
        nextInputCodePoint += 1
    }
    
    func codePointAtLookAhead(_ lookAhead: Int) -> unichar {

        let characterIndex: Int = (nextInputCodePoint-1) + lookAhead

        if (characterIndex < stringInputStreamLength ) {
            
            return sourceString.character(at: characterIndex)
        }

        return UnicodeCharacter.endOfText.rawValue
    }
    
    /*
    * When this method is called the next input code point should be
    * an hex digit and the current code point a reverse solidus (this
    * has already been verified).
    * see http://dev.w3.org/csswg/css-syntax/#consume-an-escaped-code-point
    *
    * Note : This method is placed here since we assume that other
    *           scanners may need this kind of functionality even if the
    *           algorythm directly comes from the CSS specification.
    */
    @discardableResult
    func consumeEscapedCodePoint() -> Character {
        
        var codePoint = consumeNextInputCodePoint()
        
        if UnicodeHexDigit.isUnicodeHexDigit(codePoint) {
            
            var escapedCodePointString = String()
            
            escapedCodePointString.append(codePoint)
            
            for _ in 0..<5 {
                
                codePoint = consumeNextInputCodePoint()
                
                if UnicodeHexDigit.isUnicodeHexDigit(codePoint) {
                    
                    escapedCodePointString.append(codePoint)
                }
                else if codePoint == §UnicodeCharacter.whitespace {
                    
                    escapedCodePointString.append(codePoint)
                    break;
                }
                // FIXME : nothing specified in the algorythm
                // it is a possible error.
            }
            
            // convert the code point to it's code point value
            let characterValue = characterValueFromHexStringValue(escapedCodePointString);
            
            let codePointValue = characterValue.unicodeScalarCodePoint()
            
            // If this number is zero, or is for a surrogate code point,
            // or is greater than the maximum allowed code point,
            // return U+FFFD REPLACEMENT CHARACTER (�).
            // Otherwise, return the code point with that value.
            if codePointValue == 0
                || (0xd800 <= codePointValue && codePointValue <= 0xdfff)
                || codePointValue > 0x10ffff {
                    
                let unicodeScalar = UnicodeScalar(§UnicodeCharacter.replacementCharacter)!
                    
                return Character(unicodeScalar)
            }
            
            return characterValue
        }
            
        else if codePoint == §UnicodeCharacter.endOfText {
            
            let unicodeScalar = UnicodeScalar(§UnicodeCharacter.replacementCharacter)!
            
            return Character(unicodeScalar)
        }
        
        // else
        return Character(UnicodeScalar(codePoint)!)
    }
    
    func nextCharactersAreEqualIgnoreCaseTo(_ startIndex: Int, numberOfCodePoints: Int, string: String) -> String? {
        
        if let extractedString = createStringFromNextCodePoints(startIndex, numberOfCodePoints: numberOfCodePoints) {
            
            if string == extractedString {
                
                return extractedString
            }
            
            return nil
        }
        
        return nil
    }
    
    func createStringFromNextCodePoints(_ startIndex: Int, numberOfCodePoints: Int) -> String? {
        
        var string = String()
        
        for i in 0..<numberOfCodePoints {

            if (startIndex + i) < stringInputStreamLength {
                
                string.append(sourceString.character(at: startIndex + i))
            }
            else {
                
                return nil
            }
        }
        return string
    }
    
    internal func createIntegerNumberFromString(_ intString: String) -> Int? {
        
        if let number = Int(intString) {
            
            return number
        }
        return nil
        
    }
    
    func characterValueFromHexStringValue(_ hexString: String) -> Character {
        
        var intValue: CUnsignedInt = 0
        
        Scanner(string: hexString).scanHexInt32(&intValue)
        
        var i = Int(intValue)
        
        let stringValue = NSString(bytes: &i, length: 4, encoding: String.Encoding.utf32LittleEndian.rawValue)
        
        if let string = stringValue {
            
            let swiftString = String(string)
            return swiftString[swiftString.startIndex]
        }
        
        let unicodeScalar = UnicodeScalar(§UnicodeCharacter.replacementCharacter)!
        
        return Character(unicodeScalar)
    }
    
}
