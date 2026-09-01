//
//  AttributesSorting.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-05-03.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Common

///
/// AttributesSorting class is responsible for managing
/// the attributes sorting for a single files outline. It is responsible
/// to publish the changed IndexPaths to the UI.
///
/// Since there is only one subscriber and this subscriber could
/// potentially subsribe to not more than one sorting mode
/// we maintain only one sorting mode in this class
///
public struct CollectionSorting<OutputSection, OutputItem: OutputItemType, InputSection, InputItem, DiffableDataSourceType: DiffableDataSource>: CustomDebugStringConvertible where OutputItem.S == OutputSection, OutputItem.I == InputItem, OutputSection.I == InputSection, DiffableDataSourceType.ItemIdentifierType == OutputItem, DiffableDataSourceType.SectionIdentifierType == OutputSection {
    
    public typealias AttributeName = String
    
    public enum Change {
        
        // insertions
        case insertsItem(indexes: Set<IndexPath>)
        
        // deletions
        case deleteItems(indexes: Set<IndexPath>)
        
        // move
        case moveItem(sourceIndex: IndexPath, targetIndex: IndexPath)
        
        // updates
        case updateItems(indexes: Set<IndexPath>)
        
        // section insertions
        case insertSections(indexes: IndexSet)
        
        // sections deletions
        case deleteSections(indexes: IndexSet)
        
        // updates
        case updateSections(indexes: IndexSet)
    }
    
    // type of sortedTokensAttributes:
    public var coalescedAttributes: OrderedDictionary<OutputSection, [OutputItem]>?
    
    public var sectionsCount: Int {
        
        return self.sections.count
    }
    
    public let attributesSortingMode: AttributesSortingMode
    
    public let tokenAttributes: [TextId: [InputSection : Set<InputItem>]]
    
    public var sections = [OutputSection]()
    
    public var sectionsValues: [[OutputItem]] = []
    
    public var valuesToNames: [AttributeName: [OutputSection]]?
    
    public var isEmpty: Bool {
        return self.valuesCount == 0
    }
    
    public var allIindexPaths: Set<IndexPath> {
        
        var selectedIndexPaths = Set<IndexPath>()
        
        // sectionsValues: [[OutputItem]]
        for (sectionIndex, sectionValues) in self.sectionsValues.enumerated() {
            for (itemIndex, _) in sectionValues.enumerated() {
                selectedIndexPaths.insert(IndexPath(item: itemIndex, section: sectionIndex))
            }
        }
        return selectedIndexPaths
    }
    
    public var valuesCount: Int {
        return tokenAttributes.reduce(0) { (result, inputItems) -> Int in
            inputItems.value.reduce(result) { (result, arg1) -> Int in
                let (key, value) = arg1
                return result+value.count
            }
        }
    }
    
    public var outputItemsCount: Int {
        return sectionsValues.reduce(0) { (result, outputItems) -> Int in
            return result + outputItems.count
        }
    }
    
    public var debugDescription: String {
        
        var string = ""
        for (index, section) in sections.enumerated() {
            string += section.stringValue + ": ["
            
            for (itemIndex, sectionValue) in sectionsValues[index].enumerated() {
                if itemIndex != sectionsValues[index].count-1 {
                    string += ", "
                }
                
                string += sectionValue.stringValue
            }
            string += "]\n"
        }
        return string
    }
    
    public init(attributesSortingMode: AttributesSortingMode, tokenAttributes: [TextId: [InputSection : Set<InputItem>]]) {
        
        self.attributesSortingMode = attributesSortingMode
        self.tokenAttributes = tokenAttributes
    }
    
