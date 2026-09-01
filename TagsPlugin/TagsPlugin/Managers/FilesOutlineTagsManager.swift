//
//  FilesOutlineTagsManager.swift
//  TagsPlugin
//
//  Created by Sebastien Hamel on 2020-06-11.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Foundation
import WriterCommon
import Common
import os

class FilesOutlineTagsManager<DiffableDataSourceType>: NSObject, Observer where DiffableDataSourceType: DiffableDataSource, DiffableDataSourceType.ItemIdentifierType == AttributeTagOutputItemValue, DiffableDataSourceType.SectionIdentifierType == AttributeTagOutputSectionValue {
    
    typealias AttributesCollectionSorting = CollectionSorting<AttributeTagOutputSectionValue, AttributeTagOutputItemValue, AttributeTagInputSection, AttributeTagInputItem, DiffableDataSourceType>
    
    typealias OccurencesNavigatorType = OccurencesNavigator<OutputItemOccurence<AttributeTagOutputItemValue>>
    
    var priority: ObserverPriority {
        return .background
    }
    
    let selectionNotEmpty = Dynamic<Bool>(true)
    
    let valuesNotEmpty = Dynamic<Bool>(true)
    
    var allValuesSelected: Bool {

        guard let actualCollectionSorting = self.actualCollectionSorting.value else {
            assertionFailure("Error: self.actualCollectionSorting.value is nil")
            return true
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("self.selectionIndexPaths.values.count: %@", log: Log.Tags.all, type: .info, %%self.selectionIndexPaths.values.count)
        os_log("actualCollectionSorting.outputItemsCount: %@", log: Log.Tags.all, type: .info, %%actualCollectionSorting.outputItemsCount)
        #endif
        
        return self.selectionIndexPaths.values.count == actualCollectionSorting.outputItemsCount
    }
    
    let attributesMode = Dynamic<AttributesSortingMode>(.values)
    
    let filterString = Dynamic<String?>(nil)
    
    let selectionIndexPaths = DynamicSet<IndexPath>()
    
    ///
    /// Contains the tags displayed in the tags collection view.
    ///
    /// Note: This collection does not contain the updated
    /// text positions.
    ///
    let actualCollectionSorting = Dynamic<AttributesCollectionSorting?>(nil)
    
    ///
    /// This value always contains the latest tags collection
    /// with the updated text positions.
    ///
    let completeCollectionSorting = Dynamic<AttributesCollectionSorting?>(nil)
    
    let valuesCount = Dynamic<Int>(0)
    
    var orderedValuesOccurences: [OutputItemOccurence<AttributeTagOutputItemValue>]?
    
    var occurencesNavigator: OccurencesNavigatorType?
    
    var dataSource: DiffableDataSourceType?
    
    let filesOutlineManager: FilesOutlineManager
    
    var scrolledOutputItems = Dynamic<[AttributeTagOutputItemValue]?>(nil)
    
    public var currentFilesOutlinePosition: FilesOutlinePosition? {
       
        return filesOutlineManager.currentFilesOutlinePosition
    }
    
    private let tagsUpdateSerialQueue = DispatchQueue(label: "tagsUpdateSerialQueue")
    
    private var filterTimer: Timer?
    
    init(filesOutlineManager: FilesOutlineManager) {
        
        self.filesOutlineManager = filesOutlineManager
        super.init()
        subscribeToFilesOutlineManager()
    }
    
    func selectAllTags() {
        
        guard let actualCollectionSorting = self.actualCollectionSorting.value else {
            assertionFailure("Error: actualCollectionSorting is nil")
            return
        }
        
        let selectedIndexPaths = actualCollectionSorting.allIindexPaths
        #if DEBUG && DEBUG_LOGS_ENABLED
        for selectedIndexPath in selectedIndexPaths {
            debugPrint("section: \(selectedIndexPath.section), item: \(selectedIndexPath.item)")
        }
        #endif
        self.selectionIndexPaths.removeAll(notify: false)
        self.selectionIndexPaths.insert(selectedIndexPaths)
        self.updateTextsOutputItemValueOccurences(usingIndexPaths: self.selectionIndexPaths.values)
        self.updateFilesOutlineStyleAssembly(usingSelectedIndexPaths: self.selectionIndexPaths.values)
    }
    
    func unselectAllTags() {
        
        self.selectionIndexPaths.removeAll()
        self.updateTextsOutputItemValueOccurences(usingIndexPaths: self.selectionIndexPaths.values)
        self.updateFilesOutlineStyleAssembly(usingSelectedIndexPaths: self.selectionIndexPaths.values)
    }
    
    func scrollToPreviousTag() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("scrollToPreviousTag()", log: Log.Tags.all, type: .info)
        #endif
        
        let filesOutlineCurrentPosition = self.currentFilesOutlinePosition
        self.occurencesNavigator?.updateUserSelectedPosition(withPosition: filesOutlineCurrentPosition)
        guard let previousOccurence = self.occurencesNavigator?.previous() as? OutputItemOccurence<AttributeTagOutputItemValue> else {
            assertionFailure("Error: previousOccurence is nil")
            return
        }
        
        self.scrolledOutputItems.setValue(previousOccurence.outputItems)
        
        let filesOutlinePosition = FilesOutlinePosition(textId: previousOccurence.textId, range: previousOccurence.range)
        let filesOutlineScrollPosition = FilesOutlineScrollPosition(position: filesOutlinePosition, flash: true)
        filesOutlineManager.filesOutlineDesiredScrollPosition.setValue(filesOutlineScrollPosition)
    }
    
