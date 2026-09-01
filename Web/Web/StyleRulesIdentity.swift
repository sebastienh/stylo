//
//  StyleRulesIdentity.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-02-15.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation

class StyleRulesIdentity: CustomStringConvertible {
    
    var description: String {
        
        return identity
    }
    
    private var identity: String
    
    static func create(from rules: [CSSStyleRule]?) -> StyleRulesIdentity {

        if let rules = rules {
            
            var identities = [String]()
            
            for rule in rules {
                identities.append(String(describing: rule.identity))
            }
            
            identities.sort()
            return StyleRulesIdentity(identity: identities.joined(separator: "-"))
        }

        return StyleRulesIdentity(identity: "")
    }
    
    private init(identity: String) {
        
        self.identity = identity
    }
}
