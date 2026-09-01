//
//  SortedMessagesArray.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-04-03.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
//struct SortedArray<T: Comparable> {
//    
//    private var contents: [T] = []
//    
//    init<S : SequenceType where S.Generator.Element == T>(_ sequence: S) {
//        contents = sorted(sequence)
//    }
//    
//    func indexOf(value: T) -> Int? {
//        let index = _insertionIndex(contents, forValue: value)
//        if index >= contents.count {
//            return nil
//        }
//        return contents[index] == value ? index : nil
//    }
//    
//    mutating func insert(value: T) {
//        contents.insert(value, atIndex: _insertionIndex(contents, forValue: value))
//    }
//    
//    mutating func remove(value: T) -> T? {
//        if let index = indexOf(value: value) {
//            return contents.removeAtIndex(index)
//        }
//        return nil
//    }
//}
