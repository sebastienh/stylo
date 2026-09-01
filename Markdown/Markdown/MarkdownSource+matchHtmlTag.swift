//
//  String+matchHtmlTag.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-30.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

extension MarkdownSource {
    
    func matchHtmlTag(_ tag: HtmlElement, fromPosition position: Int = 0) -> HtmlElement? {
        
        let tagString = §tag
        
        for i in 0..<tagString.length {
            
            let tagChar = tagString.charAt(i)!
            
            if i < length {
                
                let selfChar = charAt(i)!
                
                if tagChar != selfChar {
                    
                    return nil
                }
            }
            else {
                
                return nil
            }
        }
        
        return tag
    }
    
}
