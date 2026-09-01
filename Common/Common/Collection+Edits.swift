//
//  Collection+Edits.swift
//  Common
//
//  Created by Sebastien Hamel on 2020-03-24.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

extension Array where Element: Equatable{
    
    public mutating func applyEditOperations(_ operations: [ArrayEdit<Element>]) {
        
        var factor = 0
        for operation in operations {
            
            switch operation {
            case .add(let index, let value):
                self.insert(value, at: index+factor)
                factor += 1
            case .delete(let index):
                self.remove(at: index+factor)
                factor -= 1
            case .replace(let index, let value):
                self.remove(at: index+factor)
                self.insert(value, at: index+factor)
            }
        }
    }
}

//extension OrderedDictionary where Key: Equatable {
//
//    public mutating func applyMoveOperations(_ moves: [Move]) {
//
//        for move in moves {
//            self.move(elementAt: move.source, to: move.destination)
//        }
//    }
//
//    public func movesOperations(to other: OrderedDictionary) -> [Move] {
//
//        assert(self.count == other.count)
//        let selfKeys = self.orderedKeys
//        let otherKeys = other.orderedKeys
//
//        let editOperations = selfKeys.editOperations(to: otherKeys)
//
//        var moves = [Move]()
//        
//        var deletes = [Key: Int]()
//        var additions = [Key: Int]()
//
//        for editOperation in editOperations {
//            switch editOperation {
//            case .add(let index, let value):
//                additions[value] = index
//            case .delete(let index):
//                deletes[self[index].key] = index
//            case .replace(let index, let value):
//                deletes[self[index].key] = index
//                additions[value] = index
//            }
//        }
//
//        assert(deletes.count == additions.count)
//        var factor = 0
//        for value in self {
//            if let deleteIndex = deletes[value.key], let addIndex = additions[value.key] {
//                if deleteIndex > addIndex {
//                    moves.append(Move(source: deleteIndex, destination: addIndex+factor))
//                    factor += 1
//                }
//                else {
//                    // move further: we consider the final destination
//                    moves.append(Move(source: deleteIndex+factor, destination: addIndex))
//                    factor -= 1
//                }
//            }
//        }
//        return moves
//    }
//
//}


extension OrderedSet where Element: Equatable {
    
    public mutating func applyMoveOperations(_ moves: [Move]) {
    
        for move in moves {
            self.move(elementAt: move.source, to: move.destination)
        }
    }
    
    public mutating func applyEditOperations(_ operations: [ArrayEdit<Element>]) {
        
        var factor = 0
        
        // delete pass
        for edit in operations {
            switch edit {
            case .delete(let index):
                self.remove(at: index+factor)
                factor -= 1
            default:
                break
            }
        }
        
        factor = 0
        
        // addition pass
        for edit in operations {
            switch edit {
            case .add(let index, let value):
                self.insert(value, at: index+factor)
                factor += 1
            case .delete:
                factor -= 1
            case .replace(let index, let value):
                self.remove(at: index+factor)
                self.insert(value, at: index+factor)
            }
        }
    }
}

extension Collection where Element: Equatable & Hashable, Self.Index == Int {
    
    public func editOperationsWithReplace<C>(to other: C) -> [ArrayEdit<Element>] where C: Collection, C.Element == Element, C.Index == Int {
        
        let editMatrix = editDistanceMatrix(other: other)
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        for i in 0..<editMatrix.count {
            var line = ""
            for j in 0..<editMatrix[0].count {
                line += "\(editMatrix[i][j]) "
            }
            print("\(line)")
        }
        #endif
        
        var edits = [ArrayEdit<Element>]()
        
        if editMatrix.count-1 == 0 {
            for j in 0..<editMatrix[0].count-1 {
                edits.append(.add(index: 0, value: other[j]))
            }
            return edits
        }
        
        if editMatrix[0].count-1 == 0 {
            for i in 0..<editMatrix.count-1 {
                edits.append(.delete(index: i))
            }
            return edits
        }
        
        var i = editMatrix.count-1
        var j = editMatrix[0].count-1
        
        while i >= 0 && j >= 0 {
            
            if j > 0 && i > 0 && self[i-1] == other[j-1] {
                i -= 1
                j -= 1
            }
            else if i > 0 && editMatrix[i][j] == editMatrix[i-1][j] + 1 {
                edits.append(.delete(index: i-1))
                i -= 1
            }
            else if j > 0 && i > 0 && editMatrix[i][j] == editMatrix[i-1][j-1] + 1 {
                edits.append(.replace(index: i-1, value: other[j-1]))
                i -= 1
                j -= 1
            }
            else if j > 0 && editMatrix[i][j] == editMatrix[i][j-1] + 1 {
                edits.append(.add(index: i, value: other[j-1]))
                j -= 1
            }
            else {
                break
            }
        }
        return edits.reversed()
    }
    
