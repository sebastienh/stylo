//
//  CollectionSorting+DiffableDataSource.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-06-11.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Common
import Cocoa
import os

extension CollectionSorting where
    OutputSection == AttributeTagOutputSectionValue,
    OutputItem == AttributeTagOutputItemValue,
    InputSection == AttributeTagInputSection,
    InputItem == AttributeTagInputItem {
    
    public typealias AllowsAnimations = Bool
    public typealias CollectionUpdateClosure = (CollectionSorting, DiffableDataSourceType.DiffableDataSourceSnapshotType, AllowsAnimations) -> ()
    
    public func completeSnapshot() -> DiffableDataSourceType.DiffableDataSourceSnapshotType? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("completeSnapshot with: %@", log: Log.WriterCommon.all, type: .info, %%self)
        #endif
    
        guard !self.sections.isEmpty else {
            assertionFailure("Error: sections are empty")
            return nil 
        }
        
        var snapshot = DiffableDataSourceType.DiffableDataSourceSnapshotType()
        
        for (sectionIndex, section) in self.sections.enumerated() {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Append section: %@", log: Log.Tags.all, type: .info, %%section.stringValue)
            #endif
            
            snapshot.appendSections([section])
            
            let values = self.sectionsValues[sectionIndex]
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            let valuesString = values.reduce("") { (result, item) -> String in
                return result + " , " + item.stringValue
            }
            os_log("Append values: %@", log: Log.WriterCommon.all, type: .info, %%valuesString)
            #endif
            
            snapshot.appendItems(values, toSection: section)
            assert(snapshot.numberOfItems(inSection: section) == values.count)
        }
        
        assert(snapshot.numberOfSections == self.sections.count)
        return snapshot
    }
    
    @discardableResult
    public mutating func update(withSnapshot snapshot: inout DiffableDataSourceType.DiffableDataSourceSnapshotType, from collectionSorting: CollectionSorting? = nil, closure: CollectionUpdateClosure?) -> [Change] {
        
        self.sections = collectionSorting?.sections ?? [OutputSection]()
        self.sectionsValues = collectionSorting?.sectionsValues ?? [[OutputItem]]()

        let coalescedAttributes = sortedTokensAttributes()
        self.coalescedAttributes = coalescedAttributes
        switch self.attributesSortingMode {
        case .attributes:
            return self.updateToAttributes(withSnapshot: &snapshot, using: coalescedAttributes, closure: closure)
        case .values:
            return self.updateToValues(withSnapshot: &snapshot, using: coalescedAttributes, closure: closure)
        }
    }
    
    ///
    /// This method is used to update:
    ///
    /// private var sections = OrderedSet<SectionType>()
    /// private var sectionsValues: [[ItemType]] = []
    ///
    /// using the computed coalescedAttributes when in .attributes
    /// mode.
    ///
    private mutating func updateToAttributes(withSnapshot snapshot: inout DiffableDataSourceType.DiffableDataSourceSnapshotType, using coalescedAttributes: OrderedDictionary<OutputSection, [OutputItem]>, closure: CollectionUpdateClosure?) -> [Change] {
        
        var changes: [Change] = []
        
        // take care of the sections
        
        let nonEmptyAttributes = coalescedAttributes.filter { (arg0) -> Bool in
            let (_, value) = arg0
            return !value.isEmpty
        }
        
        let keys: [OutputSection] = nonEmptyAttributes.map { (arg) -> OutputSection in
            // (key: SectionType, value: [ItemType]) = arg
            return arg.key
        }
        
        let editOperations = self.sections.editOperations(to: keys)
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        for editOperation in editOperations {
            debugPrint("section edit: \(editOperation.debugDescription)")
        }
        #endif
        
        let sectionsChanges = self.applySectionsEditOperations(editOperations, toSnapshot: &snapshot, closure: closure)
        changes.append(contentsOf: sectionsChanges)
        
        // take care of all the attributes values
        // the end result populates sectionsValues: [[ItemType]]
        assert(self.sectionsValues.count == self.sections.count)
        for (index, (_, sectionTargetValues)) in nonEmptyAttributes.enumerated() {
            
            let sectionActualValues = self.sectionsValues[index]
            let editOperations = sectionActualValues.editOperations(to: sectionTargetValues)
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            for editOperation in editOperations {
                debugPrint("section value edit: \(editOperation.debugDescription) in section: \(index)")
            }
            #endif
            
            let sectionValuesChanges = self.applySectionValuesEditOperations(editOperations, inSection: index, andSnapshot: &snapshot, closure: closure)
            changes.append(contentsOf: sectionValuesChanges)
        }
        
        return changes
    }
    
    ///
    /// This method is used to update:
    ///
    /// private var values = [ItemType]()
    ///
    /// using the computed coalescedAttributes when in .values
    /// mode.
    ///
    private mutating func updateToValues(withSnapshot snapshot: inout DiffableDataSourceType.DiffableDataSourceSnapshotType, using coalescedAttributes: OrderedDictionary<OutputSection, [OutputItem]>, closure: CollectionUpdateClosure?) -> [Change] {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Before update to values: %@", log: Log.Tags.all, type: .info, %%self.debugDescription)
        #endif
        
        assert(self.coalescedAttributes != nil)
        self.valuesToNames = self.buildValuesToAttributeNamesMapping(fromCoalescedAttributes: coalescedAttributes)
        
        // we will do all the calculations in the background
        // thread but we should always update the Dynamic values
        // on the main thread
        var changes: [Change] = []
        
        let sectionEditOperations = self.sections.editOperations(to: [OutputSection(string: "Values")])
        
        #if DEBUG
        for sectionEditOperation in sectionEditOperations {
            debugPrint("section edit: \(sectionEditOperation.debugDescription)")
        }
        #endif
        
        let sectionsChanges = self.applySectionsEditOperations(sectionEditOperations, toSnapshot: &snapshot, closure: closure)
        changes.append(contentsOf: sectionsChanges)
        
        assert(self.sections.count == 1)
        assert(self.sectionsValues.count == 1)
        
        // merge all the output items with the same name
        
        typealias AttributeValue = String
        
        let items: [OutputItem] = coalescedAttributes.flatMap { (arg) -> [OutputItem] in
            let values: (key: OutputSection, value: [OutputItem]) = arg
            return Array<OutputItem>(values.value)
        }
        
        var values: [AttributeValue: [OutputItem]] = [:]
        
        for item in items {
            if values[item.stringValue] == nil {
                values[item.stringValue] = []
            }
            assert(values[item.stringValue] != nil)
            values[item.stringValue]?.append(item)
        }
        
        var coallescedValues: [AttributeValue: OutputItem] = [:]
        for (attributeValue, outputItems) in values {
            coallescedValues[attributeValue] = OutputItem.from(outputItems: outputItems)
        }

        let newValues = coallescedValues.values.sorted { (item1, item2) -> Bool in
            return item1 < item2
        }
        
        let previousFirstSectionValues: [OutputItem] = self.sectionsValues.first ?? [OutputItem]()
        
        let valuesEditOperations = previousFirstSectionValues.editOperations(to: newValues)
        
        #if DEBUG
        for valuesEditOperation in valuesEditOperations {
            debugPrint("value edit: \(valuesEditOperation.debugDescription)")
        }
        #endif
        
        let sectionValuesChanges = self.applySectionValuesEditOperations(valuesEditOperations, inSection: 0, andSnapshot: &snapshot, closure: closure)
        changes.append(contentsOf: sectionValuesChanges)
        return changes
    }
    
    private mutating func applySectionsEditOperations(_ edits: [ArrayEdit<OutputSection>], toSnapshot snapshot: inout DiffableDataSourceType.DiffableDataSourceSnapshotType, closure: CollectionUpdateClosure?) -> [Change] {
        
        guard !edits.isEmpty else {
            return []
        }
        
        var factor = 0
        
        var changes: [Change] = []
        
        // delete pass
        for edit in edits {
            switch edit {
            case .delete(let index):
                let sectionToRemove = self.sections.remove(at: index+factor)
                snapshot.deleteSections([sectionToRemove])
                self.sectionsValues.remove(at: index+factor)
                //            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                debugPrint("applying section edit remove at index: \(index+factor) with value: \(sectionToRemove.stringValue)")
                //            #endif
                
                closure?(self, snapshot, false)
                let indexSet = IndexSet(arrayLiteral: index+factor)
                changes.append(.deleteSections(indexes: indexSet))
                factor -= 1
            default:
                break
            }
        }
        
        factor = 0
        
        // addition pass
        for edit in edits {
            switch edit {
            case .add(let index, let value):
                insertSection(value, atSectionIndex: index+factor, inSnapshot: &snapshot)
                self.sections.insert(value, at: index+factor)
                self.sectionsValues.insert([OutputItem](), at: index+factor)
                //            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                debugPrint("applying section edit insert at index: \(index+factor) with value: \(value.stringValue)")
                //            #endif
                closure?(self, snapshot, true)
                let indexSet = IndexSet(arrayLiteral: index+factor)
                changes.append(.insertSections(indexes: indexSet))
                factor += 1
            case .delete:
                factor -= 1
            case .replace(let index, let value):
                
                let sectionToRemove = self.sections[index+factor]
                snapshot.deleteSections([sectionToRemove])
                self.sections[index+factor] = value
                insertSection(value, atSectionIndex: index+factor, inSnapshot: &snapshot)
                closure?(self, snapshot, false)
                let indexSet = IndexSet(arrayLiteral: index+factor)
                changes.append(.updateSections(indexes: indexSet))
            }
        }
        
        return changes
    }
    
    private mutating func applySectionValuesEditOperations(_ edits: [ArrayEdit<OutputItem>], inSection sectionIndex: Int, andSnapshot snapshot: inout DiffableDataSourceType.DiffableDataSourceSnapshotType, closure: CollectionUpdateClosure?) -> [Change] {
        
        guard !edits.isEmpty else {
            return []
        }
        
        var changes: [Change] = []
       
        var factor = 0
        
        // delete pass
        for edit in edits {
            switch edit {
            case .delete(let index):
                let sectionValueToRemove = self.sectionsValues[sectionIndex].remove(at: index+factor)
                snapshot.deleteItems([sectionValueToRemove])
                //            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                debugPrint("applying section value edit delete at index: \(index+factor) value: \(sectionValueToRemove.stringValue)")
                //            #endif
                let indexPath = IndexPath(item: index+factor, section: sectionIndex)
                changes.append(.deleteItems(indexes: Set<IndexPath>([indexPath])))
                factor -= 1
            default:
                break
            }
        }
        
        factor = 0

        // addition pass
        for edit in edits {
            switch edit {
            case .add(let index, let value):
                
                // update datasource
                insertValue(value, atSectionIndex: sectionIndex, andItemIndex: index+factor, inSnapshot: &snapshot)
                self.sectionsValues[sectionIndex].insert(value, at: index+factor)
                //            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                debugPrint("applying section value edit add at index: \(index+factor) value: \(value.stringValue)")
                //            #endif
                let indexPath = IndexPath(item: index+factor, section: sectionIndex)
                changes.append(.insertsItem(indexes: Set<IndexPath>([indexPath])))
                factor += 1
            case .delete:
                factor -= 1
            case .replace(let index, let value):
                
                assert(false, "This code is not supported and buggy, leaving here as a receipe if needed in the future.")
                let replacedValue = self.sectionsValues[sectionIndex][index+factor]
                
                // update datasource
                snapshot.deleteItems([replacedValue])
                self.sectionsValues[sectionIndex][index+factor] = value
                
                // update datasource
                let indexPath = IndexPath(item: index+factor, section: sectionIndex)
                insertValue(value, atSectionIndex: sectionIndex, andItemIndex: index+factor, inSnapshot: &snapshot)
                changes.append(.updateItems(indexes: Set<IndexPath>([indexPath])))
            }
        }
        
        // we apply the changes to each section individually
        closure?(self, snapshot, true)
        return changes
    }
    
    private func insertValue(_ value: OutputItem, atSectionIndex sectionIndex: Int, andItemIndex itemIndex: Int, inSnapshot snapshot: inout DiffableDataSourceType.DiffableDataSourceSnapshotType) {
        
        if itemIndex == 0 && !self.sectionsValues[sectionIndex].isEmpty {
            let itemAfter = self.sectionsValues[sectionIndex][itemIndex]
            
            assert(itemAfter.stringValue != value.stringValue)
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("inserting %@ before item: %@", log: Log.Tags.all, type: .info, %%value.stringValue, %%itemAfter.stringValue)
            #endif
            
            snapshot.insertItems([value], beforeItem: itemAfter)
        }
        else if itemIndex == 0 && self.sectionsValues[sectionIndex].isEmpty {
            let section = self.sections[sectionIndex]
            snapshot.appendItems([value], toSection: section)
        }
        else if itemIndex > 0 {
            let itemBefore = self.sectionsValues[sectionIndex][itemIndex-1]
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("inserting %@ after item: %@", log: Log.Tags.all, type: .info, %%value.stringValue, %%itemBefore.stringValue)
            #endif
            snapshot.insertItems([value], afterItem: itemBefore)
        }
    }
    
    private func insertSection(_ value: OutputSection, atSectionIndex sectionIndex: Int, inSnapshot snapshot: inout DiffableDataSourceType.DiffableDataSourceSnapshotType) {
        
        if sectionIndex == 0 && !self.sections.isEmpty {
            let sectionAfter = self.sections[sectionIndex]
            snapshot.insertSections([value], beforeSection: sectionAfter)
        }
        else if sectionIndex == 0 && self.sections.isEmpty {
            snapshot.appendSections([value])
        }
        else if sectionIndex > 0 {
            let sectionBefore = self.sections[sectionIndex-1]
            snapshot.insertSections([value], afterSection: sectionBefore)
        }
    }
}
