//
//  CSSStyleManager+Editable.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-04-18.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Common

extension CSSStyleManager: Editable {

    public typealias StylableStore = JsonStyleStore
    
    public typealias EditableStore = JsonStore
    
    public func executeCompilation(withChangeDescription changeDescription: SourceStringChangeDescription) {
        
        fatalError("missing implementation")
    }
    
    public func focusedRange(forChange change: SourceStringChangeDescription) -> NSRange? {
        
        assertionFailure("Error: method not implementated")
        return nil
    }
}
