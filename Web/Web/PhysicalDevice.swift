//
//  Device.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-20.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

/// Class that is used to resolve all device dependant values. 
public final class PhysicalDevice {
    
    /// Singleton instance.
    static var shared = AppleDevice()
    
    fileprivate init() {

    }
}