    public func editOperations<C>(to other: C) -> [ArrayEdit<Element>] where C: Collection, C.Element == Element, C.Index == Int {
        
        let editMatrix = editDistanceMatrix(other: other)
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        for i in 0..<editMatrix.count {
            var line = ""
            for j in 0..<editMatrix[0].count {
                line += "\(editMatrix[i][j]) "
            }
            print("\(line)")
        }
        #endif
        
        var edits = [ArrayEdit<Element>]()

        if editMatrix.count-1 == 0 {
            for j in 0..<editMatrix[0].count-1 {
                edits.append(.add(index: 0, value: other[j]))
            }
            return edits
        }
        
        if editMatrix[0].count-1 == 0 {
            for i in 0..<editMatrix.count-1 {
                edits.append(.delete(index: i))
            }
            return edits
        }
        
        var i = editMatrix.count-1
        var j = editMatrix[0].count-1
        
        while i >= 0 && j >= 0 {
            
            if j > 0 && i > 0 && self[i-1] == other[j-1] {
                i -= 1
                j -= 1
            }
            else if i > 0 && editMatrix[i][j] == editMatrix[i-1][j] + 1 {
                edits.append(.delete(index: i-1))
                i -= 1
            }
            else if j > 0 && i > 0 && editMatrix[i][j] == editMatrix[i-1][j-1] + 1 {
                edits.append(.delete(index: i-1))
                edits.append(.add(index: i-1, value: other[j-1]))
                i -= 1
                j -= 1
            }
            else if j > 0 && editMatrix[i][j] == editMatrix[i][j-1] + 1 {
                edits.append(.add(index: i, value: other[j-1]))
                j -= 1
            }
            else {
                break
            }
        }
        return edits.reversed()
    }
    
    public func editDistanceMatrix<C>(other: C) -> [[Int]] where C: Collection, C.Element == Element {
        
        let m = self.count
        let n = other.count
        var matrix = [[Int]](repeating: [Int](repeating: 0, count: n + 1), count: m + 1)
        
        if n == 0 && m == 0 {
            return matrix
        }
        
        if m == 0 {
            
            for index in 1...n {
                // the distance of any second string to an empty first string
                matrix[0][index] = index
            }
            return matrix
        }
        
        if n == 0 {
            
            // initialize matrix
            for index in 1...m {
                // the distance of any first string to an empty second string
                matrix[index][0] = index
            }
            return matrix
        }
        
        // initialize matrix
        for index in 1...m {
            // the distance of any first string to an empty second string
            matrix[index][0] = index
        }
        
        for index in 1...n {
            // the distance of any second string to an empty first string
            matrix[0][index] = index
        }
        
        // compute Levenshtein distance
        for (i, selfChar) in self.enumerated() {
            for (j, otherChar) in other.enumerated() {
                if otherChar == selfChar {
                    // substitution of equal symbols with cost 0
                    matrix[i + 1][j + 1] = matrix[i][j]
                } else {
                    // minimum of the cost of insertion, deletion, or substitution
                    // added to the already computed costs in the corresponding cells
                    matrix[i + 1][j + 1] = Swift.min(matrix[i][j] + 1, matrix[i + 1][j] + 1, matrix[i][j + 1] + 1)
                }
            }
        }
        return matrix
    }
    
    public func movesOperations<C>(to other: C) -> [Move] where C: Collection, C.Element == Element, Element: Comparable, C.Index == Int {
        
        assert(self.count == other.count)
        assert(self.sorted() == other.sorted())
    
        let editOperations = self.editOperations(to: other)

        var moves = [Move]()
        var deletes = [Element: Int]()
        var additions = [Element: Int]()


        for editOperation in editOperations {
            switch editOperation {
            case .add(let index, let value):
                additions[value] = index
            case .delete(let index):
                deletes[self[index]] = index
            case .replace(let index, let value):
                deletes[self[index]] = index
                additions[value] = index
            }
        }

        assert(deletes.count == additions.count)
        var factor = 0
        for value in self {
            if let deleteIndex = deletes[value], let addIndex = additions[value] {
                if deleteIndex > addIndex {
                    moves.append(Move(source: deleteIndex, destination: addIndex+factor))
                    factor += 1
                }
                else {
                    // move further: we consider the final destination
                    moves.append(Move(source: deleteIndex+factor, destination: addIndex))
                    factor -= 1
                }
            }
        }
        return moves
    }
}
