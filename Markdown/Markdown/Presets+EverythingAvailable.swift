//
//  Presets+EverythingAvailable.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-26.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

extension Presets {
    
    public static func GetEverythingAvailaiblePresets() -> Presets {
        
        if self.everythingAvailableInstance == nil {
            
            let options = Options(
                markdownOut: true,
                html: true,
                xhtmlOut: true,
                breaks: false,
                langPrefix: "language-",
                linkify: false,
                typographer: false,
                quotes: "\u{201c}\u{201d}\u{2018}\u{2019}",
                highlight: nil,
                maxNesting: 20)
            
            let components = Components(
                
                coreRules: [
                    CoreTokenizeRule.Normalize,
                    CoreTokenizeRule.Block,
                    CoreTokenizeRule.Inline
                ],
                
                blockRules: [
                    BlockTokenizeRule.Heading,
                    BlockTokenizeRule.BlockQuote,
                    BlockTokenizeRule.Code,
                    BlockTokenizeRule.Fence,
                    BlockTokenizeRule.Hr,
                    BlockTokenizeRule.HtmlBlock,
                    BlockTokenizeRule.LHeading,
                    BlockTokenizeRule.List,
                    BlockTokenizeRule.Reference,
                    BlockTokenizeRule.Table,
                    BlockTokenizeRule.Paragraph
                ],
                
                inlineRules: [
                    InlineTokenizeRule.Autolink,
                    InlineTokenizeRule.NewLine,
                    InlineTokenizeRule.Text,
                    InlineTokenizeRule.HtmlInline,
                    InlineTokenizeRule.Backticks,
                    InlineTokenizeRule.Entity,
                    InlineTokenizeRule.Escape,
                    InlineTokenizeRule.Emphasis,
                    InlineTokenizeRule.Image,
                    InlineTokenizeRule.Link,
                    InlineTokenizeRule.Strikethrough
                ],
                
                inlineRules2: [
                    InlinePostProcessingRule.BalancePair,
                    InlinePostProcessingRule.TextCollapse,
                    InlinePostProcessingRule.Emphasis,
                    InlinePostProcessingRule.Strikethrough
                ]
            )
            
            self.everythingAvailableInstance = Presets(options: options, components: components)
        }
        
        return self.everythingAvailableInstance!
    }
}
