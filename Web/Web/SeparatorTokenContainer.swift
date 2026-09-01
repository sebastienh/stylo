//
//  SeparatorCSSTokenContainer.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-09-09.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

protocol SeparatorTokenContainer: class {
    
    associatedtype TokenType: Token
    
    subscript(separatorIndex: Int) -> TokenType { get }
    
}
