//
//  AttributesOperationsNodeInfo.swift
//  Common
//
//  Created by Sebastien Hamel on 2020-09-08.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

public protocol AttributesOperationsNodeInfo {
    
    var attributesOperations: AttributesOperations? { get set }

    mutating func merge(with other: AttributesOperationsNodeInfo?)
    
}

extension AttributesOperationsNodeInfo {
    
    public mutating func merge(with other: AttributesOperationsNodeInfo?) {
        
        guard let other = other else {
            return 
        }
        
        guard self.attributesOperations != nil else {
            self.attributesOperations = other.attributesOperations
            return
        }
        
        guard let otherAttributesOperations = other.attributesOperations else {
            return
        }
        
        self.attributesOperations!.addedAttributes.append(contentsOf: otherAttributesOperations.addedAttributes)
        self.attributesOperations!.deletedAttributes.append(contentsOf: otherAttributesOperations.deletedAttributes)
        self.attributesOperations!.setAttributes.append(contentsOf: otherAttributesOperations.setAttributes)
    }
    
}
