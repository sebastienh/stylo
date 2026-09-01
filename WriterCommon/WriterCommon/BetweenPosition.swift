//
//  BetweenPosition.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-05-05.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation

/// {
///  "type":"between",
///  "beforeIndex":0,
///  "afterIndex":1,
///  "ratio":0.5525902668759811
/// }
struct BetweenPosition {
    
    let ratio: Double
    
    let beforeIndex: Int
    
    let afterIndex: Int
    
    init?(json: [String: Any]) {
        
        guard let type = json["type"] as? String, type == "between" else {
            return nil
        }
        
        guard let beforeIndex = json["beforeIndex"] as? Int else {
            return nil
        }
        
        guard let afterIndex = json["afterIndex"] as? Int else {
            return nil
        }
        
        guard let ratio = json["ratio"] as? Double else {
            return nil
        }
        
        self.ratio = ratio
        self.beforeIndex = beforeIndex
        self.afterIndex = afterIndex
    }
}
