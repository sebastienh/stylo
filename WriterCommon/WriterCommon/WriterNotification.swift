//
//  StyloNotification.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2016-01-01.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation
import Common

public enum WriterNotification: String, Notifications {
    
    case didChangeTemporaryAttributes
    case didCompleteAttributesRendering
}
