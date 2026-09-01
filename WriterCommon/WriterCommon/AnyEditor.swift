//
//  AnyEditor.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-08-01.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Common
import PromiseKit
import Web

public protocol AnyEditor: class {
    
    var compilationUnit: Dynamic<CompilationUnit?> { get }
    
    var globalAttributes: Dynamic<GlobalAttributes?> { get }
    
    var selectionStatistics: Dynamic<TextStatistics?> { get }
    
    var styleAssemblyDescriptor: StyleAssemblyDescriptor { get }
    
    var isFirstResponder: Bool { get set }
    
    var selectedRange: NSRange? { get set }

    var visibleRange: NSRange? { get }
    
    var isFocused: Bool { get }
    
    var paragraphAttributes: [NSAttributedString.Key: Any]? { get }
    
    func flashText(withRange range: NSRange)
    
    func removeFlash()
    
    func highlight(with selectorString: String, visibleTopElements: ContiguousArray<Element>?, document: Document, selectedRange: NSRange?)
    
    func clearHighlight(visibleTopElements: ContiguousArray<Element>?, document: Document, selectedRange: NSRange?)
    
    func updateSelectionStatistics() -> Promise<Void>
    
    func applyGlobalAttributes()
    
    func updateTemporaryAttributedRange(from stringAction: StringAction)
    
}

extension EditorManager: AnyEditor {
    
}
