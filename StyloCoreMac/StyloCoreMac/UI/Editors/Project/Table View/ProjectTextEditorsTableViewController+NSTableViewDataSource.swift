//
//  ProjectTextEditorsTableViewController+NSTableViewDataSource.swift
//  Stylo
//
//  Created by Sebastien Hamel on 2019-12-30.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import WriterCommon
import Common
import os

extension ProjectTextEditorsTableViewController: NSTableViewDataSource {


    ////////////////////////////////////////////////////////////////////////////////
    //                  MARK: NSTableViewDataSource protocol
    ////////////////////////////////////////////////////////////////////////////////
    
    func numberOfRows(in aTableView: NSTableView) -> Int {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("numberOfItems: %@", log: Log.StyloCore.all, type: .info, %%numberOfItems)
        #endif
        
        return self.numberOfItems*2
    }
}
