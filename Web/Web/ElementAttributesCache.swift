//
//  ElementAttributesCache.swift
//  Web
//
//  Created by Sebastien Hamel on 2020-10-15.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Common

final class ElementAttributesCache {
    
    private var elementsAttributes: [StyleIdentity: [[NSAttributedString.Key: Any]]]
    
    private let lock: ReadWriteLock
    
    init() {
        self.elementsAttributes = [StyleIdentity: [[NSAttributedString.Key: Any]]]()
        self.lock = ReadWriteLock()
    }
    
    public func clean() {
        lock.withWriteLock {
            self.elementsAttributes.removeAll(keepingCapacity: true)
        }
    }
    
    public func setAttributes(_ attributes: [[NSAttributedString.Key: Any]], forStyleIdentity styleIdentity: StyleIdentity) {
        lock.withWriteLock {
            self.elementsAttributes[styleIdentity] = attributes
        }
    }
    
    public func elementAttributes(forStyleIdentity styleIdentity: StyleIdentity) -> [[NSAttributedString.Key: Any]]? {
        return lock.withReadLock {
            return self.elementsAttributes[styleIdentity]
        }
    }
}
