//
//  Presets+CommonMark.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-24.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

extension Presets {
    
    public static func GetCommonMarkPresets() -> Presets {
        
        if self.commonMarkPresetsInstance == nil {
            
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
                    BlockTokenizeRule.BlockQuote,
                    BlockTokenizeRule.Code,
                    BlockTokenizeRule.Fence,
                    BlockTokenizeRule.Heading,
                    BlockTokenizeRule.Hr,
                    BlockTokenizeRule.HtmlBlock,
                    BlockTokenizeRule.LHeading,
                    BlockTokenizeRule.List,
                    BlockTokenizeRule.Reference,
                    BlockTokenizeRule.Paragraph
                ],
                
                inlineRules: [
                    InlineTokenizeRule.Autolink,
                    InlineTokenizeRule.Backticks,
                    InlineTokenizeRule.Emphasis,
                    InlineTokenizeRule.Entity,
                    InlineTokenizeRule.Escape,
                    InlineTokenizeRule.HtmlInline,
                    InlineTokenizeRule.Image,
                    InlineTokenizeRule.Link,
                    InlineTokenizeRule.NewLine,
                    InlineTokenizeRule.Text
                ],
                
                inlineRules2: [
                    InlinePostProcessingRule.BalancePair,
                    InlinePostProcessingRule.Emphasis,
                    InlinePostProcessingRule.TextCollapse
                ])
            
            self.commonMarkPresetsInstance = Presets(options: options, components: components)
        }
        
        return self.commonMarkPresetsInstance!
    }

    
}
