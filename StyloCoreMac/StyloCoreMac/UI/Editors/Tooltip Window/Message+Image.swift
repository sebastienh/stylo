//
//  Message+Image.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-03-21.
//  Copyright © 2017 Textually Inc. All rights reserved.
//


import Foundation
import Common
import Cocoa
import WriterCommon

extension Message {
    
    public var imageName: String {
        
        switch self.messageSeverity {
            
        case .Emergency:
            
            return WriterCommon.Constants.Images.EmergencyImageName
            
        case .Alert:
            
            return WriterCommon.Constants.Images.EmergencyImageName
            
        case .Critical:
            
            return WriterCommon.Constants.Images.EmergencyImageName
            
        case .Error:
            
            return WriterCommon.Constants.Images.EmergencyImageName
            
        case .Warning:
            
            return WriterCommon.Constants.Images.EmergencyImageName
            
        case .Notice:
            
            return WriterCommon.Constants.Images.EmergencyImageName
            
        case .Informational:
            
            return WriterCommon.Constants.Images.EmergencyImageName
            
        case .Debug:
            
            return WriterCommon.Constants.Images.DebugImageName
        }
    }
    
    public var image: NSImage {
        
        switch self.messageSeverity {
            
        case .Emergency:
            
            return NSImage(named: NSImage.Name(string: "emergency_image.png"))!
            
        case .Alert:
            
            return NSImage(named: NSImage.Name(string: "alert_image.png"))!
            
        case .Critical:
            
            return NSImage(named: NSImage.Name(string: "critical_image.png"))!
            
        case .Error:
            
            return NSImage(named: NSImage.Name(string: "error_image.png"))!
            
        case .Warning:
            
            return NSImage(named: NSImage.Name(string: "warning_image.png"))!
            
        case .Notice:
            
            return NSImage(named: NSImage.Name(string: "notice_image.png"))!
            
        case .Informational:
            
            return NSImage(named: NSImage.Name(string: "info_image.png"))!
            
        case .Debug:
            
            return NSImage(named: NSImage.Name(string: "debug_image.png"))!
        }
    }
    
}
