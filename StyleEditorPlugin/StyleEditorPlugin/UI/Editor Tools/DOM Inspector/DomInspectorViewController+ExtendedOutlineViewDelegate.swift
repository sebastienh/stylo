//
//  DomInspectorViewController+ExtendedOutlineViewDelegate.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-02-13.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon
import StyloCoreMac
import Web

extension DomInspectorViewController: ExtendedOutlineViewDelegate {
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ExtendedOutlineViewDelegate protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func outlineView(_ outlineView: NSOutlineView, didClickedRow row: NSInteger) {
        
        if let item = outlineView.item(atRow: row) as? DomInspectable {
            
            // Make sure if we are not better to broadcast the event in itself:
            // DidClickDomInspectableNode
            
            let userInfo = [WriterCommon.Constants.Notifications.DomInspectableNode: item]
            StyloNotification.DidClickDomInspectableNode.sendNotification(domRenderable, userInfo: userInfo)
        }
    }
    
}
