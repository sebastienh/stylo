//
//  StyleSheetContainer.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-10-26.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation
import Web

public protocol StyleSheetContainer: class {
    
    var styleSheet: CSSStyleSheet? { get set }
    
    var containFollowingSiblingSelectors: Bool { get }
}

extension StyleSheetContainer {
    
    public var containFollowingSiblingSelectors: Bool {
    
        if let containFollowingSiblingSelectors = styleSheet?.containFollowingSiblingSelectors {
            
            return containFollowingSiblingSelectors
        }
        // if there is no StyleSheet we return false
        return false
    }
}
