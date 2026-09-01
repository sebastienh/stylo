//
//  URLSheme.swift
//  Common
//
//  Created by Sébastien Hamel on 2015-04-02.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

enum URLFirstPathComponent : String {
    
    case HTTP = "http:"
    case HTTPS = "https:"
    case FTP = "ftp:"
    case FILE = "file:"
    
    func isNetworkFirstPathComponent() -> Bool {
    
        switch self {
            
        case .FILE:
            return false

        case .HTTP:
            return true

        case .HTTPS:
            return true
            
        case .FTP:
            return true
        }
    }
    
}
