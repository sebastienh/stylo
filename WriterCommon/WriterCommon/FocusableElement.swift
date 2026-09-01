//
//  FocusableElement.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-08-05.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Web
import Common
import os

protocol FocusableElement {
    
    var focusable: Bool { get }
    
    func focusEphemeralOptions(from focusedRange: NSRange?, focusType: FocusType?, inString string: String) -> (PseudoClassesOptions, NSRange?)?
    
}

extension HTMLElement: FocusableElement {
    
    var focusable: Bool {
        return true
    }
    
    func focusEphemeralOptions(from editedRange: NSRange?, focusType: FocusType?, inString string: String) -> (PseudoClassesOptions, NSRange?)? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("focusEphemeralOptions(from: %@, focusType:%@, inString: %@)", log: Log.WriterCommon.all, type: .info, %%editedRange, %%focusType, %%string)
        #endif
        
        guard let focusType = focusType else {
            return nil
        }
        
        guard let editedRange = editedRange else {
            return nil
        }
        
        switch focusType {
        case .bloc:
            if let _ = self.parentElement as? HTMLBodyElement {
                if let _ = self.whitespacesExtendedIntersectionRange(editedRange, inString: string) {
                    return (.focus, nil)
                }
                return (.fade, nil)
            }
            else if let pre = self.parentElement as? HTMLPreElement, let _ = pre.parentElement as? HTMLBodyElement {
                if let _ = self.whitespacesExtendedIntersectionRange(editedRange, inString: string) {
                    return (.focus, nil)
                }
                return (.fade, nil)
            }
            
        case .paragraph:
            
            if self.focusable {
                if let _ = self.whitespacesExtendedIntersectionRange(editedRange, inString: string) {
                    return (.focus, self.paragraphRange(fromEditedRange: editedRange, sourceString: string))
                }
                else {
                    return (.fade, self.paragraphRange(fromEditedRange: editedRange, sourceString: string))
                }
            }
            return nil
            
        case .sentence:
            
            if self.focusable {
                
                // in sentence mode we always consider only the start of the endited range
                let range = editedRange.zeroLengthRange
                if let whitespacesExtendedElementRange = self.whitespacesExtendedIntersectionRange(range, inString: string) {
                    if let focusedRange = self.sentenceRange(fromEditedRange: range, whitespacesExtendedElementRange: whitespacesExtendedElementRange, sourceString: string) {
                        return (.focus, focusedRange)
                    }
                }
            }
            
        case .flash:
            assertionFailure("Errro:")
            break
        }
        
        return nil
    }
    
    private func paragraphRange(fromEditedRange editedRange: NSRange, sourceString: String) -> NSRange? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("paragraphRange(fromEditedRange: %@, sourceString: %@)", log: Log.WriterCommon.all, type: .info, %%editedRange, %%targetString)
        #endif
        switch self {
        case let listElement as HTMLLIElement:
            return listElement.lineRange(fromEditedRange: editedRange, sourceString: sourceString)
        default:
            return nil
        }
    }
    
    private func lineRange(fromEditedRange editedRange: NSRange, sourceString: String) -> NSRange? {
        
        guard editedRange.location >= 0 else {
            assertionFailure("Error: negative editedRange.location")
            return nil
        }
        
        let string = sourceString as NSString
        
        guard editedRange.upperBound <= string.length else {
            assertionFailure("Error: edited range outside string range")
            return  nil
        }
        
        return string.lineRange(for: editedRange)
    }
    
    private func sentenceRange(fromEditedRange editedRange: NSRange, whitespacesExtendedElementRange: NSRange, sourceString: String) -> NSRange? {

        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("sentenceRange(fromEditedRange: %@, sourceString: %@)", log: Log.WriterCommon.all, type: .info, %%editedRange, %%targetString)
        #endif
        
        switch self {
        case let blockquote as HTMLQuoteElement:
            return blockquote.lineRange(fromEditedRange: editedRange, sourceString: sourceString)
        case let paragraph as HTMLParagraphElement:
            return paragraph.sentenceRange(fromEditedRange: editedRange, in: sourceString)
        case let pre as HTMLPreElement:
            return pre.lineRange(fromEditedRange: editedRange, sourceString: sourceString)
        case let code as HTMLCodeElement:
            return code.sentenceRange(fromEditedRange: editedRange, in: sourceString)
        case let listElement as HTMLLIElement:
            return listElement.lineRange(fromEditedRange: editedRange, sourceString: sourceString)
        case is HTMLTableElement: fallthrough
        case is HTMLUListElement: fallthrough
        case is HTMLOListElement:
            return nil
        case is HTMLTableRowElement: fallthrough
        default:
            return whitespacesExtendedElementRange
        }
    }
}

