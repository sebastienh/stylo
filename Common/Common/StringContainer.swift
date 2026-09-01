//
//  StringContainer.swift
//  Common
//
//  Created by Sébastien Hamel on 2015-08-24.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

public protocol StringContainer: class {
    
    var resultString: NSString { get }
    
}

extension NSString: StringContainer {
    
    public var resultString: NSString {
    
        return self
    }
}
