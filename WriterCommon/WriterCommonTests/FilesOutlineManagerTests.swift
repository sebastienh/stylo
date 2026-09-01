//
//  FilesOutlineManagerTests.swift
//  WriterCommonTests
//
//  Created by Sebastien Hamel on 2020-03-25.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import XCTest
@testable import WriterCommon

extension StyloApplication {
    
    func clear() {
        StyloApplication.shared.cssStyleSetManager = nil
    }
    
}


class FilesOutlineManagerTests: XCTestCase {
    
    override func setUp() {
        StyloApplication.shared.loadCSSStylesSetManager()
        StyloApplication.shared.cssStyleSetManager!.selectStyle(atIndex: 0)
        StyloApplication.shared.computedAppearance.setValue(.dark)
    }
    
    override func tearDown() {
        StyloApplication.shared.clear()
    }
    
    /// Crash while changing Group names
    /// stylo #1053
    /// Removed and kept for reference purpose: it does not test anything...
//    func testSelectingGroupWhenAFileIsAlreadySelected() {
//
//        let textDocument = try! TextDocument(type: "stylo")
//        let documentManager = textDocument.documentManager!
//        let sourceSetManager = documentManager._sourceSetManager.value!
//
//        let filesGroup = sourceSetManager.firstGroupDirectory(withTitle: "Files")!
//        filesGroup.name.setValue("Fichiers")
//
//        let histoireGroup = sourceSetManager.addGroup(withTitle: "Histoire")!
//        histoireGroup.addEmptyTextManager(document: textDocument)
//        histoireGroup.addEmptyTextManager(document: textDocument)
//        histoireGroup.addEmptyTextManager(document: textDocument)
//        histoireGroup.addEmptyTextManager(document: textDocument)
//        histoireGroup.addEmptyTextManager(document: textDocument)
//        histoireGroup.addEmptyTextManager(document: textDocument)
//        histoireGroup.addEmptyTextManager(document: textDocument)
//        histoireGroup.addEmptyTextManager(document: textDocument)
//        histoireGroup.addEmptyTextManager(document: textDocument)
//
//        let lieuxDirectory = documentManager.addUntitledDirectory(atEndOfDirectory: histoireGroup)!
//        let lieuxFirstFile = lieuxDirectory.addEmptyTextManager(document: textDocument)
//
//        let filesOutlineSetManager = documentManager.filesOutlineSetManager.value!
//        let filesOutlineManager = filesOutlineSetManager.filesOutlines.values.first!
//
//        filesOutlineManager.userSelectedItems.removeAll()  // removeUserSelectedItem(itemId: firstTextManager.id)
//        XCTAssert(filesOutlineManager.userSelectedItems.isEmpty)
//
//        filesOutlineManager.appendItemToExistingUserSelection(with: lieuxFirstFile.id)
//
//        XCTAssert(filesOutlineManager.userSelectedItems.count == 1)
//
//        filesOutlineManager.replaceUserSelectedItems(with: [filesGroup.id])
//    }
    
    func testMergeSelectedItems1() {
        
        StyloApplication.shared.loadApplicationTextStyleSetManager()
        let textDocument = try? TextDocument(type: "stylo")
        let documentManager = textDocument!.documentManager
        let sourceSetManager = documentManager!._sourceSetManager.value!
        
        var selectedTextManager: TextManager?
        
        // at this point there should be only one text manager
        // in the source set manager
        for directoryItemManager in sourceSetManager.directoryItemsManagersArray {
            if let textManager = directoryItemManager as? TextManager {
                selectedTextManager = textManager
            }
        }
        
        documentManager?.addUntitledTextAfter(selectedTextManager!)
        documentManager?.addUntitledTextAfter(selectedTextManager!)
        documentManager?.addUntitledTextAfter(selectedTextManager!)
        documentManager?.addUntitledTextAfter(selectedTextManager!)
        documentManager?.addUntitledTextAfter(selectedTextManager!)
        
        let array = sourceSetManager.directoryItemsManagersArray
        debugPrint("directoryItemsManagersArray: \(array)")
        
        //        let directoryManager = sourceSetManager.directoryItemsManagersArray.first as! DirectoryManager
        
        let firstTextManager = sourceSetManager.directoryItemsManagersArray[1] as! TextManager
        let secondTextManager = sourceSetManager.directoryItemsManagersArray[2] as! TextManager
        let thirdTextManager = sourceSetManager.directoryItemsManagersArray[3] as! TextManager
        
        let filesOutlineSetManager = documentManager!.filesOutlineSetManager.value!
        let filesOutlineManager = filesOutlineSetManager.filesOutlines.values.first!
        
        filesOutlineManager.userSelectedItems.removeAll()  // removeUserSelectedItem(itemId: firstTextManager.id)
        XCTAssert(filesOutlineManager.userSelectedItems.isEmpty)
        
        filesOutlineManager.appendItemToExistingUserSelection(with: secondTextManager.id)
        filesOutlineManager.appendItemToExistingUserSelection(with: thirdTextManager.id)
        
        XCTAssert(filesOutlineManager.userSelectedItems.count == 2)
        
        let mergedKeys = filesOutlineManager.mergeUserSelectedItems(with: [firstTextManager.id, secondTextManager.id, thirdTextManager.id], removedItemsIds: Set<String>())!
        
        XCTAssert(mergedKeys.count == 3)
    }

