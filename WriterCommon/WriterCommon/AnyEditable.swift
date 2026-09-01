//
//  AnyEditable.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-04-20.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import PromiseKit
import Common
import Web

public protocol AnyEditable: class {
    
    var isEdited: Dynamic<Bool> { get }
    
    var lastEditDate: Dynamic<Date?> { get }
    
    var editedLanguage: Language { get }
    
    var string: String { get set }
    
    func editor(for editorId: EditorId) -> AnyEditor?
    
    func applyEdit(withChangeDescription changeDescription: SourceStringChangeDescription, forEditorWithId editorId: EditorId, undoManager: UndoManager?, updateAll: Bool)
    
    func flashAttributes(forEditorWithId editorId: EditorId, inRange range: NSRange) -> [AttributesRange]?
    
    func textStorage(forEditorWithId id: EditorId) -> NSTextStorage

    ///
    /// This method is responsible for registering a new renderer
    ///
    /// @precondition: editableStore is initialized
    /// @precondition: styleManager is not nil
    ///
    func registerEditor(withRenderer renderer: SourceStringAttributesRenderer) throws
    
    func setStyleAssemblyDescriptor(_ descriptor: StyleAssemblyDescriptor, forEditorId editorId: EditorId, visibleRange: NSRange?)
    
    ///
    /// This method removes all references to this renderer. It should also
    /// make sure that if a StyledStoreManager referenced by a StyleAssemblyDescriptor
    /// is not used anymore it is removed from the styledStoreManagers dictionary.
    ///
    func unregisterEditor(withId editorId: EditorId)
    
}


extension TextManager: AnyEditable {
    
}

extension StylesheetManager: AnyEditable {
    
}

extension CSSStyleManager: AnyEditable {
    
}
