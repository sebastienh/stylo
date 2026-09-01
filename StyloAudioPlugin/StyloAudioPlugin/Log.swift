//
//  Log.swift
//  StyloAudioPlugin
//
//  Created by Sebastien hamel on 2019-09-12.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Foundation
import os 

struct Log {
    struct Audio {
        static let all = OSLog(subsystem: "net.textually.mac.stylo-audio-plugin", category: "default")
    }
}
