//
//  AttributesBlocsSet.swift
//  Markdown
//
//  Created by Sebastien hamel on 2019-05-13.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation

extension Set where Element == AttributesBloc {
    
    private var attributes: Set<Attribute> {
        
        var attributes = Set<Attribute>()
        for attributesBloc in self {
            attributes = attributes.union(attributesBloc.attributes)
        }
        return attributes
    }
    
    public func attributesBlocsChange(from other: Set<AttributesBloc>, otherPositionChange change: Int = 0) -> AttributesBlocsChange {
        
        var updatedPositionsBlocs = Set<AttributesBloc>()
        for var attributesBloc in other {
            
            attributesBloc.move(change)
            updatedPositionsBlocs.insert(attributesBloc)
        }
        
        let intersect = self.intersection(updatedPositionsBlocs)
        let currentUniques = self.subtracting(intersect)
        let otherUniques = updatedPositionsBlocs.subtracting(intersect)
        
        if currentUniques.isEmpty && otherUniques.isEmpty {
            return .none
        }
        else if currentUniques.isEmpty {

            return AttributesBlocsChange.modified(attributes: otherUniques.attributes)
        }
        else if otherUniques.isEmpty {
            
            return AttributesBlocsChange.modified(attributes: currentUniques.attributes)
        }
        else {
            
            // most common reason of difference: we are editing an attributes bloc
            if currentUniques.count == 1 && otherUniques.count == 1 {
                
                let currentBloc = currentUniques.first
                let otherBloc = otherUniques.first
                
                assert(currentBloc != nil)
                assert(otherBloc != nil)
                if let currentBloc = currentBloc, let otherBloc = otherBloc {
                    
                    let modified = currentBloc.differentAttributes(from: otherBloc)
                    
                    if modified.isEmpty {
                        return .none
                    }
                    else {
                        // identify the attributes that has changed
                        return AttributesBlocsChange.modified(attributes: modified)
                    }
                }
                else {
                    // safety
                    return collectDifferentAttributes(from: currentUniques, and: otherUniques)
                }
            }
            else {
                
                return collectDifferentAttributes(from: currentUniques, and: otherUniques)
            }
        }
    }
    
    private func collectDifferentAttributes(from curAttributesBlocs: Set<AttributesBloc>, and otherAttributesBlocs: Set<AttributesBloc>) -> AttributesBlocsChange {
        
        let total = curAttributesBlocs.union(otherAttributesBlocs)
        var diff = Set<Attribute>()
        
        if !total.isEmpty {
            
            if let first = total.first {
                
                // deffine the diff as the attributes in the first attributes bloc
                diff = diff.union(first.attributes)
                
                for attrBloc in total {
                    
                    if attrBloc != first {
                        
                        diff = diff.symmetricDifferenceWithIntersectingRanges(Set<Attribute>(attrBloc.attributes))
                    }
                }
            }
        }
        return AttributesBlocsChange.modified(attributes: diff)
    }
    
}
