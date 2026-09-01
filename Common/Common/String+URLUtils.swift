//
//  String+URLUtils.swift
//  Common
//
//  Created by Sébastien Hamel on 2015-04-02.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

extension String : URLUtils {
    
    func contructURL() -> URL? {
        
        return URL(fileURLWithPath: self)
    }
    
    func constructFirstPathComponent() -> String {
        
        return self + ":"
    }
    
    fileprivate func isNetworkComponent(_ component: String) -> Bool {
        
        if let firstPathComponent = URLFirstPathComponent(rawValue: component) {
            
            return firstPathComponent.isNetworkFirstPathComponent()
        }
        
        return false
    }
    
}
