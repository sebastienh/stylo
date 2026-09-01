//
//  StylesheetManager+TextFormatter.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-05-25.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Common
import os

extension StylesheetManager: TextFormatter {

    public func handleInsertion(ofString string: String, with replacementRange: NSRange, in input: FormattableInput) -> Insertion? {
        
        if string.count == 0 && replacementRange.length == 1 {
            return handleOneCharacterDeletion(with: replacementRange, in: input)
        }
        else if string.count == 1 && replacementRange.length > 0 {
            return handleInsert(ofString: string, in: input, withSelection: replacementRange)
        }
        else if string.count == 1 && replacementRange.length == 0 {
            return handleOneCharacterInsertion(ofString: string, with: replacementRange, in: input)
        }
        return nil
    }
    
    public func handleOneCharacterInsertion(ofString string: String, with replacementRange: NSRange, in input: FormattableInput) -> Insertion? {
        
        assert(string.count == 1)
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("affectedRange: %@", log: Log.WriterCommon.all, type: .debug, %%NSStringFromRange(replacementRange))
        os_log("replacementString: %@", log: Log.WriterCommon.all, type: .debug, %%string)
        #endif
        
        let character: UInt16 = string.charAt(0)!
        
        if character == §UnicodeCharacter.leftCurlyBracket
            || character == §UnicodeCharacter.quotationMark
            || character == §UnicodeCharacter.apostrophe {
            
            // (, [, {, ", ` : insert that, and end character.
            let startCharacter: UInt16 = character
            let endCharacter: UInt16 = UnicodeCharacter.mirrorVariantCharacter(startCharacter)!
            
            if let nextCharacter = nextNonWhitespaceInputCharacter(from: replacementRange.location + 1, in: input.string) {
                if nextCharacter == endCharacter {
                    return nil
                }
            }
            
            let inputString = input.string
            
            if character == §UnicodeCharacter.quotationMark ||
                character == §UnicodeCharacter.apostrophe{
                
                // Double special case for quote. If the character immediately to the left
                // of the insertion point is a number, we're done.  That way if you type,
                // say, 27", it works as you expect.
                let selectionRange: NSRange = input.selectedRange
                
                if selectionRange.location > 0  {
                    
                    if let character = inputString.charAt(replacementRange.location - 2), UnicodeDigit.isUnicodeDigit(character) {
                        return nil
                    }
                    else {
                        
                        // if we are in front of a character different from whitespace
                        // we don't return anything.
                        if let frontCharacter = inputString.charAt(replacementRange.location) {
                            
                            // if character is not whitespace or lineFeed we return nil
                            if !(frontCharacter == §UnicodeCharacter.whitespace || frontCharacter == §UnicodeCharacter.lineFeed) {
                                return nil
                            }
                            else {
                                
                                // look if we have one in the same string to the start
                                var previousIndex = replacementRange.location-1
                                while let previousChar = inputString.charAt(previousIndex), previousChar != §UnicodeCharacter.lineFeed {
                                    
                                    if character == previousChar {
                                        
                                        let beforeQuote = inputString.charAt(previousIndex-1)
                                        
                                        if let beforeQuote = beforeQuote {
                                            
                                            if beforeQuote == §UnicodeCharacter.lineFeed || beforeQuote == §UnicodeCharacter.whitespace {
                                                return nil
                                            }
                                            else {
                                                break
                                            }
                                        }
                                        else {
                                            break
                                        }
                                    }
                                    previousIndex -= 1
                                }
                            }
                        }
                    }
                }
            }
            
            let replacementString: String = String(format: "%c%c", startCharacter, endCharacter)
            // Remember the character, so if the user deletes it we remember to also delete the
            // one we inserted.
            input.lastCharacterInserted = endCharacter
            input.lastCharacterWhichCausedInsertion = startCharacter

            input.justInsertedBrace = input.lastCharacterWhichCausedInsertion == §UnicodeCharacter.leftCurlyBracket
            
            return Insertion(replacementString: replacementString, locationVariation: 1, replacementRange: replacementRange)
        }
            
        else if character == §UnicodeCharacter.rightParenthesis
            || character == §UnicodeCharacter.rightSquareBracket
            || character == §UnicodeCharacter.rightCurlyBracket
            || character == §UnicodeCharacter.quotationMark
            || character == §UnicodeCharacter.apostrophe {
            
            if let lastCharacterInserted = input.lastCharacterInserted, lastCharacterInserted == character {
                
                // We recently inserted one of these.  Just type through it; don't insert anything.
                // But then forget we did that.
                input.lastCharacterInserted = 0
                input.lastCharacterWhichCausedInsertion = 0
                return nil
            }
        }
        else if character == §UnicodeCharacter.characterTabulation {
            
            // If hit tab, and the next character is the last character inserted, type through it.
            let nextIndex = input.selectedRange.location
            let fullText = input.string
            
            if nextIndex < fullText.length {
                
                let nextChar: UInt16? = fullText.charAt(nextIndex)
                
                if let nextChar = nextChar, let lastCharacterInserted = input.lastCharacterInserted, nextChar == lastCharacterInserted {
                    
                    input.lastCharacterInserted = 0
                    input.lastCharacterWhichCausedInsertion = 0
                    return Insertion(replacementString: "", locationVariation: 1, replacementRange: replacementRange)
                }
            }
        }
        else if character == §UnicodeCharacter.lineFeed
            || character == §UnicodeCharacter.carriageReturn {
            
            if let previousCharacter = input.string.charAt(replacementRange.location - 1), previousCharacter == §UnicodeCharacter.leftCurlyBracket {
             
                if let nextCharacter = input.string.charAt(replacementRange.location), nextCharacter == §UnicodeCharacter.rightCurlyBracket {
                
                    input.lastCharacterInserted = 0
                    input.lastCharacterWhichCausedInsertion = 0
                    
                    return Insertion(replacementString: "\n\t\n", locationVariation: 2, replacementRange: replacementRange)
                }
            }
        }
        return nil
    }
    
