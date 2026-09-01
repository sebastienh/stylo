//
//  ResourceGlyphGenerator.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-07-11.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa
import Common

class ResourceGlyphGenerator: NSGlyphGenerator, NSGlyphStorage {
    
    var _destination: NSGlyphStorage? // the original glyph generation requester
    
    override func generateGlyphs(for glyphStorage: NSGlyphStorage, desiredNumberOfCharacters nChars: Int, glyphIndex: UnsafeMutablePointer<Int>?, characterIndex charIndex: UnsafeMutablePointer<Int>?) {
        
        // Stash the original requester
        _destination = glyphStorage
        NSGlyphGenerator.shared.generateGlyphs(for: self, desiredNumberOfCharacters: nChars, glyphIndex: glyphIndex, characterIndex: charIndex)
        _destination = nil
    }
    
    func insertGlyphs(_ glyphs: UnsafePointer<NSGlyph>, length: Int, forStartingGlyphAt glyphIndex: Int, characterIndex charIndex: Int) {
        
        let attributedString = self.attributedString()

        if attributedString.attribute(StyloAttribute.headingTagBefore.key, at: charIndex, longestEffectiveRange: nil, in: NSMakeRange(0, attributedString.length)) != nil {

            let mutableGlyphsPointer: UnsafeMutablePointer<NSGlyph> = UnsafeMutablePointer<NSGlyph>.allocate(capacity: length)
            mutableGlyphsPointer.assign(repeating: NSGlyph(NSNullGlyph), count: length)
            _destination?.insertGlyphs(mutableGlyphsPointer, length: length, forStartingGlyphAt: glyphIndex, characterIndex: charIndex)
        }
        else {
        
            _destination?.insertGlyphs(glyphs, length: length, forStartingGlyphAt: glyphIndex, characterIndex: charIndex)
        }
    }
    
    func setIntAttribute(_ attributeTag: Int, value val: Int, forGlyphAt glyphIndex: Int) {
        _destination?.setIntAttribute(attributeTag, value: val, forGlyphAt: glyphIndex)
    }
    
    func attributedString() -> NSAttributedString {
        return _destination!.attributedString()
    }
    
    func layoutOptions() -> Int {
        return _destination!.layoutOptions()
    }
}
