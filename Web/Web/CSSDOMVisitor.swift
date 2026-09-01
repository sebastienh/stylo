//
//  CSSDOMVisitor.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-06-08.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

public protocol CSSDOMVisitor: DOMVisitor {
    
    func visit(_ node: CSSDOMDocument) -> NodeInfoType?
    
    func visit(_ node: CSSDOMElement) -> NodeInfoType?
    
    func visit(_ node: CSSDOMStyleSheetElement) -> NodeInfoType?
    
    func visit(_ node: CSSDOMTokenElement) -> NodeInfoType?
}