    func scrollToNextTag() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("scrollToNextTag()", log: Log.Tags.all, type: .info)
        #endif
        
        let filesOutlineCurrentPosition = self.currentFilesOutlinePosition
        self.occurencesNavigator?.updateUserSelectedPosition(withPosition: filesOutlineCurrentPosition)
        guard let nextOccurence = self.occurencesNavigator?.next() as? OutputItemOccurence<AttributeTagOutputItemValue> else {
            assertionFailure("Error: previousOccurence is nil")
            return
        }
        
        self.scrolledOutputItems.setValue(nextOccurence.outputItems)
        
        let filesOutlinePosition = FilesOutlinePosition(textId: nextOccurence.textId, range: nextOccurence.range)
        let filesOutlineScrollPosition = FilesOutlineScrollPosition(position: filesOutlinePosition, flash: true)
        filesOutlineManager.filesOutlineDesiredScrollPosition.setValue(filesOutlineScrollPosition)
    }
    
    
    func updateFilterString(to filterString: String?) {
        
        self.filterString.setValue(filterString)
        scheduleTagsFiltering()
    }
    
    ///
    /// This method is called from the screen to set the slection index paths.
    ///
    func updateSelectionIndexPaths(_ selectedIndexPaths: Set<IndexPath>) {
        
        self.selectionIndexPaths.removeAll(notify: false)
        self.selectionIndexPaths.insert(selectedIndexPaths, notify: false)
        
        self.updateTextsOutputItemValueOccurences(usingIndexPaths: selectedIndexPaths)
        self.updateFilesOutlineStyleAssembly(usingSelectedIndexPaths: selectedIndexPaths)
    }
    
    private func updateFilesOutlineStyleAssembly(usingSelectedIndexPaths selectedIndexPaths: Set<IndexPath>) {
        
        if selectedIndexPaths.isEmpty {
            self.requestResetHighlight()
        }
        else {
            let selectorsArray: [String] = buildSelectors(fromSelectedIndexPaths: selectedIndexPaths)
            self.setHighlightStyleAssembly(withSelectors: selectorsArray)
        }
    }
    
    ///
    /// This method take as input the selected index paths in the collection view
    /// and build an array of selectors from it.
    ///
    ///
    private func buildSelectors(fromSelectedIndexPaths selectedIndexPaths: Set<IndexPath>) -> [String] {
        
        // take a copy of the current sorting
        guard let filesOutlineAttributesSorting = self.actualCollectionSorting.value else {
            assertionFailure("Error: self.filesOutlineAttributesSorting is nil")
            return []
        }
        return filesOutlineAttributesSorting.buildSelectors(fromSelectedIndexPaths: selectedIndexPaths)
    }
    
    ///
    /// This method wait for a defined time interval before reseting
    /// the highlight appesarance since selectedIndexPaths can be empty
    /// when we are in the transition to selecting another item. The delay
    /// allows for the selection to take place if any before actually
    /// calling resetHighlight() on the FilesOutlineManager.
    ///
    private func requestResetHighlight() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(10)) { [weak self] in
            if self?.selectionIndexPaths.values.isEmpty == true {
                self?.resetHighlight()
            }
        }
    }
    
    private func scheduleTagsFiltering() {
        
        self.filterTimer?.invalidate()
        self.filterTimer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false, block: { [weak self](_) in
            if let completeCollectionSorting = self?.completeCollectionSorting.value {
                self?.updateFilesOutlineAttributes(toAtributesSorting: completeCollectionSorting)
            }
        })
    }
    
    func resetHighlight() {
        
        self.filesOutlineManager.resetHighlight()
    }
    
    ///
    /// Method that assign the style highlight style assembly selector to all
    /// associated text managers's editors using the selectors strings array.
    ///
    public func setHighlightStyleAssembly(withSelectors selectors: [String]) {
        
        self.filesOutlineManager.setHighlightStyleAssembly(withSelectors: selectors)
    }
    
    func setValuesSortingMode() {
        
        let tokenAttributes = filesOutlineManager.textManagersTokenAttributes.values
        let filesOutlineAttributesSorting = AttributesCollectionSorting(attributesSortingMode: .values, tokenAttributes: tokenAttributes)
        
        self.completeCollectionSorting.setValue(filesOutlineAttributesSorting)
        self.updateFilesOutlineAttributes(toAtributesSorting: filesOutlineAttributesSorting)
        
        // we need to do it at the end since updateFilesOutlineAttributes uses it to know
        // if there was change
        self.attributesMode.setValue(.values)
    }
    
    func setAttributesSortingMode() {

        let tokenAttributes = filesOutlineManager.textManagersTokenAttributes.values
        let filesOutlineAttributesSorting = AttributesCollectionSorting(attributesSortingMode: .attributes, tokenAttributes: tokenAttributes)
        
        self.completeCollectionSorting.setValue(filesOutlineAttributesSorting)
        self.updateFilesOutlineAttributes(toAtributesSorting: filesOutlineAttributesSorting)
        
        // we need to do it at the end since updateFilesOutlineAttributes uses it to know
        // if there was change
        self.attributesMode.setValue(.attributes)
    }
    
    func reloadDataSource(_ dataSource: DiffableDataSourceType) {
        
        self.dataSource = dataSource
        
        guard let actualCollectionSorting = self.actualCollectionSorting.value else {
            // it's possible to be nil if we have nothing.
            return
        }

        guard let snapshot = actualCollectionSorting.completeSnapshot() else {
            assertionFailure("Error: snapshot is nil")
            return
        }
        
        dataSource.apply(snapshot, animatingDifferences: false, completion: nil)
    }
    
    private func subscribeToFilesOutlineManager() {
        
        let tokenAttributes = filesOutlineManager.textManagersTokenAttributes.values
        
        let filesOutlineAttributesSorting = AttributesCollectionSorting(attributesSortingMode: self.attributesMode.value, tokenAttributes: tokenAttributes)
        
        self.completeCollectionSorting.setValue(filesOutlineAttributesSorting)
        
        self.initFilesOutlineAttributes(toAtributesSorting: filesOutlineAttributesSorting)
        filesOutlineManager.textManagersTokenAttributes.subscribe({ [weak self](change) in
            self?.handleFilesOutlineAttributesChange(change.udpatedValues)
        }, observer: self)
    }
    
    // Dynamic<[AttributeTagInputSection : Set<AttributeTagInputItem>]?>(nil)
    private func handleFilesOutlineAttributesChange(_ tokenAttributes: [TextId: [AttributeTagInputSection : Set<AttributeTagInputItem>]]) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("handleFilesOutlineAttributesChange(%@)", log: Log.Tags.all, type: .info, %%tokenAttributes)
        #endif
        
        let filesOutlineAttributesSorting = AttributesCollectionSorting(attributesSortingMode: self.attributesMode.value, tokenAttributes: tokenAttributes)
        
        self.completeCollectionSorting.setValue(filesOutlineAttributesSorting)
        self.updateFilesOutlineAttributes(toAtributesSorting: filesOutlineAttributesSorting)
    }
    
    private func initFilesOutlineAttributes(toAtributesSorting filesOutlineAttributesSorting: AttributesCollectionSorting) {
        
        let selectionIndexPaths = self.selectionIndexPaths.values
        let actualCollectionSorting = self.actualCollectionSorting.value
        let attributesSortingMode = self.attributesMode.value
        let filterString = self.filterString.value
        
        self.tagsUpdateSerialQueue.async { [weak self] in
            
            let filteredFilesOutlineAttributesSorting = AttributesCollectionSorting.filtered(tokenAttributes: filesOutlineAttributesSorting.tokenAttributes, withString: filterString, attributesSortingMode: attributesSortingMode)
            
            self?.initFilesOutlineAttributes(toAtributesSorting: filteredFilesOutlineAttributesSorting, selectionIndexPaths: selectionIndexPaths, actualCollectionSorting: actualCollectionSorting)
        }
    }
    
    private func initFilesOutlineAttributes(toAtributesSorting filesOutlineAttributesSorting: AttributesCollectionSorting, selectionIndexPaths: Set<IndexPath>, actualCollectionSorting: AttributesCollectionSorting?) {
        
        assert(!Thread.isMainThread)
        var filesOutlineAttributesSorting = filesOutlineAttributesSorting
        
        let valuesCount = filesOutlineAttributesSorting.valuesCount
        self.valuesCount.setValue(valuesCount)
        
        filesOutlineAttributesSorting.update()
        guard let snapshot = filesOutlineAttributesSorting.completeSnapshot() else {
            assertionFailure("Error: snapshot is nil")
            return
        }
        
        let targetIndexPaths = self.actualCollectionSorting.value?.correspondingSelectionIndexPaths(selectionIndexPaths, inCollectionSorting: filesOutlineAttributesSorting)
        
        let targetSelectionIndexPaths: Set<IndexPath> = targetIndexPaths ?? selectionIndexPaths
        
        DispatchQueue.main.sync { [weak self] in
            self?.actualCollectionSorting.setValue(filesOutlineAttributesSorting, sameExecutionStack: true)
            self?.dataSource?.apply(snapshot, animatingDifferences: false, completion: nil)
            self?.selectionIndexPaths.insert(targetSelectionIndexPaths)
            self?.updateTextsOutputItemValueOccurences(usingIndexPaths: targetSelectionIndexPaths)
        }
    }
    
    private func updateFilesOutlineAttributes(toAtributesSorting filesOutlineAttributesSorting: AttributesCollectionSorting) {
        
        assert(Thread.isMainThread)
        let filterString = self.filterString.value
        // if we have deleted the unique value in the collection and this value was selected
        // self.selectionIndexPaths will return this selection which we wont find in the CollectionSorting.
        let selectionIndexPaths = filesOutlineAttributesSorting.valuesCount != 0 ? self.selectionIndexPaths.values : Set<IndexPath>()
        let previousAttributesSortingMode = self.attributesMode.value
        let actualCollectionSorting = self.actualCollectionSorting.value
        
        self.tagsUpdateSerialQueue.async { [weak self] in
            
            let filesOutlineAttributesSorting = AttributesCollectionSorting.filtered(tokenAttributes: filesOutlineAttributesSorting.tokenAttributes, withString: filterString, attributesSortingMode: filesOutlineAttributesSorting.attributesSortingMode)
            
            self?.updateFilesOutlineAttributes(toAtributesSorting: filesOutlineAttributesSorting, selectionIndexPaths: selectionIndexPaths, actualCollectionSorting: actualCollectionSorting, previousAttributesSortingMode: previousAttributesSortingMode)
        }
    }
    
    private func updateFilesOutlineAttributes(toAtributesSorting filesOutlineAttributesSorting: AttributesCollectionSorting, selectionIndexPaths: Set<IndexPath>, actualCollectionSorting: AttributesCollectionSorting?, previousAttributesSortingMode: AttributesSortingMode) {
        
        guard !filesOutlineAttributesSorting.equalsIgnoringPositions(to: actualCollectionSorting) || previousAttributesSortingMode != filesOutlineAttributesSorting.attributesSortingMode else {
            
            var filesOutlineAttributesSorting = filesOutlineAttributesSorting
            filesOutlineAttributesSorting.update()
            // we do this only to update the positions, no need to update
            // the displayed collection view
            self.actualCollectionSorting.setValue(filesOutlineAttributesSorting)
            self.updateTextsOutputItemValueOccurences(usingIndexPaths: selectionIndexPaths)
            return
        }
        
        assert(!Thread.isMainThread)
        let newValuesCount = filesOutlineAttributesSorting.valuesCount
        
        var filesOutlineAttributesSorting = filesOutlineAttributesSorting
        
        // returning from empty selection
        if valuesCount.value == 0 && newValuesCount != 0 {
            
            self.valuesCount.setValue(newValuesCount)
            self.initFilesOutlineAttributes(toAtributesSorting: filesOutlineAttributesSorting, selectionIndexPaths: Set<IndexPath>(), actualCollectionSorting: actualCollectionSorting)
        }
        else {
            
            self.valuesCount.setValue(newValuesCount)
            
            if let dataSource = self.dataSource {
                
                var snapshot = dataSource.snapshot()
                
                filesOutlineAttributesSorting.update(withSnapshot: &snapshot, from: actualCollectionSorting) { [weak self](state, snapshot, allowAnimation) in
                    DispatchQueue.main.sync { [weak self] in
                        self?.actualCollectionSorting.setValue(state, sameExecutionStack: true)
                        dataSource.apply(snapshot, animatingDifferences: allowAnimation, completion: nil)
                    }
                }
            }
            else {
                
                filesOutlineAttributesSorting.update(from: actualCollectionSorting)
                self.actualCollectionSorting.setValue(filesOutlineAttributesSorting)
            }
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("current selectionIndexPaths: %@", log: Log.Tags.all, type: .info, %%selectionIndexPaths)
            #endif
            
            // might be nil if no collection is displayed
            let targetIndexPaths = actualCollectionSorting?.correspondingSelectionIndexPaths(selectionIndexPaths, inCollectionSorting: filesOutlineAttributesSorting)
            
            let targetSelectionIndexPaths: Set<IndexPath> = targetIndexPaths ?? selectionIndexPaths
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("current targetSelectionIndexPaths: %@", log: Log.Tags.all, type: .info, %%targetSelectionIndexPaths)
            #endif
            
            self.selectionIndexPaths.removeAll()
            self.selectionIndexPaths.insert(targetSelectionIndexPaths)
            
            self.updateTextsOutputItemValueOccurences(usingIndexPaths: targetSelectionIndexPaths)
            
            // update the style assembly only if the final selected values
            // are different
            let oldSelectedItemsValues = actualCollectionSorting?.selectedItemsValues(fromIndexPaths: selectionIndexPaths)
            let targetSelectedItemsValues = filesOutlineAttributesSorting.selectedItemsValues(fromIndexPaths: targetSelectionIndexPaths)
            
            if oldSelectedItemsValues != targetSelectedItemsValues {
                self.updateFilesOutlineStyleAssembly(usingSelectedIndexPaths: targetSelectionIndexPaths)
            }
        }
    }
    
    func unsubscribedToFilesOutlineManager() {
        
        filesOutlineManager.textManagersTokenAttributes.unsubscribe(observer: self)
    }
    
    ///
    /// This method use the indexPaths and the displayed collection sorting
    /// to compute the selected index paths in the completeCollectionSorting which
    /// contains the updated text positions and then use these values to
    /// create a new OccurencesNavigator.
    ///
    /// orderedTextsOutputItemValueOccurences(fromIndexPaths indexPaths: Set<IndexPath>) ->  [TextId: [OutputItemOccurence<OutputItem>]]
    func updateTextsOutputItemValueOccurences(usingIndexPaths indexPaths: Set<IndexPath>) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("updateTextsOutputItemValueOccurences(usingIndexPaths: %@)", log: Log.Tags.all, type: .info, %%indexPaths)
        #endif
        
        DispatchQueue.asyncOnMain { [weak self] in
            
            self?.selectionNotEmpty.setValue(!indexPaths.isEmpty)
                
            guard !indexPaths.isEmpty else {
                self?.orderedValuesOccurences = nil
                return
            }
            
            guard let actualCollectionSorting = self?.actualCollectionSorting.value else {
                assertionFailure("Error: self.actualCollectionSorting is nil")
                return
            }
            
            assert(self?.completeCollectionSorting.value != nil)
            if self?.completeCollectionSorting.value?.coalescedAttributes == nil {
                self?.completeCollectionSorting.value?.update()
            }
            
            guard let completeCollectionSorting = self?.completeCollectionSorting.value else {
                assertionFailure("Error: self?.completeCollectionSorting is nil")
                return
            }
            
            // might be nil if no collection is displayed
            let targetIndexPaths = actualCollectionSorting.correspondingSelectionIndexPaths(indexPaths, inCollectionSorting: completeCollectionSorting)
            
            guard let filesOutlineManager = self?.filesOutlineManager else {
                assertionFailure("Error: filesOutlineManager is nil")
                return
            }
            
            self?.tagsUpdateSerialQueue.async { [weak self] in
                
                guard let textValuesOccurences: [TextId: [OutputItemOccurence<AttributeTagOutputItemValue>]] =  completeCollectionSorting.orderedTextsOutputItemValueOccurences(fromIndexPaths: targetIndexPaths) else {
                    assertionFailure("Error: textValuesOccurences is nil")
                    return
                }
                
                var orderedValuesOccurences: [OutputItemOccurence<AttributeTagOutputItemValue>] = []
                for selectedTextItemId in filesOutlineManager.selectedTextItems {
                    if let valuesOccurences = textValuesOccurences[selectedTextItemId] {
                        orderedValuesOccurences.append(contentsOf: valuesOccurences)
                    }
                }
                
                var orderedValuesOccurencesWithoutDuplicates: [OutputItemOccurence<AttributeTagOutputItemValue>] = []
                var lastAddedOccurence: OutputItemOccurence<AttributeTagOutputItemValue>?
                for orderedValueOccurence in orderedValuesOccurences {
                    if let _lastAddedOccurence = lastAddedOccurence {
                        
                        if !_lastAddedOccurence.sameLocation(as: orderedValueOccurence) {
                            orderedValuesOccurencesWithoutDuplicates.append(orderedValueOccurence)
                            lastAddedOccurence = orderedValueOccurence
                        }
                    }
                    else {
                        orderedValuesOccurencesWithoutDuplicates.append(orderedValueOccurence)
                        lastAddedOccurence = orderedValueOccurence
                    }
                }
                
                DispatchQueue.asyncOnMain { [weak self] in
                    
                    self?.orderedValuesOccurences = orderedValuesOccurencesWithoutDuplicates
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("updateTextsOutputItemValueOccurences -> orderedValuesOccurences: %@", log: Log.Tags.all, type: .info, %%orderedValuesOccurences)
                    #endif
                    
                    self?.occurencesNavigator = OccurencesNavigatorType(occurences: orderedValuesOccurencesWithoutDuplicates, orderedTextIds: filesOutlineManager.selectedItemsArray)
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("updateTextsOutputItemValueOccurences -> occurencesNavigator: %@", log: Log.Tags.all, type: .info, %%self?.occurencesNavigator)
                    #endif
                }
            }
        }
    }
}
