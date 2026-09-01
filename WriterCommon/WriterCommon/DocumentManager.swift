//
//  DocumentManager.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-03-02.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import Common
import PromiseKit
import Web

public enum DocumentMode {
    
    case document
    case project
}

@objc public class DocumentManager: NSObject, Observer {
    
    public var priority: ObserverPriority {
        return .background
    }
    
    public var styleSetManager: StyleSetManager
    
    public var _sourceSetManager: Dynamic<SourceSetManager?>
    
    public var pluginManager: PluginManager?
    
    public var isKeyDocument: Dynamic<Bool> = Dynamic<Bool>(true)
    
    public let loading = Dynamic<Bool>(true)
    
    public var filesOutlineSetManager: Dynamic<FilesOutlineSetManager?>

    /// This value present the selected items of the current
    /// selected outline in one unified dynamic value which
    /// takes into account the selected outline change and
    /// the selected files change inside that selected outline.
    public let _selectedFilesOutlineSelectedTextItems: DynamicOrderedSet<String>
    
    public let allowsAddingDirectoryAndTexts: Dynamic<Bool>
    
    public var selectedFilesOutlineManager: FilesOutlineManager? {
        
        return filesOutlineSetManager.value?.selectedFilesOutlineManager.value
    }
    
    public let clearFocusRequest: Dynamic<FilesOutlineManager.FileOutlineId?> = Dynamic<FilesOutlineManager.FileOutlineId?>(nil)
    
    public let _editedTextManager = Dynamic<TextManager?>(nil)
    
    public let id: String
    
    public var documentMode: DocumentMode = .project
    
    @objc public dynamic var title: String {
        set {
            self.namedChanged(to: newValue)
        }
        get {
            return self.name.value
        }
    }
    
    public let name: Dynamic<String>
    
    public var uiTransientState: UITransientState?
    
    // This value does not come from the StyloDocumentStore
    // it is propagated from the OS dynamic appearance being in
    // dark or light mode.
    public var documentUnderPageBackgroundColor: Dynamic<CGColor?>
    
    let documentStore: StyloDocumentStore
    
    public let userInteractionsEnabled = Dynamic<Bool>(true)
    
    public weak var document: TextDocument?
    
    public let loadedFormatVersion: SemanticVersion
    
    public let effectiveAppearance: Dynamic<NSAppearance?>
    
    public let appearanceMode: Dynamic<AppearanceMode>
    
    public let globalStyleId: Dynamic<String?>
    
    public let focusMode = Dynamic<FocusMode>(.disabled)
    
    public let lastFocusedEditorChangeEvent: Dynamic<FocusedEditorChangeEvent?> = Dynamic<FocusedEditorChangeEvent?>(nil)
    
    ///
    /// This value is used to keek the way the user interface wants
    /// the attributes to be sorted.
    ///
    public let attributesSortingMode = Dynamic<AttributesSortingMode>(.values)
    
    public var globalStyleManager: StyleManager? {
        
        guard let globalStyleId = self.globalStyleId.value else {
            assertionFailure("Error: globalStyleId is nil")
            return nil
        }
        
        return self.styleSetManager.styleById(globalStyleId)
    }
    
    var currentSourceStyleAssemblyDescriptor: StyleAssemblyDescriptor? {
        
        guard let computedAppearance = StyloApplication.shared.computedAppearance.value else {
            assertionFailure("Error: computedAppearance is nil")
            return nil
        }
        
        switch computedAppearance {
        case .dark:
            return StyleAssemblyDescriptor.textDarkStyleAssemblyDescriptor
        case .light:
            return StyleAssemblyDescriptor.textLightStyleAssemblyDescriptor
        }
    }
    
    var styleIdForNewText: String? {
        
        let _styleId: String? = {
            if let initiallyCreatedTextStyleId = self.document?.initiallyCreatedTextStyleId {
                return initiallyCreatedTextStyleId
            }
            else {
                guard let globalStyleId = self.globalStyleId.value else {
                    assertionFailure("Error: self.globalStyleId.value is nil")
                    return nil
                }
                return globalStyleId
            }
        }()
        
        guard let styleId = _styleId else {
            assertionFailure("Error: styleId is nil")
            return nil
        }
        return styleId
    }
    
    private var filesOutlineSetManagerValue: FilesOutlineSetManager? {
        
        return self.filesOutlineSetManager.value
    }
    
    private var firstUserSelectedItemId: String? {
        
        guard let selectedFilesOutlineManager = self.selectedFilesOutlineManager else {
            assertionFailure("Error: self.selectedFilesOutlineManager is nil")
            return nil
        }

        return selectedFilesOutlineManager.userSelectedItemsIdsArray.first
    }
    
