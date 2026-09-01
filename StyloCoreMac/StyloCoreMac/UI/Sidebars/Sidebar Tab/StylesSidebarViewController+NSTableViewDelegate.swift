//
//  StyleSidebarViewController+NSTableViewDelegate.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-07-31.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon

extension StylesSidebarViewController: NSTableViewDelegate {
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: NSTableViewDelegate protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        return false
    }
    
    /// FIXME: This method should not be needed fot an ordinary array
    /// but there seem to have a problem with framework.
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        
        return 44.0
    }
}
