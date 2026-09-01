//
//  MarkdownFormattingShortcut.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-08-02.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import os
import Common

enum MarkdownFormattingShortcut {

    // Heading 1: ⌘1
    case heading1
    
    // Heading 2: ⌘2
    case heading2
    
    // Heading 3: ⌘3
    case heading3
    
    // Heading 4: ⌘4
    case heading4
    
    // Heading 5: ⌘5
    case heading5
    
    // Heading 6: ⌘6
    case heading6
    
    // Indent Block: ⌘>
    case indentBlock
    
    // Unordered list: ⌘L
    case unorderedList
    
    // Ordered list: ⇧⌘L
    case orderedList
    
    // Bold: ⌘B
    case makeBold
    
    // Italic: ⌘I
    case makeItalic
    
    // Strikethrough: ⌘-
    case strikethrough
    
    // Add Link: ⌘K
    case addLink
    
    static func from(_ event: NSEvent) -> MarkdownFormattingShortcut? {
        
        let character = event.charactersIgnoringModifiers
        
        if event.modifierFlags.contains(NSEvent.ModifierFlags.command) {
            
            if event.modifierFlags.contains(NSEvent.ModifierFlags.shift) {
                
                // Ordered list: ⇧⌘L
                if character == "l" {
                    return MarkdownFormattingShortcut.orderedList
                }
            }
            else {
                if character == "1" {
                    return MarkdownFormattingShortcut.heading1
                }
                else if character == "2" {
                    return MarkdownFormattingShortcut.heading2
                }
                else if character == "3" {
                    return MarkdownFormattingShortcut.heading3
                }
                else if character == "4" {
                    return MarkdownFormattingShortcut.heading4
                }
                else if character == "5" {
                    return MarkdownFormattingShortcut.heading5
                }
                else if character == "6" {
                    return MarkdownFormattingShortcut.heading6
                }
                // Indent Block: ⌘>
                else if character == ">" {
                    return MarkdownFormattingShortcut.indentBlock
                }
                // Unordered list: ⌘L
                else if character == "l" {
                    return MarkdownFormattingShortcut.unorderedList
                }
                // Bold: ⌘B
                else if character == "b" {
                    return MarkdownFormattingShortcut.makeBold
                }
                // Italic: ⌘I
                else if character == "i" {
                    return MarkdownFormattingShortcut.makeBold
                }
                // Strikethrough: ⌘-
                else if character == "-" {
                    return MarkdownFormattingShortcut.makeBold
                }
                // Add Link: ⌘K
                else if character == "k" {
                    return MarkdownFormattingShortcut.makeBold
                }
            }
        }
        return nil 
    }
    
}
