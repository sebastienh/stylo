//
//  FilesOutlineStoreTests.swift
//  WriterCommonTests
//
//  Created by Sebastien Hamel on 2020-01-15.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import XCTest
@testable import WriterCommon

class FilesOutlineStoreTests: XCTestCase {

    func testHistoryFirstInsert() {
    
        let firstItemId = "firstItemId"
        
        let fileOutlineStore = FilesOutlineStore(name: "test")
        do {
            
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.insertItemInUserSelection(id: firstItemId, index: 0))
            XCTAssert(fileOutlineStore.userSelectedItems.count == 1)
            XCTAssert(fileOutlineStore.historyIndex.value == 1, "received: \(fileOutlineStore.historyIndex.value)")
            XCTAssert(fileOutlineStore.userSelectedItems.values[0] == firstItemId)
            
            XCTAssert(fileOutlineStore.historicStates.values[safe: 1]?.userSelectedItems == [firstItemId])
            
        } catch let error {
            XCTAssertTrue(false, "Error: \(error)")
        }
    }
    
    func testHistoryTwoInserts() {
    
        let firstItemId = "firstItemId"
        let secondItemId = "secondItemId"
        
        let fileOutlineStore = FilesOutlineStore(name: "test")
        do {
            
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.insertItemInUserSelection(id: firstItemId, index: 0))
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.insertItemInUserSelection(id: secondItemId, index: 1))
            
            XCTAssert(fileOutlineStore.historicStates.values[safe: 1]?.userSelectedItems == [firstItemId])
            XCTAssert(fileOutlineStore.historicStates.values[safe: 2]?.userSelectedItems == [firstItemId, secondItemId])
            
            XCTAssert(fileOutlineStore.userSelectedItems.count == 2)
            XCTAssert(fileOutlineStore.historyIndex.value == 2, "received: \(fileOutlineStore.historyIndex.value)")
            XCTAssert(fileOutlineStore.userSelectedItems.values[0] == firstItemId)
            XCTAssert(fileOutlineStore.userSelectedItems.values[1] == secondItemId)
        } catch let error {
            XCTAssertTrue(false, "Error: \(error)")
        }
    }
    
    
    func testHistoryThreeInserts() {
    
        let firstItemId = "firstItemId"
        let secondItemId = "secondItemId"
        let thirdItemId = "thirdItemId"
        
        let fileOutlineStore = FilesOutlineStore(name: "test")
        do {
            
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.insertItemInUserSelection(id: firstItemId, index: 0))
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.insertItemInUserSelection(id: secondItemId, index: 1))
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.insertItemInUserSelection(id: thirdItemId, index: 2))
            
            XCTAssert(fileOutlineStore.historicStates.values[safe: 1]?.userSelectedItems == [firstItemId])
            XCTAssert(fileOutlineStore.historicStates.values[safe: 2]?.userSelectedItems == [firstItemId, secondItemId])
            XCTAssert(fileOutlineStore.historicStates.values[safe: 3]?.userSelectedItems == [firstItemId, secondItemId, thirdItemId])
            
            XCTAssert(fileOutlineStore.userSelectedItems.count == 3)
            XCTAssert(fileOutlineStore.historyIndex.value == 3, "received: \(fileOutlineStore.historyIndex.value)")
            XCTAssert(fileOutlineStore.userSelectedItems.values[0] == firstItemId)
            XCTAssert(fileOutlineStore.userSelectedItems.values[1] == secondItemId)
            XCTAssert(fileOutlineStore.userSelectedItems.values[2] == thirdItemId)
        } catch let error {
            XCTAssertTrue(false, "Error: \(error)")
        }
    }
    
    func testMoveBack() {
        
        let firstItemId = "firstItemId"
        let secondItemId = "secondItemId"
        let thirdItemId = "thirdItemId"
        
        let fileOutlineStore = FilesOutlineStore(name: "test")
        do {
            
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.insertItemInUserSelection(id: firstItemId, index: 0))
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.insertItemInUserSelection(id: secondItemId, index: 1))
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.insertItemInUserSelection(id: thirdItemId, index: 2))
        
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.moveBack)
            XCTAssert(fileOutlineStore.userSelectedItems.count == 2)
            XCTAssert(fileOutlineStore.historyIndex.value == 2, "received: \(fileOutlineStore.historyIndex.value)")
            XCTAssert(fileOutlineStore.userSelectedItems.values[0] == firstItemId)
            XCTAssert(fileOutlineStore.userSelectedItems.values[1] == secondItemId)
        } catch let error {
            XCTAssertTrue(false, "Error: \(error)")
        }
    }

    func testMoveForward() {

        let firstItemId = "firstItemId"
        let secondItemId = "secondItemId"
        let thirdItemId = "thirdItemId"
        
        let fileOutlineStore = FilesOutlineStore(name: "test")
        
        do {
            
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.insertItemInUserSelection(id: firstItemId, index: 0))
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.insertItemInUserSelection(id: secondItemId, index: 1))
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.insertItemInUserSelection(id: thirdItemId, index: 2))
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.moveBack)
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.moveBack)
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.moveForward)
        
            XCTAssert(fileOutlineStore.userSelectedItems.count == 2)
            XCTAssert(fileOutlineStore.userSelectedItems.values[0] == firstItemId)
            XCTAssert(fileOutlineStore.userSelectedItems.values[1] == secondItemId)
        } catch let error {
            XCTAssertTrue(false, "Error: \(error)")
        }
    }

    func testMoveForwardTwoTimes() {

        let firstItemId = "firstItemId"
        let secondItemId = "secondItemId"
        let thirdItemId = "thirdItemId"
        
        let fileOutlineStore = FilesOutlineStore(name: "test")
        
        do {
            
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.insertItemInUserSelection(id: firstItemId, index: 0))
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.insertItemInUserSelection(id: secondItemId, index: 1))
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.insertItemInUserSelection(id: thirdItemId, index: 2))
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.moveBack)
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.moveBack)
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.moveForward)
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.moveForward)
            
            XCTAssert(fileOutlineStore.userSelectedItems.count == 3)
            XCTAssert(fileOutlineStore.userSelectedItems.values[0] == firstItemId)
            XCTAssert(fileOutlineStore.userSelectedItems.values[1] == secondItemId)
            XCTAssert(fileOutlineStore.userSelectedItems.values[2] == thirdItemId)
        } catch let error {
            XCTAssertTrue(false, "Error: \(error)")
        }
    }
    
    func testMoveInsertCauseHistoryResetAndMoveBack() {

        let firstItemId = "firstItemId"
        let secondItemId = "secondItemId"
        let thirdItemId = "thirdItemId"
        
        let fileOutlineStore = FilesOutlineStore(name: "test")
        
        do {
            
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.insertItemInUserSelection(id: firstItemId, index: 0))
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.insertItemInUserSelection(id: secondItemId, index: 1))
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.moveBack)
            XCTAssert(fileOutlineStore.userSelectedItems.values[0] == firstItemId)
            XCTAssert(fileOutlineStore.userSelectedItems.values.count == 1)
            
            
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.insertItemInUserSelection(id: thirdItemId, index: 1))
            XCTAssert(fileOutlineStore.userSelectedItems.values[0] == firstItemId)
            XCTAssert(fileOutlineStore.userSelectedItems.values[1] == thirdItemId)
            XCTAssert(fileOutlineStore.userSelectedItems.values.count == 2)
            
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.moveBack)
            XCTAssert(fileOutlineStore.userSelectedItems.values[0] == firstItemId)
            XCTAssert(fileOutlineStore.userSelectedItems.values.count == 1)
        } catch let error {
            XCTAssertTrue(false, "Error: \(error)")
        }
    }
    
    func testMoveForwardPastEmptyHistoricState() {

        let firstItemId = "firstItemId"
        let secondItemId = "secondItemId"
        let thirdItemId = "thirdItemId"
        
        let fileOutlineStore = FilesOutlineStore(name: "test")
        
        do {
            
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.insertItemInUserSelection(id: firstItemId, index: 0))
            
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.insertItemInUserSelection(id: secondItemId, index: 1))
            
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.insertItemInUserSelection(id: thirdItemId, index: 2))
            
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.removeUserSelectedItem(itemId: firstItemId))
            
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.removeUserSelectedItem(itemId: secondItemId))
            
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.removeUserSelectedItem(itemId: thirdItemId))
            
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.insertItemInUserSelection(id: firstItemId, index: 0))
            
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.insertItemInUserSelection(id: secondItemId, index: 1))
            
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.insertItemInUserSelection(id: thirdItemId, index: 2))
            
            // states
            // 0. empty
            // 1. 1
            // 2. 1,2
            // 3. 1,2,3
            // 4. 2,3
            // 5. 3
            // 6. empty
            // 7. 1
            // 8. 1,2
            // 9. 1,2,3

            
            XCTAssert(fileOutlineStore.historyIndex.value == 9)
            
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.moveBack)
            
            XCTAssert(fileOutlineStore.historyIndex.value == 8)
            XCTAssert(fileOutlineStore.userSelectedItems.count == 2)
            XCTAssert(fileOutlineStore.userSelectedItems.values[0] == firstItemId)
            XCTAssert(fileOutlineStore.userSelectedItems.values[1] == secondItemId)
            
            // state before: 1,2
            // state after: 1
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.moveBack)
            
            XCTAssert(fileOutlineStore.historyIndex.value == 7)
            XCTAssert(fileOutlineStore.userSelectedItems.count == 1)
            XCTAssert(fileOutlineStore.userSelectedItems.values[0] == firstItemId)
            
            // state before: 1
            // state after: empty
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.moveBack)
            
            XCTAssert(fileOutlineStore.historyIndex.value == 6)
            XCTAssert(fileOutlineStore.userSelectedItems.count == 0)
            
            // state before: empty
            // state after: 3
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.moveBack)
            
            XCTAssert(fileOutlineStore.historyIndex.value == 5)
            XCTAssert(fileOutlineStore.userSelectedItems.count == 1)
            XCTAssert(fileOutlineStore.userSelectedItems.values[0] == thirdItemId)
            
            // state before: 1
            // state after: empty
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.moveForward)
            
            XCTAssert(fileOutlineStore.historyIndex.value == 6)
            XCTAssert(fileOutlineStore.userSelectedItems.count == 0)
            
            // state before: 1,2
            // state after: 1
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.moveForward)
            
            XCTAssert(fileOutlineStore.historyIndex.value == 7)
            XCTAssert(fileOutlineStore.userSelectedItems.count == 1)
            XCTAssert(fileOutlineStore.userSelectedItems.values[0] == firstItemId)
            
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.moveForward)
            
            XCTAssert(fileOutlineStore.historyIndex.value == 8)
            XCTAssert(fileOutlineStore.userSelectedItems.count == 2)
            XCTAssert(fileOutlineStore.userSelectedItems.values[0] == firstItemId)
            XCTAssert(fileOutlineStore.userSelectedItems.values[1] == secondItemId)

        } catch let error {
            XCTAssertTrue(false, "Error: \(error)")
        }
    }
    
    
    func testMaxFilesOutlineStoreHistory() {

        let firstItemId = "firstItemId"
        let secondItemId = "secondItemId"
        let thirdItemId = "thirdItemId"
        let fourthItemId = "fourthItemId"

        let fileOutlineStore = FilesOutlineStore(maxHistory: 3, name: "test")
        
        do {
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.insertItemInUserSelection(id: firstItemId, index: 0))
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.insertItemInUserSelection(id: secondItemId, index: 1))
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.insertItemInUserSelection(id: thirdItemId, index: 2))
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.insertItemInUserSelection(id: fourthItemId, index: 4))
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.moveBack)
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.moveBack)
            XCTAssertThrowsError(try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.moveBack))
        } catch let error {
            XCTAssertTrue(false, "Error: \(error)")
        }
    }
    
    func testMoveForwardOverMaxFilesOutlineStoreHistory() {

        let firstItemId = "firstItemId"
        let secondItemId = "secondItemId"
        let thirdItemId = "thirdItemId"
        let fourthItemId = "fourthItemId"

        let fileOutlineStore = FilesOutlineStore(maxHistory: 3, name: "test")
        
        do {
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.insertItemInUserSelection(id: firstItemId, index: 0))
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.insertItemInUserSelection(id: secondItemId, index: 1))
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.insertItemInUserSelection(id: thirdItemId, index: 2))
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.insertItemInUserSelection(id: fourthItemId, index: 4))
            XCTAssertThrowsError(try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.moveForward))
        } catch let error {
            XCTAssertTrue(false, "Error: \(error)")
        }
    }
    
    func testInsertOverMaxFilesOutlineStoreHistoryOneTime() {

        let firstItemId = "firstItemId"
        let secondItemId = "secondItemId"
        let thirdItemId = "thirdItemId"

        let fileOutlineStore = FilesOutlineStore(maxHistory: 2, name: "test")
        
        do {
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.insertItemInUserSelection(id: firstItemId, index: 0))
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.insertItemInUserSelection(id: secondItemId, index: 1))
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.insertItemInUserSelection(id: thirdItemId, index: 2))
            
            XCTAssert(fileOutlineStore.historicStates.values[safe: 0]?.userSelectedItems == [firstItemId, secondItemId])
            XCTAssert(fileOutlineStore.historicStates.values[safe: 1]?.userSelectedItems == [firstItemId, secondItemId, thirdItemId])
            
        } catch let error {
            XCTAssertTrue(false, "Error: \(error)")
        }
    }
    
    func testInsertOverMaxFilesOutlineStoreHistoryTwoTimes() {

        let firstItemId = "firstItemId"
        let secondItemId = "secondItemId"
        let thirdItemId = "thirdItemId"
        let fourthItemId = "fourthItemId"

        let fileOutlineStore = FilesOutlineStore(maxHistory: 2, name: "test")
        
        do {
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.insertItemInUserSelection(id: firstItemId, index: 0))
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.insertItemInUserSelection(id: secondItemId, index: 1))
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.insertItemInUserSelection(id: thirdItemId, index: 2))
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.insertItemInUserSelection(id: fourthItemId, index: 4))
            
            XCTAssert(fileOutlineStore.historicStates.values[safe: 0]?.userSelectedItems == [firstItemId, secondItemId, thirdItemId])
            XCTAssert(fileOutlineStore.historicStates.values[safe: 1]?.userSelectedItems == [firstItemId, secondItemId, thirdItemId, fourthItemId])
        } catch let error {
            XCTAssertTrue(false, "Error: \(error)")
        }
    }
    
    func testHistoryBackDisabledWhenAtStart() {
        
        let firstItemId = "firstItemId"
        let secondItemId = "secondItemId"
        let thirdItemId = "thirdItemId"
        let fourthItemId = "fourthItemId"
        
        let fileOutlineStore = FilesOutlineStore(maxHistory: 8, name: "test")
        
        do {
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.insertItemInUserSelection(id: firstItemId, index: 0))
            XCTAssert(fileOutlineStore.historyIndex.value == 1, "received: \(fileOutlineStore.historyIndex.value)")
            
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.insertItemInUserSelection(id: secondItemId, index: 1))
            XCTAssert(fileOutlineStore.historyIndex.value == 2, "received: \(fileOutlineStore.historyIndex.value)")
            
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.insertItemInUserSelection(id: thirdItemId, index: 2))
            XCTAssert(fileOutlineStore.historyIndex.value == 3, "received: \(fileOutlineStore.historyIndex.value)")
            
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.insertItemInUserSelection(id: fourthItemId, index: 4))
            XCTAssert(fileOutlineStore.historyIndex.value == 4, "received: \(fileOutlineStore.historyIndex.value)")
            
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.moveBack)
            XCTAssert(fileOutlineStore.historyIndex.value == 3, "received: \(fileOutlineStore.historyIndex.value)")
            
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.moveBack)
            XCTAssert(fileOutlineStore.historyIndex.value == 2, "received: \(fileOutlineStore.historyIndex.value)")
            
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.moveBack)
            XCTAssert(fileOutlineStore.historyIndex.value == 1, "received: \(fileOutlineStore.historyIndex.value)")

            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.moveBack)
            XCTAssert(fileOutlineStore.historyIndex.value == 0, "received: \(fileOutlineStore.historyIndex.value)")
            
            XCTAssertFalse(fileOutlineStore.historyBackEnabled.value)
            
        } catch let error {
            XCTAssertTrue(false, "Error: \(error)")
        }
        
    }
    
    func testHistoryForwardDisabledWhenAtEnd() {
        
        let firstItemId = "firstItemId"
        let secondItemId = "secondItemId"
        let thirdItemId = "thirdItemId"
        let fourthItemId = "fourthItemId"
        
        let fileOutlineStore = FilesOutlineStore(maxHistory: 8, name: "test")
        
        do {
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.insertItemInUserSelection(id: firstItemId, index: 0))
            XCTAssert(fileOutlineStore.historyIndex.value == 1, "received: \(fileOutlineStore.historyIndex.value)")
            XCTAssertTrue(fileOutlineStore.historyBackEnabled.value)
            XCTAssertFalse(fileOutlineStore.historyForwardEnabled.value)
            
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.insertItemInUserSelection(id: secondItemId, index: 1))
            XCTAssertTrue(fileOutlineStore.historyBackEnabled.value)
            XCTAssertFalse(fileOutlineStore.historyForwardEnabled.value)
            
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.insertItemInUserSelection(id: thirdItemId, index: 2))
            XCTAssert(fileOutlineStore.historyIndex.value == 3, "received: \(fileOutlineStore.historyIndex.value)")
            XCTAssertTrue(fileOutlineStore.historyBackEnabled.value)
            XCTAssertFalse(fileOutlineStore.historyForwardEnabled.value)
            
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.insertItemInUserSelection(id: fourthItemId, index: 4))
            XCTAssert(fileOutlineStore.historyIndex.value == 4, "received: \(fileOutlineStore.historyIndex.value)")
            XCTAssertTrue(fileOutlineStore.historyBackEnabled.value)
            XCTAssertFalse(fileOutlineStore.historyForwardEnabled.value)
            
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.moveBack)
            XCTAssert(fileOutlineStore.historyIndex.value == 3, "received: \(fileOutlineStore.historyIndex.value)")
            XCTAssertTrue(fileOutlineStore.historyBackEnabled.value)
            XCTAssertTrue(fileOutlineStore.historyForwardEnabled.value)
            
            try fileOutlineStore.reducer.online(store: fileOutlineStore, action: FilesOutlineAction.moveForward)
            XCTAssert(fileOutlineStore.historyIndex.value == 4, "received: \(fileOutlineStore.historyIndex.value)")
            XCTAssertTrue(fileOutlineStore.historyBackEnabled.value)
            XCTAssertFalse(fileOutlineStore.historyForwardEnabled.value)
            
        } catch let error {
            XCTAssertTrue(false, "Error: \(error)")
        }
        
    }
    
}
