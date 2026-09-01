//
//  NSView+ObserverPriority.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-03-09.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa
import Common

extension NSView: Common.Observer {
    public var priority: ObserverPriority {
        return .ui
    }
}
