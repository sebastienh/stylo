//
//  Components.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-24.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation

enum ComponentRulesType {
    
    case core
    case block
    case inline
    case inline2
}

struct Components {
    
    let core: [String: [CoreTokenizeRule]]

    let block: [String: [BlockTokenizeRule]]
    
    let inline: [String: [InlineTokenizeRule]]
    
    let inline2: [String: [InlinePostProcessingRule]]
    
    init(coreRules: [CoreTokenizeRule], blockRules: [BlockTokenizeRule], inlineRules: [InlineTokenizeRule], inlineRules2: [InlinePostProcessingRule]) {
        
        self.core = [
        
            "rules" : coreRules
        ]
        
        self.block = [
        
            "rules" : blockRules
        ]
        
        self.inline = [
        
            "rules" : inlineRules
        ]
        
        self.inline2 = [
        
            "rules2" : inlineRules2
        ]
    }
    
}
