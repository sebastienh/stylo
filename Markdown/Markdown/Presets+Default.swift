//
//  Presets+Default.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-24.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation

public extension Presets {
    
    public static func GetDefaultPresets() -> Presets {
        
        if self.defaultPresetsInstance == nil {
            
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
                coreRules: [],
                blockRules: [],
                inlineRules: [],
                inlineRules2: [])
            
            self.defaultPresetsInstance = Presets(options: options, components: components)
        }
        
        return self.defaultPresetsInstance!
    }
    
    
    
}
