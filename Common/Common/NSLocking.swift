//
//  NSLocking.swift
//  Common
//
//  Created by Sebastien Hamel on 2020-09-02.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

extension NSLocking {
    public func withCriticalSection<T>(_ closure: () throws -> T) rethrows -> T {
        lock()
        defer { unlock() }
        return try closure()
    }
}
