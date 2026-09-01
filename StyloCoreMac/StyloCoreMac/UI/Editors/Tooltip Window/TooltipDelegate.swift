//
//  TooltipDelegate.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-03-20.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import Common

public protocol TooltipDelegate {
    
    func removeDisplayedMessageTooltip()
    
    func showMessageTooltip(with message: Message, relativeTo positioningRect: NSRect, in positioningView: NSView)
    
}
