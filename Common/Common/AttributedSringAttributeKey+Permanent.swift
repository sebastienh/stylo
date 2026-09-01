//
//  AttributedSringAttributeKey+Permanent.swift
//  Common
//
//  Created by Sebastien Hamel on 2020-04-13.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

extension NSAttributedString.Key {
    
    public var isTemporary: Bool {
        switch self {
        case .strokeColor:
            return true
        case .backgroundColor:
            return true
        case .foregroundColor:
            return true
        case .underlineColor:
            return true
        case .underlineStyle:
            return true
        case .strikethroughColor:
            return true
        case .strikethroughStyle:
            return true
        case NSAttributedString.Key(rawValue: §StyloAttribute.overlineStyle):
            return true
        case NSAttributedString.Key(rawValue: §StyloAttribute.overlineColor):
            return true
        case NSAttributedString.Key(rawValue: §StyloAttribute.strikethroughColor):
            return true
        case NSAttributedString.Key(rawValue: §StyloAttribute.headingTagBefore):
            return false
        case NSAttributedString.Key(rawValue: §StyloAttribute.headingTagAfter):
            return false
        default:
            return false
        }
    }
    
    public static var temporaryAttributesKeys: [NSAttributedString.Key] {
        
        return [.strokeColor,
            .backgroundColor,
            .foregroundColor,
            .underlineColor,
            .underlineStyle,
            .strikethroughColor,
            NSAttributedString.Key(rawValue: §StyloAttribute.overlineStyle),
            NSAttributedString.Key(rawValue: §StyloAttribute.overlineColor),
            NSAttributedString.Key(rawValue: §StyloAttribute.strikethroughColor)
        ]
    }
    
}
