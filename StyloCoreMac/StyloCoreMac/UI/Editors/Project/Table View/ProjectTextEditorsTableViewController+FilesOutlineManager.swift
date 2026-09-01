//
//  ProjectTextEditorsTableViewController+FilesOutlineManager.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-05-25.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa
import WriterCommon
import Common
import os

extension ProjectTextEditorsTableViewController {
    
    func subscribeToFilesOutlineManager() {
        
        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: self.filesOutlineManager is nil")
            return
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("subscribing to files outline named: %@", log: Log.StyloCore.all, type: .info, %%filesOutlineManager.name.value)
        #endif
        
        var animate = true
        
        var removedTextIds: [TextId]?
        
        filesOutlineManager.selectedTextItems.subscribe({ [weak self](change) in
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            guard let filesOutlineManager = self?.filesOutlineManager else {
                assertionFailure("Error: self.filesOutlineManager is nil")
                return
            }
            os_log("handling change from files outline named: %@, change: %@", log: Log.StyloCore.all, type: .info, %%filesOutlineManager.name.value, %%change)
            #endif
            
            guard let projectTextEditorsTableView = self?.projectTextEditorsTableView else {
                assertionFailure("Error: self.projectTextEditorsTableView is nil")
                return
            }
            
            func shouldAnimateTextEditorsSelectionChange<C>(from source: C, to destination: C) -> Bool where C: Collection, C.Element == String {
                
                if destination.count == 1 || abs(source.count-destination.count) > 1 {
                    return false
                }
                return true
            }
            
            switch change {
            case .deletes(let indexes, let deletedTextIds, _):
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("selectedTextItems.deletes -> deletedTextIds: %@, indexes: %@", log: Log.StyloCore.all, type: .info, %%deletedTextIds, %%indexes)
                os_log("delete selected editors in table", log: Log.StyloCore.all, type: .info)
                #endif
                
                if animate {
                    
                    var updatedIndexes: [Int] = []
                    for index in indexes {
                        let titleIndex = index*2
                        let editorIndex = (index*2)+1
                        updatedIndexes.append(titleIndex)
                        updatedIndexes.append(editorIndex)
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("delete editors title index: %@ in table", log: Log.StyloCore.all, type: .info, %%titleIndex)
                        os_log("delete editors editor index: %@ in table", log: Log.StyloCore.all, type: .info, %%editorIndex)
                        #endif
                        
                    }
                    
                    self?.executeWorkWithDisabledUserInteractionsIfNecessary(withTextIds: deletedTextIds) {
                        projectTextEditorsTableView.beginUpdates()
                        projectTextEditorsTableView.removeRows(at: IndexSet(updatedIndexes), withAnimation: NSTableView.AnimationOptions.effectFade)
                        projectTextEditorsTableView.endUpdates()
                        removedTextIds = deletedTextIds
                    }
                }
            case .insert(let textId, let index, _):
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("selectedTextItems.insert -> textId: %@, index: %@", log: Log.StyloCore.all, type: .info, %%textId, %%index)
                os_log("insert index: %@ in editors in table", log: Log.StyloCore.all, type: .info, %%index)
                #endif
                
                var updatedIndexes: [Int] = []
                let titleIndex = index*2
                let editorIndex = (index*2)+1
                updatedIndexes.append(titleIndex)
                updatedIndexes.append(editorIndex)
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("insert title index: %@ in editors in table", log: Log.StyloCore.all, type: .info, %%titleIndex)
                os_log("insert editor index: %@ in editors in table", log: Log.StyloCore.all, type: .info, %%editorIndex)
                os_log("insert editor -> animate: %@", log: Log.StyloCore.all, type: .info, %%animate)
                #endif
                
                if animate {
                    let animationOption: NSTableView.AnimationOptions = {
                        if projectTextEditorsTableView.numberOfRows > 0 && titleIndex == 0 {
                            return .effectGap
                        }
                        return .slideDown
                    }()
                        
                    self?.executeWorkWithDisabledUserInteractionsIfNecessary(withTextIds: [textId]) {
                        self?._openTexts(withTextIds: [textId], updatedIndexes: updatedIndexes, animationOptions: animationOption)
                    }
                }
            case .inserts(let textIds, let indexes, _):

                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("selectedTextItems.inserts -> textIds: %@, indexes: %@", log: Log.StyloCore.all, type: .info, %%textIds, %%indexes)
                os_log("inserts selected editors in table", log: Log.StyloCore.all, type: .info)
                #endif
                
                var updatedIndexes: [Int] = []
                for index in indexes {
                    let titleIndex = index*2
                    let editorIndex = (index*2)+1
                    updatedIndexes.append(titleIndex)
                    updatedIndexes.append(editorIndex)
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("insert editors title index: %@ in table", log: Log.StyloCore.all, type: .info, %%titleIndex)
                    os_log("insert editors editor index: %@ in table", log: Log.StyloCore.all, type: .info, %%editorIndex)
                    #endif
                }
                if animate {
                    
                    self?.executeWorkWithDisabledUserInteractionsIfNecessary(withTextIds: Array(textIds)) {
                        self?._openTexts(withTextIds: Array(textIds), updatedIndexes: updatedIndexes, animationOptions: .slideDown)
                    }
                }
            case .move(let textId, let sourceIndex, let targetIndex, _):
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("selectedTextItems.move -> textId: %@, sourceIndex: %@, targetIndex: %@", log: Log.StyloCore.all, type: .info, %%textId, %%sourceIndex, %%targetIndex)
                #endif
                
                if animate {
                    
                    self?.executeWorkWithDisabledUserInteractionsIfNecessary(withTextIds: [textId]) {
                        projectTextEditorsTableView.beginUpdates()
                        projectTextEditorsTableView.moveRow(at: sourceIndex*2, to: targetIndex*2)
                        projectTextEditorsTableView.moveRow(at: (sourceIndex*2)+1, to: (targetIndex*2)+1)
                        projectTextEditorsTableView.endUpdates()
                    }
                }
            case .start(let sourceArray, let destinationArray):
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("selectedTextItems.start -> sourceArray: %@, destinationArray: %@", log: Log.StyloCore.all, type: .info, %%sourceArray, %%destinationArray)
                #endif
                
                if !shouldAnimateTextEditorsSelectionChange(from: sourceArray, to: destinationArray) {
                    animate = false
                }
            case .end(let textIds):
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("selectedTextItems.end -> textIds: %@", log: Log.StyloCore.all, type: .info, %%textIds)
                os_log("selectedTextItems.end -> animate: %@", log: Log.StyloCore.all, type: .info, %%animate)
                #endif
                
                if !animate {
                    assert(self != nil)
                    assert(self?.projectTextEditorsTableView != nil)
                    self?.executeWorkWithDisabledUserInteractionsIfNecessary(withTextIds: Array(textIds)) { [weak self] in
                        self?.projectTextEditorsTableView.reloadData()
                    }
                    animate = true
                }
                if let _removedTextIds = removedTextIds {
                    self?.removeTextEditorsIfNecessary(withIds: _removedTextIds)
                    removedTextIds = nil
                }
                self?.updateLastTextEditor(fromSelectedTextIds: textIds)
            }
        }, observer: self)
        
        filesOutlineManager.collapsedEditorItems.subscribe({ [weak self](change) in
            switch change {
            case .inserts(let values, _):
                for id in values {
                    self?.collapseEditor(withId: id)
                }
            case .deletes(let values, _):
                for id in values {
                    self?.expandEditor(withId: id)
                }
            }
        }, observer: self)
        
        filesOutlineManager.scrolledItemId.subscribe({ [weak self](textManagerId) in
            if let textManagerId = textManagerId {
                self?.scrollToItemContent(withId: textManagerId)
            }
        }, observer: self)
        
        filesOutlineManager.filesOutlineDesiredScrollPosition.subscribe({ [weak self](scrollPosition) in
            self?.handleFilesOutlineDesiredPositionChange(scrollPosition)
        }, observer: self)
        
        filesOutlineManager.styleAssemblyDescriptor.subscribe({ [weak self](styleAssemblyDescriptor) in
            self?.styleAssemblyDescriptor = styleAssemblyDescriptor
        }, observer: self)
    }
    
