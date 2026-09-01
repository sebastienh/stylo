//
//  InsidePosition.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-05-05.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation

/// {
///  "type":"inside",
///  "index":0,
///  "ratio":0.3333333333333333
/// }
struct InsidePosition {
    
    let ratio: Double
    
    let index: Int
    
    init?(json: [String: Any]) {
        
        guard let type = json["type"] as? String, type == "inside" else {
            return nil
        }
        
        guard let index = json["index"] as? Int else {
            return nil
        }
        
        guard let ratio = json["ratio"] as? Double else {
            return nil
        }
        
        self.ratio = ratio
        self.index = index
    }
}
