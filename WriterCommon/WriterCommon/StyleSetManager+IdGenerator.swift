//
//  StyleSetManager+IdGenerator.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-10-13.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Common

extension StyleSetManager: IdGenerator {

    public var idPrefix: String {
        
        return "style"
    }
}
