//
//  Pushable.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-04-14.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa

public protocol Pushable {
    
    var contentView: NSView? { get }
    
    func animatePush() 
    
    func completeAfterPush()
    
    func beforeDismissal()
}

extension Pushable {
    
    public func animatePush() { }
    
    public func completeAfterPush() { }
    
    public func beforeDismissal() { }
}