    private var lastUserSelectedItemId: String? {
        
        guard let selectedFilesOutlineManager = self.selectedFilesOutlineManager else {
            assertionFailure("Error: self.selectedFilesOutlineManager is nil")
            return nil
        }
        
        return selectedFilesOutlineManager.userSelectedItemsIdsArray.last
    }
    
    public var documentUrl: URL? {
        
        return document?.documentURL.value
    }
    
    var dispatcher: StyloDocumentDispatcher? {
        
        return document?.documentDispatcher
    }
    
    let backgroundStyleApplicator: BackgroundStyleApplicator
    
    var focusTemporarlyDisabled: Bool = false
    
    private var sourceSetManagerValue: SourceSetManager? {
        
        return self._sourceSetManager.value
    }
    
    convenience init(documentMetadata: DocumentMetadata_1, document: TextDocument, globalStyleId: String? = nil, styleSetManager: StyleSetManager) {
    
        // when loading the old document format we don't have uuid
        self.init(id: UUID().uuidString, name: documentMetadata.name, document: document, globalStyleId: globalStyleId, styleSetManager: styleSetManager)
    }
    
    convenience init(name: String = "", document: TextDocument, globalStyleId: String? = nil, styleSetManager: StyleSetManager) {
        self.init(id: UUID().uuidString, name: name, document: document, globalStyleId: globalStyleId, styleSetManager: styleSetManager)
    }
    
    convenience init(documentMetadata: DocumentMetadata, document: TextDocument, styleSetManager: StyleSetManager) {
        
        self.init(id: documentMetadata.id, name: documentMetadata.name, document: document, formatVersion: documentMetadata.formatVersion, filesOutlineSet: documentMetadata.filesOutlineSet, globalStyleId: documentMetadata.globalStyleID, styleSetManager: styleSetManager)
    }
 
    private init(id: String, name: String, document: TextDocument, formatVersion: SemanticVersion? = nil, filesOutlineSet: FilesOutlineSetMetadata? = nil, globalStyleId: String? = nil, styleSetManager: StyleSetManager) {
        
        self.id = id
        self.name = Dynamic<String>(name)
        self.document = document
        self.documentUnderPageBackgroundColor = Dynamic<CGColor?>(nil)
        self.styleSetManager = styleSetManager
        self.filesOutlineSetManager = Dynamic<FilesOutlineSetManager?>(nil)
        self.documentStore = StyloDocumentStore(id: id, name: name, globalStyleID: globalStyleId)
        self.allowsAddingDirectoryAndTexts = Dynamic<Bool>(false)
        self.loadedFormatVersion = formatVersion ?? Constants.Versions.document
        self.backgroundStyleApplicator = BackgroundStyleApplicator()
        
        if let appearance = StyloApplication.shared.computedAppearance.value?.appearance {
            self.effectiveAppearance = Dynamic<NSAppearance?>(appearance)
        }
        else if let appearance = AppearanceMode.dark.appearance{
            self.effectiveAppearance = Dynamic<NSAppearance?>(appearance)
        }
        else {
            assertionFailure("Error: self.effectiveAppearance is set to nil")
            self.effectiveAppearance = Dynamic<NSAppearance?>(nil)
        }
        if let appearanceMode = self.effectiveAppearance.value?.appearanceMode {
            self.appearanceMode = Dynamic<AppearanceMode>(appearanceMode)
        }
        else {
            assertionFailure("Error: self.effectiveAppearance.value?.appearanceMode was nil")
            self.appearanceMode = Dynamic<AppearanceMode>(.dark)
        }
        
        self._sourceSetManager = Dynamic<SourceSetManager?>(nil)
        self.globalStyleId = Dynamic<String?>(globalStyleId)
        self._selectedFilesOutlineSelectedTextItems = DynamicOrderedSet<String>()
        super.init()
        self.dispatcher?.register(store: documentStore)
        bindToStore()
        subscribeToApplication()
        
        if let filesOutlineSet = filesOutlineSet {
            let filesOutlineSetManager = FilesOutlineSetManager(filesOutlineSetMetadata: filesOutlineSet, documentManager: self)
            self.filesOutlineSetManager.setValue(filesOutlineSetManager, notify: false)
        }
        else {
            self.filesOutlineSetManager.setValue(FilesOutlineSetManager(documentManager: self), notify: false)
        }
    }

    func initSubscriptions() {
        
        self.subscribeToSourceSetManager()
        self.subscribeToFilesOutlineSetManager()
    }
    
    func initPluginsData() {
        
        assert(self.pluginManager != nil)
        self.pluginManager?.initPluginsData()
    }
    
