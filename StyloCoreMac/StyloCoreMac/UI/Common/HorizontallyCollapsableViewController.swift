//
//  HorizontallyCollapsableViewController.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2015-10-18.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa

public protocol HorizontallyCollapsableViewController: class {
    
    var viewWidth: NSLayoutConstraint? { get set }
    
}
