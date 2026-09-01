//
//  UserAgent.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-15.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common

public final class UserAgent {
    
    /// Singleton instance.
    static var shared = UserAgent()
    
    internal var fontFamilies: [String : [String]]
    
    fileprivate init() {
        
        self.fontFamilies = [String : [String]]()
        
        updateFontFamiliesComponents()
    }
}
