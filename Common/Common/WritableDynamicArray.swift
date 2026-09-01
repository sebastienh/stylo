//
//  ReadOnlyDynamicArray.swift
//  Common
//
//  Created by Sebastien hamel on 2019-08-31.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation

public protocol WritableDynamicArray {
    
    associatedtype T
    
    func insert(newElements: [T], at indexes: [Int], notify: Bool, sameExecutionStack: Bool)
    
    func insert(_ newElement: T, at i: Int, notify: Bool, sameExecutionStack: Bool)
    
    func append(_ item: T, notify: Bool, sameExecutionStack: Bool)
    
    func append<S>(contentsOf newElements: S, notify: Bool) where S : Sequence, T == S.Element
    
    func remove(at index: Int, notify: Bool, sameExecutionStack: Bool)
    
    func remove(at indexes: [Int], notify: Bool, sameExecutionStack: Bool)
    
    func removeAll(notify: Bool, sameExecutionStack: Bool)
    
}
