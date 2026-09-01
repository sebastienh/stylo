//
//  EditableView.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-10-22.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation

public protocol EditableView: class {
    
    var isEditable: Bool { get set }
    
    var editableManager: AnyEditable? { get }
    
}

public protocol ProjectSrollableEditor: class {
    
    func preventScrollingAndSaveBoundsIfNecessary(_ string: Any, replacementRange: NSRange)
    
    func restoreScrollingPositionIfNeeeded()
}
