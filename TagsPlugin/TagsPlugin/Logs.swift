//
//  Logs.swift
//  TagsPlugin
//
//  Created by Sebastien Hamel on 2020-06-04.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Foundation
import os

struct Log {
    struct Tags {
        static let all = OSLog(subsystem: "net.textually.mac.stylo-tags-plugin", category: "default")
    }
}
