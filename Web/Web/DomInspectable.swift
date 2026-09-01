//
//  DomInspectable.swift
//  Web
//
//  Created by Sébastien Hamel on 2016-01-09.
//  Copyright © 2016 NM. All rights reserved.
//

import Foundation

/// This protocol defines what an element should imlplement
/// in order to be displayable in the a DOM inspector.
public protocol DomInspectable: class {
        
    var inspectablePath: [Int] { get }
    
    var range: NSRange? { get }
    
    var nodeType: NodeType { get }
    
    var expanded: Bool { get set }
    
    var inspectableParent: DomInspectable? { get }
    
    var inspectableChilds: [DomInspectable]? { get }
    
    var numberOfChildren: Int { get }
    
    var expandable: Bool { get }
    
    var expandedOpenElementString: String { get }
    
    var unexpandedElementString: String { get }
    
    func hasChildNodes() -> Bool
    
    func hasOnlyChildTextNodes() -> Bool
    
    func childAtIndex(_ index: Int) -> DomInspectable?
    
    func inspectable(at path: [Int]) -> DomInspectable?
}
