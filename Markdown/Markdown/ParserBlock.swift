//
//  ParserBlock.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-24.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

enum BlockTokenizeRule: String {
    
    case Paragraph = "paragraph"
    case BlockQuote = "blockquote"
    case Heading = "heading"
    case Code = "code"
    case Fence = "fence"
    case Hr = "hr"
    case HtmlBlock = "html_block"
    case LHeading = "lheading"
    case List = "list"
    case Reference = "reference"
    case Table = "table"
    case AttributesBloc = "attributes_block"
    case Container = "container"
}


/// internal
/// class ParserBlock
///
/// Block-level tokenizer.
///
final class ParserBlock: Parser {

    typealias BlockRuleFunction = (StateBlock, Int, Int, Bool) -> Bool
    
    let rules = [Rule<BlockRuleFunction>](arrayLiteral:
        // First 2 params - rule name & source. Secondary array - list of rules,
        // which can be terminated by this one.
        Rule(name: §BlockTokenizeRule.AttributesBloc, fn: attributes_block, alt:[§BlockTokenizeRule.Paragraph, §BlockTokenizeRule.Reference, §BlockTokenizeRule.BlockQuote, §BlockTokenizeRule.List]),
        Rule(name: §BlockTokenizeRule.Table, fn: table, alt: [§BlockTokenizeRule.Paragraph, §BlockTokenizeRule.Reference]),
        Rule(name: §BlockTokenizeRule.Code, fn: code),
        Rule(name: §BlockTokenizeRule.Fence, fn: fence, alt: [§BlockTokenizeRule.Paragraph, §BlockTokenizeRule.Reference, §BlockTokenizeRule.BlockQuote, §BlockTokenizeRule.List]),
        Rule(name: §BlockTokenizeRule.Container, fn: container, alt: [§BlockTokenizeRule.Paragraph, §BlockTokenizeRule.Reference, §BlockTokenizeRule.BlockQuote, §BlockTokenizeRule.List]),
        Rule(name: §BlockTokenizeRule.BlockQuote, fn: blockquote, alt:  [§BlockTokenizeRule.Paragraph, §BlockTokenizeRule.Reference, §BlockTokenizeRule.BlockQuote, §BlockTokenizeRule.List]),
        Rule(name: §BlockTokenizeRule.Hr, fn: hr, alt: [§BlockTokenizeRule.Paragraph, §BlockTokenizeRule.Reference, §BlockTokenizeRule.BlockQuote, §BlockTokenizeRule.List]),
        Rule(name: §BlockTokenizeRule.List, fn: list, alt: [§BlockTokenizeRule.Paragraph, §BlockTokenizeRule.Reference, §BlockTokenizeRule.BlockQuote]),
        Rule(name: §BlockTokenizeRule.Reference, fn: reference),
        Rule(name: §BlockTokenizeRule.Heading, fn: heading, alt: [§BlockTokenizeRule.Paragraph, §BlockTokenizeRule.Reference, §BlockTokenizeRule.BlockQuote]),
        Rule(name: §BlockTokenizeRule.LHeading, fn: lheading),
        Rule(name: §BlockTokenizeRule.HtmlBlock, fn: html_block, alt: [§BlockTokenizeRule.Paragraph, §BlockTokenizeRule.Reference, §BlockTokenizeRule.BlockQuote]),
        Rule(name: §BlockTokenizeRule.Paragraph, fn: paragraph)
    )
    
    let ruler: Ruler<BlockRuleFunction>
    
    required init() {
        
        self.ruler = Ruler<BlockRuleFunction>(rules: rules)
    }
    
    
    ///
    /// ParserBlock.parse(str, md, env, outTokens)
    ///
    /// Process input string and push block tokens into `outTokens`
    ///
    func parse(_ src: MarkdownString?, md: MarkdownParser, env: Env, outTokens: Tokens) {
    
        #if DEBUG
        assert(src!.length == md.src.length)
        #endif
        if src == nil || src!.length == 0 {
            
            // original code states that we should return this 
            // but after code inspection there is nowhere were it is 
            // used so
//            return Tokens()
            return
        }
    
        let state = StateBlock(src: src!, md: md, env: env, tokens: outTokens)
    
        // here we will iterate through all the lines
        tokenize(state, startLine: state.line, endLine: state.lineMax);
    }
 
    /// Generate tokens for input range
    ///
    func tokenize(_ state: StateBlock, startLine: Int, endLine: Int) {
    
        let rules = ruler.getRules("")
        let len = rules.count
        var line = startLine
        var hasEmptyLines = false
        let maxNesting = state.md.options.maxNesting
    
        // while we have not reached the endLine
        while line < endLine && !state.md.shouldStop {

            line = state.skipEmptyLines(line)
            state.line = line
            
            if line >= endLine {
                
                break
            }
    
            // Termination condition for nested calls.
            // Nested calls currently used for blockquotes & lists
            if state.sCount[line] < state.blkIndent {
                
                break
            }
    
            // If nesting level exceeded - skip tail to the end. That's not ordinary
            // situation and we should not care about content.
            if state.level >= maxNesting {

                state.line = endLine
                break
            }
    
            // Try all possible rules.
            // On success, rule should:
            //
            // - update `state.line`
            // - update `state.tokens`
            // - return true
    
            for i in 0..<len {
                
                let ok = rules[i].fn(state, line, endLine, false)
                
                if ok || state.md.shouldStop {
                    
                    break
                }
            }
    
            // set state.tight if we had an empty line before current tag
            // i.e. latest empty line should not count
            state.tight = !hasEmptyLines
    
            // paragraph might "eat" one newline after it in nested lists
            if state.isEmpty(state.line - 1) {

                hasEmptyLines = true
            }
    
            line = state.line
    
            if line < endLine && state.isEmpty(line) {

                hasEmptyLines = true
                line += 1             
                state.line = line
            }
        }
        
        /// Here we are updating the status saying that
        /// we stopped because it was requested, we may
        /// have reached the end of the string to parse.
        if state.md.shouldStop {
            
            state.md.stopped = true
        }
    }
}