    public func updateIsKeyDocument(to value: Bool) {
        
        self.isKeyDocument.setValue(value)
        self.handleIsKeyDocumentChange(value)
    }
    
    func readPluginsData(from pluginsFileWrapper: FileWrapper?) throws {
        
        try self.pluginManager?.readPluginsData(from: pluginsFileWrapper)
    }
    
    public func pluginsTextEditorControls(forTextId textId: String, andEditorId editorId: String) -> [NSView]? {
        
        return self.pluginManager?.pluginsTextEditorControls(forTextId: textId, andEditorId: editorId)
    }
    
    /// Method to remove an item. It returns true or false
    /// depending on if the removed item was part of the user
    /// selection. This case is managed independently as
    /// when a user selection is righ clicked for deletion
    /// all visible user selected items are higlighted.
    public func removeItem(_ item: Any, visibleItems: [String]) throws -> Bool {
        
        guard let directoryItem = item as? DirectoryItemManager else {
            assertionFailure("Error: item is not DirectoryItemManager")
            return false
        }
        
        // two cases here:
        // 1. the item may be part of the user selection
        // 2. the item may be not be part of the user selection
        if visibleItems.contains(directoryItem.id) {
            try removeVisibleItems(visibleItems)
            return true
        }
        else {
            
            guard let sourceSetManager = self.sourceSetManagerValue else {
                assertionFailure("Error: self.sourceSetManagerValue is nil")
                return false
            }
            
            guard let filesOutlineSetManager = self.filesOutlineSetManager.value else {
                assertionFailure("Error: self.filesOutlineSetManager is nil")
                return false
            }
            
            try filesOutlineSetManager.removeSelectedFilesOutlineNotUserSelectedItem(withId: directoryItem.id)
            sourceSetManager.removeItem(withId: directoryItem.id)
            return false
        }
    }
    
    public func removeFilesOutlineManager(atIndex index: Int) {
        
        guard let filesOutlineSetManager = self.filesOutlineSetManager.value else {
            assertionFailure("Error: self.filesOutlineSetManager is nil")
            return
        }
        
        guard index >= 0 && index < filesOutlineSetManager.filesOutlines.count else {
            assertionFailure("Error: index is out of range")
            return
        }
        
        let filesOutlineManager = filesOutlineSetManager.filesOutlines.values[index]
        filesOutlineSetManager.removeFilesOutlineManager(filesOutlineManager, atIndex: index)
    }
    
    /// stylo #634: New files outline should be empty
    /// sytlo #650: new files outline should keep the same expanded items as the origin
    public func addNewEmptyFilesOutlineManager(atIndex index: Int) {
        
        guard let filesOutlineSetManager = self.filesOutlineSetManager.value else {
             assertionFailure("Error: self.filesOutlineSetManager is nil")
             return
         }
         
        guard let selectedFilesOutlineManager = filesOutlineSetManager.selectedFilesOutlineManager.value else {
            assertionFailure("Error: selectedFilesOutlineManager is nil")
            return
        }
        
        guard let selectedFilesOutlineManagerMetadata = selectedFilesOutlineManager.metadata else {
            assertionFailure("Error: selectedFilesOutlineManager.metadata is nil")
            return
        }
        
        var filesOutlineManagerMetadata = selectedFilesOutlineManagerMetadata
        filesOutlineManagerMetadata.name = filesOutlineSetManager.nextAvailableUntitledFilesOutlineName
        filesOutlineManagerMetadata.id = UUID().uuidString
        filesOutlineManagerMetadata.outlineUserSelectedItems = []
        
        guard let currentSourceStyleAssemblyDescriptor = self.currentSourceStyleAssemblyDescriptor else {
            assertionFailure("Error: self.currentSourceStyleAssemblyDescriptor is nil")
            return
        }
        
        let filesOutlineManager = FilesOutlineManager(filesOutlineMetadata: filesOutlineManagerMetadata, documentManager: self, styleAssemblyDescriptor: currentSourceStyleAssemblyDescriptor)
        filesOutlineSetManager.addFilesOutlineManager(filesOutlineManager, atIndex: index)
        filesOutlineSetManager.filesOutlineManagerSelected(withId: filesOutlineManager.id)
    }
    