    public static func filtered(tokenAttributes: [TextId: [InputSection : Set<InputItem>]], withString filterString: String?, attributesSortingMode: AttributesSortingMode) -> CollectionSorting {
        
        guard let filterString = filterString else {
            return CollectionSorting<OutputSection, OutputItem, InputSection, InputItem, DiffableDataSourceType>(attributesSortingMode: attributesSortingMode, tokenAttributes: tokenAttributes)
        }
        
        // we are filtering the tokenAttributes directly since update will take care
        // of the rest of the manipulations for us.
        // [TextId : [String : Set<String>]]
        
        var filteredTokenAttributes: [TextId: [InputSection : Set<InputItem>]] = [:]
        for (textId, sections) in tokenAttributes {
            filteredTokenAttributes[textId] = [:]
            for (section, values) in sections {
                filteredTokenAttributes[textId]![section] = values.filter { (value) -> Bool in
                    return value.localizedStandardContains(filterString)
                }
            }
        }
        
        let filteredCollectionSorting = CollectionSorting<OutputSection, OutputItem, InputSection, InputItem, DiffableDataSourceType>(attributesSortingMode: attributesSortingMode, tokenAttributes: filteredTokenAttributes)
        
        return filteredCollectionSorting
    }
    
    public func correspondingSelectionIndexPaths(_ selectionIndexPaths: Set<IndexPath>, inCollectionSorting targetCollectionSorting: CollectionSorting) -> Set<IndexPath> {
        // We must have a updated targetAttributesSorting to get to corresponding
        // index paths i.e. update(...) must have been called on it.
        // We use coalescedAttributes because they are always computed when updating.
        precondition(targetCollectionSorting.coalescedAttributes != nil)
        
        // in this case we need to preserve the selections index paths
        // so we need to apply the selection to the files outline current sorting
        let selectedValues = self.selectedItemsValues(fromIndexPaths: selectionIndexPaths)
        
        // apply the old selection indexes paths
        return targetCollectionSorting.indexPaths(fromSelectedValues: selectedValues, originAttributesMode: self.attributesSortingMode)
    }
    
    ///
    /// This method returns if the tokenAttributes are equals or not.
    /// Since this method use the equals from Set<InputItem> for items
    /// and that positions is not considered this method will not return
    /// false if the positions are different.
    ///
    public func equalsIgnoringPositions(to other: CollectionSorting?) -> Bool {
        
        guard let other = other else {
            return false
        }
        
        // comparing [TextId: [InputSection : Set<InputItem>]]
        guard self.tokenAttributes.count == other.tokenAttributes.count else {
            return false
        }
        
        let textIds = self.tokenAttributes.keys
        let otherTextIds = other.tokenAttributes.keys
        
        guard textIds == otherTextIds else {
            return false
        }
        
        for textId in textIds {
            
            let sections = self.tokenAttributes[textId]!.keys
            let otherSections = other.tokenAttributes[textId]!.keys
            
            guard sections.count == otherSections.count else {
                return false
            }
            
            guard sections == otherSections else {
                return false
            }
            
            for section in sections {
                
                let items = self.tokenAttributes[textId]![section]!
                let otherItems = other.tokenAttributes[textId]![section]!
                
                guard items.count == otherItems.count else {
                    return false
                }
                
                let itemStrings = items.map { (inputItem) -> String in
                    return inputItem.stringValue
                }.sorted()
                
                let otherItemStrings = otherItems.map { (inputItem) -> String in
                    return inputItem.stringValue
                }.sorted()
                
                if itemStrings != otherItemStrings {
                    return false
                }
            }
        }
        return true
    }
    
    public func selectedItemsValues(fromIndexPaths indexPaths: Set<IndexPath>) -> Set<OutputItem> {
        
        var selectedItemsValues = Set<OutputItem>()
        for indexPath in indexPaths {
            guard let item = self.item(atIndexPath: indexPath) else {
                assertionFailure("Error: item is nil")
                continue
            }
            selectedItemsValues.insert(item)
        }
        return selectedItemsValues
    }
    
