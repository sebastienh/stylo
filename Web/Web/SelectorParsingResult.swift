//
//  SelectorParsingResult.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-07-01.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation

enum SelectorParsingResult<T> {
    
    case success(T)
    case failure(InvalidComplexSelector)
    
}
