//
//  OrderedDictionary+Edits.swift
//  Common
//
//  Created by Sebastien Hamel on 2020-07-06.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

extension OrderedDictionary {
    
    public mutating func applyMoveOperations(_ moves: [Move]) {
        
        for move in moves {
            self.move(elementAt: move.source, to: move.destination)
        }
    }
    
    public func movesOperations(to other: OrderedDictionary) -> [Move] {
        
        assert(self.count == other.count)
        
        let editOperations = self.editOperations(to: other)
        
        var moves = [Move]()
        var deletes = [Key: Int]()
        var additions = [Key: Int]()
        
        
        for editOperation in editOperations {
            switch editOperation {
            case .add(let index, let key, _):
                additions[key] = index
            case .delete(let index):
                deletes[self[index].key] = index
            }
        }
        
        assert(deletes.count == additions.count)
        var factor = 0
        for value in self {
            if let deleteIndex = deletes[value.key], let addIndex = additions[value.key] {
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
    
    public func editOperations(to other: OrderedDictionary) -> [DictionaryEdit<Key, Value>] {
        
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
        
        var edits = [DictionaryEdit<Key, Value>]()

        if editMatrix.count-1 == 0 {
            for j in 0..<editMatrix[0].count-1 {
                edits.append(.add(index: 0, key: other[j].key, value: other[j].value))
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
            
            if j > 0 && i > 0 && self[i-1].key == other[j-1].key {
                i -= 1
                j -= 1
            }
            else if i > 0 && editMatrix[i][j] == editMatrix[i-1][j] + 1 {
                edits.append(.delete(index: i-1))
                i -= 1
            }
            else if j > 0 && i > 0 && editMatrix[i][j] == editMatrix[i-1][j-1] + 1 {
                edits.append(.delete(index: i-1))
                edits.append(.add(index: i-1, key: other[j-1].key, value: other[j-1].value))
                i -= 1
                j -= 1
            }
            else if j > 0 && editMatrix[i][j] == editMatrix[i][j-1] + 1 {
                edits.append(.add(index: i, key: other[j-1].key, value: other[j-1].value))
                j -= 1
            }
            else {
                break
            }
        }
        return edits.reversed()
    }
    
    public mutating func applyEditOperations(_ operations: [DictionaryEdit<Key, Value>]) {
        
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
            case .add(let index, let key, let value):
                self.insert((key, value), at: index+factor)
                factor += 1
            case .delete:
                factor -= 1
            }
        }
    }
    
    public func editDistanceMatrix(other: OrderedDictionary) -> [[Int]] {
        
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
        for (i, key) in self.orderedKeys.enumerated() {
            for (j, otherKey) in other.orderedKeys.enumerated() {
                if otherKey == key {
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
    
}
