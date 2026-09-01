//
//  Cancelable.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2016-06-21.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation

public protocol Cancelable: class {
    
    var isCancelled: Bool { get }
    
}

extension Operation: Cancelable {
    
    
}
