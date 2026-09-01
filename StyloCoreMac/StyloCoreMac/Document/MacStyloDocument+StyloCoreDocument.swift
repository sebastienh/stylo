//
//  MacStyloDocument+StyloCoreDocument.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-01-03.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Foundation
import WriterCommon
import PromiseKit

extension MacStyloDocument: StyloCoreDocument {
    
    public var toolsCollapsed: Bool {
        
        guard let windowController = self.windowController else {
            assertionFailure("Error: self.windowController is nil")
            return false
        }
        
        return windowController.toolsCollapsed
    }
    
    public func openTools(_ sender: AnyObject? = nil) {
        
        guard let windowController = self.windowController else {
            assertionFailure("Error: self.windowController is nil")
            return
        }
        
        windowController.openTools(sender)
    }
    
    public func animateCloseEditorTools(_ sender: AnyObject? = nil) -> Promise<Void> {
        
        guard let windowController = self.windowController else {
            assertionFailure("Error: self.windowController is nil")
            return Promise<Void>(value: ())
        }
        
        return windowController.animateCloseEditorTools(sender)
    }
}
