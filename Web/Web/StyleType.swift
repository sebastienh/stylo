//
//  StyleType.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-01-15.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation

public enum StyleType: String, SourceType {
    
    case preview
    
    // else if themeURL.lastPathComponent.endsWith("source - single error") {
    case error
    
    // else if themeURL.lastPathComponent.endsWith("source - all errors") {
    case errors
    
    // if themeURL.lastPathComponent.endsWith("source") {
    case source
    
    case printing 
    
    public var source: Bool {
        
        switch self {
            
        case .preview: fallthrough
        case .printing:
            return false
        default:
            return true
        }
    }
    
    public var print: Bool {
        
        switch self {
            
        case .printing:
            return true 
        default:
            return false
        }
        
    }
    
}
