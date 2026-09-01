//
//  TextPositionType.swift
//  Common
//
//  Created by Sebastien Hamel on 2020-05-25.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

public extension Int {
    
    public var zeroLengthRange: NSRange {
        return NSMakeRange(self, 0)
    }
}


public protocol TextPositionType {

    ///
    /// The id iof the text in which this position is.
    ///
    var textId: String { get }

    ///
    /// The test position value (the location of the range)
    ///
    var value: Int { get }
    
    
    var range: NSRange { get }
    
}

extension TextPositionType {
    
    public var value: Int {
        return range.location
    }
}
