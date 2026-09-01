//
//  Resource.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-06-18.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

/// A Resource is a string document that can be referenced
/// by an URL. 
open class Resource: Hashable {
    
    open var dirty: Bool
    
    let resourceOperationQueue: OperationQueue
    
    init() {
        
        self.dirty = true
        self.resourceOperationQueue = OperationQueue()
        self.resourceOperationQueue.qualityOfService = QualityOfService.userInitiated
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Hashable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    open var hashValue: Int {
        
        return UInt(bitPattern: ObjectIdentifier(self)).hashValue
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                  MARK: Equatable protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////

public func ==(lhs: Resource, rhs: Resource) -> Bool {
    
    return lhs.hashValue == rhs.hashValue
}
