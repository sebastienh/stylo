//
//  Array+CSComponentValue.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-09-17.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common

/// FIXME: In Swift 2 we will be able to add this extension only 
/// when the type is CSComponentValue. No need for the assert anymore.
extension Array {

    func extractPositionFromComponents() -> SourceStringSegment? {
        
        if let firstComponentValue = self.first as? CSComponentValue {
        
            if let lastComponentValue = self.last as? CSComponentValue {
            
                if let fistComponentValuePosition = firstComponentValue.sourceStringSegment, let lastComponentValuePosition = lastComponentValue.sourceStringSegment {
                
                    let startIndex = fistComponentValuePosition.startIndex
                    let endIndex = lastComponentValuePosition.endIndex
                    return SourceStringSegment(startIndex: startIndex, endIndex: endIndex)
                }
            }
        }
        
        return nil
    }
}
