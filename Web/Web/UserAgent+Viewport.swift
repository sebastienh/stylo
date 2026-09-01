//
//  UserAgent+Viewport.swift
//  Web
//
//  Created by Sebastien hamel on 2018-10-25.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation

extension UserAgent: Viewport {
    
    private var screenSize: NSSize? {
        
        return NSScreen.main?.frame.size
    }
    
    public var viewportWidth: CGFloat? {
        
        return screenSize?.width
    }
        
    public var viewportHeight: CGFloat? {
        
        return screenSize?.height
    }
}
