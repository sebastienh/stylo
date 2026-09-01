//
//  image.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-12-02.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

/// Process ![image](<src> "title")
func image(_ state: StateInline, silent: Bool) -> Bool {

    var href = ""
    var attrsBlocs: [AttributesBloc]?
    let oldPos = state.pos
    let max = state.posMax
    
    if let char = state.src.charAt(state.pos) , char != 0x21/* ! */ {
        
        return false
    }
    
    if let char = state.src.charAt(state.pos + 1) , char != 0x5B/* [ */ {
        
        return false
    }
    
    //
    // Regions that we should record position information about...
    //
    var wholeRegion = SourceStringRegion()
    var tagRegion = SourceStringRegion()
    
    // title may be absent
    var titleRegion: SourceStringRegion?
    
    // destination may be absent
    var destinationRegion: SourceStringRegion?
    
    // link lable may be absent
    var linkLabelSegment: SourceStringSegment?
    
    let exclamationPLusLeftSquareBraquetSegment = state.sourceStringSegmentFromPosition(oldPos, length: 2)
    tagRegion.addSourceStringSegment(exclamationPLusLeftSquareBraquetSegment!)
    wholeRegion.addSourceStringSegment(exclamationPLusLeftSquareBraquetSegment!)
    
    let labelStart = state.pos + 2
    let labelEnd = state.md.parseLinkLabel(state, start: state.pos + 1, disableNested: false)
    
    // parser failed to find ']', so it's not a valid link
    if labelEnd! < 0 {
        
        return false
    }
    
    let rightSquareBraquetSegment = state.sourceStringSegmentFromPosition(labelEnd!, length: 1)
    tagRegion.addSourceStringSegment(rightSquareBraquetSegment!)
    
    var linkTextSegment: SourceStringSegment? = nil
    if labelEnd! - labelStart > 0 {
        linkTextSegment = state.sourceStringSegmentFromPosition(labelStart, length: labelEnd! - labelStart)
        wholeRegion.addSourceStringSegment(linkTextSegment!)
    }
    wholeRegion.addSourceStringSegment(rightSquareBraquetSegment!)
    var pos = labelEnd! + 1
    
    var title = ""
    
    var label: String?
    
    if let char = state.src.charAt(pos), pos < max && char == 0x28/* ( */ {
    
        //
        // Inline link
        //
        let leftParenthesisSegment = state.sourceStringSegmentFromPosition(pos, length: 1)
        tagRegion.addSourceStringSegment(leftParenthesisSegment!)
        wholeRegion.addSourceStringSegment(leftParenthesisSegment!)
        
        // [link](  <href>  "title"  )
        //        ^^ skipping these spaces
        pos += 1
        while pos < max {
            
            let code = state.src.charAt(pos)!
            
            if !isSpace(code) && !isPossibleNewLineStartCodePoint(code) {
                
                break
            }
            else if let newLineLength = state.src.startWithNewLine(atPosition: pos) {
            
                pos += (newLineLength - 1)
            }
            
            pos += 1
        }
        
        if pos >= max {
            
            return false
        }
        
        // [link](  <href>  "title"  )
        //          ^^^^^^ parsing link destination
        var start = pos
        
        let res = state.md.parseLinkDestination(state, str: state.src.slice(0, end: state.posMax)!.string, pos: pos, max: state.posMax)
        
        if res.ok {
            
            href = state.md.normalizeLink(res.str)
            
            destinationRegion = res.region
            wholeRegion = wholeRegion + destinationRegion!
            
            if state.md.validateLink(href) {
                
                pos = res.pos
            }
            else {
            
                href = ""
            }
        }
        
        // [link](  <href>  "title"  )
        //                ^^ skipping these spaces
        start = pos
        
        while pos < max  {
            
            let code = state.src.charAt(pos)!
            
            if !isSpace(code) && !isPossibleNewLineStartCodePoint(code) {
                
                break
            }
            else if let newLineLength = state.src.startWithNewLine(atPosition: pos) {
                
                pos += (newLineLength - 1)
            }
            
            pos += 1
        }
        
        // [link](  <href>  "title"  )
        //                  ^^^^^^^ parsing link title
        
        let parseLinkTitleRes = state.md.parseLinkTitle(state, str: state.src.slice(0, end: state.posMax)!.string, pos: pos, max: state.posMax)
        
        if pos < max && start != pos && parseLinkTitleRes.ok {
            
            title = parseLinkTitleRes.str
            pos = parseLinkTitleRes.pos
            titleRegion = parseLinkTitleRes.region
            wholeRegion = wholeRegion + parseLinkTitleRes.region
            
            // [link](  <href>  "title"  )
            //                         ^^ skipping these spaces
            while pos < max {
                
                let code = state.src.charAt(pos)!
                
                if !isSpace(code) && !isPossibleNewLineStartCodePoint(code) {
                    
                    break
                }
                else if let newLineLength = state.src.startWithNewLine(atPosition: pos) {
                    
                    pos += (newLineLength - 1)
                }
                
                pos += 1
            }
        }
        
        if pos >= max || state.src.charAt(pos)! != 0x29/* ) */ {
            
            state.pos = oldPos
            return false
        }
        else if state.src.charAt(pos)! == 0x29 /* ) */ {
            
            let rightParenthesisSegment = state.sourceStringSegmentFromPosition(pos, length: 1)
            tagRegion.addSourceStringSegment(rightParenthesisSegment!)
            wholeRegion.addSourceStringSegment(rightParenthesisSegment!)
        }
        
        pos += 1
    }
    else {
        
        //
        // Link reference
        //
        //
        // original: if (typeof state.env.references === 'undefined') { return false; }
        // We remove this part because we want to know if it is a "potentially linking position".
//        if state.env.isEmpty {
//
//            // maybe undefined is equal to this...
//            return false
//        }
        
        if pos < max && state.src.charAt(pos) == 0x5B/* [ */ {
            
            let leftSquareBraquetSegment = state.sourceStringSegmentFromPosition(pos, length: 1)
            tagRegion.addSourceStringSegment(leftSquareBraquetSegment!)
            wholeRegion.addSourceStringSegment(leftSquareBraquetSegment!)
            
            let start = pos + 1
            pos = state.md.parseLinkLabel(state, start: pos)!
            
            let rightSquareBraquetSegment = state.sourceStringSegmentFromPosition(pos, length: 1)
            tagRegion.addSourceStringSegment(rightSquareBraquetSegment!)
            wholeRegion.addSourceStringSegment(rightSquareBraquetSegment!)
            
            if pos - start > 0 {
                linkLabelSegment = state.sourceStringSegmentFromPosition(start, length: pos - start)
                wholeRegion.addSourceStringSegment(linkLabelSegment!)
            }
            if pos >= 0 {
                
                label = state.src.slice(start, end: pos)?.string
                pos += 1
            }
            else {
                
                pos = labelEnd! + 1
            }
        }
        else {
            
            pos = labelEnd! + 1;
        }
        
        // covers label === '' and label === undefined
        // (collapsed reference link and shortcut reference link respectively)
        if label == nil || label!.count == 0 {
            
            label = state.src.slice(labelStart, end: labelEnd)?.string
        }
        
        let ref = state.env.reference(for: normalizeReference(label!))
        
        if ref == nil {
            
            state.potentiallyLinking = true
            state.pos = oldPos
            return false
        }
        
        attrsBlocs = ref!.attrsBlocs
        href = ref!.href
        title = ref!.title
    }
    
    //
    // We found the end of the link, and know for a fact it's a valid link;
    // so all that's left to do is to call tokenizer.
    //
    if !silent {
        
        let imageToken = state.push(.image, tag: "img", nesting: .selfClosing)
        
        if let label = label {
            imageToken.referenceLabel = label.lowercased()
            state.env.referencingTokens.insert(imageToken)
        }
        imageToken.attrs = [("src", href), ("alt", "")]
        imageToken.attrsBlocs = attrsBlocs
        
        if labelEnd! - labelStart > 0 {
            
            let subRegion = state.sourceFragment.subRegion(fromPosition: labelStart, endPosition: labelEnd!)!
            let tokens = Tokens()
            let content = state.src.slice(labelStart, end: labelEnd)!
        
            state.md.inline.parse(state.src.slice(labelStart, end: labelEnd)!, stringRegion: subRegion, md: state.md, env: state.env, outTokens: tokens)
        
            imageToken.children = tokens
            imageToken.content = content.string
        }
        
        
        imageToken.setSourceFragment(linkTextSegment, for: .Text)
        imageToken.setSourceFragment(wholeRegion, for: .All)
        imageToken.setSourceFragment(tagRegion, for: .Tag)
        
        if let titleRegion = titleRegion {
            imageToken.setSourceFragment(titleRegion, for: .Title)
        }
        
        if let destinationRegion = destinationRegion {
            imageToken.setSourceFragment(destinationRegion, for: .Destination)
        }
        
        if let linkLabelSegment = linkLabelSegment {
            imageToken.setSourceFragment(linkLabelSegment, for: .Label)
        }
        
        if !title.isEmpty {
            
            imageToken.attrs!.append(("title", title))
        }
    }
    
    state.pos = pos
    state.posMax = max
    return true
}
