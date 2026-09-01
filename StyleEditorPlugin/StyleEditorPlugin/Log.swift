//
//  Log.swift
//  StyleEditorPlugin
//
//  Created by Sebastien Hamel on 2019-12-31.
//  Copyright © 2019 Sebastien hamel. All rights reserved.
//

import Foundation
import os

struct Log {
    struct StyleEditor {
        static let all = OSLog(subsystem: "net.textually.mac.style-editor-plugin", category: "default")
    }
}