    func testMergeSelectedItems2() {
        
        let textDocument = try? TextDocument(type: "stylo")
        let documentManager = textDocument!.documentManager
        let sourceSetManager = documentManager!._sourceSetManager.value!
        
        var selectedTextManager: TextManager?
        
        // at this point there should be only one text manager
        // in the source set manager
        for directoryItemManager in sourceSetManager.directoryItemsManagersArray {
            if let textManager = directoryItemManager as? TextManager {
                selectedTextManager = textManager
            }
        }
        
        documentManager?.addUntitledTextAfter(selectedTextManager!)
        documentManager?.addUntitledTextAfter(selectedTextManager!)
        documentManager?.addUntitledTextAfter(selectedTextManager!)
        documentManager?.addUntitledTextAfter(selectedTextManager!)
        documentManager?.addUntitledTextAfter(selectedTextManager!)
        
        let array = sourceSetManager.directoryItemsManagersArray
        debugPrint("directoryItemsManagersArray: \(array)")
        
        //        let directoryManager = sourceSetManager.directoryItemsManagersArray.first as! DirectoryManager
        
        let firstTextManager = sourceSetManager.directoryItemsManagersArray[1] as! TextManager
        let secondTextManager = sourceSetManager.directoryItemsManagersArray[2] as! TextManager
        let thirdTextManager = sourceSetManager.directoryItemsManagersArray[3] as! TextManager
        
        let filesOutlineSetManager = documentManager!.filesOutlineSetManager.value!
        let filesOutlineManager = filesOutlineSetManager.filesOutlines.values.first!
        
        filesOutlineManager.userSelectedItems.removeAll()
        XCTAssert(filesOutlineManager.userSelectedItems.isEmpty)
        
        filesOutlineManager.filesOutlineStore.userSelectedItems.removeAll()
        XCTAssert(filesOutlineManager.filesOutlineStore.userSelectedItems.isEmpty)
        
        filesOutlineManager.appendItemToExistingUserSelection(with: secondTextManager.id)
        filesOutlineManager.appendItemToExistingUserSelection(with: thirdTextManager.id)
        
        XCTAssert(filesOutlineManager.userSelectedItems.count == 2)
        XCTAssert(filesOutlineManager.filesOutlineStore.userSelectedItems.count == 2)
        
        filesOutlineManager.shrinkUserSelectedItems(with: [firstTextManager.id, secondTextManager.id, thirdTextManager.id], removedItemsIds: Set<String>())
        
        XCTAssert(filesOutlineManager.userSelectedItems.count == 3)
    }

    func testMergeSelectedItems3() {
        
        let textDocument = try? TextDocument(type: "stylo")
        let documentManager = textDocument!.documentManager
        let filesOutlineSetManager = documentManager!.filesOutlineSetManager.value!
        let filesOutlineManager = filesOutlineSetManager.filesOutlines.values.first!
        
        let mergedItems = filesOutlineManager.mergeUserSelectedItems(with: [("AF050FDC-798D-4A40-B146-F39A32218051", 0), ("DE7D9719-0879-4E41-8E83-828C3DFCE349", 1)], existingItemsIds: [("DE7D9719-0879-4E41-8E83-828C3DFCE349", 1)], removedItemsIds: Set<String>())
        
        XCTAssert(mergedItems == ["AF050FDC-798D-4A40-B146-F39A32218051", "DE7D9719-0879-4E41-8E83-828C3DFCE349"])
    }
}
