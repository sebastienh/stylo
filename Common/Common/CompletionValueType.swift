//
//  CompletionValueType.swift
//  Common
//
//  Created by Sébastien Hamel on 2016-02-12.
//  Copyright © 2016 NM. All rights reserved.
//

import Foundation

public protocol CompletionValueType: Equatable {
    
    var desc: String { get }
    
    var language: Language { get }
    
    var shortDescription: String { get }
}
