//
//  String+ExtractStringFromPreservedComponentValue.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-09-27.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation

extension String {
    
    init(preservedTokenComponentValues: [CSPreservedTokenComponentValue]) {
        
        var string = ""
        
        for preservedTokenComponentValue in preservedTokenComponentValues {
            
            string.append(preservedTokenComponentValue.cssText())
        }
        
        self.init(string)
    }
}
