//
//  IdGenerator.swift
//  Common
//
//  Created by Sébastien Hamel on 2018-10-12.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation

public protocol IdGenerator: class {
    
    var idPrefix: String { get }
    
    var nextIntegerSeed: Int { get }
    
    var nextId: String? { get }
    
    func generateId(from value: Int) -> String?
    
    func order(from id: String) -> Int?
}

extension IdGenerator {
    
    public var nextId: String? {

        return generateId(from: nextIntegerSeed)
    }
    
    public func generateId(from value: Int) -> String? {
        
        return "\(idPrefix)-\(value)"
        
    }
    
    public func order(from id: String) -> Int? {
        
        let suffix = id.slice(idPrefix.count+1)
        
        assert(suffix != nil)
        if let suffix = suffix {
            
            assert(Int(suffix) != nil)
            return Int(suffix)
        }
        return nil
    }
    
}
