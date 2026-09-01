//
//  StylesheetsViewController.swift
//  StyleEditorPlugin
//
//  Created by Sebastien Hamel on 2020-08-17.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Foundation
import Common
import WriterCommon
import StyloCoreMac
import os

class StylesheetsViewController: NSViewController {

    @IBOutlet var stylesheetsTableView: StylesheetsTableView? {
        didSet {
            stylesheetsTableView?.registerForDraggedTypes([StyloConstants.DragTypes.StylesheetType])
        }
    }
    
    var styleManager: StyleManager? {
        return self.representedObject as? StyleManager
    }
    
    private var styleViewController: StyleViewController? {
        
        var responder: NSResponder? = self.nextResponder
        while responder != nil {
            if let styleViewController = responder as? StyleViewController {
                return styleViewController
            }
            responder = responder?.nextResponder
        }
        return nil
    }
    
    var dragOperationInProgress: Bool = false
    
    var stylesheetViewControllers: [StylesheetId: StylesheetItemViewController] = [:]
    
    @IBOutlet var stylesheetsTableViewContainerView: StylesheetsTableViewContainerView?
    
    @IBOutlet var scrollViewHeightConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
    }
    
    func delete(stylesheetWithId id: StylesheetId) {
        
        guard let stylesheetsTableView = self.stylesheetsTableView else {
            assertionFailure("Error: self.stylesheetsTableView is nil")
            return
        }
        
        guard let index = self.styleManager?.deleteStylesheet(withId: id) else {
            // stylo #1157
            // if the index is not there we simply ignore the UI event
            return
        }
        
        stylesheetsTableView.beginUpdates()
        let indexes = IndexSet(arrayLiteral: index-1)
        stylesheetsTableView.removeRows(at: indexes, withAnimation: .effectFade)
        self.stylesheetsTableView?.endUpdates()
        self.styleViewController?.hasPendingChanges = true
    }
    
    func appendStylesheet() {
        
        guard let stylesheetsTableView = self.stylesheetsTableView else {
            assertionFailure("Error: self.stylesheetsTableView is nil")
            return
        }
        
        let numberOfRowsBefore = self.numberOfRows(in: stylesheetsTableView)
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("numberOfRowsBefore: %@", log: Log.StyleEditor.all, type: .info, %%numberOfRowsBefore)
        #endif
        
        let selectedCssStyleManager = StyloApplication.shared.cssStyleSetManager.selectedStyleManager.value
        assert(selectedCssStyleManager != nil)
        self.styleManager?.addEmptyStylesheet(stylingManager: selectedCssStyleManager)
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        let numberOfRowsAfter = self.numberOfRows(in: stylesheetsTableView)
        os_log("numberOfRowsAfter: %@", log: Log.StyleEditor.all, type: .info, %%numberOfRowsAfter)
        #endif
        
        stylesheetsTableView.beginUpdates()
        let indexes = IndexSet(arrayLiteral: numberOfRowsBefore)
        stylesheetsTableView.insertRows(at: indexes, withAnimation: .slideDown)
        self.stylesheetsTableView?.endUpdates()
    }
    
    private func setupTableView() {
        
        guard let stylesheetsTableView = self.stylesheetsTableView else {
            assertionFailure("Error: stylesheetsTableView is nil")
            return
        }
        
        stylesheetsTableView.dataSource = self
        stylesheetsTableView.delegate = self
        
        stylesheetsTableView.postsFrameChangedNotifications = true

        NotificationCenter.default.addObserver(forName: NSView.frameDidChangeNotification, object: self.stylesheetsTableView, queue: nil) { [weak self](_) in

            self?.scrollViewHeightConstraint?.constant = stylesheetsTableView.frame.height
        }
    }
    
}
