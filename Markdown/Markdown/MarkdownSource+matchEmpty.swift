//
//  String+matchEmpty.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-12-01.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

extension MarkdownSource {
    
    func matchEmpty() -> [Match]? {
        
        if length != 0 {
         
            return nil
        }
        
        return [Match(start: 0, end: 0)]
    }
}
