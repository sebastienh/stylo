//
//  DelimitersCSSTokenContainer.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-09-09.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

protocol DelimiterTokenContainer: class {
    
    associatedtype TokenType: Token
    
    var firstDelimiterToken: TokenType { get }
    
    var lastDelimiterToken: TokenType { get }
}
