//
//  Rule.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-22.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common


/// {
///   name: XXX,
///   enabled: Boolean,
///   fn: Function(),
///   alt: [ name2, name3 ]
/// }
struct Rule<F> {
    
    let name: String
    
    var enabled: Bool
    
    // this is he function to execute. 
    var fn: F
    
    var alt: [String]
    
    init(name: String, enabled: Bool = true, fn: F, alt: [String]? = nil) {
    
        self.name = name
        self.enabled = enabled
        self.fn = fn
        
        if let alt = alt {

            self.alt = alt
        }
        else {
            
            self.alt = [String]()
        }
    }
    
}
