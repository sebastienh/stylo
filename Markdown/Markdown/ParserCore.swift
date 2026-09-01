//
//  ParserCore.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-24.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

enum CoreTokenizeRule: String {
    
    case Normalize = "normalize"
    case Block = "block"
    case Inline = "inline"
    case ReferenceAttributes = "ref-attributes"
}

final class ParserCore: Parser {
    
    typealias CoreRuleFunction = (StateCore) -> Void
    
    let rules = [Rule<CoreRuleFunction>](arrayLiteral:
        Rule<CoreRuleFunction>(name: §CoreTokenizeRule.Normalize, fn: normalize),
        Rule<CoreRuleFunction>(name: §CoreTokenizeRule.Block, fn: block),
        Rule<CoreRuleFunction>(name: §CoreTokenizeRule.ReferenceAttributes, fn: referenceAttributes),
        Rule<CoreRuleFunction>(name: §CoreTokenizeRule.Inline, fn: inline)
//        [ 'linkify',        require('./rules_core/linkify')        ],
//        [ 'replacements',   require('./rules_core/replacements')   ],
//        [ 'smartquotes',    require('./rules_core/smartquotes')    ]
    )
    
    let ruler: Ruler<CoreRuleFunction>
    
    required init() {
        
        self.ruler = Ruler<CoreRuleFunction>(rules: rules)
    }
    
    /**
    * Core.process(state)
    *
    * Executes core chain rules.
    **/
    func process(_ state: StateCore) {
    
        let rulesFunctions: [Rule<CoreRuleFunction>] = ruler.getRules("")
    
        for rule in rulesFunctions {
            
            rule.fn(state)
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///                                  MARK: Parser protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func parse(_ src: String, md: MarkdownParser, env: Any, tokens: Tokens) {
        
        fatalError("Missing implementation.")
    }
    
}
