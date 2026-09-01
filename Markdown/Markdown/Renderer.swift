//
//  Renderer.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-24.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation

public protocol Renderer {
    
    associatedtype ReturnType
    
    func render(_ tokens: Tokens, options: Options?, env: Env?) -> ReturnType
}
