//
//  CollectionSortingTests.swift
//  WriterCommonTests
//
//  Created by Sebastien Hamel on 2020-05-05.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import XCTest
@testable import WriterCommon

#if os(OSX)
import Cocoa
#elseif os(iOS)
import UIKit
#endif

func locally(work: () -> ()) {
    work()
}

extension NSDiffableDataSourceSnapshot: DiffableDataSourceSnapshot where ItemIdentifierType == AttributeTagOutputItemValue, SectionIdentifierType == AttributeTagOutputSectionValue {
    
    public typealias SectionIdentifierType = AttributeTagOutputSectionValue
    
    public typealias ItemIdentifierType = AttributeTagOutputItemValue
}

extension NSCollectionViewDiffableDataSource: DiffableDataSource where ItemIdentifierType == AttributeTagOutputItemValue, SectionIdentifierType == AttributeTagOutputSectionValue {
   
    public typealias SectionIdentifierType = AttributeTagOutputSectionValue
   
    public typealias ItemIdentifierType = AttributeTagOutputItemValue
}

typealias CollectionViewDiffableDataSourceType = NSCollectionViewDiffableDataSource<AttributeTagOutputSectionValue, AttributeTagOutputItemValue>

typealias CollectionSortingTest = CollectionSorting<AttributeTagOutputSectionValue, AttributeTagOutputItemValue, AttributeTagInputSection, AttributeTagInputItem, CollectionViewDiffableDataSourceType>

class CollectionSortingTests: XCTestCase {
    
