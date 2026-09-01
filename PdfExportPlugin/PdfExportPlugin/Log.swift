//
//  Log.swift
//  PdfExportPlugin
//
//  Created by Sebastien hamel on 2019-09-21.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Foundation
import os

struct Log {
    struct PdfExport {
        static let all = OSLog(subsystem: "net.textually.mac.pdf-export-plugin", category: "default")
    }
}