    public func addNewFilesOutlineManager(atIndex index: Int) {
        
        guard let filesOutlineSetManager = self.filesOutlineSetManager.value else {
            assertionFailure("Error: self.filesOutlineSetManager is nil")
            return
        }
        
        guard let selectedFilesOutlineManager = filesOutlineSetManager.selectedFilesOutlineManager.value else {
            assertionFailure("Error: selectedFilesOutlineManager is nil")
            return
        }
        
        guard let selectedFilesOutlineManagerMetadata = selectedFilesOutlineManager.metadata else {
            assertionFailure("Error: selectedFilesOutlineManager.metadata is nil")
            return
        }
        
        guard let currentSourceStyleAssemblyDescriptor = self.currentSourceStyleAssemblyDescriptor else {
            assertionFailure("Error: self.currentSourceStyleAssemblyDescriptor is nil")
            return
        }
        
        var filesOutlineManagerMetadata = selectedFilesOutlineManagerMetadata
        filesOutlineManagerMetadata.name = filesOutlineSetManager.nextAvailableUntitledFilesOutlineName
        filesOutlineManagerMetadata.id = UUID().uuidString
        
        let filesOutlineManager = FilesOutlineManager(filesOutlineMetadata: filesOutlineManagerMetadata, documentManager: self, styleAssemblyDescriptor: currentSourceStyleAssemblyDescriptor)
        filesOutlineManager.updateSelectedItems()
        filesOutlineSetManager.addFilesOutlineManager(filesOutlineManager, atIndex: index)
    }
    
    public func removeAllUserSelectedItems() throws {
        
        guard let sourceSetManager = self.sourceSetManagerValue else {
            assertionFailure("Error: self.sourceSetManagerValue is nil")
            return
        }
        
        guard let filesOutlineSetManager = self.filesOutlineSetManager.value else {
            assertionFailure("Error: self.filesOutlineSetManager is nil")
            return
        }
        
        let deletedItems = try filesOutlineSetManager.removeSelectedFilesOutlineUserSelectedItems()
        for deletedItem in deletedItems {
            sourceSetManager.removeItem(withId: deletedItem)
        }
        self.updateAllowsAddingDirectoryAndTexts()
    }
    
    public func removeVisibleItems(_ visibleItems: [String]) throws {
        
        guard let sourceSetManager = self.sourceSetManagerValue else {
            assertionFailure("Error: self.sourceSetManagerValue is nil")
            return
        }
        
        guard let filesOutlineSetManager = self.filesOutlineSetManager.value else {
            assertionFailure("Error: self.filesOutlineSetManager is nil")
            return
        }
        
        let deletedItems = try filesOutlineSetManager.removeUserSelectedItems(withIds: visibleItems)
        for deletedItem in deletedItems {
            sourceSetManager.removeItem(withId: deletedItem)
        }
        self.updateAllowsAddingDirectoryAndTexts()
        
    }
    
    public func addUntitledGroup() -> DirectoryManager? {
        
        guard let sourceSetManager = self.sourceSetManagerValue else {
            assertionFailure("Error: self.sourceSetManagerValue is nil")
            return nil
        }

        guard let directoryManager = sourceSetManager.addUntitledDirectoryToUserFilesGroupsManager() else {
            assertionFailure("Error: userFilesGroupsManager is nil")
            return nil
        }
        
        self.updateAllowsAddingDirectoryAndTexts()
        return directoryManager
    }
    
    public func addUntitledDirectory(atEndOfDirectory directoryManager: DirectoryManager) -> DirectoryManager? {
        
        guard let sourceSetManager = self.sourceSetManagerValue else {
            assertionFailure("Error: self.sourceSetManagerValue is nil")
            return nil
        }
        
        // we add the directory manager as the first item in the directory
        let newDirectoryManager = DirectoryManager(sourceSetManager: sourceSetManager, parentId: directoryManager.id, name: directoryManager.nextAvailableUntitledDirectoryName)
        sourceSetManager.addDirectoryItemManager(newDirectoryManager , withId: newDirectoryManager.id, atEndOfParentWithId: directoryManager.id)
        
        do {
            try sourceSetManager.putItemAtEnd(newDirectoryManager, ofParentWithId: directoryManager.id)
            return newDirectoryManager
        }
        catch let error {
            sourceSetManager.removeItem(withId: newDirectoryManager.id)
            assertionFailure("Error: \(error)")
        }
        return nil
    }
    
    public func addUntitledText(atEndOfDirectory directoryManager: DirectoryManager) -> TextManager? {
        
        guard let sourceSetManager = self.sourceSetManagerValue else {
            assertionFailure("Error: self.sourceSetManagerValue is nil")
            return nil
        }
        
        guard let textManager = sourceSetManager.createEmptyTextManager(under: directoryManager.id) else {
            assertionFailure("Error: textManager is nil")
            return nil
        }
        
        do {
            
            sourceSetManager.addDirectoryItemManager(textManager, withId: textManager.id, atEndOfParentWithId: directoryManager.id)
            try sourceSetManager.putItemAtEnd(textManager, ofParentWithId: directoryManager.id)
            return textManager
        }
        catch let error {
            sourceSetManager.removeItem(withId: textManager.id)
            assertionFailure("Error: \(error)")
        }
        
        return nil
    }
    
