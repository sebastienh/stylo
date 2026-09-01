//
//  IssuesReporterViewController+ExtendedTableViewDelegate.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-11-25.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon
import StyloCoreMac

extension IssuesReporterViewController: ExtendedTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, didClickedRow row: NSInteger) {
        
        assert(tableView == issuesTableView)
        
        let message = failable[row]
        let userInfo = [WriterCommon.Constants.Notifications.Message: message]
        
        unselectCurrentSelection()
        select(row: row)
        
        guard let editorId = self.editorId else {
            assertionFailure("Error: self.editorId is nil")
            return
        }
        
        failable.highlightElementWithMessageId(message.uuid, forEditorWithId: editorId)
        
        StyloNotification.DidSelectMessageInIssuesReporter.sendNotification(failable, userInfo: userInfo)
    }
    
}