    func testInitial() {
        
        
        
        let tokenAttributes: [TextId: [AttributeTagInputSection: Set<AttributeTagInputItem>]] = [
            "text-1": [
                "class": Set<AttributeTagInputItem>(arrayLiteral:
                    AttributeTagInputItem(stringValue: "test", ranges: [], textId: "text-1")
                )
            ]
        ]
        
        var outlineTags = CollectionSortingTest(attributesSortingMode: .values, tokenAttributes: tokenAttributes)
        
        
        let changes = outlineTags.update()
        
        XCTAssert(changes.count == 2)
        XCTAssert(changes[0] == CollectionSortingTest.Change.insertSections(indexes: IndexSet(arrayLiteral: 0)))
        XCTAssert(changes[1] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 0, section: 0))))
        
    }
    
    func testBasicChangeRemoveOneLetter() {
        
        let tokenAttributes: [TextId: [AttributeTagInputSection: Set<AttributeTagInputItem>]] = [
            "text-1": [
                "class": Set<AttributeTagInputItem>(arrayLiteral:
                    AttributeTagInputItem(stringValue: "test", ranges: [], textId: "text-1")
                )
            ]
        ]
        
        var outlineTags = CollectionSortingTest(attributesSortingMode: .values, tokenAttributes: tokenAttributes)
        
        
        let changes = outlineTags.update()
        
        XCTAssert(changes.count == 2)
        XCTAssert(changes[0] == CollectionSortingTest.Change.insertSections(indexes: IndexSet(arrayLiteral: 0)))
        XCTAssert(changes[1] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 0, section: 0))))
        
        let targetTokenAttributes: [TextId: [AttributeTagInputSection: Set<AttributeTagInputItem>]] = [
            "text-1": [
                "class": Set<AttributeTagInputItem>(arrayLiteral:
                    AttributeTagInputItem(stringValue: "tes", ranges: [], textId: "text-1")
                )
            ]
        ]
        
        var targetTags = CollectionSortingTest(attributesSortingMode: .values, tokenAttributes: targetTokenAttributes)
        
        let targetChanges = targetTags.update(from: outlineTags)
        
        debugPrint("targetChanges[0]: \(targetChanges[0])")
        XCTAssert(targetChanges.count == 2)
        let expected1 = CollectionSortingTest.Change.deleteItems(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 0, section: 0)))
        let expected2 = CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 0, section: 0)))
        debugPrint("expected1: \(expected1)")
        XCTAssert(targetChanges[0] == expected1)
        XCTAssert(targetChanges[1] == expected2)
    }
    
    func testBasicChangeRemoveOneLetter2() {
        
        let tokenAttributes: [TextId: [AttributeTagInputSection: Set<AttributeTagInputItem>]] = [
            "text-1": [
                "class": Set<AttributeTagInputItem>(arrayLiteral:
                    AttributeTagInputItem(stringValue: "test", ranges: [], textId: "text-1"),
                    AttributeTagInputItem(stringValue: "test2", ranges: [], textId: "text-1")
                )
            ]
        ]
        
        var outlineTags = CollectionSortingTest(attributesSortingMode: .values, tokenAttributes: tokenAttributes)
        
        
        let changes = outlineTags.update()
        
        XCTAssert(changes.count == 3)
        XCTAssert(changes[0] == CollectionSortingTest.Change.insertSections(indexes: IndexSet(arrayLiteral: 0)))
        XCTAssert(changes[1] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 0, section: 0))))
        XCTAssert(changes[2] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 1, section: 0))))
        
        let targetTokenAttributes: [TextId: [AttributeTagInputSection: Set<AttributeTagInputItem>]] = [
            "text-1": [
                "class": Set<AttributeTagInputItem>(arrayLiteral:
                    AttributeTagInputItem(stringValue: "test", ranges: [], textId: "text-1"),
                    AttributeTagInputItem(stringValue: "test", ranges: [], textId: "text-1")
                )
            ]
        ]
        
        var targetTags = CollectionSortingTest(attributesSortingMode: .values, tokenAttributes: targetTokenAttributes)
        
        let targetChanges = targetTags.update(from: outlineTags)
        
        debugPrint("targetChanges[0]: \(targetChanges[0])")
        XCTAssert(targetChanges.count == 1)
        
        let expected = CollectionSortingTest.Change.deleteItems(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 1, section: 0)))
        debugPrint("expected: \(expected)")
        XCTAssert(targetChanges[0] == expected)
    }
    
    func testBasicChangeRemoveOneLetter3() {
        
        let tokenAttributes: [TextId: [AttributeTagInputSection: Set<AttributeTagInputItem>]] = [
            "text-1": [
                "class": Set<AttributeTagInputItem>(arrayLiteral:
                    AttributeTagInputItem(stringValue: "test2", ranges: [], textId: "text-1")
                )
            ],
            "text-2": [
                "class": Set<AttributeTagInputItem>(arrayLiteral:
                    AttributeTagInputItem(stringValue: "test", ranges: [], textId: "text-2")
                )
            ]
        ]
        
        var outlineTags = CollectionSortingTest(attributesSortingMode: .values, tokenAttributes: tokenAttributes)
        
        
        let changes = outlineTags.update()
        
        XCTAssert(changes.count == 3)
        XCTAssert(changes[0] == CollectionSortingTest.Change.insertSections(indexes: IndexSet(arrayLiteral: 0)))
        XCTAssert(changes[1] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 0, section: 0))))
        XCTAssert(changes[2] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 1, section: 0))))
        
        let targetTokenAttributes: [TextId: [AttributeTagInputSection: Set<AttributeTagInputItem>]] = [
            "text-1": [
                "class": Set<AttributeTagInputItem>(arrayLiteral: AttributeTagInputItem(stringValue: "test", ranges: [], textId: "text-1"))
            ],
            "text-2": [
                "class": Set<AttributeTagInputItem>(arrayLiteral:
                    AttributeTagInputItem(stringValue: "test", ranges: [], textId: "text-2")
                )
            ]
        ]
        
        var targetTags = CollectionSortingTest(attributesSortingMode: .values, tokenAttributes: targetTokenAttributes)
        
        let targetChanges = targetTags.update(from: outlineTags)
        
        debugPrint("targetChanges[0]: \(targetChanges[0])")
        XCTAssert(targetChanges.count == 1)
        
        let expected = CollectionSortingTest.Change.deleteItems(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 1, section: 0)))
        debugPrint("expected: \(expected)")
        XCTAssert(targetChanges[0] == expected)
    }
    
    
    func testBasicChangeRemoveOneLetter4() {
        
        let tokenAttributes: [TextId: [AttributeTagInputSection: Set<AttributeTagInputItem>]] = [
            
            // .abcdef .bcdef .cdefg .defgh .efghij .fghijk
            "text-1": [
                "class": Set<AttributeTagInputItem>(arrayLiteral:
                    AttributeTagInputItem(stringValue: "abcdef", ranges: [], textId: "text-1"),  //"abcdef",
                    AttributeTagInputItem(stringValue: "bcdef", ranges: [], textId: "text-1"),  //  "bcdef",
                    AttributeTagInputItem(stringValue: "cdefg", ranges: [], textId: "text-1"),  //"cdefg",
                    AttributeTagInputItem(stringValue: "defgh", ranges: [], textId: "text-1"),  //"defgh",
                    AttributeTagInputItem(stringValue: "efghij", ranges: [], textId: "text-1"),  //"efghij",
                    AttributeTagInputItem(stringValue: "fghijk", ranges: [], textId: "text-1")  //"fghijk"
                )
            ],
            "text-2": [
                "class": Set<AttributeTagInputItem>(arrayLiteral:
                    AttributeTagInputItem(stringValue: "zzzzzzsse", ranges: [], textId: "text-2")  //"zzzzzzsse"
                )
            ]
        ]
        
        var outlineTags = CollectionSortingTest(attributesSortingMode: .values, tokenAttributes: tokenAttributes)
        
        
        let changes = outlineTags.update()
        
        XCTAssert(changes.count == 8)
        XCTAssert(changes[0] == CollectionSortingTest.Change.insertSections(indexes: IndexSet(arrayLiteral: 0)))
        XCTAssert(changes[1] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 0, section: 0))))
        XCTAssert(changes[2] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 1, section: 0))))
        XCTAssert(changes[3] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 2, section: 0))))
        XCTAssert(changes[4] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 3, section: 0))))
        XCTAssert(changes[5] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 4, section: 0))))
        XCTAssert(changes[6] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 5, section: 0))))
        XCTAssert(changes[7] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 6, section: 0))))
        
        let targetTokenAttributes: [TextId: [AttributeTagInputSection: Set<AttributeTagInputItem>]] = [
            "text-1": [
                "class": Set<AttributeTagInputItem>(arrayLiteral:
                    AttributeTagInputItem(stringValue: "abcdef", ranges: [], textId: "text-1"),  //"abcdef",
                    AttributeTagInputItem(stringValue: "bcde", ranges: [], textId: "text-1"),  //  "bcde",
                    AttributeTagInputItem(stringValue: "cdefg", ranges: [], textId: "text-1"),  //"cdefg",
                    AttributeTagInputItem(stringValue: "defgh", ranges: [], textId: "text-1"),  //"defgh",
                    AttributeTagInputItem(stringValue: "efghij", ranges: [], textId: "text-1"),  //"efghij",
                    AttributeTagInputItem(stringValue: "fghijk", ranges: [], textId: "text-1")  //"fghijk"
                )
            ],
            "text-2": [
                "class": Set<AttributeTagInputItem>(arrayLiteral:
                    AttributeTagInputItem(stringValue: "zzzzzzsse", ranges: [], textId: "text-2")
                )
            ]
        ]
        
        var targetTags = CollectionSortingTest(attributesSortingMode: .values, tokenAttributes: targetTokenAttributes)
        
        let targetChanges = targetTags.update(from: outlineTags)
        
        let values1 = targetTags.sectionsValues[0]
        
        // Array<AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>>
        var expectedValues1: Array<AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>> = []
            
        expectedValues1.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "abcdef", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "class"), valueOccurencesPositions: [:]))
        expectedValues1.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "bcde", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "class"), valueOccurencesPositions: [:]))
        expectedValues1.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "cdefg", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "class"), valueOccurencesPositions: [:]))
        expectedValues1.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "defgh", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "class"), valueOccurencesPositions: [:]))
        expectedValues1.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "efghij", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "class"), valueOccurencesPositions: [:]))
        expectedValues1.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "fghijk", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "class"), valueOccurencesPositions: [:]))
        expectedValues1.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "zzzzzzsse", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "class"), valueOccurencesPositions: [:]))
        
        XCTAssert(values1 == expectedValues1)
        
        debugPrint("targetChanges: \(targetChanges)")
        XCTAssert(targetChanges.count == 2)
        
        let expected1 = CollectionSortingTest.Change.deleteItems(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 1, section: 0)))
        let expected2 = CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 1, section: 0)))
        debugPrint("expected1: \(expected1)")
        XCTAssert(targetChanges[0] == expected1, "received: \(targetChanges[0])")
        XCTAssert(targetChanges[1] == expected2, "received: \(targetChanges[1])")

        
        let targetTokenAttributes2: [TextId: [AttributeTagInputSection: Set<AttributeTagInputItem>]] = [
            "text-1": [
                "class": Set<AttributeTagInputItem>(arrayLiteral:
                    AttributeTagInputItem(stringValue: "abcdef", ranges: [], textId: "text-1"),  //"abcdef",
                    AttributeTagInputItem(stringValue: "bcd", ranges: [], textId: "text-1"),  //  "bcde",
                    AttributeTagInputItem(stringValue: "cdefg", ranges: [], textId: "text-1"),  //"cdefg",
                    AttributeTagInputItem(stringValue: "defgh", ranges: [], textId: "text-1"),  //"defgh",
                    AttributeTagInputItem(stringValue: "efghij", ranges: [], textId: "text-1"),  //"efghij",
                    AttributeTagInputItem(stringValue: "fghijk", ranges: [], textId: "text-1")  //"fghijk"
                )
            ],
            "text-2": [
                "class": Set<AttributeTagInputItem>(arrayLiteral:
                    AttributeTagInputItem(stringValue: "zzzzzzsse", ranges: [], textId: "text-2")
                )
            ]
        ]
        
        var targetTags2 = CollectionSortingTest(attributesSortingMode: .values, tokenAttributes: targetTokenAttributes2)
        
        let targetChanges2 = targetTags2.update(from: outlineTags)
        
        debugPrint("targetChanges[0]: \(targetChanges2[0])")
        XCTAssert(targetChanges2.count == 2)
        
        let expected3 = CollectionSortingTest.Change.deleteItems(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 1, section: 0)))
        let expected4 = CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 1, section: 0)))
        
        XCTAssert(targetChanges2[0] == expected3, "received: \(targetChanges2[0])")
        XCTAssert(targetChanges2[1] == expected4, "received: \(targetChanges2[1])")
        
        let values = targetTags2.sectionsValues[0]

        var expectedValues: Array<AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>> = []
            
        expectedValues.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "abcdef", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "class"), valueOccurencesPositions: [:]))
        expectedValues.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "bcd", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "class"), valueOccurencesPositions: [:]))
        expectedValues.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "cdefg", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "class"), valueOccurencesPositions: [:]))
        expectedValues.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "defgh", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "class"), valueOccurencesPositions: [:]))
        expectedValues.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "efghij", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "class"), valueOccurencesPositions: [:]))
        expectedValues.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "fghijk", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "class"), valueOccurencesPositions: [:]))
        expectedValues.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "zzzzzzsse", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "class"), valueOccurencesPositions: [:]))
        
        XCTAssert(values == expectedValues)
    }
    
    
    func testBasicChangeToAttributes() {
        
        let tokenAttributes: [TextId: [AttributeTagInputSection: Set<AttributeTagInputItem>]] = [
            
            // .abcdef .bcdef .cdefg .defgh .efghij .fghijk
            "text-1": [
                "class": Set<AttributeTagInputItem>(arrayLiteral:
                    AttributeTagInputItem(stringValue: "abcdef", ranges: [], textId: "text-1"),  //"abcdef",
                    AttributeTagInputItem(stringValue: "bcdef", ranges: [], textId: "text-1"),  //  "bcdef",
                    AttributeTagInputItem(stringValue: "cdefg", ranges: [], textId: "text-1"),  //"cdefg",
                    AttributeTagInputItem(stringValue: "defgh", ranges: [], textId: "text-1"),  //"defgh",
                    AttributeTagInputItem(stringValue: "efghij", ranges: [], textId: "text-1"),  //"efghij",
                    AttributeTagInputItem(stringValue: "fghijk", ranges: [], textId: "text-1")  //"fghijk"    
                )
            ],
            "text-2": [
                "class": Set<AttributeTagInputItem>(arrayLiteral:
                    AttributeTagInputItem(stringValue: "zzzzzzsse", ranges: [], textId: "text-2")
                ),
                "other": Set<AttributeTagInputItem>(arrayLiteral:
                    AttributeTagInputItem(stringValue: "other-value", ranges: [], textId: "text-2")
                )
            ]
        ]
        
        var outlineTags = CollectionSortingTest(attributesSortingMode: .values, tokenAttributes: tokenAttributes)
        
        
        let changes = outlineTags.update()
        
        XCTAssert(changes.count == 9)
        XCTAssert(changes[0] == CollectionSortingTest.Change.insertSections(indexes: IndexSet(arrayLiteral: 0)))
        XCTAssert(changes[1] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 0, section: 0))))
        XCTAssert(changes[2] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 1, section: 0))))
        XCTAssert(changes[3] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 2, section: 0))))
        XCTAssert(changes[4] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 3, section: 0))))
        XCTAssert(changes[5] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 4, section: 0))))
        XCTAssert(changes[6] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 5, section: 0))))
        XCTAssert(changes[7] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 6, section: 0))))
        XCTAssert(changes[8] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 7, section: 0))))
        
        var targetTags = CollectionSortingTest(attributesSortingMode: .attributes, tokenAttributes: tokenAttributes)
        
        let targetChanges = targetTags.update(from: outlineTags)
        
        let values1 = targetTags.sectionsValues[0]
