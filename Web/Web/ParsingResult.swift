//
//  ParsingResult.swift
//  Web
//
//  Created by Sebastien hamel on 2018-12-31.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Common

enum ParsingResult<T> {
    
    case none
    case success(T)
    case failure(MessageCode)
}
