//
//  StringSet+Additions.swift
//  Common
//
//  Created by Sebastien Hamel on 2020-01-18.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

extension Set where Element == String {

    public func setEditOperations(to other: Set<String>) -> Set<SetEdit<String>>? {
        
        guard self != other else {
            return nil
        }
        
        let intersection = self.intersection(other)
        
        // we want to know the removed values from origin to destination
        // origin - intersection
        let removedValues = self.symmetricDifference(intersection)
        
        // we want to know the added values from origin to destination
        // destination - intersection
        let addedValues = other.symmetricDifference(intersection)
        
        guard !addedValues.isEmpty || !removedValues.isEmpty else {
            // no difference between both
            assertionFailure("Error: this should have been checked already")
            return nil
        }
        
        var edits = Set<SetEdit<String>>()

        for removedValue in removedValues {
            edits.insert(.delete(value: removedValue))
        }
        
        for addedValue in addedValues {
            edits.insert(.add(value: addedValue))
        }
        
        return edits
    }

    public mutating func applyEditOperations(_ operations: Set<SetEdit<String>>) {
        
        for operation in operations {
            switch operation {
            case .add(let value):
                self.insert(value)
            case .delete(let value):
                self.remove(value)
            }
        }
    }
    
}