extension HTMLCodeElement {
    
    func sentenceRange(fromEditedRange editedRange: NSRange, in sourceString: String) -> NSRange? {
        
        return (sourceString as NSString).lineRange(for: editedRange)
    }
    
}

extension HTMLParagraphElement {
    
    func sentenceRange(fromEditedRange editedRange: NSRange, in sourceString: String) -> NSRange? {
        
        guard let elementRange = self.range else {
            assertionFailure("Error: range is nil")
            return nil
        }
        
        // the range when there is no text childs is determined
        // by the contained element
        if self.textChilds.isEmpty {
            return elementRange
        }
        else if var sentenceRange = sourceString.sentencesRange(aroundRange: editedRange) {
            
//            #if DEBUG
//            guard let _sentence = sourceString[sentenceRange.lowerBound..<sentenceRange.upperBound] else {
//                assertionFailure("Error: sentence is nil")
//                return NSIntersectionRange(elementRange, sentenceRange)
//            }
//            print("sourceString sentence: \(_sentence)")
//            var sentence = _sentence
//            #endif
            
            // the range starts with an image link definition
            while sourceString.startsAfterImageLinkDefinitionStart(beforeRange: sentenceRange) {
            
                let rangeBefore = NSMakeRange(sentenceRange.lowerBound-1, 0)
                
                guard let beforeSentenceRange = sourceString.sentencesRange(aroundRange: rangeBefore) else {
                    assertionFailure("Error: afterSentenceRange is nil")
                    break
                }
                
                sentenceRange = sentenceRange.union(beforeSentenceRange)
//                print("sentenceRange: \(sentenceRange)")
//                #if DEBUG
//                guard let _sentence = sourceString[sentenceRange.lowerBound..<sentenceRange.upperBound] else {
//                    assertionFailure("Error: sentence is nil")
//                    return NSIntersectionRange(elementRange, sentenceRange)
//                }
//                sentence = _sentence
//                print("sourceString sentence: \(sentence)")
//                #endif
            }
            
            // the range ends with an image link definition
            while sourceString.endsWithImageLinkDefinition(inRange: sentenceRange) {
                
                let rangeAfter = NSMakeRange(sentenceRange.upperBound+1, 0)
                guard let afterSentenceRange = sourceString.sentencesRange(aroundRange: rangeAfter) else {
                    assertionFailure("Error: afterSentenceRange is nil")
                    break
                }
                
                sentenceRange = sentenceRange.union(afterSentenceRange)
//                print("sentenceRange: \(sentenceRange)")
//                #if DEBUG
//                guard let _sentence = sourceString[sentenceRange.lowerBound..<sentenceRange.upperBound] else {
//                    assertionFailure("Error: sentence is nil")
//                    return NSIntersectionRange(elementRange, sentenceRange)
//                }
//                sentence = _sentence
//                print("sourceString sentence: \(sentence)")
//                #endif
            }
            return sentenceRange
        }
        return elementRange
    }
}


extension String {
    
    func startsAfterImageLinkDefinitionStart(beforeRange range: NSRange) -> Bool {
        
        guard range.lowerBound > 1 else {
            return false
        }

//        #if DEBUG
//        print("String before: \(String(describing: self.substring(range.location-2, length: 2)))")
//        #endif
        
        var pos = range.lowerBound
        
        if self.charAt(pos) != §UnicodeCharacter.leftSquareBracket {
            return false
        }
        
        pos -= 1
        
        if self.charAt(pos) != §UnicodeCharacter.exclamationMark {
            return false
        }
        return true
    }
    
    func endsWithImageLinkDefinition(inRange range: NSRange) -> Bool {
        
        guard range.length > 1 else {
            return false
        }
        
        var pos = range.upperBound-1
        
        if self.charAt(pos) != §UnicodeCharacter.exclamationMark {
            return false
        }
        
        pos += 1
        
        if self.charAt(pos) != §UnicodeCharacter.leftSquareBracket {
            return false
        }
        
        return true
    }
}
