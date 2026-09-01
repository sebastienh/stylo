//
//  ElementSelection.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-07-19.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Web

/// This struct is used to describe a user selection
/// in the text view. Used mainly for the moment,
/// for the "Copy selector" functionality.
///
/// The only reason why this is a class is because we want to
/// use this value with "dynamic" in the StyloWindowController.
public struct ElementSelection {
    
    public let element: Element
    public let charIndex: Int
    
    public init(element: Element, charIndex: Int) {
        
        self.element = element
        self.charIndex = charIndex
    }
    
}
