//
//  UnmanagedUtils.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2016-10-15.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation

postfix operator -->

public postfix func --><T>(lhs: Unmanaged<T>) -> T {
    return lhs.takeUnretainedValue()
}
