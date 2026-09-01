//
//  IssuesReporterTableColumn.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2016-01-18.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa

final class IssuesReporterTableColumn: NSTableColumn {
    
    // see http://www.cocoabuilder.com/archive/cocoa/239598-recalculating-nstableview-row-sizes-during-live-column-resize.html
    override var width: CGFloat {

        didSet {

            if let tableView = tableView as? IssuesReporterTableView {

                if tableView.isInLiveResize {

                    tableView.reloadData()
                }
            }
        }
    }
}
