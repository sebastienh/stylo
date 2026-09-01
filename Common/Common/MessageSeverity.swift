//
//  MessageSeverity.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-18.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation


/// Severity levels are based on rfc-5424 
/// see http://tools.ietf.org/html/rfc5424
public enum MessageSeverity: String {
    
    case Emergency = "emergency"
    case Alert = "alert"
    case Critical = "critical"
    case Error = "error"
    case Warning = "warning"
    case Notice = "notice"
    case Informational = "informational"
    case Debug = "debug"
}
