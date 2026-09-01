//
//  Log.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-07-24.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import os

struct Log {
    struct Stylo {
        static let all = OSLog(subsystem: "net.textually.mac.stylo", category: "default")
    }
}
