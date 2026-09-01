//
//  RandomlyAccessibleIndices.swift
//  Common
//
//  Created by Sébastien Hamel on 2016-09-03.
//  Copyright © 2016 NM. All rights reserved.
//

import Foundation

protocol RandomlyAccessibleIndices {
    
    associatedtype IndiceType
    
    var first: IndiceType? { get }
    
    var count: Int { get }
    
    subscript(index: Int) -> IndiceType { get set }
    
    mutating func addSegment(_ segment: SourceStringSegment)
    
    mutating func removeAll()
    
    mutating func removeLast()
    
    mutating func removeFirst()
}