    public func indexPaths(fromSelectedValues selectedValues: Set<OutputItem>, originAttributesMode: AttributesSortingMode) -> Set<IndexPath> {
        
        var selectedIndexPaths = Set<IndexPath>()
        
        
        // sectionsValues: [[OutputItem]]
        for (sectionIndex, sectionValues) in self.sectionsValues.enumerated() {
            for (itemIndex, outputItem) in sectionValues.enumerated() {
                for selectedValue in selectedValues {
                    if outputItem.stringValue == selectedValue.stringValue {
                        
                        switch originAttributesMode {
                        case .attributes:
                            switch self.attributesSortingMode {
                            case .values:
                                selectedIndexPaths.insert(IndexPath(item: itemIndex, section: sectionIndex))
                            case .attributes:
                                // in attributes mode we also need the section name to match
                                if outputItem.section.stringValue  == selectedValue.section.stringValue  {
                                    selectedIndexPaths.insert(IndexPath(item: itemIndex, section: sectionIndex))
                                }
                            }
                        case .values:
                            selectedIndexPaths.insert(IndexPath(item: itemIndex, section: sectionIndex))
                            
                        }
                    }
                }
            }
        }
        return selectedIndexPaths
    }
    
    
    public func itemsCount(inSection index: Int) -> Int {
        guard index >= 0 && index < sections.count else {
            assertionFailure("Error: index out of range")
            return 0
        }
        return self.sectionsValues[index].count
    }
    
    public func section(atIndex index: Int) -> OutputSection? {
        
        guard index >= 0 && index < sections.count else {
            assertionFailure("Error: index out of range")
            return nil
        }
        return self.sections[index]
    }
    
    public func item(atIndexPath path: IndexPath) -> OutputItem? {
        
        let sectionIndex = path.section
        let itemIndex = path.item
        
        guard sectionIndex >= 0 && sectionIndex < self.sections.count else {
            assertionFailure("Error: sectionIndex out of range")
            return nil
        }
        
        let sectionValues = self.sectionsValues[sectionIndex]
        
        guard itemIndex >= 0 && itemIndex < sectionValues.count else {
            assertionFailure("Error: itemIndex out of range")
            return nil
        }
        return sectionValues[itemIndex]
    }
    
    ///
    /// In this method we are going to compute for TextId, the ordered ranges
    /// for all output items. Some output items may be repeated but we need
    /// to keep them for further use, this will be the role of the struct
    /// "OutputItemValueOccurence" which keep a range and the OutputItem.
    ///
    /// The end result looks like:
    ///
    /// [TextId: [OutputItemValueOccurence]]
    ///
    public func orderedTextsOutputItemValueOccurences(fromIndexPaths indexPaths: Set<IndexPath>) ->  [TextId: [OutputItemOccurence<OutputItem>]]? {
        
        // Set<OutputItem>
        let selectedItemsValues = self.selectedItemsValues(fromIndexPaths: indexPaths)
        
        // [TextId: [NSRange: [OutputItem]]]
        var textOutputItems: [TextId: [NSRange: [OutputItem]]] = [:]
        for selectedItemValue in selectedItemsValues {
            for (textId, ranges) in selectedItemValue.valueOccurencesPositions {
                if textOutputItems[textId] == nil {
                    textOutputItems[textId] = [:]
                }
                
                for range in ranges {
                    if textOutputItems[textId]![range] == nil {
                        textOutputItems[textId]![range] = []
                    }
                    textOutputItems[textId]![range]?.append(selectedItemValue)
                }
            }
        }
        
        var sortedOutputItems: [TextId: OrderedDictionary<NSRange, [OutputItem]>] = [:]
        for (textId, outputItemsRanges) in textOutputItems {
            sortedOutputItems[textId] = outputItemsRanges.sorted(by: { (first, second) -> Bool in
                let firstRange: (key: NSRange, value: [OutputItem]) = first
                let secondRange: (key: NSRange, value: [OutputItem]) = second
                return firstRange.key.location < secondRange.key.location
            })
        }
        
        var outputItemOccurences: [TextId: [OutputItemOccurence<OutputItem>]] = [:]
        
        for (textId, occurences) in sortedOutputItems {
            assert(outputItemOccurences[textId] == nil)
            outputItemOccurences[textId] = occurences.map { (arg) -> OutputItemOccurence<OutputItem> in
                let (key, value) = arg
                return OutputItemOccurence<OutputItem>(textId: textId, range: key, outputItems: value)
            }
        }
        
        return outputItemOccurences
    }
    
