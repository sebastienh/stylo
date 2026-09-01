//
//  autolink.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-12-02.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}



/*eslint max-len:0*/
//var EMAIL_RE    = /^<([a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*)>/;
//var AUTOLINK_RE = /^<([a-zA-Z.\-]{1,25}):([^<>\x00-\x20]*)>/;

/// Process autolinks '<protocol:...>'
func autolink(_ state: StateInline, silent: Bool) -> Bool {
    
    func assignSegments(_ pos: Int, autolinkLength: Int, open: Token, text: Token, close: Token) {
        
        var autolinkCompleteRegion = SourceStringRegion()
        var autolinkTagRegion = SourceStringRegion()
        
        let autolinkOpenSegment = state.sourceStringSegmentFromPosition(pos, length: 1)
        autolinkCompleteRegion.addSourceStringSegment(autolinkOpenSegment!)
        autolinkTagRegion.addSourceStringSegment(autolinkOpenSegment!)
        
        let autolinkContentSegment = state.sourceStringSegmentFromPosition(pos &+ 1, length: autolinkLength - 2)
        autolinkCompleteRegion.addSourceStringSegment(autolinkContentSegment!)
        
        let autolinkCloseSegment = state.sourceStringSegmentFromPosition(pos &+ autolinkLength &- 1, length: 1)
        autolinkCompleteRegion.addSourceStringSegment(autolinkCloseSegment!)
        autolinkTagRegion.addSourceStringSegment(autolinkCloseSegment!)
        
        open.setSourceFragment(autolinkTagRegion, for: .Tag)
        open.setSourceFragment(autolinkCompleteRegion, for: .All)
        
        // handling text
        text.setSourceFragment(autolinkContentSegment, for: .Content)
        text.setSourceFragment(autolinkContentSegment, for: .All)
    }
    
    
    let pos = state.pos
    
    if let char = state.src.charAt(pos) , char != 0x3C/* < */ {
        
        return false
    }
    
    if state.src.indexOf(">", fromIndex: pos) < 0 {
        
        return false
    }
    
    if let linkMatch = state.src.matchAutolink(fromPosition: pos) {
        
        let linkMatchLength = linkMatch.first!.length
        let url = state.src.slice(pos &+ 1, end: pos &+ linkMatchLength - 1)!
        let fullUrl = state.md.normalizeLink(url.string)

        if !state.md.validateLink(fullUrl) {
            
            return false;
        }
        
        if !silent {
            
            let linkOpenToken = state.push(.linkOpen, tag: "a", nesting: .opening)
            linkOpenToken.attrs = [ ("href", fullUrl)]
            linkOpenToken.markup = "autolink"
            linkOpenToken.info = "auto"
            
            let textToken = state.push(.text, tag: "", nesting: .selfClosing)
            textToken.content = state.md.normalizeLinkText(url.string)
            
            let linkCloseToken = state.push(.linkClose, tag: "a", nesting: .closing)
            linkCloseToken.markup  = "autolink"
            linkCloseToken.info    = "auto"
            
            assignSegments(pos, autolinkLength: linkMatchLength, open: linkOpenToken, text: textToken, close: linkCloseToken)
        }
        
        state.pos += linkMatchLength
        return true
    }
    
    else if let emailAutolinkMatch = state.src.matchEmailAutolink(fromPosition: pos) {
        
        let emailAutolinkMatchLength = emailAutolinkMatch.first!.length
        let url = state.src.slice(pos + 1, end: pos + emailAutolinkMatchLength - 1)!
        let fullUrl = state.md.normalizeLink("mailto:" + url.string)
        
        if !state.md.validateLink(fullUrl) {
            
            return false;
        }
        
        if !silent {
            
            let linkOpenToken = state.push(.linkOpen, tag: "a", nesting: .opening)
            linkOpenToken.attrs = [ ("href", fullUrl)]
            linkOpenToken.markup = "autolink"
            linkOpenToken.info = "auto"
            
            let textToken = state.push(.text, tag: "", nesting: .selfClosing)
            textToken.content = state.md.normalizeLinkText(url.string)
            
            let linkCloseToken = state.push(.linkClose, tag: "a", nesting: .closing)
            linkCloseToken.markup = "autolink"
            linkCloseToken.info = "auto"

            assignSegments(pos, autolinkLength: emailAutolinkMatchLength, open: linkOpenToken, text: textToken, close: linkCloseToken)
        }
        
        state.pos += emailAutolinkMatchLength
        return true
    }
    
    return false
}
