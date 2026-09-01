//
//  EquatableLanguageObject.swift
//  Common
//
//  Created by Sébastien Hamel on 2018-06-15.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation

public protocol EquatableLanguageObject {
    
    func equals(to other: Any?, comparePositions: Bool) -> Bool
    
}
