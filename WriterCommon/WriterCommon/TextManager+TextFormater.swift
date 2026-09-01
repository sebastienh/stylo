//
//  TextManager+TextFormater.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-05-12.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import Common
import os

extension TextManager: TextFormatter {
    
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
    
    public func handleOneCharacterInsertion(ofString insertedString: String, with replacementRange: NSRange, in input: FormattableInput) -> Insertion? {
     
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG_LOGS_ENABLED
        print("handling one character insertion")
        #endif
        
        assert(insertedString.count == 1)
        if let insertion = handleThreeGraveAccents(insertedString: insertedString, replacementRange: replacementRange, in: input) {
            return insertion
        }
        if let insertion = handleThreeGraveColumns(insertedString: insertedString, replacementRange: replacementRange, in: input) {
            return insertion
        }
        if let insertion = handleHashInsert(insertedString: insertedString, replacementRange: replacementRange, in: input) {
            return insertion
        }
        return nil
    }
    
    public func handleOneCharacterDeletion(with replacementRange: NSRange, in input: FormattableInput) -> Insertion? {
     
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG_LOGS_ENABLED
        print("text before: \"\(input.textStorage!.attributedSubstring(from: NSMakeRange(replacementRange.upperBound-1, 1)).string)\"")
        print("text attributes before: \"\(input.textStorage!.attributedSubstring(from: NSMakeRange(replacementRange.upperBound-1, 1)))\"")
        #endif
        
        // if we delete and we are in front of a header tag start
        if let textStorage = input.textStorage,
            input.textStorage!.attributedSubstring(from: NSMakeRange(replacementRange.upperBound-1, 1)).string == " " {
            
            if let headingTagBeforeValue = textStorage.attribute(StyloAttribute.headingTagBefore.key, at: replacementRange.upperBound-1, longestEffectiveRange: nil, in: NSMakeRange(replacementRange.upperBound-1, 1)) as? NSNumber {
        
                if headingTagBeforeValue.intValue == 1 {
                    return Insertion(replacementString: "", locationVariation: -2, replacementRange: NSMakeRange(replacementRange.location-1, 2))
                }
                else {
                    return Insertion(replacementString: "", locationVariation: -1, replacementRange: NSMakeRange(replacementRange.location-1, 1))
                }
            }
        }
        
        return nil
    }
    
    public func handleInsert(ofString string: String, in input: FormattableInput, withSelection range: NSRange) -> Insertion? {
     
        return nil
    }
    
    /// Insertion of # in Markdown headers
    private func handleHashInsert(insertedString: String, replacementRange: NSRange, in input: FormattableInput) -> Insertion? {
    
        guard let textStorage = input.textStorage else {return nil}
        guard insertedString == "#" else {return nil}
        
        if textStorage.isCursorAtHeaderTagEnd(at: replacementRange.location) {
            
            assert(replacementRange.location >= 2, "we cannot be at header tag end if location is less than two...")
            return Insertion(replacementString: "#", locationVariation: 1, replacementRange: NSMakeRange(replacementRange.location-2, 0))
        }
        return nil
    }
    
    /// ``` becomes:
    /// ```<caret>
    ///
    /// ```
    private func handleThreeGraveColumns(insertedString: String, replacementRange: NSRange, in input: FormattableInput) -> Insertion? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("affectedRange: %@", log: Log.WriterCommon.all, type: .debug, %%NSStringFromRange(replacementRange))
        os_log("replacementString: %@", log: Log.WriterCommon.all, type: .debug, %%insertedString)
        #endif
        
        let character: UInt16 = insertedString.charAt(0)!
        
        if character == §UnicodeCharacter.colon {
            
            // if the two preceeding characters are grave accents
            // then we should complete with three grave accents
            if replacementRange.location >= 2 && characterIsNewLineOrStartOfFile(at: replacementRange.location-3, in: input) {
                
                let firstCharacter = input.string.charAt(replacementRange.location-2)
                let secondCharacter = input.string.charAt(replacementRange.location-1)
                
                if let firstCharacter = firstCharacter, let secondCharacter = secondCharacter,
                    firstCharacter == §UnicodeCharacter.colon &&
                        secondCharacter == §UnicodeCharacter.colon {
                    
                    let replacementString: String = ":  :::\n\n:::"
                    
                    return Insertion(replacementString: replacementString, locationVariation: 2, replacementRange: replacementRange)
                }
            }
        }
        return nil
    }
    
    /// ``` becomes:
    /// ```<caret>
    ///
    /// ```
    private func handleThreeGraveAccents(insertedString: String, replacementRange: NSRange, in input: FormattableInput) -> Insertion? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("affectedRange: %@", log: Log.WriterCommon.all, type: .debug, %%NSStringFromRange(replacementRange))
        os_log("replacementString: %@", log: Log.WriterCommon.all, type: .debug, %%insertedString)
        #endif
        
        if let character: UInt16 = insertedString.charAt(0) {
        
            if character == §UnicodeCharacter.graveAccent {
                
                // if the two preceeding characters are grave accents
                // then we should complete with three grave accents
                if replacementRange.location >= 2 && characterIsNewLineOrStartOfFile(at: replacementRange.location-3, in: input) {
                    
                    let firstCharacter = input.string.charAt(replacementRange.location-2)
                    let secondCharacter = input.string.charAt(replacementRange.location-1)
                    
                    if let firstCharacter = firstCharacter, let secondCharacter = secondCharacter,
                        firstCharacter == §UnicodeCharacter.graveAccent &&
                            secondCharacter == §UnicodeCharacter.graveAccent {
                        
                        let replacementString: String = "`\n\n```"
                        
                        return Insertion(replacementString: replacementString, locationVariation: 1, replacementRange: replacementRange)
                    }
                }
            }
        }
        return nil
    }
    
    private func characterIsNewLineOrStartOfFile(at index: Int, in input: FormattableInput) -> Bool {
        
        if index < 0 {
            return true
        }
        
        let character = input.string.charAt(index)
        
        if let character = character, character == §UnicodeCharacter.lineFeed {
            
            return true
        }
        return false
    }
    
}