//        let expectedValues1 = ["abcdef", "bcdef", "cdefg", "defgh", "efghij", "fghijk","zzzzzzsse"]
        
        var expectedValues1: Array<AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>> = []
            
        expectedValues1.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "abcdef", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "class"), valueOccurencesPositions: [:]))
        expectedValues1.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "bcdef", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "class"), valueOccurencesPositions: [:]))
        expectedValues1.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "cdefg", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "class"), valueOccurencesPositions: [:]))
        expectedValues1.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "defgh", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "class"), valueOccurencesPositions: [:]))
        expectedValues1.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "efghij", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "class"), valueOccurencesPositions: [:]))
        expectedValues1.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "fghijk", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "class"), valueOccurencesPositions: [:]))
        expectedValues1.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "zzzzzzsse", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "class"), valueOccurencesPositions: [:]))
        
        
        
        
        
        
        XCTAssert(values1 == expectedValues1, "\nExpected: \(expectedValues1)\n, received: \(values1)")
        
        let values2 = targetTags.sectionsValues[1]
        
//        let expectedValues2 = ["other-value"]
        var expectedValues2: Array<AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>> = []
                   
        expectedValues2.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "other-value", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "other"), valueOccurencesPositions: [:]))
               
        
        XCTAssert(values2 == expectedValues2, "\nExpected: \(expectedValues2)\n, received: \(values2)")
        
        debugPrint("targetChanges[0]: \(targetChanges[0])")
        for targetChange in targetChanges {
            debugPrint("target change: \(targetChange)")
        }
        
        XCTAssert(targetChanges.count == 11)
        XCTAssert(targetChanges[0] == CollectionSortingTest.Change.deleteSections(indexes: IndexSet(arrayLiteral: 0)))
        XCTAssert(targetChanges[1] == CollectionSortingTest.Change.insertSections(indexes: IndexSet(arrayLiteral: 0)))
        XCTAssert(targetChanges[2] == CollectionSortingTest.Change.insertSections(indexes: IndexSet(arrayLiteral: 1)))
        XCTAssert(targetChanges[3] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 0, section: 0))))
        XCTAssert(targetChanges[4] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 1, section: 0))))
        XCTAssert(targetChanges[5] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 2, section: 0))))
        XCTAssert(targetChanges[6] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 3, section: 0))))
        XCTAssert(targetChanges[7] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 4, section: 0))))
        XCTAssert(targetChanges[8] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 5, section: 0))))
        XCTAssert(targetChanges[9] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 6, section: 0))))
        XCTAssert(targetChanges[10] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 0, section: 1))))
    }
    
    func testBasicChangeToAttributesAndToValues() {
        
        let tokenAttributes: [TextId: [AttributeTagInputSection: Set<AttributeTagInputItem>]] = [
            
            // .abcdef .bcdef .cdefg .defgh .efghij .fghijk
            "text-1": [
                "class": Set<AttributeTagInputItem>(arrayLiteral:
                    AttributeTagInputItem(stringValue: "abcdef", ranges: [], textId: "text-1"),  //"abcdef",
                    AttributeTagInputItem(stringValue: "bcdef", ranges: [], textId: "text-1"),  //  "bcdef",
                    AttributeTagInputItem(stringValue: "cdefg", ranges: [], textId: "text-1"),  //"cdefg",
                    AttributeTagInputItem(stringValue: "defgh", ranges: [], textId: "text-1"),  //"defgh",
                    AttributeTagInputItem(stringValue: "efghij", ranges: [], textId: "text-1"),  //"efghij",
                    AttributeTagInputItem(stringValue: "fghijk", ranges: [], textId: "text-1")  //"fghijk"
                 )
            ],
            "text-2": [
                "class": Set<AttributeTagInputItem>(arrayLiteral:
                    AttributeTagInputItem(stringValue: "zzzzzzsse", ranges: [], textId: "text-2")
                ),
                "other": Set<AttributeTagInputItem>(arrayLiteral:
                    AttributeTagInputItem(stringValue: "other-value", ranges: [], textId: "text-2")
                )
            ]
        ]
        
        var outlineTags = CollectionSortingTest(attributesSortingMode: .values, tokenAttributes: tokenAttributes)
        
        
        let changes = outlineTags.update()
        
        XCTAssert(changes.count == 9)
        XCTAssert(changes[0] == CollectionSortingTest.Change.insertSections(indexes: IndexSet(arrayLiteral: 0)))
        XCTAssert(changes[1] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 0, section: 0))))
        XCTAssert(changes[2] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 1, section: 0))))
        XCTAssert(changes[3] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 2, section: 0))))
        XCTAssert(changes[4] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 3, section: 0))))
        XCTAssert(changes[5] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 4, section: 0))))
        XCTAssert(changes[6] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 5, section: 0))))
        XCTAssert(changes[7] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 6, section: 0))))
        XCTAssert(changes[8] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 7, section: 0))))
        
        var targetTags = CollectionSortingTest(attributesSortingMode: .attributes, tokenAttributes: tokenAttributes)
        
        let targetChanges = targetTags.update(from: outlineTags)
        
        let values1 = targetTags.sectionsValues[0]
