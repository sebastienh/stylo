//
//  OutputSectionType.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-05-22.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Common

public protocol OutputSectionType: Hashable, Comparable, StringInitializableType {
    
    associatedtype I: InputSectionType
    
    static func from(inputSection: I) -> Self
}