    @discardableResult
    public func addUntitledTextAfter(_ item: DirectoryItemManager, directlyAfter: Bool = false) -> TextManager? {
        
        guard let filesOutlineManager = self.selectedFilesOutlineManager else {
            assertionFailure("Error: selectedFilesOutlineManager is nil")
            return nil
        }
        
        guard let sourceSetManager = self.sourceSetManagerValue else {
            assertionFailure("Error: self.sourceSetManagerValue is nil")
            return nil
        }
        
        switch item {
        case let selectedDirectoryManager as DirectoryManager:
            
            // if the directory is expanded or top we add under it
            if filesOutlineManager.isItemExpanded(id: selectedDirectoryManager.id) || selectedDirectoryManager.isTopDirectory {
                
                guard let textManager = sourceSetManager.createEmptyTextManager(under: selectedDirectoryManager.id ) else {
                    assertionFailure("Error: textManager is nil")
                    return nil
                }
                
                do {
                    
                    sourceSetManager.addDirectoryItemManager(textManager, withId: textManager.id, atEndOfParentWithId: selectedDirectoryManager.id)
                    try sourceSetManager.putItemAtEnd(textManager, ofParentWithId: selectedDirectoryManager.id)
                    if selectedDirectoryManager.isTopDirectory && !filesOutlineManager.isItemExpanded(id: selectedDirectoryManager.id) {
                        filesOutlineManager.addExpandedItem(with: selectedDirectoryManager.id)
                    }
                    return textManager
                }
                catch let error {
                    sourceSetManager.removeItem(withId: textManager.id)
                    assertionFailure("Error: \(error)")
                }
            }
            else {
                
                // we add the new text under the current directory and expand it.
                guard let textManager = sourceSetManager.createEmptyTextManager(under: selectedDirectoryManager.id) else {
                    assertionFailure("Error: textManager is nil")
                    return nil
                }
                
                do {
                    sourceSetManager.addDirectoryItemManager(textManager, withId: textManager.id, atEndOfParentWithId: selectedDirectoryManager.id)
                    try sourceSetManager.putItemAtEnd(textManager, ofParentWithId: selectedDirectoryManager.id)
                    if !filesOutlineManager.isItemExpanded(id: selectedDirectoryManager.id) {
                        filesOutlineManager.addExpandedItem(with: selectedDirectoryManager.id)
                    }
                    return textManager
                }
                catch let error {
                    sourceSetManager.removeItem(withId: textManager.id)
                    assertionFailure("Error: \(error)")
                }
            }
            
        case let previousTextManager as TextManager:
            // we add the text manager as the item after the current text manager
            
            guard let sourceSetManager = self.sourceSetManagerValue else {
                assertionFailure("Error: self.sourceSetManagerValue is nil")
                return nil
            }
            
            guard let textManager = sourceSetManager.createEmptyTextManager(under: previousTextManager.parentID.value) else {
                assertionFailure("Error: textManager is nil")
                return nil
            }
            
            do {
                if !directlyAfter {
                    sourceSetManager.addDirectoryItemManager(textManager, withId: textManager.id, atEndOfParentWithId: previousTextManager.parentID.value)
                    try sourceSetManager.putItemAtEnd(textManager, ofParentWithId: previousTextManager.parentID.value)
                }
                else {
                    sourceSetManager.addDirectoryItemManager(textManager, withId: textManager.id, afterItemWithId: previousTextManager.id)
                    try sourceSetManager.putItem(textManager, afterItemWithId: previousTextManager.id, inParentWithId: previousTextManager.parentID.value)
                }
                return textManager
            }
            catch let error {
                assertionFailure("Error: \(error)")
            }
            
        default:
            assertionFailure("Error: unsupported item type: \(type(of: item))")
            break
        }
        self.updateAllowsAddingDirectoryAndTexts()
        return nil
        
    }
    
    public func addUntitledText(directlyAfter: Bool = false) -> TextManager? {
        
        // find the last selected item
        guard let lastUserSelectedItemId = self.lastUserSelectedItemId else {
            assertionFailure("Error: should not call addUntitledText() when there is nothing selected.")
            return nil 
        }
        
        guard let sourceSetManager = self.sourceSetManagerValue else {
            assertionFailure("Error: self.sourceSetManagerValue is nil")
            return nil
        }
        
        guard let lastSelectedItem = sourceSetManager.directoryItemManager(withId: lastUserSelectedItemId) else {
            assertionFailure("Error: item with id: \(lastUserSelectedItemId) is nil")
            return nil
        }
        
        return addUntitledTextAfter(lastSelectedItem, directlyAfter: directlyAfter)
    }
    
