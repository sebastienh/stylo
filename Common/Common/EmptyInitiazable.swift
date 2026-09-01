//
//  EmptyInitiazable.swift
//  Common
//
//  Created by Sebastien Hamel on 2020-05-04.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

public protocol EmptyInitializable {

    init()
}


extension String: EmptyInitializable {
    public init() {
        self.init("")
    }
}
