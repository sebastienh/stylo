//
//  StringInitializableType.swift
//  Common
//
//  Created by Sebastien Hamel on 2020-05-22.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

public protocol StringInitializableType: StringValueType {

    init(string: String)

}

extension String: StringInitializableType {
    

}