    private func updateLastTextEditor(fromSelectedTextIds textIds: OrderedSet<TextId>) {
        
        for (index, textId) in textIds.enumerated() {
            
            guard let projectTextEditorViewController = self.projectTextEditorViewControllers[textId] else {
                // when adding the first element in an empty editors pane
                // it's possible for the projectTextEditorViewController to be nil
                // we simply ignore this error since it will be
                // managed when displaying the editor
                continue
            }
            
            // last item
            projectTextEditorViewController.isLast = index == textIds.count-1
        }
    }
    
    private func executeWorkWithDisabledUserInteractionsIfNecessary(withTextIds textIds: [String], work: @escaping () -> ()) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("executeWorkWithDisabledUserInteractionsIfNecessary(work: ...)", log: Log.StyloCore.all, type: .info)
        #endif
        
        guard let sourceSetManager = self.sourceSetManager else {
            assertionFailure("Error: ")
            return
        }
        
        guard let documentManager = self.documentManager else {
            assertionFailure("Error: ")
            return
        }
        
        /// If userInteractionsEnabled is disabled (maybe because of previous
        /// added text that needed working overlay) we also want to wait.
        let needsToDisplayWorkingOverlay = sourceSetManager.needsToDisplayWorkingOverlay(forTextWithIds: textIds) || documentManager.userInteractionsEnabled.value == false
        
