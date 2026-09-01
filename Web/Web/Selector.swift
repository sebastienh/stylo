//
//  Selector.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-11-02.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common

public protocol Selector: CSSVisitable, CSSSelectorListVisitable, Positionnable {
    
    var selectorText: String { get }
    
    // see http://dev.w3.org/csswg/selectors-4/#specificity
    func calculateSpecificity(_ selectorSpecificity: SelectorSpecificity)

}
