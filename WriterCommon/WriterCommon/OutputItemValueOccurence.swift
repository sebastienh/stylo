//
//  OutputItemValueOccurence.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-05-24.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Common

public struct OutputItemOccurence<OutputItem: OutputItemType>: TextElementOccurence {
    
    public let textId: TextId
    
    public let range: NSRange
    
    public var value: Int {
        
        return range.location
    }
    
    public let outputItems: [OutputItem]
    
    init(textId: TextId, range: NSRange, outputItems: [OutputItem]) {
        
        self.textId = textId
        self.range = range
        self.outputItems = outputItems
    }
 
    public func sameLocation(as other: OutputItemOccurence<OutputItem>) -> Bool {
        
        if self.textId != other.textId {
            return false
        }
        if self.range.location != other.range.location {
            return false
        }
        
        if self.range.length != other.range.length {
            return false
        }
        
        return true
    }
    
    
}
