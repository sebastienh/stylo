//
//  StyleIdentity.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-02-15.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation

/// The StyleIdentity is the identity of a style no matter
/// the element. If two elements share a same style Identity
/// at one point we consider we can apply the same style to them.
///
/// A StyleIdentity can be built using the identity of the element
/// and all it's parent when the style has no following sibling
/// selectors and/or next sibling selector, or using the applicable rules
/// of the element and the style identity of it's parent when the style
/// contains following sibling selectors and/or next sibling selector.
struct StyleIdentity: Hashable, CustomStringConvertible {
    
    var description: String {
        return identity
    }
    
    let identity: String
    
    private let _hashValue: Int
    
    var hashValue: Int {
        return _hashValue
    }
    
    static let dummy = StyleIdentity(string: "dummy")
    
    static func ==(lhs: StyleIdentity, rhs: StyleIdentity) -> Bool {

        return lhs.identity == rhs.identity
    }

    private init(string: String) {
        
        self.identity = string
        self._hashValue = identity.hashValue
    }
    
    /// This constructor is for a style without following sibling
    /// selectors and/or next sibling selector. Since a same element
    /// will resolve to same applicable rules, we only need the element
    /// identity plus the parents identity to create the StyleIdentity.
    init(treePseudoClassesIdentity: TreePseudoClassesIdentity, treePositionIdentity: TreePositionIdentity) {
        self.identity = treePseudoClassesIdentity + "-" + treePositionIdentity
        self._hashValue = identity.hashValue
    }
    
    /// This constructor is for a style with following sibling
    /// selectors and/or next sibling selector. Since we assume
    /// that the element applicable rules have been computed it means
    /// the type of the element itself doesn't matter anymore, only
    /// it's place in the tree so that's the reason the only information
    /// we need more is the parent element identity.
    init(node: Node, applicableRules: [CSSStyleRule]?, parentStyleIdentity: StyleIdentity?) {
        
        if let applicableRules = applicableRules {
            let rulesIdentity = StyleRulesIdentity.create(from: applicableRules)
            if let parentStyleIdentity = parentStyleIdentity {
                self.identity = String(describing: parentStyleIdentity) + String(describing: rulesIdentity)
            }
            else {
                self.identity = node.nodeName
            }
        }
        else {
            if let parentStyleIdentity = parentStyleIdentity {
                self.identity = String(describing: parentStyleIdentity)
            }
            else {
                self.identity = node.nodeName
            }
        }
            
        self._hashValue = identity.hashValue
    }
    
    init(node: PseudoElement, applicableRules: [CSSStyleRule]?, associatedElementStyleIdentity: StyleIdentity?, withElement element: Element) {
        
        var identity = node.localName
        
        // A Pseudo-element can be associated to another pseudo-element
        while let pseudo = element as? PseudoElement {
            identity += pseudo.localName
        }
        
        if let applicableRules = applicableRules {
            let rulesIdentity = StyleRulesIdentity.create(from: applicableRules)
            self.identity = identity + String(describing: associatedElementStyleIdentity) + String(describing: rulesIdentity)
        }
        else {
            self.identity = identity + String(describing: associatedElementStyleIdentity)
        }
        self._hashValue = identity.hashValue
    }
}
