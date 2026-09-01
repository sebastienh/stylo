//
//  StyloDocumentController.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-06-11.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon
import Common
import os

public class StyloDocumentController: NSDocumentController {
    
    private var loadingWindowControllers: [String: NSWindowController]
    
    @discardableResult
    public override init() {
        self.loadingWindowControllers = [String: NSWindowController]()
        super.init()
    }
    
    @discardableResult
    required init?(coder: NSCoder) {
        self.loadingWindowControllers = [String: NSWindowController]()
        super.init(coder: coder)
    }
    
    public override func makeDocument(withContentsOf url: URL, ofType typeName: String) throws -> NSDocument {
        
//        let documentName = self.documentName(from: url)
//        showLoadingWindow(with: documentName)
//        defer {
//            hideLoadingWindow(with: documentName)
//        }
        return try super.makeDocument(withContentsOf: url, ofType: typeName)
    }
    
    // we leave this here in case we need it for document restoration loading window
    // but it is not used for now.
//    private func showLoadingWindow(with filename: String) {
//
//        DispatchQueue.main.async {
//            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
//            os_log("Showing loading window.", log: Log.StyloCore.all, type: .info)
//            #endif
//
//            let bundle = Bundle(for: MacStyloDocument.self)
//            let storyboard = NSStoryboard(name: NSStoryboard.Name(string: "DocumentLoadingActivity"), bundle: bundle)
//            let documentLoadingWindowController = storyboard.instantiateInitialController() as! DocumentLoadingWindowController
//            assert(documentLoadingWindowController.window != nil)
//            self.loadingWindowControllers[filename] = documentLoadingWindowController
//            documentLoadingWindowController.documentLoadViewController?.filename = filename
//            documentLoadingWindowController.window?.center()
//            documentLoadingWindowController.window?.isMovableByWindowBackground = true
//            documentLoadingWindowController.window?.makeKeyAndOrderFront(self)
//        }
//    }
//
//    private func hideLoadingWindow(with filename: String) {
//
//        DispatchQueue.main.async {
//            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
//            os_log("Hiding loading window.", log: Log.StyloCore.all, type: .info)
//            #endif
//            assert(self.loadingWindowControllers[filename] != nil)
//            if let loadingWindowController = self.loadingWindowControllers[filename] {
//                loadingWindowController.window?.orderOut(self)
//            }
//        }
//    }
    
    private func documentName(from url: URL) -> String {
        
        let lastPathComponent = url.lastPathComponent as NSString
        return lastPathComponent.deletingPathExtension
    }
    
    private func isDocumentOpened(at url: URL) -> Bool {
        
        for document in documents {
            if let fileURL = document.fileURL, url == fileURL {
                return true
            }
        }
        return false
    }
    
    
}
