//
//  RawComputedStyle.swift
//  Web
//
//  Created by Sebastien Hamel on 2020-10-21.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Common

public class RawComputedStyle: ComputedStyleDeclaration {
    
    /// keep all calculated values
    open var propertyValues: [DOMString: CSSPropertyValueContainer] {
        
        #if CONCURENT_RENDERING
        lock.readLock()
        defer {
            lock.unlock()
        }
        #endif
        return self._propertyValues
    }
    
    private var propertyOrigins: [DOMString: CSSOrigin] = [:]
    
    /// see CascadingPhaseOrigin
    private var propertyCascadingPhaseOrigins: [DOMString: CascadingPhaseOrigin] = [:]
    
    open var allPropertyValuesSpecified: Bool {
        #if CONCURENT_RENDERING
        lock.readLock()
        defer {
            lock.unlock()
        }
        #endif
        if _propertyValues.count == 0 {
            return false
        }
        
        for (_, propertyValue) in _propertyValues {
            if propertyValue == CSSPropertyValueContainer.none {
                return false
            }
        }
        return true
    }
    
    #if CONCURENT_RENDERING
    private let lock: ReadWriteLock
    #endif
    
    private var _propertyValues: [DOMString: CSSPropertyValueContainer] = [:]
    
    init() {
        
        #if CONCURENT_RENDERING
        self.lock = ReadWriteLock()
        #endif
    }
    
    public func setPropertyOrigin(_ propertyName: DOMString, origin: CSSOrigin) {
        #if CONCURENT_RENDERING
        lock.writeLock()
        defer {
            lock.unlock()
        }
        #endif
        assert(propertyOrigins[propertyName] == nil, "Overriding existing property origin.")
        propertyOrigins[propertyName] = origin
    }
    
    public func getPropertyOrigin(_ propertyName: DOMString) -> CSSOrigin? {
        #if CONCURENT_RENDERING
        lock.readLock()
        defer {
            lock.unlock()
        }
        #endif
        return propertyOrigins[propertyName]
    }
    
    public func propertyCascadingPhaseOrigin(forPropertyWithName name: String) -> CascadingPhaseOrigin? {
        
        #if CONCURENT_RENDERING
        lock.readLock()
        defer {
            lock.unlock()
        }
        #endif
        return propertyCascadingPhaseOrigins[name]
    }
    
    public func getCSSPropertyValueContainer(_ property: DOMString) -> CSSPropertyValueContainer? {
        
        #if CONCURENT_RENDERING
        lock.readLock()
        defer {
            lock.unlock()
        }
        #endif
        return _propertyValues[property]
    }
    
    public func setCSSPropertyValueContainer(_ propertyName: DOMString, value: CSSPropertyValueContainer) {
        
        #if CONCURENT_RENDERING
        lock.writeLock()
        defer {
            lock.unlock()
        }
        #endif
        _propertyValues[propertyName] = value
    }
    
    public func setCSSPropertyValueContainer(_ propertyName: DOMString, value: CSSPropertyValueContainer, cascadingPhase: CascadingPhaseOrigin) {
            
        #if CONCURENT_RENDERING
        lock.writeLock()
        defer {
            lock.unlock()
        }
        #endif
        _propertyValues[propertyName] = value
        propertyCascadingPhaseOrigins[propertyName] = cascadingPhase
    }
    
    public func equals(to other: Any?) -> Bool {
        
        fatalError()
    }
}