    public func addUntitledDirectoryAfter(_ item: DirectoryItemManager, directlyAfter: Bool = false) -> DirectoryManager? {
    
        guard let filesOutlineManager = self.selectedFilesOutlineManager else {
            assertionFailure("Error: selectedFilesOutlineManager is nil")
            return nil
        }
        
        guard let sourceSetManager = self.sourceSetManagerValue else {
            assertionFailure("Error: self.sourceSetManagerValue is nil")
            return nil
        }
        
        switch item {
        case let selectedDirectoryManager as DirectoryManager:
            
            // we add the directory manager as the first item in the directory
            let newDirectoryManager = DirectoryManager(sourceSetManager: sourceSetManager, parentId: selectedDirectoryManager.id, name: selectedDirectoryManager.nextAvailableUntitledDirectoryName)
            sourceSetManager.addDirectoryItemManager(newDirectoryManager , withId: newDirectoryManager.id, atEndOfParentWithId: selectedDirectoryManager.id)
            
            do {
                try sourceSetManager.putItemAtEnd(newDirectoryManager, ofParentWithId: selectedDirectoryManager.id)
            }
            catch let error {
                sourceSetManager.removeItem(withId: newDirectoryManager.id)
                assertionFailure("Error: \(error)")
            }
            
            if filesOutlineManager.isItemExpanded(id: selectedDirectoryManager.id) || selectedDirectoryManager.isTopDirectory {
                if selectedDirectoryManager.isTopDirectory && !filesOutlineManager.isItemExpanded(id: selectedDirectoryManager.id) {
                    filesOutlineManager.addExpandedItem(with: selectedDirectoryManager.id)
                }
            }
            else {
                if !filesOutlineManager.isItemExpanded(id: selectedDirectoryManager.id) {
                    filesOutlineManager.addExpandedItem(with: selectedDirectoryManager.id)
                }
            }
            return newDirectoryManager
            
        case let previousTextManager as TextManager:
            
            guard let parentDirectoryManager = sourceSetManager.directoryItemManager(withId: previousTextManager.parentID.value) as? DirectoryManager else {
                assertionFailure("Error: item with id: \(previousTextManager.parentID.value) is nil")
                return nil
            }
            
            let newDirectoryManager = DirectoryManager(sourceSetManager: sourceSetManager, parentId: parentDirectoryManager.id, name: parentDirectoryManager.nextAvailableUntitledDirectoryName)
            
            do {
                
                if !directlyAfter {
                    sourceSetManager.addDirectoryItemManager(newDirectoryManager, withId: newDirectoryManager.id, atEndOfParentWithId: parentDirectoryManager.id)
                    try sourceSetManager.putItemAtEnd(newDirectoryManager, ofParentWithId: parentDirectoryManager.id)
                }
                else {
                    sourceSetManager.addDirectoryItemManager(newDirectoryManager, withId: newDirectoryManager.id, afterItemWithId: previousTextManager.id)
                    try sourceSetManager.putItem(newDirectoryManager, afterItemWithId: previousTextManager.id, inParentWithId: previousTextManager.parentID.value)
                }
                return newDirectoryManager
            }
            catch let error {
                sourceSetManager.removeItem(withId: newDirectoryManager.id)
                assertionFailure("Error: \(error)")
            }
        default:
            assertionFailure("Error: unsupported item type: \(type(of: item))")
            break
        }
        return nil
    }
    
    public func addUntitledDirectory(directlyAfter: Bool = false) -> DirectoryManager? {
        
        // find the first selected item
        guard let lastUserSelectedItemId = self.lastUserSelectedItemId else {
            assertionFailure("Error: should not call addUntitledDirectory() when there is nothing selected.")
            return nil
        }
        
        guard let sourceSetManager = self.sourceSetManagerValue else {
            assertionFailure("Error: self.sourceSetManagerValue is nil")
            return nil
        }
        
        guard let lastSelectedItem = sourceSetManager.directoryItemManager(withId: lastUserSelectedItemId) else {
            assertionFailure("Error: item with id: \(lastUserSelectedItemId) is nil")
            return nil
        }
        
        return addUntitledDirectoryAfter(lastSelectedItem, directlyAfter: directlyAfter)
    }
    
