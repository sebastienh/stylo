//
//  DynamicStylableString.swift
//  Common
//
//  Created by Sébastien Hamel on 2017-09-12.
//  Copyright © 2017 NM. All rights reserved.
//

import Foundation
import os

open class DynamicStylableString: Observable {
    
    public let lock = ReadWriteLock()
    
    public let listenersQueue = DispatchQueue(label: "net.textually.DynamicStylableString.Listeners", attributes: .concurrent)
    
    public enum StylableStringChange {
        
        case newValue(value: AttributedStringChangeRecorder?)
        case updateAttributes(value: AttributedStringChangeRecorder, ranges: [NSRange])
        case updateTemporaryAttributes(value: AttributedStringChangeRecorder, ranges: [NSRange])
    }
    
    private var synchronizedValue: SynchronizedValue<AttributedStringChangeRecorder?>
    
    public var value: AttributedStringChangeRecorder? {
        
        get {
            return synchronizedValue.value
        }
        set {
            synchronizedValue.value = newValue
        }
    }
    
    public convenience init(string: String) {
        
        self.init(AttributedStringChangeRecorder(string: string))
    }
    
    public init(_ v: AttributedStringChangeRecorder?) {
        
        synchronizedValue = SynchronizedValue<AttributedStringChangeRecorder?>(value: v)
        listeners = [WeakListener: ObserverClosure]()
    }
    
    public func setValue(_ newValue: AttributedStringChangeRecorder?, notify: Bool = true) {
        
        self.synchronizedValue.value = newValue
        if notify {
            notifySubscribers(StylableStringChange.newValue(value: newValue))
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Observable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public typealias ChangeNotificationType = StylableStringChange
    
    public typealias ObserverClosure = (StylableStringChange) -> Void
    
    public var listeners: [WeakListener: ObserverClosure]
    
}
