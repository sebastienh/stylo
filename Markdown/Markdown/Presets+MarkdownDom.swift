//
//  Presets+MarkdownDom.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2016-03-14.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation

extension Presets {
    
    public static func GetMarkdownDomPresets() -> Presets {
        
        if self.markdownDomPresetsInstance == nil {
            
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
                    BlockTokenizeRule.Paragraph
                ],
                
                inlineRules: [
                    InlineTokenizeRule.Text
                ],
                
                inlineRules2: [
                    InlinePostProcessingRule.BalancePair,
                    InlinePostProcessingRule.TextCollapse
                ]
            )
            
            self.markdownDomPresetsInstance = Presets(options: options, components: components)
        }
        
        return self.markdownDomPresetsInstance!
    }
}
