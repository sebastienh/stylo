//
//  StringInitializable.swift
//  Common
//
//  Created by Sebastien Hamel on 2020-05-05.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

public protocol StringValueType {

    var stringValue: String { get }
    
    func localizedStandardContains(_ str: String) -> Bool
}


extension String: StringValueType {
    
    public var stringValue: String {
        return self
    }
}
