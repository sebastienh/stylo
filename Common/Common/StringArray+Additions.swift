//
//  StringArray+Additions.swift
//  Common
//
//  Created by Sebastien hamel on 2019-07-30.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation

public struct Move {
    
    enum MoveType {
        case forward
        case backward
    }
    
    public let source: Int
    public let destination: Int
    
    private var type: MoveType {
        if source < destination {
            return .forward
        }
        else {
            return .backward
        }
    }
    
    init(source: Int, destination: Int) {
        self.source = source
        self.destination = destination
    }
    
    func updated(withMove move: Move) -> Move {
        
        var source = self.source
        var destination = self.destination
        
        switch move.type {
        case .backward:
            // if we move backward it means that
            // every elements at the destination and below the source
            // will moved by one forward
            if self.source >= move.destination && self.source < move.source {
                source += 1
            }
            if self.destination >= move.destination && self.destination < move.source {
                destination += 1
            }
            
        case .forward:
            
            if self.source > move.source && self.source > move.source {
                source -= 1
            }
            if self.destination > move.destination && self.destination > move.destination {
                destination -= 1
            }
        }
        return Move(source: source, destination: destination)
    }
}

extension Move: Equatable {
    
    public static func ==(lhs: Move, rhs: Move) -> Bool {
        if lhs.source != rhs.source {
            return false
        }
        if lhs.destination != rhs.destination {
            return false
        }
        return true
    }
}



public enum ArrayEditError: Error {
    
    case error
}

extension Array where Element == String {
    
    public var nextFreeEndNumber: Int {
        
        var curentNextFreeEndNumber: Int = 1
        
        for string in self {
            
            let words = string.split(separator: " ")
            
            let lastWord = words.last
            
            assert(lastWord != nil)
            if let lastWord = lastWord {
                
                let lastWordValue = Int(String(lastWord))
                if let lastWordValue = lastWordValue, lastWordValue >= curentNextFreeEndNumber {
                    
                    curentNextFreeEndNumber = lastWordValue + 1
                }
            }
        }
        return curentNextFreeEndNumber
    }
    
    public func movesOperations(to other: Array<String>) -> [Move] {
        
        assert(self.count == other.count)
        assert(self.sorted() == other.sorted())
    
        let editOperations = self.editOperations(to: other)

        var moves = [Move]()
        var deletes = [String: Int]()
        var additions = [String: Int]()


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
    
    public func editOperations(to other: Array<String>) -> [ArrayEdit<String>] {
        
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
        
        var edits = [ArrayEdit<String>]()

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
    
    public mutating func applyEditOperations(_ operations: [ArrayEdit<String>]) {
        
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
    
    public mutating func applyMoveOperations(_ moves: [Move]) {
    
        for move in moves {
            self.move(elementAt: move.source, to: move.destination)
        }
    }
    
    /// The new index is before the removal of the target element,
    /// since we can only know the target index after having removed it...
    public mutating func move(elementAt index: Int, to targetIndex: Int) {
        
        guard index != targetIndex else {
            return
        }
        
        let value = self.remove(at: index)
        
        let adjustedTargetIndex = targetIndex > index ? targetIndex-1 : targetIndex
        
        if adjustedTargetIndex < self.count {
        
            // now target index is one less
            self.insert(value, at: adjustedTargetIndex)
        }
        else {
            self.append(value)
        }
    }
    
    public func editDistanceMatrix(other: Array<String>) -> [[Int]] {
        
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
}

