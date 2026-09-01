//
//  StartPosition.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-05-05.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation

/// {
///     "type": "start",
///     "index": -1,
///     "ratio": 0.8888888888888888
/// }
struct StartPosition {
    
    let ratio: Double
    
    init?(json: [String: Any]) {
        
        guard let type = json["type"] as? String, type == "start" else {
            return nil
        }
        
        guard let index = json["index"] as? Int, index == -1 else {
            return nil
        }
        
        guard let ratio = json["ratio"] as? Double else {
            return nil
        }
        
        self.ratio = ratio
    }
}