    @discardableResult
    public mutating func update(from filesOutlineAttributesSorting: CollectionSorting? = nil) -> [Change] {
        
        self.sections = filesOutlineAttributesSorting?.sections ?? [OutputSection]()
        self.sectionsValues = filesOutlineAttributesSorting?.sectionsValues ?? [[OutputItem]]()
        
        let coalescedAttributes = sortedTokensAttributes()
        self.coalescedAttributes = coalescedAttributes
        switch self.attributesSortingMode {
        case .attributes:
            return self.updateToAttributes(using: coalescedAttributes)
        case .values:
            return self.updateToValues(using: coalescedAttributes)
        }
    }
    
    public func buildSelectors(fromSelectedIndexPaths selectedIndexPaths: Set<IndexPath>) -> [String] {
        
        guard let coalescedAttributes: OrderedDictionary<OutputSection, [OutputItem]> = self.coalescedAttributes else {
            assertionFailure("Error: self.coalescedAttributes is nil")
            return []
        }
        
        let selectedAttributes: [OutputSection: [OutputItem]] = self.collectedSelectedAttributes(fromSelectedIndexPaths: selectedIndexPaths)
        
        var selectors: [String] = []
        
        for (attributeName, attributeValues) in selectedAttributes {
            
            guard let coalescedAttributesValues = coalescedAttributes[attributeName] else {
                assertionFailure("Error: coalescedAttributes[\(attributeName)] is nil")
                continue
            }
            
            // if the user selected all attributes
            if coalescedAttributesValues.count == attributeValues.count {
                if attributeName.stringValue == "class" {
                    for attributeValue in attributeValues {
                        selectors.append(".\(attributeValue.stringValue)")
                    }
                }
                else if attributeName.stringValue == "id" {
                    for attributeValue in attributeValues {
                        selectors.append("#\(attributeValue.stringValue)")
                    }
                }
                else {
                    let selectorString = "[\(attributeName.stringValue)]"
                    selectors.append(selectorString)
                }
            }
            else {
                if attributeName.stringValue == "class" {
                    for attributeValue in attributeValues {
                        selectors.append(".\(attributeValue.stringValue)")
                    }
                }
                else if attributeName.stringValue == "id" {
                    for attributeValue in attributeValues {
                        selectors.append("#\(attributeValue.stringValue)")
                    }
                }
                else {
                    for attributeValue in attributeValues {
                        let selectorString = "\(attributeName.stringValue)=\(attributeValue.stringValue)"
                        selectors.append(selectorString)
                    }
                }
            }
        }
        
        return selectors
    }
    
    private func collectedSelectedAttributes(fromSelectedIndexPaths selectedIndexPaths: Set<IndexPath>) -> [OutputSection: [OutputItem]] {
        
        assert(self.coalescedAttributes != nil)
        
        var attributes: [OutputSection: [OutputItem]] = [:]
        
        switch self.attributesSortingMode {
        case .attributes:
            
            for selectedIndexPath in selectedIndexPaths.sorted() {
                
                guard let section = self.section(atIndex: selectedIndexPath.section) else {
                    assertionFailure("Error: section is nil")
                    continue
                }
                
                guard let item = self.item(atIndexPath: selectedIndexPath) else {
                    assertionFailure("Error: item is nil")
                    continue
                }
                
                if attributes[section] == nil {
                    attributes[section] = []
                }
                
                attributes[section]?.append(item)
            }
            
        case .values:
            
            assert(self.sectionsValues.count == 1)
            assert(self.sections.count == 1)
            guard let valuesToNames = self.valuesToNames else {
                assertionFailure("Error: self.valuesToNames is nil")
                return attributes
            }
            guard let sectionValues = self.sectionsValues.first else {
                assertionFailure("Error: self.sectionsValues.first is nil")
                return attributes
            }
            
            for selectedIndexPath in selectedIndexPaths.sorted() {
                
                assert(selectedIndexPath.section == 0)
                guard selectedIndexPath.item >= 0 && selectedIndexPath.item < sectionValues.count else {
                    assertionFailure("Error: item index out of range.")
                    continue
                }
                
                let valueName = sectionValues[selectedIndexPath.item]
                
                guard let sections = valuesToNames[valueName.stringValue] else {
                    assertionFailure("Error: valuesToNames[\(valueName)] is nil")
                    continue
                }
                
                for section in sections {
                    
                    if attributes[section] == nil {
                        attributes[section] = []
                    }
                    attributes[section]?.append(valueName)
                }
            }
        }
        return attributes
    }
    
