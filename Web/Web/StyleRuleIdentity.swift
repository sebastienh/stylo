//
//  StyleRuleIdentity.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-02-15.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation

class StyleRuleIdentity: CustomStringConvertible {
    
    var description: String {
        
        return self.identity
    }
    
    private var identity: String
    
    static func create(from node: CSSStyleRule) -> StyleRuleIdentity {
        assert(node.sourceStringFragment != nil)
        if let sourceStringFragment = node.sourceStringFragment {
            return StyleRuleIdentity(identity: node.selectorText + sourceStringFragment.stringRepresentation)
        }
            
        let properties = node.style?.propertyValues.keys.joined(separator: "")
        
        assert(properties != nil)
        if let properties = properties {
            return StyleRuleIdentity(identity: node.selectorText + properties)
        }
        else {
            
            return StyleRuleIdentity(identity: node.selectorText)
        }
    }
    
    private init(identity: String) {
        
        self.identity = identity
    }
}
