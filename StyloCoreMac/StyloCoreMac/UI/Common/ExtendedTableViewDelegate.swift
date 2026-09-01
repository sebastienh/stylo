//
//  ExtendedTableViewDelegate.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2015-10-22.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa

public protocol ExtendedTableViewDelegate: class {

    func tableView(_ tableView: NSTableView, didClickedRow row: NSInteger)

}