    public func handleOneCharacterDeletion(with replacementRange: NSRange, in input: FormattableInput) -> Insertion? {
        
        let inputString = input.string
        
        if inputString.length > 0 {
            
            if let character: UInt16 = inputString.charAt(replacementRange.location + 1), let previousCharacter: UInt16 = inputString.charAt(replacementRange.location) {
                
                if character == §UnicodeCharacter.rightParenthesis && previousCharacter == §UnicodeCharacter.leftParenthesis
                    || character == §UnicodeCharacter.rightCurlyBracket && previousCharacter == §UnicodeCharacter.leftCurlyBracket
                    || character == §UnicodeCharacter.rightSquareBracket && previousCharacter == §UnicodeCharacter.leftSquareBracket
                    || character == §UnicodeCharacter.quotationMark && previousCharacter == §UnicodeCharacter.quotationMark
                    || character == §UnicodeCharacter.apostrophe && previousCharacter == §UnicodeCharacter.apostrophe
                    || character == §UnicodeCharacter.semiColon && previousCharacter == §UnicodeCharacter.colon {
                    
                    return Insertion(replacementString: "", locationVariation: -1, replacementRange: NSMakeRange(replacementRange.location, 2))
                }
            }
        }
        return nil
    }
    
    public func handleInsert(ofString string: String, in input: FormattableInput, withSelection range: NSRange) -> Insertion? {
        
        if string.length == 0 {
            return nil
        }
        
        if let character: UInt16 = string.charAt(0) {
            
            input.justInsertedBrace = false
            
            if character == §UnicodeCharacter.leftParenthesis
                || character == §UnicodeCharacter.leftSquareBracket
                || character == §UnicodeCharacter.leftCurlyBracket
                || character == §UnicodeCharacter.apostrophe
                || character == §UnicodeCharacter.quotationMark
                || character == §UnicodeCharacter.lessThanSign {
                
                // (, [, {, <, ", ' : surround selection with (), [], {}, <>, "", ''.
                let startCharacter: UInt16 = character
                let endCharacter: UInt16 = UnicodeCharacter.mirrorVariantCharacter(startCharacter)!
                if let surroundedString = input.string.substring(range.location, length: range.length) {
                
                    let replacementString: String = String(format: "%c%@%c", startCharacter, NSString(string: surroundedString), endCharacter)
                    return Insertion(replacementString: replacementString, locationVariation: 1, replacementRange: range)
                }
            }
            else if character == §UnicodeCharacter.leftCurlyBracket {
                input.justInsertedBrace = true
            }
        }
        return nil
    }
}
