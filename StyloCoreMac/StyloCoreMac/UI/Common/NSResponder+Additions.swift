//
//  NSResponder+Additions.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-06-28.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa

extension NSResponder {
    
    public func next<T>() -> T? {
        
        guard let responder = self.nextResponder else {
            
            return nil
        }
        
        return (responder as? T) ?? responder.next()
    }       
}
