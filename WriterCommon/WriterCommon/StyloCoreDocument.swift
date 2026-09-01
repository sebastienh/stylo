//
//  StyloCoreDocument.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-01-03.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import PromiseKit

public protocol StyloCoreDocument {
    
    var toolsCollapsed: Bool { get }
    
    func openTools(_ sender: AnyObject?)
    
    @discardableResult
    func animateCloseEditorTools(_ sender: AnyObject?) -> Promise<Void>
}
