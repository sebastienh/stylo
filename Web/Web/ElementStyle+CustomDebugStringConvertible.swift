//
//  ElementStyle+CustomDebugStringConvertible.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-01-16.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation

extension ElementStyle: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        
        var _debugString = ""
        
//        if let userAgentLevelStyle = userAgentLevelStyle {
            _debugString += "\(userAgentLevelStyle)"
//        }
        
//        if let cascadedStyle = cascadedStyle {
            _debugString += "\(cascadedStyle)"
//        }
        
//        if let specifiedValues = specifiedValues {
            _debugString += "\(specifiedValues)"
//        }
        
//        if let defaultStyle = defaultStyle {
            _debugString += "\(defaultStyle)"
//        }
        
//        if let rawComputedStyle = rawComputedStyle {
            _debugString += "\(rawComputedStyle)"
//        }
        
//        if let actualStyle = actualStyle {
//            _debugString += "\(actualStyle)"
//        }
        
        return _debugString
    }
}