    ///
    /// This method use the tokenAttributes value and transforme it
    /// to be usable by this class. The value is kept in the variable
    /// coalescedAttributes.
    ///
    /// @return: OrderedDictionary<OutputSection, [OutputItem]>
    ///
    public func sortedTokensAttributes() -> OrderedDictionary<OutputSection, [OutputItem]> {
        
        // from  [TextId: [InputSection : Set<InputItem>]]
        // to    [TextId: [OutputSection: Set<OutputItem>]]
        var outputTokenAttributes: [TextId: [OutputSection: Set<OutputItem>]] = [:]
        for (textId, textAttributes) in self.tokenAttributes {
            outputTokenAttributes[textId] = [:]
            for (inputSection, inputItems) in textAttributes {
                
                let outputSection = OutputSection.from(inputSection: inputSection)
                let outputItems: [OutputItem] = inputItems.map { (inputItem) -> OutputItem in
                    return OutputItem.from(inputItem: inputItem, outputSection: outputSection)
                }
                outputTokenAttributes[textId]?[outputSection] = Set<OutputItem>(outputItems)
            }
        }
        
        return outputTokenAttributes.values.reduce([:]) { (result, value: [OutputSection : Set<OutputItem>]) -> [OutputSection : Set<OutputItem>] in
            return result.merging(value) { (first: Set<OutputItem>, second: Set<OutputItem>) -> Set<OutputItem> in
                
                typealias AttributeValue = String
                var values: [AttributeValue: [OutputItem]] = [:]
                
                for item in first {
                    if values[item.stringValue] == nil {
                        values[item.stringValue] = []
                    }
                    assert(values[item.stringValue] != nil)
                    values[item.stringValue]?.append(item)
                }
                
                for item in second {
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
                let outputItems = coallescedValues.values
                let outputItemsSet = Set<OutputItem>(outputItems)
                
                assert(outputItems.count == outputItemsSet.count)
                return outputItemsSet
            }
        }.sorted(by: { (arg1, arg2) -> Bool in
            let first: (key: OutputSection, value: Set<OutputItem>) = arg1
            let second: (key: OutputSection, value: Set<OutputItem>) = arg2
            return first.key < second.key
        }).mapValues({ (values) -> [OutputItem] in
            return values.sorted { (value1, value2) -> Bool in
                return value1 < value2
            }
        })
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
    private mutating func updateToAttributes(using coalescedAttributes: OrderedDictionary<OutputSection, [OutputItem]>) -> [Change] {
        
        var changes: [Change] = []
        
        let nonEmptyAttributes = coalescedAttributes.filter { (arg0) -> Bool in
            let (_, value) = arg0
            return !value.isEmpty
        }
        
        // take care of the sections
        let keys: [OutputSection] = nonEmptyAttributes.map { (arg) -> OutputSection in
            // (key: SectionType, value: [ItemType]) = arg
            return arg.key
        }
        
        let editOperations = self.sections.editOperations(to: keys)
        let sectionsChanges = self.applySectionsEditOperations(editOperations)
        changes.append(contentsOf: sectionsChanges)
        
        // take care of all the attributes values
        // the end result populates sectionsValues: [[ItemType]]
        assert(self.sectionsValues.count == self.sections.count)
        for (index, (_, sectionTargetValues)) in nonEmptyAttributes.enumerated() {
            
            let sectionActualValues = self.sectionsValues[index]
            let editOperations = sectionActualValues.editOperations(to: sectionTargetValues)
            let sectionValuesChanges = self.applySectionValuesEditOperations(editOperations, inSection: index)
            changes.append(contentsOf: sectionValuesChanges)
        }
        
        return changes
    }
    
    private mutating func applySectionsEditOperations(_ edits: [ArrayEdit<OutputSection>]) -> [Change] {
        
        var factor = 0
        
        var changes: [Change] = []
        
        // delete pass
        for edit in edits {
            switch edit {
            case .delete(let index):
                self.sections.remove(at: index+factor)
                self.sectionsValues.remove(at: index+factor)
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
                self.sections.insert(value, at: index+factor)
                self.sectionsValues.insert([OutputItem](), at: index+factor)
                let indexSet = IndexSet(arrayLiteral: index+factor)
                changes.append(.insertSections(indexes: indexSet))
                factor += 1
            case .delete:
                factor -= 1
            case .replace(let index, let value):
                self.sections[index+factor] = value
                let indexSet = IndexSet(arrayLiteral: index+factor)
                changes.append(.updateSections(indexes: indexSet))
            }
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
    private mutating func updateToValues(using coalescedAttributes: OrderedDictionary<OutputSection, [OutputItem]>) -> [Change] {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Before update to values: %@", log: Log.WriterCommon.all, type: .info, %%self.debugDescription)
        #endif 
        
        assert(self.coalescedAttributes != nil)
        self.valuesToNames = self.buildValuesToAttributeNamesMapping(fromCoalescedAttributes: coalescedAttributes)
        
        // we will do all the calculations in the background
        // thread but we should always update the Dynamic values
        // on the main thread
        var changes: [Change] = []
        
        let sectionEditOperations = self.sections.editOperations(to: [OutputSection(string: "Values")])
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        for sectionEditOperation in sectionEditOperations {
            os_log("section edits: %@", log: Log.WriterCommon.all, type: .info, %%sectionEditOperation.debugDescription)
        }
        #endif 
        
        let sectionsChanges = self.applySectionsEditOperations(sectionEditOperations)
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
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        for valuesEditOperation in valuesEditOperations {
            os_log("value edit: %@", log: Log.WriterCommon.all, type: .info, %%valuesEditOperation.debugDescription)
        }
        #endif 
        let sectionValuesChanges = self.applySectionValuesEditOperations(valuesEditOperations, inSection: 0)
        changes.append(contentsOf: sectionValuesChanges)
        return changes
    }
    
    ///
    /// We need this method to be able to compute fast the selectors when
    /// we are in values mode. Basically, in values mode we lose the attributes
    /// name information. This method construct a map that allows to rapidly
    /// know the attributes names from values.
    ///
    public func buildValuesToAttributeNamesMapping(fromCoalescedAttributes coalescedAttributes: OrderedDictionary<OutputSection, [OutputItem]>) -> [AttributeName: [OutputSection]] {
        
        var valuesToNamesMap: [AttributeName: [OutputSection]] = [:]
        
        for (sectionType, items) in coalescedAttributes {
            for item in items {
                if valuesToNamesMap[item.stringValue] == nil {
                    valuesToNamesMap[item.stringValue] = []
                }
                valuesToNamesMap[item.stringValue]?.append(sectionType)
            }
        }
        return valuesToNamesMap
    }
    
    private mutating func applySectionValuesEditOperations(_ edits: [ArrayEdit<OutputItem>], inSection sectionIndex: Int) -> [Change] {
        
        var changes: [Change] = []
        
        var factor = 0
        
        // delete pass
        for edit in edits {
            switch edit {
            case .delete(let index):
                self.sectionsValues[sectionIndex].remove(at: index+factor)
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
                self.sectionsValues[sectionIndex].insert(value, at: index+factor)
                let indexPath = IndexPath(item: index+factor, section: sectionIndex)
                changes.append(.insertsItem(indexes: Set<IndexPath>([indexPath])))
                factor += 1
            case .delete:
                factor -= 1
            case .replace(let index, let value):
                
                self.sectionsValues[sectionIndex][index+factor] = value
                let indexPath = IndexPath(item: index+factor, section: sectionIndex)
                changes.append(.updateItems(indexes: Set<IndexPath>([indexPath])))
            }
        }
        return changes
    }
}

extension CollectionSorting.Change: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        switch self {
        case .insertsItem(let indexes):
            let indexesStrings = indexes.map { (indexPath) -> String in
                "section: \(indexPath.section), item: \(indexPath.item)"
            }
            let indexesString = indexesStrings.reduce("") { (result, indexString) -> String in
                return (!result.isEmpty ? "," : "") + result + indexString
            }
            return "insertsItem at: \(indexesString)"
        case .deleteItems(let indexes):
            let indexesStrings = indexes.map { (indexPath) -> String in
                "section: \(indexPath.section), item: \(indexPath.item)"
            }
            let indexesString = indexesStrings.reduce("") { (result, indexString) -> String in
                return (!result.isEmpty ? "," : "") + result + indexString
            }
            return "deleteItems at: \(indexesString)"
        case .moveItem(let sourceIndex, let targetIndex):
            return "move from \(sourceIndex) to: \(targetIndex)"
        case .updateItems(let indexes):
            let indexesStrings = indexes.map { (indexPath) -> String in
                "section: \(indexPath.section), item: \(indexPath.item)"
            }
            let indexesString = indexesStrings.reduce("") { (result, indexString) -> String in
                return (!result.isEmpty ? "," : "") + result + indexString
            }
            return "updateItems at: \(indexesString)"
        case .insertSections(let indexes):
            let indexesStrings = indexes.map { (index) -> String in
                "\(index)"
            }
            let indexesString = indexesStrings.reduce("") { (result, indexString) -> String in
                return (!result.isEmpty ? "," : "") + result + indexString
            }
            return "insertSections at: \(indexesString)"
        case .deleteSections(let indexes):
            let indexesStrings = indexes.map { (index) -> String in
                "\(index)"
            }
            let indexesString = indexesStrings.reduce("") { (result, indexString) -> String in
                return (!result.isEmpty ? "," : "") + result + indexString
            }
            return "deleteSections at: \(indexesString)"
        case .updateSections(let indexes):
            let indexesStrings = indexes.map { (index) -> String in
                "\(index)"
            }
            let indexesString = indexesStrings.reduce("") { (result, indexString) -> String in
                return (!result.isEmpty ? "," : "") + result + indexString
            }
            return "updateSections at: \(indexesString)"
        }
    }
    
}

extension CollectionSorting.Change: Equatable {
    
    public static func ==(lhs: CollectionSorting.Change, rhs: CollectionSorting.Change) -> Bool {
        switch (lhs, rhs) {
        case (.insertsItem(let indexes1), .insertsItem(let indexes2)):
            return indexes1 == indexes2
        case (.deleteItems(let indexes1), .deleteItems(let indexes2)):
            return indexes1 == indexes2
        case (.moveItem(let from1, let to1), .moveItem(let from2, let to2)):
            return from1 == from2 && to1 == to2
        case (.updateItems(let indexes1), .updateItems(let indexes2)):
            return indexes1 == indexes2
        case (.insertSections(let indexes1), .insertSections(let indexes2)):
            return indexes1 == indexes2
        case (.deleteSections(let indexes1), .deleteSections(let indexes2)):
            return indexes1 == indexes2
        case (.updateSections(let indexes1), .updateSections(let indexes2)):
            return indexes1 == indexes2
        default:
            return false
        }
    }
    
}
