//
//  DocumentManager+Style.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-09-16.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import PromiseKit
import Common
import os
import Igloo

extension DocumentManager {
    
    public func applyGlobalStyle(styleId: String) throws {
        
        try self.dispatcher?.online(store: self.documentStore, action: DocumentAction.globalStyleChanged(styleId: styleId))
    }
    
    public func applyGlobalStyleSync(styleId: String) {
        
        self.dispatcher?.sync(store: self.documentStore, action: DocumentAction.globalStyleChanged(styleId: styleId).syncAction)
    }
    
    private var editedTextManagersIds: Set<String>? {
        
        guard let filesOutlineSetManager = self.filesOutlineSetManager.value else {
            assertionFailure("Error: self.filesOutlineSetManager is nil")
            return nil
        }
        
        return filesOutlineSetManager.selectedTextFiles
    }
    
    var notEditedTextManagers: [TextManager]? {
        
        guard let sourceSetManager = self._sourceSetManager.value else {
            assertionFailure("Error: self._sourceSetManager is nil")
            return nil
        }
        
        return self.notEditedTextManagersIds?.compactMap({ (textManagerId) -> TextManager? in
            
            guard let itemManager = sourceSetManager.directoryItemManager(withId: textManagerId) else {
                assertionFailure("Error: item manager is nil for id: \(textManagerId)")
                return nil
            }
            
            guard let textManager = itemManager as? TextManager else {
                assertionFailure("Error: itemManager is not TextManager")
                return nil
            }
            
            return textManager
        })
    }
    
    private var notEditedTextManagersIds: Set<String>?{
        
        guard let sourceSetManager = self._sourceSetManager.value else {
            assertionFailure("Error: self._sourceSetManager is nil")
            return nil
        }
        
        guard let editedTextManagersIds = self.editedTextManagersIds else {
            assertionFailure("Error: self.editedTextManagersIds is nil")
            return nil
        }
        
        var notEditedTextManagersIds = Set<String>(sourceSetManager._textManagers)
        
        for editedTextManagerId in editedTextManagersIds {
            notEditedTextManagersIds.remove(editedTextManagerId)
        }
        
        return notEditedTextManagersIds
    }
    
    @discardableResult
    public func applyTextStyle(_ styleManager: StyleManager) -> Promise<Void> {
        
        return Promise<Void> { fulfill, reject in
            
            if let editedTextManagersIds = self.editedTextManagersIds {
                firstly {
                    applyTextStyle(styleManager, to: editedTextManagersIds)
                }.then { _ -> Void in
                    fulfill(())
                }.catch { error in
                    reject(error)
                }
            }
            else {
                assertionFailure("Error: self.editedTextManagersIds is nil")
                reject(NWError.custom(message: "self.editedTextManagersIds is nil"))
            }
        }
    }
    
    public func applyAppearance(_ appearance: AppearanceMode) -> Promise<Void> {
        
        guard let filesOutlineSetManager = self.filesOutlineSetManager.value else {
            assertionFailure("Error: self.filesOutlineSetManager is nil")
            return Promise(error: NWError.custom(message: "Error: self.filesOutlineSetManager is nil"))
        }
        
        var promises: [Promise<Void>] = []
        
        for filesOutline in filesOutlineSetManager.filesOutlines.values {
            
            let promise = filesOutline.applyAppearanceAsync(appearance)
            promises.append(promise)
        }
        
        return when(fulfilled: promises)
    }
    
    public func applyTextStyleToEditedTextManagers(_ styleManager: StyleManager) -> Promise<Void> {
        
        return Promise<Void> { fulfill, reject in
            if let editedTextManagersIds = self.editedTextManagersIds {
                firstly {
                    applyTextStyle(styleManager, to: editedTextManagersIds)
                }.then { _ -> Void in
                    fulfill(())
                }.catch { error in
                    reject(error)
                }
            }
            else {
                assertionFailure("Error: self.editedTextManagersIds is nil")
                reject(NWError.custom(message: "self.editedTextManagersIds is nil"))
            }
        }
    }
    
    public func applyTextStyleToNotEditedTextManagers(_ styleManager: StyleManager) -> Promise<Void> {
    
        return Promise<Void> { fulfill, reject in
        
            if let notEditedTextManagersIds = self.notEditedTextManagersIds {
               
                firstly {
                    applyTextStyle(styleManager, to: notEditedTextManagersIds)
                }.then { _ -> Void in
                    fulfill(())
                }.catch { error in
                    reject(error)
                }
            }
            else {
                assertionFailure("Error: self.editedTextManagersIds is nil")
                reject(NWError.custom(message: "self.editedTextManagersIds is nil"))
            }
        }
    }
        
    public func applyTextStyleToNotEditedTextManagersSequentially(_ styleAssemblyStore: StyleAssemblyStore) {
        
        guard let notEditedTextManagers = self.notEditedTextManagers else {
            assertionFailure("Error: notEditedTextManagers is nil")
            return
        }
        
        backgroundStyleApplicator.applyStyle(styleAssemblyStore, toTextManagers: notEditedTextManagers)
    }
    
    func resetStylePendingChanges(forStyleAssemblyStore styleAssemblyStore: StyleAssemblyStore) -> Promise<ActionResult?> {
        
        assertionFailure("Error: unimplemented")
        return Promise<ActionResult?>(error: NWError.custom(message: "missing implementation"))
        
//        guard let styleManager = self.styleSetManager.styleManagerById(styleAssemblyStore.id) else {
//            assertionFailure("Error: no styleManager for id: \(styleAssemblyStore.id)")
//            return Promise<ActionResult?>.init(value: nil)
//        }
//
//
//
//        guard let authorStylesheetManager = styleManager.authorStylesheetManager else {
//            assertionFailure("Error: styleManager.authorStylesheetManager is nil")
//            return Promise<ActionResult?>.init(value: nil)
//        }
//
//        let action = EditableStoreActionsFactory.resetPendingChangesActionAsync()
//        return self.dispatcher.async(store: authorStylesheetManager.stylesheetDocumentStore, action: action)
    }
    
    @discardableResult
    func applyTextStyle(_ styleManager: StyleManager, to textManagersId: Set<String>) -> Promise<Void> {
        
        return Promise<Void> { fulfill, reject in
        
            if let sourceSetManager = self._sourceSetManager.value {
                
                var promises = [Promise<Void>]()
                
                for textManagerId in textManagersId {
                
                    guard let itemManager = sourceSetManager.directoryItemManager(withId: textManagerId) else {
                        assertionFailure("Error: item manager is nil for id: \(textManagerId)")
                        continue
                    }
                    
                    guard let textManager = itemManager as? TextManager else {
                        assertionFailure("Error: itemManager is not TextManager")
                        continue
                    }
                    
                    let promise = textManager.setStyleAsync(withStyleManager: styleManager)
                    promises.append(promise)
                }
                
                when(resolved: promises).then { _ -> Void in
                    fulfill(())
                }.catch { error in
                    reject(error)
                }
            }
            else {
                assertionFailure("Error: self.sourceSetManager is nil")
                reject(NWError.custom(message: "self.sourceSetManager is nil"))
            }
        }
        
    }
    
}