        if needsToDisplayWorkingOverlay {
            
            self.addPendingOpenTextManagerTask()
            DispatchQueue.global(qos: .background).async { [weak self] in
                DispatchQueue.main.async { [weak self] in
                    self?.tableUpdateSerialQueue.sync {
                        usleep(50000)
                        work()
                        self?.removePendingOpenTextManagerTask()
                    }
                }
            }
        }
        else {
            work()
        }
    }
    
    private func _openTexts(withTextIds textIds: [TextId], updatedIndexes indexes: [Int], animationOptions: NSTableView.AnimationOptions) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("_openTexts(withTextIds: %@, updatedIndexes: %@, animationOptions: %@)", log: Log.StyloCore.all, type: .info, %%textIds, %%indexes, %%animationOptions)
        #endif
        
        projectTextEditorsTableView.beginUpdates()
        projectTextEditorsTableView.insertRows(at: IndexSet(indexes), withAnimation: animationOptions)
        projectTextEditorsTableView.endUpdates()
        
        guard indexes.count > 1 else {
            assertionFailure("Error: indexes.count is not > 1")
            return
        }
        
        let firstTextIndex = indexes[1]
        projectTextEditorsTableView.scrollRowToVisible(firstTextIndex)
    }
    
    private func handleFilesOutlineDesiredPositionChange(_ scrollPosition: FilesOutlineScrollPosition?) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("handleFilesOutlineDesiredPositionChange(%@)", log: Log.StyloCore.all, type: .info, %%position)
        #endif
        
        if let scrollPosition = scrollPosition {
            self.scroll(toFilesOutlineScrollPosition: scrollPosition)
        }
        
        self.filesOutlineManager?.filesOutlineDesiredScrollPosition.setValue(nil, notify: false)
    }
    
    private func scroll(toFilesOutlineScrollPosition scrollPosition: FilesOutlineScrollPosition) {

        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("scroll(toFilesOutlinePosition: %@)", log: Log.StyloCore.all, type: .info, %%position)
        #endif
        
        let position = scrollPosition.position
        
        DispatchQueue.asyncOnMain { [weak self] in

            guard let scrollPoint = self?.scrollPoint(forFilesOutlinePosition: position) else {
                assertionFailure("Erorr: scrollPoint is nil")
                return
            }

            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("scroll:toFilesOutlinePosition -> scrollPoint: %@)", log: Log.StyloCore.all, type: .info, %%scrollPoint)
            #endif

            guard scrollPoint.y >= 0 else {
                assertionFailure("Error: trying to scroll to a negative position: \(scrollPoint.y)")
                return
            }

            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("scrolling to scrollPoint: %@ in table", log: Log.StyloCore.all, type: .info, %%scrollPoint)
            #endif
            if scrollPosition.flash {
                self?.flashText(atFilesOutlinePosition: position)
            }
            
            NSAnimationContext.runAnimationGroup({ (context) in
                context.duration = 0.2
                guard let clipView = self?.scrollView.contentView else {
                    assertionFailure("Error: clipView is nil")
                    return
                }

                let oldOrigin = clipView.bounds.origin

                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("scrolling from: %@ in table", log: Log.StyloCore.all, type: .info, %%oldOrigin)
                #endif
                
                
                let halfHeight: CGFloat = clipView.bounds.height/2

                var y = scrollPoint.y-halfHeight
                // make sure to not scroll before origin
                y = y < 0 ? 0 : y

                let origin = NSMakePoint(oldOrigin.x, y)
                clipView.animator().setBoundsOrigin(origin)
                if oldOrigin.y != origin.y {
                    self?.scrollView.flashScrollers()
                }
            })
        }
    }
    
    private func scrollAndFlash(toFilesOutlinePosition position: FilesOutlinePosition) {

         #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
         os_log("scroll(toFilesOutlinePosition: %@)", log: Log.StyloCore.all, type: .info, %%position)
         #endif
         
         guard let textIndex = self.filesOutlineManager?.selectionIndex(of: position.textId) else {
             assertionFailure("Error: textIndex is nil")
             return
         }
         
         let rowIndex = (textIndex*2)+1
         
         #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
         os_log("scroll:toFilesOutlinePosition -> textIndex: %@", log: Log.StyloCore.all, type: .info, %%textIndex)
         os_log("scroll:toFilesOutlinePosition -> rowIndex: %@", log: Log.StyloCore.all, type: .info, %%rowIndex)
         os_log("scroll:toFilesOutlinePosition -> numberOfRows: %@", log: Log.StyloCore.all, type: .info, %%projectTextEditorsTableView.numberOfRows)
         #endif
         
         projectTextEditorsTableView.scrollRowToVisible(rowIndex)
         
         DispatchQueue.asyncOnMain { [weak self] in
             
             guard let scrollPoint = self?.scrollPoint(forFilesOutlinePosition: position) else {
                 assertionFailure("Erorr: scrollPoint is nil")
                 return
             }
             
             #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
             os_log("scroll:toFilesOutlinePosition -> scrollPoint: %@)", log: Log.StyloCore.all, type: .info, %%scrollPoint)
             #endif
             
             guard scrollPoint.y >= 0 else {
                 assertionFailure("Error: trying to scroll to a negative position: \(scrollPoint.y)")
                 return
             }
             
             #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
             os_log("scrolling to scrollPoint: %@ in table", log: Log.StyloCore.all, type: .info, %%scrollPoint)
             #endif
             self?.flashText(atFilesOutlinePosition: position)
             
             NSAnimationContext.runAnimationGroup({ (context) in
                 context.duration = 0.2
                 guard let clipView = self?.scrollView.contentView else {
                     assertionFailure("Error: clipView is nil")
                     return
                 }
                 
                 let oldOrigin = clipView.bounds.origin
                 
                 let halfHeight: CGFloat = clipView.bounds.height/2
                 
                 var y = scrollPoint.y-halfHeight
                 // make sure to not scroll before origin
                 y = y < 0 ? 0 : y
                 
                 let origin = NSMakePoint(oldOrigin.x, y)
                 clipView.animator().setBoundsOrigin(origin)
                 if oldOrigin.y != origin.y {
                     self?.scrollView.flashScrollers()
                 }
             })
         }
     }
    
    private func flashText(atFilesOutlinePosition position: FilesOutlinePosition) {
        
        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: filesOutlineManager is nil")
            return
        }
        
        guard let editorId = filesOutlineManager.editorId(forTextId: position.textId) else {
            assertionFailure("Error: editorId is nil")
            return
        }
        
        guard let sourceSetManager = self.sourceSetManager else {
            assertionFailure("Error: self.sourceSetManager is nil")
            return
        }
        
        guard let textManager = sourceSetManager.textManager(withId: position.textId) else {
            assertionFailure("Error: textManager is nil")
            return
        }
        
        guard let editorManager = textManager.editor(for: editorId) else {
            assertionFailure("Error: editorManager is nil")
            return
        }
        
        self.previouslyFocusedEditor?.removeFlash()
        editorManager.flashText(withRange: position.range)
        self.previouslyFocusedEditor = editorManager
    }
    
    private func scrollToItemContent(withId id: String) {
        
        guard let itemIndex = filesOutlineManager?.selectionIndex(of: id) else {
            assertionFailure("Error: itemIndex is nil")
            return
        }
        
        self.projectTextEditorsTableView.scrollRowToVisible((itemIndex*2)+1)
    }
    
    private func collapseEditor(withId id: String) {
        
        guard let editorItemTableCellView = editorItemsTableCellViews[id] else {
            assertionFailure("Error: editorItemTableCellView is nil")
            return
        }
        
        editorItemTableCellView.collapse()
    }
    
    private func expandEditor(withId id: String) {
        
        guard let editorItemTableCellView = editorItemsTableCellViews[id] else {
            assertionFailure("Error: editorItemTableCellView is nil")
            return
        }
        
        editorItemTableCellView.expand()
    }
    
    func unsubscribe(fromFilesOutlineManager filesOutlineManager: FilesOutlineManager?) {
        
        filesOutlineManager?.filesOutlineDesiredScrollPosition.unsubscribe(observer: self)
        filesOutlineManager?.selectedTextItems.unsubscribe(observer: self)
        filesOutlineManager?.scrolledItemId.unsubscribe(observer: self)
        filesOutlineManager?.historyBackEnabled.unsubscribe(observer: self)
        filesOutlineManager?.historyForwardEnabled.unsubscribe(observer: self)
        filesOutlineManager?.styleAssemblyDescriptor.unsubscribe(observer: self)
    }
    
}
