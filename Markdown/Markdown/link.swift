//
//  link.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-12-03.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

/// Process [link](<to> "stuff")
/// Renamed because of conflict with Darwin code...
func _link(_ state: StateInline, silent: Bool) -> Bool {
    
    var href = ""
    let oldPos = state.pos
    let max = state.posMax
    var start = state.pos
    var parseReference = true
    var attrsBlocs: [AttributesBloc]?
    
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
    
    //
    // Parse [link] ... : we don't know if we have a link reference of an inline link
    //       ^^^^^^ parsing the link part
    //
    // Note: this is the "link text" of the [CommonMark specification](http://spec.commonmark.org/0.24/#links)
    //
    if let char = state.src.charAt(state.pos) , char != 0x5B/* [ */ {
        return false
    }
    
    let leftSquareBraquetSegment = state.sourceStringSegmentFromPosition(state.pos, length: 1)
    tagRegion.addSourceStringSegment(leftSquareBraquetSegment!)
    wholeRegion.addSourceStringSegment(leftSquareBraquetSegment!)
    
    let labelStart = state.pos + 1
    let labelEnd = state.md.parseLinkLabel(state, start: state.pos, disableNested: true)
    
    if labelEnd == nil {
        return false
    }
    
    // parser failed to find ']', so it's not a valid link
    if labelEnd! < 0 {
        return false
    }
    
    var linkTextSegment: SourceStringSegment? = nil
    if labelEnd! - labelStart > 0 {
        
        linkTextSegment = state.sourceStringSegmentFromPosition(labelStart, length: labelEnd! - labelStart)
        wholeRegion.addSourceStringSegment(linkTextSegment!)
    }
    
    let rightSquareBraquetSegment = state.sourceStringSegmentFromPosition(labelEnd!, length: 1)
    tagRegion.addSourceStringSegment(rightSquareBraquetSegment!)
    wholeRegion.addSourceStringSegment(rightSquareBraquetSegment!)
    
    var pos = labelEnd! + 1
    
    var title = ""
    
    if let char = state.src.charAt(pos) , pos < max && char == 0x28/* ( */ {
        
        //
        // Inline link
        //
        
        // might have found a valid shortcut link, disable reference parsing
        parseReference = false
        
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
        else {
        
            title = ""
        }
        
        if pos >= max || state.src.charAt(pos)! != 0x29 /* ) */ {
            
            // parsing a valid shortcut link failed, fallback to reference
            parseReference = true
        }
        else if state.src.charAt(pos)! == 0x29 /* ) */ {
            
            let rightParenthesisSegment = state.sourceStringSegmentFromPosition(pos, length: 1)
            tagRegion.addSourceStringSegment(rightParenthesisSegment!)
            wholeRegion.addSourceStringSegment(rightParenthesisSegment!)
        }
        
        pos += 1
    }
    
    var label: String?
    
    if parseReference {
        
        //
        // Link reference
        //
        // (typeof state.env.references === 'undefined')
        // We remove this part because we want to know if it is a "potentially linking position".
//        if state.env.isEmpty {
//
//            // maybe undefined is equal to this...
//            return false
//        }
        
        if let char = state.src.charAt(pos) , pos < max && char == 0x5B/* [ */ {
            
            let leftSquareBraquetSegment = state.sourceStringSegmentFromPosition(pos, length: 1)
            tagRegion.addSourceStringSegment(leftSquareBraquetSegment!)
            wholeRegion.addSourceStringSegment(leftSquareBraquetSegment!)
            
            start = pos + 1
            pos = state.md.parseLinkLabel(state, start: pos)!
            
            if pos >= 0 {

                if let _linkLabelSegment = state.sourceStringSegmentFromPosition(start, length: pos - start) {
                    linkLabelSegment = _linkLabelSegment
                    wholeRegion.addSourceStringSegment(_linkLabelSegment)
                }
                
                if let rightSquareBraquetSegment = state.sourceStringSegmentFromPosition(pos, length: 1) {
                
                    tagRegion.addSourceStringSegment(rightSquareBraquetSegment)
                    wholeRegion.addSourceStringSegment(rightSquareBraquetSegment)
                }
                
                label = state.src.slice(start, end: pos)!.string
                pos += 1 
            }
            else {
            
                pos = labelEnd! + 1
            }
        } else {
            
            pos = labelEnd! + 1
        }
        
        // covers label === '' and label === undefined
        // (collapsed reference link and shortcut reference link respectively)
        if label == nil || label!.count == 0 {
            
            label = state.src.slice(labelStart, end: labelEnd)?.string
        }
        
        let reference = normalizeReference(label!)
        let ref = state.env.reference(for: reference)
        
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
       
        state.pos = labelStart
        state.posMax = labelEnd!
        
        let linkOpenToken = state.push(.linkOpen, tag: "a", nesting: .opening)
        
        if let label = label {
            linkOpenToken.referenceLabel = label.lowercased()
            state.env.referencingTokens.insert(linkOpenToken)
        }
        linkOpenToken.attrs = [ ("href", href)]
        linkOpenToken.attrsBlocs = attrsBlocs
        
        linkOpenToken.setSourceFragment(linkTextSegment, for: .Text)
        linkOpenToken.setSourceFragment(wholeRegion, for: .All)
        linkOpenToken.setSourceFragment(tagRegion, for: .Tag)
        
        if let titleRegion = titleRegion {
            linkOpenToken.setSourceFragment(titleRegion, for: .Title)
        }
        
        if let destinationRegion = destinationRegion {
            linkOpenToken.setSourceFragment(destinationRegion, for: .Destination)
        }
        
        if let linkLabelSegment = linkLabelSegment {
            
            linkOpenToken.setSourceFragment(linkLabelSegment, for: .Label)
        }
        
        if !title.isEmpty {
    
            linkOpenToken.attrs!.append(("title", title))
        }
        
        state.md.inline.tokenize(state);
        state.push(.linkClose, tag: "a", nesting: .closing)
    }
    
    state.pos = pos
    state.posMax = max
    return true
}


