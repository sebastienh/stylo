//
//  ResourceTypesetter.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-07-03.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa
import WriterCommon
import Common
import os



class ResourceTypesetter: NSTypesetter {
    
//    override func insertGlyph(_ glyph: NSGlyph, atGlyphIndex glyphIndex: Int, characterIndex: Int) {
//        
//        debugPrint("insertGlyph")
//        
//        super.insertGlyph(glyph, atGlyphIndex: glyphIndex, characterIndex: characterIndex)
//    }
    
//
//    override func layoutGlyphs(in layoutManager: NSLayoutManager, startingAtGlyphIndex startGlyphIndex: Int, maxNumberOfLineFragments maxNumLines: Int, nextGlyphIndex nextGlyph: UnsafeMutablePointer<Int>) {
//
//        let charRange = layoutManager.characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)
//
//
//
//
//
//    }
//
//    override func setNotShownAttribute(_ flag: Bool, forGlyphRange glyphRange: NSRange) {
//
//        guard let layoutManager = self.layoutManager else {
//            assertionFailure("Error: self.layoutManager is nil")
//            super.setNotShownAttribute(flag, forGlyphRange: glyphRange)
//        }
//
//        guard let textStorage = layoutManager.textStorage else {
//            assertionFailure("Error: layoutManager.textStorage is nil")
//            super.setNotShownAttribute(flag, forGlyphRange: glyphRange)
//        }
//
//        let charRange = layoutManager.characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)
//
//        var effectiveRange: NSRange = NSMakeRange(0, 0)
//        if let number = textStorage.attribute(StyloAttribute.headingTagBefore.attributeKey, at: charRange.location, effectiveRange: &effectiveRange) as? NSNumber {
//
//
//        }
//
////        var theFlag = flag
////
////        if PreferencesManager.shared.shouldShowInvisibles == true {
////            theFlag = false
////
////            // add new line glyphs into the glyph storage
////            var newLineGlyph = yourFont.glyph(withName: "paragraph")
////            self.substituteGlyphs(in: glyphRange, withGlyphs: &newLineGlyph)
////
////            // draw new line char with different color
////            self.layoutManager?.addTemporaryAttribute(NSForegroundColorAttributeName, value: NSColor.invisibleTextColor, forCharacterRange: glyphRange)
////        }
//
//        super.setNotShownAttribute(flag, forGlyphRange: glyphRange)
//    }
//
//    /// Currently hadn't found any faster way to draw space glyphs with different color
//    override func setParagraphGlyphRange(_ paragraphRange: NSRange, separatorGlyphRange paragraphSeparatorRange: NSRange) {
//        super.setParagraphGlyphRange(paragraphRange, separatorGlyphRange: paragraphSeparatorRange)
//
//        guard PreferencesManager.shared.shouldShowInvisibles == true else { return }
//
//        if let substring = (self.layoutManager?.textStorage?.string as NSString?)?.substring(with: paragraphRange) {
//            let expression = try? NSRegularExpression.init(pattern: "\\s", options: NSRegularExpression.Options.useUnicodeWordBoundaries)
//            let sunstringRange = NSRange(location: 0, length: substring.characters.count)
//
//            if let matches = expression?.matches(in: substring, options: NSRegularExpression.MatchingOptions.withoutAnchoringBounds, range: sunstringRange) {
//                for match in matches {
//                    let globalSubRange = NSRange(location: paragraphRange.location + match.range.location, length: 1)
//                    self.layoutManager?.addTemporaryAttribute(NSForegroundColorAttributeName, value: Color.invisibleText, forCharacterRange: globalSubRange)
//                }
//            }
//        }
//    }
    
}