    public func addUntitledDirectory(under parentItemId: String) -> DirectoryManager? {
        
        guard let sourceSetManager = self.sourceSetManagerValue else {
            assertionFailure("Error: self.sourceSetManagerValue is nil")
            return nil
        }
        
        guard let parentItem = sourceSetManagerValue?.directoryItemManager(withId: parentItemId) else {
            assertionFailure("Error: item with id: \(parentItemId) is nil")
            return nil
        }
        
        // two cases:
        // 1. add from document, only possible if there one element selected, and
        // this element is a directory, this should be validated on the UI.
        // 2. add from directory, always possible. It means we add from the
        // group item add menu.
        if parentItemId == sourceSetManagerValue?.documentId {
            
            
            
        }
        // the user wants to add a directory under another one.
        else if let directoryManager = parentItem as? DirectoryManager {
            
            let directoryManager = DirectoryManager(sourceSetManager: sourceSetManager, parentId: parentItemId, name: directoryManager.nextAvailableUntitledDirectoryName)
            do {
                sourceSetManager.addDirectoryItemManager(directoryManager, withId: directoryManager.id, atStartOfParentWithId: parentItemId)
                try sourceSetManager.putItemAtStart(directoryManager, ofParentWithId: parentItemId)
                return directoryManager
            }
            catch let error {
                sourceSetManager.removeItem(withId: directoryManager.id)
                assertionFailure("Error: \(error)")
            }
        }
        return nil
    }
    
    func namedChanged(to newName: String) {
        do {
            try self.dispatcher?.online(store: self.documentStore, action: DocumentAction.nameChanged(newName: newName))
        }
        catch let error {
            assert(false, "error: \(error)")
        }
    }
    
    func writingSessionHiddenChanged(newValue: Bool) {
        
        do {
            try self.dispatcher?.online(store: self.documentStore, action: DocumentAction.writingSessionHiddenChanged(newValue: newValue))
        }
        catch let error {
            assert(false, "error: \(error)")
        }
    }
    
    func loadPluginManager() {
    
        self.pluginManager = PluginManager(documentManager: self)
        
        guard let pluginManager = self.pluginManager else {
            assertionFailure("Error: self.pluginManager is nil")
            return
        }
        
        pluginManager.loadPlugins()
    }
    
    private func bindToStore() {
        
        self.name.bind(to: documentStore.name)
        self.handleGlobalStyleId(newStyleId: self.documentStore.globalStyleID.value)
        self.documentStore.globalStyleID.subscribe({ [weak self](newStyleId) in
            self?.handleGlobalStyleId(newStyleId: newStyleId)
        }, observer: self)
    }
    
    private func unbindToStore() {
        
        self.name.unbind(from: documentStore.name)

        self.documentStore.globalStyleID.unsubscribe(observer: self)
    }
    
    private func handleGlobalStyleId(newStyleId styleId: String?) {
        if styleId != self.globalStyleId.value {
            self.globalStyleId.setValue(styleId)
            if let styleId = styleId {
                self.styleSetManager.updateSelectedStyle(to: styleId)
            }
        }
    }
    
    func subscribeToSourceSetManager() {
        
        guard let sourceSetManager = self.sourceSetManagerValue else {
            assertionFailure("Error: self.sourceSetManagerValue is nil")
            return
        }
        
        sourceSetManager.directoryItemManagers.subscribe({ [weak self](dictionaryChange) in
            
            guard let filesOutlineSetManager = self?.filesOutlineSetManager.value else {
                assertionFailure("Error: self.filesOutlineSetManager.value is nil")
                return
            }
            
            filesOutlineSetManager.handleGlobalTextManagersChange()
        }, observer: self)
    }
    
    private func unsubscribeFromSourceSetManager() {
        
        sourceSetManager?.textManagers.unsubscribe(observer: self)
    }
    
    var subscribedFilesOutlineManager: FilesOutlineManager?
    
    public func subscribeToFilesOutlineSetManager() {
        
        self.handleFilesOutlineSetChange(self.filesOutlineSetManager.value)
        self.filesOutlineSetManager.subscribe({ [weak self](filesOutlineSetManager) in
            self?.handleFilesOutlineSetChange(filesOutlineSetManager)
        }, observer: self)
    }
    
    public func handleFilesOutlineSetChange(_ filesOutlineSetManager: FilesOutlineSetManager?) {
        
        guard let filesOutlineSetManager = filesOutlineSetManager else {
            assertionFailure("Error: filesOutlineSetManager is nil")
            return
        }

        // this condition is here in order to avoid to trigger the assertion in
        // subscribe(to filesOutlineManager: FilesOutlineManager?) method that we
        // want to keep to detect improperly setting a selected files outline to nil
        // during the normal operations after initialization.
        if let selectedFilesOutlineManager = filesOutlineSetManager.selectedFilesOutlineManager.value {
            self.subscribe(to: selectedFilesOutlineManager)
        }
        filesOutlineSetManager.selectedFilesOutlineManager.subscribe({ [weak self](filesOutlineManager) in
            self?.unsubscribe(from: self?.subscribedFilesOutlineManager)
            self?.subscribe(to: filesOutlineManager)
        }, observer: self)
    }
    
