//
//  LoadStringContentOperation.swift
//  Common
//
//  Created by Sébastien Hamel on 2015-10-21.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation

import Foundation

public final class LoadStringContentOperation: Operation, StringContainer {
    
    /// Output NSString property
    public var loadedContent: NSString?
    
    fileprivate let initialString: String
    
    /// Initialiser
    public init(initialString: String) {
        
        self.initialString = initialString
    }
    
    override public func main() {
        
        self.loadedContent = initialString as NSString

    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: StringContainer protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public var resultString: NSString {
        
        return loadedContent!
    }
}
