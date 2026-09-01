//
//  referenceAttributes.swift
//  Markdown
//
//  Created by Sebastien hamel on 2019-05-09.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation

func referenceAttributes(_ state: StateCore) {
    
    let tokens = state.tokens
    
    // Parse inlines
    for (index, token) in tokens.enumerated() {
     
        if token.type == .reference {
            
            var attributesBLocs = [AttributesBloc]()
            
            if let preceedingAttributesBlocs = preceedingAttrs(from: index, in: tokens) {
                attributesBLocs.append(contentsOf: preceedingAttributesBlocs)
            }
            if let referenceInlineAttrs = inlineAttrs(from: token) {
                attributesBLocs.append(contentsOf: referenceInlineAttrs)
            }
            if let nextSiblingAttributesBloc = nextSiblingAttrs(from: index, in: tokens) {
                attributesBLocs.append(contentsOf: nextSiblingAttributesBloc)
            }
            
            let range = token.sourceFragment(for: .All)?.range
            
            assert(range != nil)
            if let range = range {
                
                var offsetRange = range
                if let globalPositionOffset = state.md.globalPositionOffset {
                    offsetRange.move(globalPositionOffset)
                }
                
                // get the reference
                let label = token.referenceLabel
                
                assert(label != nil)
                if let label = label {
                    state.env.updateReferenceEntryAttributes(with: label, attrs: attributesBLocs, in: offsetRange.asRange)
                }
            }
        }
    }
}

fileprivate func preceedingAttrs(from index: Int, in tokens: Tokens) -> [AttributesBloc]? {
    
    var attrs = [AttributesBloc]()
    let indexes = tokens.attributesBlocsStartTokenIndexesBefore(index: index)
    
    for index in indexes {
        
        let attrStartToken = tokens[index]
        
        assert(attrStartToken != nil)
        if let attrStartToken = attrStartToken {
        
            assert(attrStartToken.type.isAttributesBlocStartToken)
            let attrsBlocs = attrStartToken.attrsBlocs
            
            assert(attrsBlocs != nil)
            if let attrsBlocs = attrsBlocs {
                
                attrs.append(contentsOf: attrsBlocs)
            }
        }
    }
    return attrs
}

fileprivate func inlineAttrs(from reference: Token) -> [AttributesBloc]? {
    
    if reference.children.length != 0 {
        if reference.children[0]?.type == .attrBlocOpen {
            return reference.children[0]?.attrsBlocs
        }
    }
    return nil
}

fileprivate func nextSiblingAttrs(from index: Int, in tokens: Tokens) -> [AttributesBloc]? {

    if let attributesBlocIndex = tokens.sameLevelAttributesBlocIndexOnLineBelow(tokenIndex: index) {
        
        let attributesBloc = tokens[attributesBlocIndex]
        
        assert(attributesBloc != nil)
        if let attributesBloc = attributesBloc {
        
            if attributesBloc.emptyLineAbove {
                
                return attributesBloc.attrsBlocs
            }
        }
    }
    return nil
}
