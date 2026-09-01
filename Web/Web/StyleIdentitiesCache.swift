//
//  StyleIdentitiesCache.swift
//  Web
//
//  Created by Sebastien Hamel on 2020-10-15.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Common

final class StyleIdentitiesCache {
    
    private var styleIdentities: [TreePositionIdentity: [TreePseudoClassesIdentity: StyleIdentity]]
    
    private let lock: ReadWriteLock
    
    init() {
        self.styleIdentities = [TreePositionIdentity: [TreePseudoClassesIdentity: StyleIdentity]]()
        self.lock = ReadWriteLock()
    }
    
    public func clean() {
        
        lock.writeLock()
        defer {
            lock.unlock()
        }
        self.styleIdentities.removeAll(keepingCapacity: true)
    }
    
    func addStyleIdentity(_ styleIdentity: StyleIdentity, toTreePositionIdentity treePositionIdentity: TreePositionIdentity, for treePseudoClassesIdentity: TreePseudoClassesIdentity) {
        
        lock.writeLock()
        defer {
            lock.unlock()
        }
        if self.styleIdentities[treePositionIdentity] == nil {
            self.styleIdentities[treePositionIdentity] = [:]
        }
        
        assert(self.styleIdentities[treePositionIdentity] != nil)
        self.styleIdentities[treePositionIdentity]?[treePseudoClassesIdentity] = styleIdentity
    }
    
    func styleIdentity(forTreePositionIdentity treePositionIdentity: TreePositionIdentity, treePseudoClassesIdentity: TreePseudoClassesIdentity) -> StyleIdentity? {
        
        lock.readLock()
        defer {
            lock.unlock()
        }
        return self.styleIdentities[treePositionIdentity]?[treePseudoClassesIdentity]
    }
    
}
