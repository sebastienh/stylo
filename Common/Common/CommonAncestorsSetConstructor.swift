//
//  RootPathable.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-05-28.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

/// An ancestors set is the set constructed for a child node in a
/// tree that includes all nodes and parent nodes until the root 
/// nodes is reached. In DOM, those nodes are called the ancestors.
/// The AncestorsSetConstructor protocol defines the functions that a 
/// node must implement to, in order
public protocol CommonAncestorsSetConstructor: class {
    
    associatedtype AncestorType : Hashable
    
    func buildInitialCommonAncestorSet() -> Set<AncestorSetItem<AncestorType>>
    
    func buildCommonAncestorsSet(_ set: inout Set<AncestorSetItem<AncestorType>>)
    
}
