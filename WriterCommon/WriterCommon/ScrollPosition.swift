//
//  ScrollPosition.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-05-04.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation

/// This enum contains everyting to describe a scroll position
/// inside a document
public enum ScrollPosition {
    
    case start(ratio: CGFloat)

    case between(first: Int, second: Int, ratio: CGFloat)

    case inside(index: Int, ratio: CGFloat)

    case end(ratio: CGFloat)
    
    public static func fromJson(string: String) -> ScrollPosition? {
        
        let data = string.data(using: String.Encoding.utf8)
        
        assert(data != nil)
        if let data = data {
        
            do {
                
                let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                
                assert(object is [String: Any])
                let dictionary = object as? [String: Any]
                
                assert(dictionary != nil)
                if let dictionary = object as? [String: Any] {
                 
                    if let startPosition = StartPosition(json: dictionary) {
                        return ScrollPosition.start(ratio: CGFloat(startPosition.ratio))
                    }
                    else if let betweenPosition = BetweenPosition(json: dictionary) {
                        return ScrollPosition.between(first: betweenPosition.beforeIndex, second: betweenPosition.afterIndex, ratio: CGFloat(betweenPosition.ratio))
                    }
                    else if let insidePosition = InsidePosition(json: dictionary) {
                        return ScrollPosition.inside(index: insidePosition.index, ratio: CGFloat(insidePosition.ratio))
                    }
                }
            }
            catch let error {
                assert(false, "error: \(error)")
            }
        }
        return nil
    }
    
}




