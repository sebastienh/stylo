//
//  Editor.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-08-01.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Common
import PromiseKit
import Igloo
import Web
import os

protocol StringStylable {
    
    associatedtype StylableStore: Store & StylableStoreType & IdentifiableStoreType
    
    var globalAttributes: Dynamic<GlobalAttributes?> { get }
    
    var styledStoreManager: StyledStoreManager<StylableStore> { get }
    
    var textStorage: NSTextStorage { get }
    
    var renderer: SourceStringAttributesRenderer { get }
    
    var styleAssemblyDescriptor: StyleAssemblyDescriptor { get }
    
    var visibleRange: NSRange? { get }
    
    var visibleRangeAsync: Promise<NSRange?> { get }
    
    ///
    /// This method is responsible for assigning the attributed string
    /// to the renderer according to the defined style assembly
    /// for the renderer.
    ///
    /// @precondition: styledStoreManagers dictionary is not empty
    /// @precondition: styledStoreManagers contains an entry for the renderer.id
    ///
    func applyStringAttributes(fromOriginStringAction stringAction: StringAction)
    
    /// Async version
    func applyStringAttributesAsync(fromOriginStringAction stringAction: StringAction) -> Promise<Void>
    
    func applyGlobalAttributes()
    
    func clearHighlight(visibleTopElements: ContiguousArray<Element>?, document: Document, selectedRange: NSRange?)
    
    func highlight(with selectorString: String, visibleTopElements: ContiguousArray<Element>?, document: Document, selectedRange: NSRange?)
    
    func applySourceAttributes(fromRenderingProcessingResult renderingProcessingResult: RenderingProcessingResult)
    
    func applyFocusAttributes(fromRenderingProcessingResult renderingProcessingResult: RenderingProcessingResult, stringAction: StringAction)
    
    func applyFocusAttributes(fromAttributes attributes: [([NSAttributedString.Key : Any], NSRange)], stringAction: StringAction)
}
