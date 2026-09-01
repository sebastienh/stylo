//
//  atttributes_block.swift
//  Markdown
//
//  Created by Sebastien hamel on 2019-04-30.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import Common

/// attributes block
func attributes_block(_ state: StateBlock, startLine: Int, endLine: Int, silent: Bool) -> Bool {

    var pos = state.bMarks[startLine] + state.tShift[startLine]
    let max = state.eMarks[startLine]
    
    // if it's indented more than 3 spaces, it should be a code block
    if state.sCount[startLine] - state.blkIndent >= 4 {
        return false
    }
    
    if pos + 3 > max {
        return false
    }
    
    if !state.allowClassNamesAttributesBlock {
        
        let ch = state.src.charAt(pos)!
        
        if ch != §UnicodeCharacter.leftCurlyBracket {
            return false
        }
    }
    else {
        
        // we are in a container block parsing the header, which
        // we consider as a attributes bloc
    }
    
    let attrStart = pos
    
    let attributesBloc: AttributesBloc?
    
    // this setting is put on by the container bloc
    if state.allowClassNamesAttributesBlock {
        attributesBloc = parseAttributes(state.src, pos: &pos, max: max)
    }
    else {
        attributesBloc = parseAttributesBloc(state.src, pos: &pos, max: max)
    }
    
    // if we don't have attributes it is not a starting indicator
    if let attributesBloc = attributesBloc {
        
        // attributes bloc can not be followed by anything
        // other than whitespaces on the same line... if it is
        // the case then the attributes bloc will be handled as
        // an inline part of a paragraph.
        let attributesBlocEndIndex = attributesBloc.range.upperBound
        let endPosition = state.skipSpaces(attributesBlocEndIndex)
        
        // If we are in a container we allow characters after,
        // otherwise no. 
        if endPosition != max && !state.allowClassNamesAttributesBlock {
            return false
        }
        
        state.allowClassNamesAttributesBlock = false
        
        if silent {
            return true
        }
        
        if state.shouldStopToCompile(from: attrStart, tokenType: .attrBlocOpen) {
            return false
        }
        
        let attrBlocTokens = attributesBloc.pushAttributesBlocTokens(in: state)
        state.line += 1
        
        assert(attrBlocTokens != nil)
        if let (startToken, closeToken) = attrBlocTokens {
        
            startToken.startLine = startLine
            closeToken.endLine = state.line
            if startLine > 0 {
                let emptyLineAboveToken = state.isEmpty(startLine-1)
                startToken.emptyLineAbove = emptyLineAboveToken
            }
            else {
                startToken.emptyLineAbove = true 
            }
        }
        
        return true
    }
    else {
        return false
    }
}
