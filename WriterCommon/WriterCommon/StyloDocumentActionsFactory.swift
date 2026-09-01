//
//  StyloDocumentActionsFactory.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-03-22.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Igloo

struct StyloDocumentActionsFactory: ActionsFactory {
    
    static func incrementLoadingPercentAction(value: CGFloat) -> SyncAction {
        
        let actionType = DocumentAction.incrementLoadingPercent(value: value)
        return SyncAction(type: actionType)
    }
}
