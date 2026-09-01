//
//  Presets+Zero.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-24.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation

extension Presets {
    
    public static func GetZeroPresets() -> Presets {
        
        if self.zeroPresetsInstance == nil {
            
            let options = Options(
                markdownOut: false,
                html: false,
                xhtmlOut: false,
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
            
            self.zeroPresetsInstance = Presets(options: options, components: components)
        }
        
        return self.zeroPresetsInstance!
    }
}
