//
//  HtmlRendererVisitable.swift
//  Web
//
//  Created by Sebastien Hamel on 2020-09-08.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

import Common

public protocol HtmlRendererVisitable: Visitable {
    
    @discardableResult
    func acceptRenderer<Visitor: HtmlRendererVisitor>(_ visitor: Visitor) -> Visitor.NodeInfoType?

}
