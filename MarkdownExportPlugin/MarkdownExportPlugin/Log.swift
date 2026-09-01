//
//  Log.swift
//  MarkdownExportPlugin
//
//  Created by Sebastien hamel on 2019-09-21.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Foundation
import os

struct Log {
    struct MarkdownExport {
        static let all = OSLog(subsystem: "net.textually.mac.markdown-export-plugin", category: "default")
    }
}
