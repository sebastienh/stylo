//
//  ParserInline.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-24.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

enum InlineTokenizeRule: String {
    
    case Text = "text"
    case NewLine = "newLine"
    case HtmlInline = "html_inline"
    case Backticks = "backticks"
    case Autolink = "autolink"
    case Entity = "entity"
    case Escape = "escape"
    case Emphasis = "emphasis"
    case Image = "image"
    case Link = "link"
    case Strikethrough = "strikethrough"
    case AttributesBloc = "attributes_bloc"
    case Span = "span"
}

enum InlinePostProcessingRule: String {
    
    case BalancePair = "balance_pairs"
    case TextCollapse = "text_collapse"
    case Emphasis = "emphasis"
    case Strikethrough = "strikethrough"
}

final class ParserInline: Parser {
    
    typealias InlineRuleFunction = (StateInline, Bool) -> Bool
    
    let rules = [Rule<InlineRuleFunction>](arrayLiteral:
        Rule<InlineRuleFunction>(name: §InlineTokenizeRule.Text, fn: text),
        Rule<InlineRuleFunction>(name: §InlineTokenizeRule.NewLine, fn: newline),
        Rule<InlineRuleFunction>(name: §InlineTokenizeRule.Escape, fn: escape),
        Rule<InlineRuleFunction>(name: §InlineTokenizeRule.Backticks, fn: backticks),
        Rule<InlineRuleFunction>(name: §InlineTokenizeRule.Strikethrough, fn: strikethroughTokenize),
        Rule<InlineRuleFunction>(name: §InlineTokenizeRule.Emphasis, fn: emphasisTokenize),
        Rule<InlineRuleFunction>(name: §InlineTokenizeRule.Link, fn: _link),
        Rule<InlineRuleFunction>(name: §InlineTokenizeRule.Image, fn: image),
        Rule<InlineRuleFunction>(name: §InlineTokenizeRule.Autolink, fn: autolink),
        Rule<InlineRuleFunction>(name: §InlineTokenizeRule.HtmlInline, fn: html_inline),
        Rule<InlineRuleFunction>(name: §InlineTokenizeRule.Entity, fn: entity),
        Rule<InlineRuleFunction>(name: §InlineTokenizeRule.Span, fn: span),
        Rule<InlineRuleFunction>(name: §InlineTokenizeRule.AttributesBloc, fn: attributes_inline)
    )
    
    let rules2 = [Rule<InlineRuleFunction>](arrayLiteral:
        Rule<InlineRuleFunction>(name: §InlinePostProcessingRule.BalancePair, fn: balance_pairs),
        Rule<InlineRuleFunction>(name: §InlinePostProcessingRule.Strikethrough, fn: strikethroughPostProcess),
        Rule<InlineRuleFunction>(name: §InlinePostProcessingRule.Emphasis, fn: emphasisPostProcess),
        Rule<InlineRuleFunction>(name: §InlinePostProcessingRule.TextCollapse, fn: text_collapse)
    )

    let ruler: Ruler<InlineRuleFunction>
    
    let ruler2: Ruler<InlineRuleFunction>
    
    required init() {
        
        self.ruler = Ruler(rules: rules)
        self.ruler2 = Ruler(rules: rules2)
    }
    
    /// ParserInline.parse(str, md, env, outTokens)
    ///
    /// Process input string and push inline tokens into `outTokens`
    func parse(_ src: MarkdownString, stringRegion: SourceStringRegion, md: MarkdownParser, env: Env, outTokens: Tokens) {

//        #if DEBUG
//        assert(stringRegion.ordered)
//        #endif
//            
        let state = StateInline(src: src, sourceFragment: stringRegion, md: md, env: env, outTokens: outTokens)
        
        tokenize(state)
            
        let rules = ruler2.getRules("")
        let len = rules.count
            
        for i in 0 ..< len {
        
            rules[i].fn(state, false)
        }
    }
    
    /// Skip single token by running all rules in validation mode;
    /// returns `true` if any rule reported success
    func skipToken(_ state: StateInline) {
    
        let pos = state.pos
        let rules = ruler.getRules("")
        let len = rules.count
        let maxNesting = state.md.options.maxNesting
        var ok = false
        
        // if it defined
        // original code:
        //
        // ```javascript
        //
        // if (typeof cache[pos] !== 'undefined') {
        //      state.pos = cache[pos];
        //      return;
        // }
        // ```
        if state.cache[pos] != nil {
            state.pos = state.cache[pos]!
            return
        }
        
        /*istanbul ignore else*/
        if state.level < maxNesting {
    
            for rule in rules {
    
                state.level += 1
                ok = rule.fn(state, true)
                state.level -= 1
                
                if ok {
                    break
                }
            }
        }
        else {
            
            // Too much nesting, just skip until the end of the paragraph.
            //
            // NOTE: this will cause links to behave incorrectly in the following case,
            //       when an amount of `[` is exactly equal to `maxNesting + 1`:
            //
            //       [[[[[[[[[[[[[[[[[[[[[foo]()
            //
            // TODO: remove this workaround when CM standard will allow nested links
            //       (we can replace it by preventing links from being parsed in
            //       validation mode)
            //
            state.pos = state.posMax
        }
        
        if !ok {
            state.pos += 1
        }
        state.cache[pos] = state.pos
    }
    
    // Generate tokens for input range
    //
    func tokenize(_ state: StateInline) {
        
        var ok = false
        let rules = ruler.getRules("")
        let end = state.posMax
        let maxNesting = state.md.options.maxNesting
    
        while state.pos < end {

            // Try all possible rules.
            // On success, rule should:
            //
            // - update `state.pos`
            // - update `state.tokens`
            // - return true
    
            if state.level < maxNesting {

                for rule in rules {

                    ok = rule.fn(state, false)
                    
                    if ok {
                        break
                    }
                }
            }
    
            if ok {

                if (state.pos >= end) {
                    break
                }
                continue
            }
    
            state.addTextToPendingText(String(describing: UnicodeScalar(state.src.charAt(state.pos)!)!))
            let segment = state.sourceStringSegmentFromPosition(state.pos, length: 1)!
            state.pendingRegion.addSourceStringSegment(segment)
            state.pos += 1
        }
    
        if state.pendingTextLength != 0 {
            
            state.pushPending()
        }
    }
    
}
