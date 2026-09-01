//
//  ElementStyleCache.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-01-15.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation
import Common
import os

/// This is the ElementStyle cache indexed by Element.
final class ElementStyleCache {
    
    private let lock: ReadWriteLock
    
    private var elementStyles: [StyleIdentity: ElementStyle]
    
    init() {
        self.elementStyles = [StyleIdentity: ElementStyle]()
        self.lock = ReadWriteLock()
    }
    
    public func clean() {
        
        lock.writeLock()
        defer {
            lock.unlock()
        }
        self.elementStyles.removeAll(keepingCapacity: true)
    }
    
    public func removeValue(forStyleIdentity styleIdentity: StyleIdentity) {

        lock.writeLock()
        defer {
            lock.unlock()
        }
        self.elementStyles.removeValue(forKey: styleIdentity)
    }
    
    public func computedStyle(forStyleIdentity styleIdentity: StyleIdentity) -> ComputedStyleDeclaration? {
        
        lock.readLock()
        defer {
            lock.unlock()
        }
        
        return self.elementStyles[styleIdentity]?.rawComputedStyle
    }
    
    public func elementStyle(forStyleIdentity styleIdentity: StyleIdentity) -> ElementStyle? {
        
        lock.readLock()
        defer {
            lock.unlock()
        }
        return self.elementStyles[styleIdentity]
    }
    
    public func elementStyleExists(forStyleIdentity styleIdentity: StyleIdentity) -> Bool {

        lock.readLock()
        defer {
            lock.unlock()
        }

        if let _ = self.elementStyles[styleIdentity] {
            return true
        }
        return false
    }
    
    public func updateElementStyle(forStyleIdentity styleIdentity: StyleIdentity, elementStyle: ElementStyle) {
        
        lock.writeLock()
        defer {
            lock.unlock()
        }
        self.elementStyles[styleIdentity] = elementStyle
    }
    
    public func updateElementStyles(with styles: [StyleIdentity: ElementStyle]) {
        
        lock.writeLock()
        defer {
            lock.unlock()
        }
    
        for (styleIdentity, elementStyle) in styles {
            self.elementStyles[styleIdentity] = elementStyle
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Equals methods
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public func equals(_ other: Any?) -> Bool {

        lock.readLock()
        defer {
            lock.unlock()
        }
        if let other = other {
            
            if let other = other as? ElementStyleCache {
                
                if self.elementStyles.count != other.elementStyles.count {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: elementStyles.count are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                for (styleIdentity, styles) in self.elementStyles {
                    
                    if let otherElementStyles = other.elementStyles[styleIdentity] {
                        if styles != otherElementStyles {
                            return false
                        }
                    }
                    else {
                        return false
                    }
                }
            }
            else {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not ElementStyleCache.", log: Log.Web.all, type: .debug)
                #endif
                return false
            }
        }
        else {
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Not equals: other is nil.", log: Log.Web.all, type: .debug)
            #endif
            return false
        }
        return true
    }
    
}