//        let expectedValues1 = ["abcdef", "bcdef", "cdefg", "defgh", "efghij", "fghijk","zzzzzzsse"]
        var expectedValues1: Array<AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>> = []
            
        expectedValues1.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "abcdef", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "class"), valueOccurencesPositions: [:]))
        expectedValues1.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "bcdef", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "class"), valueOccurencesPositions: [:]))
        expectedValues1.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "cdefg", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "class"), valueOccurencesPositions: [:]))
        expectedValues1.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "defgh", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "class"), valueOccurencesPositions: [:]))
        expectedValues1.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "efghij", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "class"), valueOccurencesPositions: [:]))
        expectedValues1.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "fghijk", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "class"), valueOccurencesPositions: [:]))
        expectedValues1.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "zzzzzzsse", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "class"), valueOccurencesPositions: [:]))
        
        XCTAssert(values1 == expectedValues1, "\nExpected: \(expectedValues1)\n, received: \(values1)")
        
        let values2 = targetTags.sectionsValues[1]
        // let expectedValues2 = ["other-value"]
        var expectedValues2: Array<AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>> = []
                   
        expectedValues2.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "other-value", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "other"), valueOccurencesPositions: [:]))
               
        XCTAssert(values2 == expectedValues2, "\nExpected: \(expectedValues2)\n, received: \(values2)")
        
        debugPrint("targetChanges[0]: \(targetChanges[0])")
        for targetChange in targetChanges {
            debugPrint("target change: \(targetChange)")
        }
        
        XCTAssert(targetChanges.count == 11)
        XCTAssert(targetChanges[0] == CollectionSortingTest.Change.deleteSections(indexes: IndexSet(arrayLiteral: 0)))
        XCTAssert(targetChanges[1] == CollectionSortingTest.Change.insertSections(indexes: IndexSet(arrayLiteral: 0)))
        XCTAssert(targetChanges[2] == CollectionSortingTest.Change.insertSections(indexes: IndexSet(arrayLiteral: 1)))
        XCTAssert(targetChanges[3] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 0, section: 0))))
        XCTAssert(targetChanges[4] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 1, section: 0))))
        XCTAssert(targetChanges[5] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 2, section: 0))))
        XCTAssert(targetChanges[6] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 3, section: 0))))
        XCTAssert(targetChanges[7] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 4, section: 0))))
        XCTAssert(targetChanges[8] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 5, section: 0))))
        XCTAssert(targetChanges[9] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 6, section: 0))))
        XCTAssert(targetChanges[10] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 0, section: 1))))
        
        locally {
            
            var newTargetTags = CollectionSortingTest(attributesSortingMode: .values, tokenAttributes: tokenAttributes)
            
            let targetChanges = newTargetTags.update(from: targetTags)
            
            
            XCTAssert(newTargetTags.sectionsValues.count == 1, "expected 1, received: \(newTargetTags.sectionsValues.count)")
            let values1 = newTargetTags.sectionsValues[0]
            // let expectedValues1 = ["abcdef", "bcdef", "cdefg", "defgh", "efghij", "fghijk","other-value","zzzzzzsse"]
            var expectedValues1: Array<AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>> = []
                
            expectedValues1.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "abcdef", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "class"), valueOccurencesPositions: [:]))
            expectedValues1.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "bcdef", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "class"), valueOccurencesPositions: [:]))
            expectedValues1.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "cdefg", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "class"), valueOccurencesPositions: [:]))
            expectedValues1.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "defgh", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "class"), valueOccurencesPositions: [:]))
            expectedValues1.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "efghij", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "class"), valueOccurencesPositions: [:]))
            expectedValues1.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "fghijk", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "class"), valueOccurencesPositions: [:]))
            expectedValues1.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "other-value", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "other"), valueOccurencesPositions: [:]))
            expectedValues1.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "zzzzzzsse", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "class"), valueOccurencesPositions: [:]))
            
            
            XCTAssert(values1 == expectedValues1, "\nExpected: \(expectedValues1)\n, received: \(values1)")
            
            
            
            debugPrint("targetChanges[0]: \(targetChanges[0])")
            for targetChange in targetChanges {
                debugPrint("target change: \(targetChange)")
            }
            
            XCTAssert(targetChanges.count == 11, "expected: 3, received\(targetChanges.count)")
            
            XCTAssert(targetChanges[0] == CollectionSortingTest.Change.deleteSections(indexes: IndexSet(arrayLiteral: 0)))
            XCTAssert(targetChanges[1] == CollectionSortingTest.Change.deleteSections(indexes: IndexSet(arrayLiteral: 0)))
            XCTAssert(targetChanges[2] == CollectionSortingTest.Change.insertSections(indexes: IndexSet(arrayLiteral: 0)))
            XCTAssert(targetChanges[3] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 0, section: 0))))
            XCTAssert(targetChanges[4] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 1, section: 0))))
            XCTAssert(targetChanges[5] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 2, section: 0))))
            XCTAssert(targetChanges[6] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 3, section: 0))))
            XCTAssert(targetChanges[7] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 4, section: 0))))
            XCTAssert(targetChanges[8] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 5, section: 0))))
            XCTAssert(targetChanges[9] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 6, section: 0))))
            XCTAssert(targetChanges[10] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 7, section: 0))))
            
        }
    }
    
    func testBasicFiltering() {
        
        let tokenAttributes: [TextId: [AttributeTagInputSection: Set<AttributeTagInputItem>]] = [
            "text-1": [
                "class": Set<AttributeTagInputItem>(arrayLiteral:
                    AttributeTagInputItem(stringValue: "abcdef", ranges: [], textId: "text-1"),  //"abcdef",
                    AttributeTagInputItem(stringValue: "bcdef", ranges: [], textId: "text-1"),  //  "bcdef",
                    AttributeTagInputItem(stringValue: "abcdefg", ranges: [], textId: "text-1"),  //"cdefg",
                    AttributeTagInputItem(stringValue: "defgh", ranges: [], textId: "text-1"),  //"defgh",
                    AttributeTagInputItem(stringValue: "abefghij", ranges: [], textId: "text-1"),  //"efghij",
                    AttributeTagInputItem(stringValue: "fghijk", ranges: [], textId: "text-1")  //"fghijk"
                )
            ],
            "text-2": [
                "class": Set<AttributeTagInputItem>(arrayLiteral:
                    AttributeTagInputItem(stringValue: "abzzzzzzsse", ranges: [], textId: "text-2")
                ),
                "other": Set<AttributeTagInputItem>(arrayLiteral:
                    AttributeTagInputItem(stringValue: "other-value", ranges: [], textId: "text-2")
                )
            ]
        ]
        
        var tags = CollectionSortingTest(attributesSortingMode: .values, tokenAttributes: tokenAttributes)
        
        tags.update()
        
        
        var filteredAttributesSorting = CollectionSortingTest.filtered(tokenAttributes: tokenAttributes, withString: "ab", attributesSortingMode: .values)
        filteredAttributesSorting.update(from: tags)
        
        let classSection = AttributeTagOutputSection<AttributeTagInputSection>(string: "class")
        let otherSection = AttributeTagOutputSection<AttributeTagInputSection>(string: "other")
        
        let bcdefItem = AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "bcdef", section:  classSection, valueOccurencesPositions: [:])
        
        let defghItem = AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "defgh", section:  classSection, valueOccurencesPositions: [:])
        
        let fghijkItem = AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "fghijk", section:  classSection, valueOccurencesPositions: [:])
        
        let otherValueItem = AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "other-value", section:  otherSection, valueOccurencesPositions: [:])
        
        XCTAssertFalse(filteredAttributesSorting.sectionsValues[0].contains(bcdefItem))
        XCTAssertFalse(filteredAttributesSorting.sectionsValues[0].contains(defghItem))
        XCTAssertFalse(filteredAttributesSorting.sectionsValues[0].contains(fghijkItem))
        XCTAssertFalse(filteredAttributesSorting.sectionsValues[0].contains(otherValueItem))
        
    }
    
    
    func testChangeOneLetter() {
        
        let tokenAttributes: [TextId: [AttributeTagInputSection: Set<AttributeTagInputItem>]] = [
            
            // .abcdef .bcdef .cdefg .defgh .efghij .fghijk
            "text-1": [
                "class": Set<AttributeTagInputItem>(arrayLiteral:
                    AttributeTagInputItem(stringValue: "abcdef", ranges: [], textId: "text-1"),  //"abcdef",
                    AttributeTagInputItem(stringValue: "bcdef", ranges: [], textId: "text-1"),  //  "bcdef",
                    AttributeTagInputItem(stringValue: "cdefg", ranges: [], textId: "text-1"),  //"cdefg",
                    AttributeTagInputItem(stringValue: "defgh", ranges: [], textId: "text-1"),  //"defgh",
                    AttributeTagInputItem(stringValue: "efghij", ranges: [], textId: "text-1"),  //"efghij",
                    AttributeTagInputItem(stringValue: "fghijk", ranges: [], textId: "text-1")  //"fghijk"
                )
            ],
            "text-2": [
                "class": Set<AttributeTagInputItem>(arrayLiteral:
                    AttributeTagInputItem(stringValue: "zzzzzzsse", ranges: [], textId: "text-2")
                )
            ]
        ]
        
        var outlineTags = CollectionSortingTest(attributesSortingMode: .values, tokenAttributes: tokenAttributes)
        
        
        let changes = outlineTags.update()
        
        XCTAssert(changes.count == 8)
        XCTAssert(changes[0] == CollectionSortingTest.Change.insertSections(indexes: IndexSet(arrayLiteral: 0)))
        XCTAssert(changes[1] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 0, section: 0))))
        XCTAssert(changes[2] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 1, section: 0))))
        XCTAssert(changes[3] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 2, section: 0))))
        XCTAssert(changes[4] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 3, section: 0))))
        XCTAssert(changes[5] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 4, section: 0))))
        XCTAssert(changes[6] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 5, section: 0))))
        XCTAssert(changes[7] == CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 6, section: 0))))
        
        let targetTokenAttributes: [TextId: [AttributeTagInputSection: Set<AttributeTagInputItem>]] = [
            "text-1": [
                "class": Set<AttributeTagInputItem>(arrayLiteral:
                    AttributeTagInputItem(stringValue: "abcdef", ranges: [], textId: "text-1"),  //"abcdef",
                    AttributeTagInputItem(stringValue: "cbcdef", ranges: [], textId: "text-1"),  //  "bcdef",
                    AttributeTagInputItem(stringValue: "cdefg", ranges: [], textId: "text-1"),  //"cdefg",
                    AttributeTagInputItem(stringValue: "defgh", ranges: [], textId: "text-1"),  //"defgh",
                    AttributeTagInputItem(stringValue: "efghij", ranges: [], textId: "text-1"),  //"efghij",
                    AttributeTagInputItem(stringValue: "fghijk", ranges: [], textId: "text-1")  //"fghijk"
                )
            ],
            "text-2": [
                "class": Set<AttributeTagInputItem>(arrayLiteral:
                    AttributeTagInputItem(stringValue: "zzzzzzsse", ranges: [], textId: "text-2")
                )
            ]
        ]
        
        var targetTags = CollectionSortingTest(attributesSortingMode: .values, tokenAttributes: targetTokenAttributes)
        
        let targetChanges = targetTags.update(from: outlineTags)
        
        let values1 = targetTags.sectionsValues[0]
        // let expectedValues1 = ["abcdef", "cbcdef", "cdefg", "defgh", "efghij", "fghijk", "zzzzzzsse"]
        var expectedValues1: Array<AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>> = []
            
        expectedValues1.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "abcdef", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "class"), valueOccurencesPositions: [:]))
        expectedValues1.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "cbcdef", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "class"), valueOccurencesPositions: [:]))
        expectedValues1.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "cdefg", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "class"), valueOccurencesPositions: [:]))
        expectedValues1.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "defgh", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "class"), valueOccurencesPositions: [:]))
        expectedValues1.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "efghij", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "class"), valueOccurencesPositions: [:]))
        expectedValues1.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "fghijk", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "class"), valueOccurencesPositions: [:]))
        expectedValues1.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "zzzzzzsse", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "class"), valueOccurencesPositions: [:]))
        
        
        XCTAssert(values1 == expectedValues1)
        
        debugPrint("targetChanges[0]: \(targetChanges[0])")
        XCTAssert(targetChanges.count == 2)
        
        let expected1 = CollectionSortingTest.Change.deleteItems(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 1, section: 0)))
        let expected2 = CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 1, section: 0)))
        debugPrint("expected1: \(expected1)")
        XCTAssert(targetChanges[0] == expected1)
        XCTAssert(targetChanges[1] == expected2)
        
        let targetTokenAttributes2: [TextId: [AttributeTagInputSection: Set<AttributeTagInputItem>]] = [
            "text-1": [
                "class": Set<AttributeTagInputItem>(arrayLiteral:
                    AttributeTagInputItem(stringValue: "abcdef", ranges: [], textId: "text-1"),  //"abcdef",
                    AttributeTagInputItem(stringValue: "bcd", ranges: [], textId: "text-1"),  //  "bcdef",
                    AttributeTagInputItem(stringValue: "cdefg", ranges: [], textId: "text-1"),  //"cdefg",
                    AttributeTagInputItem(stringValue: "defgh", ranges: [], textId: "text-1"),  //"defgh",
                    AttributeTagInputItem(stringValue: "efghij", ranges: [], textId: "text-1"),  //"efghij",
                    AttributeTagInputItem(stringValue: "fghijk", ranges: [], textId: "text-1")  //"fghijk"
                )
            ],
            "text-2": [
                "class": Set<AttributeTagInputItem>(arrayLiteral:
                    AttributeTagInputItem(stringValue: "zzzzzzsse", ranges: [], textId: "text-2")
                )
            ]
        ]
        
        var targetTags2 = CollectionSortingTest(attributesSortingMode: .values, tokenAttributes: targetTokenAttributes2)
        
        let targetChanges2 = targetTags2.update(from: outlineTags)
        
        debugPrint("targetChanges[0]: \(targetChanges2[0])")
        XCTAssert(targetChanges2.count == 2)
        
        let expected3 = CollectionSortingTest.Change.deleteItems(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 1, section: 0)))
        let expected4 = CollectionSortingTest.Change.insertsItem(indexes: Set<IndexPath>(arrayLiteral: IndexPath(item: 1, section: 0)))
        debugPrint("expected3: \(expected3)")
        XCTAssert(targetChanges2[0] == expected3, "received: \(targetChanges2[0])")
        XCTAssert(targetChanges2[1] == expected4, "received: \(targetChanges2[1])")
        
        let values = targetTags2.sectionsValues[0]
        // let expectedValues = ["abcdef", "bcd", "cdefg", "defgh", "efghij", "fghijk", "zzzzzzsse"]
        var expectedValues: Array<AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>> = []
            
        expectedValues.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "abcdef", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "class"), valueOccurencesPositions: [:]))
        expectedValues.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "bcd", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "class"), valueOccurencesPositions: [:]))
        expectedValues.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "cdefg", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "class"), valueOccurencesPositions: [:]))
        expectedValues.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "defgh", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "class"), valueOccurencesPositions: [:]))
        expectedValues.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "efghij", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "class"), valueOccurencesPositions: [:]))
        expectedValues.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "fghijk", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "class"), valueOccurencesPositions: [:]))
        expectedValues.append(AttributeTagOutputItem<AttributeTagOutputSection<AttributeTagInputSection>, AttributeTagInputItem>(string: "zzzzzzsse", section: AttributeTagOutputSection<AttributeTagInputSection>(string: "class"), valueOccurencesPositions: [:]))
        
        
        XCTAssert(values == expectedValues)
        
        
    }
    
}

