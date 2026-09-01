//
//  MarkdownResourceEditorView+NSLayoutManagerDelegate.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-03-08.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa
import WriterCommon
import Common
import os

extension MarkdownResourceEditorView: NSLayoutManagerDelegate {

    func layoutManager(_ layoutManager: NSLayoutManager, shouldGenerateGlyphs glyphs: UnsafePointer<CGGlyph>, properties props: UnsafePointer<NSLayoutManager.GlyphProperty>, characterIndexes charIndexes: UnsafePointer<Int>, font aFont: NSFont, forGlyphRange glyphRange: NSRange) -> Int {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("(%@) layoutManager(layoutManager: %@, shouldGenerateGlyphs: %@, properties: %@, characterIndexes: %@, font: %@, glyphRange: %@)", log: Log.StyloCore.all, type: .debug, %%self.address, %%layoutManager, %%glyphs.pointee, %%props.pointee, %%charIndexes.pointee, %%aFont, %%glyphRange)
        #endif
        
        guard let textStorage = layoutManager.textStorage else {
            assertionFailure("Error: textStorage is nil")
            fatalError("nmi")
        }
        
        // Make mutableProperties an optional to allow checking if it gets allocated
        var mutableProperties: UnsafeMutablePointer<NSLayoutManager.GlyphProperty>? = nil
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("(%@) shouldGenerateGlyphs -> textStorage: %@", log: Log.StyloCore.all, type: .debug, %%self.address, %%textStorage)
        #endif
        
        
        // Check the attributes value only at charIndexes.pointee, where this glyphRange begins
        if let _ = textStorage.attribute(StyloAttribute.headingTagBefore.key, at: charIndexes.pointee, effectiveRange: nil) as? NSNumber {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("(%@) shouldGenerateGlyphs -> number: %@, charIndexes.pointee: %@, effectiveRange: %@", log: Log.StyloCore.all, type: .debug, %%self.address, %%number, %%charIndexes.pointee, %%effectiveRange)
            #endif
            
            // Allocate mutableProperties
            mutableProperties = .allocate(capacity: glyphRange.length)
            // Initialize each element of mutableProperties
            for index in 0..<glyphRange.length {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("(%@) shouldGenerateGlyphs -> charIndexes[%@]: %@", log: Log.StyloCore.all, type: .debug, %%self.address, %%index, %%charIndexes[index])
                os_log("(%@) shouldGenerateGlyphs:replacing props -> index: %@", log: Log.StyloCore.all, type: .debug, %%self.address, %%index)
                
                let charRange = NSMakeRange(charIndexes[index], 1)
                let char = textStorage.attributedSubstring(from: charRange).string.charAt(0)
                assert(char == §UnicodeCharacter.whitespace || char == §UnicodeCharacter.numberSign)
                #endif
                
                mutableProperties?[index] = props[index]
                mutableProperties?[index].insert(.controlCharacter)
            }
        }
        
        // Update only if mutableProperties was allocated
        if let mutableProperties = mutableProperties {
            
            layoutManager.setGlyphs(glyphs, properties: mutableProperties, characterIndexes: charIndexes, font: aFont, forGlyphRange: glyphRange)
            
            // Clean up this UnsafeMutablePointer
            mutableProperties.deinitialize(count: glyphRange.length)
            mutableProperties.deallocate()
            
            return glyphRange.length
            
        } else {
            return 0
        }
    }
}
