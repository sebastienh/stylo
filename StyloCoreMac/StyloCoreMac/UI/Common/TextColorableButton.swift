//
//  TextColorableButton.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-07-27.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa

protocol TextColorableButton: class {
    
    var font: NSFont? { get set }
    
    var textColor: NSColor? { get set }
    
    var needsDisplay: Bool { get set }
}
