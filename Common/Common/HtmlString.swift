//
//  HtmlString.swift
//  Common
//
//  Created by Sébastien Hamel on 2016-10-08.
//  Copyright © 2016 NM. All rights reserved.
//

import Foundation

public protocol HtmlString {
    
    mutating func unescapeAll() -> Self
    
    func decodeHTML() -> Self?
}