    private func unsubscribe(from filesOutlineManager: FilesOutlineManager?) {

        self.subscribedFilesOutlineManager?.userSelectedItems.unsubscribe(observer: self)
        self.subscribedFilesOutlineManager?.selectedTextItems.unsubscribe(observer: self)
        self.subscribedFilesOutlineManager?.styleAssemblyApplicationStatus.unsubscribe(observer: self)
        self.subscribedFilesOutlineManager = nil
    }
    
    func subscribe(to filesOutlineManager: FilesOutlineManager?) {

        guard let filesOutlineManager = filesOutlineManager else {
            assertionFailure("Error: filesOutlineManager is nil")
            return
        }
        
        // subscribe to the new one
        self.handleUserSelectedItemsChange()
        filesOutlineManager.userSelectedItems.subscribe({ [weak self](_) in
            self?.handleUserSelectedItemsChange()
        }, observer: self)
        
        self.handleExpandedItemsChange()
        filesOutlineManager.expandedItems.subscribe({ [weak self](_) in
            self?.handleExpandedItemsChange()
        }, observer: self)
        
        var singleChangeHandling = false
        self.handleSelectedItemsChange(filesOutlineManager.selectedTextItems.values)
        filesOutlineManager.selectedTextItems.subscribe({ [weak self](arrayChange) in
            
            switch arrayChange {
            case .deletes(_, _, let updatedArray):
                if singleChangeHandling {
                    self?.handleSelectedItemsChange(updatedArray)
                }
            case .insert(_, _, let updatedArray):
                if singleChangeHandling {
                    self?.handleSelectedItemsChange(updatedArray)
                }
            case .inserts(_, _, let updatedArray):
                if singleChangeHandling {
                    self?.handleSelectedItemsChange(updatedArray)
                }
            case .move(_, _, _, let updatedArray):
                if singleChangeHandling {
                    self?.handleSelectedItemsChange(updatedArray)
                }
            case .start(let sourceArray, let destinationArray):
                if abs(sourceArray.count-destinationArray.count) == 1 {
                    singleChangeHandling = true
                }
            case .end(let updatedArray):
                if !singleChangeHandling {
                    self?.handleSelectedItemsChange(updatedArray)
                    singleChangeHandling = false
                }
            }
        }, observer: self)
        
        filesOutlineManager.styleAssemblyApplicationStatus.subscribe({ [weak self](styleUpdateStatus) in
            switch styleUpdateStatus {
            case .applied:
                self?.userInteractionsEnabled.setValue(true)
            case .pending:
                self?.userInteractionsEnabled.setValue(false)
            }
        }, observer: self)
        
        self.subscribedFilesOutlineManager = filesOutlineManager
    }
    
    private func handleSelectedItemsChange(_ updatedOrderedSet: OrderedSet<String>) {
        
        let currentArray = self._selectedFilesOutlineSelectedTextItems.values
        let arrayEdits = currentArray.editOperations(to: updatedOrderedSet)
        self._selectedFilesOutlineSelectedTextItems.applyArrayEdits(arrayEdits, to: updatedOrderedSet)
    }

    private func handleExpandedItemsChange() {
        
        self.updateAllowsAddingDirectoryAndTexts()
    }
    
    private func handleUserSelectedItemsChange() {
        
        self.updateAllowsAddingDirectoryAndTexts()
    }
    
    private func updateAllowsAddingDirectoryAndTexts() {
        
        guard let filesOutlineManager = self.selectedFilesOutlineManager else {
            assertionFailure("Error: self.selectedFilesOutlineManager is nil")
            return
        }
        
        self.allowsAddingDirectoryAndTexts.setValue(filesOutlineManager.hasVisibleUserSelectedItems)
    }
    
    private func subscribeToApplication() {
        subscribeToAppearanceChange()
        subscribeToFocusMode()
    }
    
    private func subscribeToAppearanceChange() {
        
        StyloApplication.shared.computedAppearance.subscribe({ [weak self](appearanceMode) in
            
            guard let appearanceMode = appearanceMode else {
                assertionFailure("Error: setting a computed appearance to nil")
                return 
            }
            
            self?.appearanceMode.setValue(appearanceMode)
            if let appearance = appearanceMode.appearance {
                self?.effectiveAppearance.setValue(appearance)
            }
        }, observer: self)
    }
    
    deinit {
        
        unbindToStore()
        self.filesOutlineSetManager.unsubscribe(observer: self)
        self.filesOutlineSetManager.value?.selectedFilesOutlineManager.unsubscribe(observer: self)
        unsubscribeFromSourceSetManager()
    }
}
