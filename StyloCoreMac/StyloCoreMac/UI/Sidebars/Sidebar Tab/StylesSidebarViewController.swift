//
//  StylesSidebarViewController.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-11-19.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon
import Common
import os

class StylesSidebarViewController: NSViewController {
    
    @IBOutlet var progressBar: ProgressBar!
    
    @IBOutlet var markdownToolsSidebarButton: NSButton!
    
    @IBOutlet var tableView: NSTableView! {
        didSet {
            tableView?.intercellSpacing = NSMakeSize(0, 0)
        }
    }
    
    @IBOutlet var stylesScrollView: NSScrollView!
    
    @IBOutlet var scrollViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var markdownToolsSidebarButtonVerticalTopSpaceConstraint: NSLayoutConstraint!
    
    @IBOutlet var styleScrollViewVerticalTopSpaceConstraint: NSLayoutConstraint!
    
    @IBOutlet var styleScrollViewVerticalBottomSpaceConstraint: NSLayoutConstraint!
    
    @IBOutlet var progressBatVerticalBottomSpaceConstraint: NSLayoutConstraint!
    
    @IBOutlet var scrollViewVerticalCenterConstraint: NSLayoutConstraint!
    
    var styleSetManager: StyleSetManager? {
        
        return documentManager?.styleSetManager
    }
 
    weak var documentManager: DocumentManager?
    
    var enabled: Bool = true
    
    private var sidebarStyleTableCellViews: [String: SidebarStyleTableCellView] = [:]
    
    private var tableViewHeight: CGFloat? {
        
        assert(self.styleSetManager != nil)
        if let styleSetManager = self.styleSetManager {
         
            let rowHeight = self.tableView(tableView, heightOfRow: 0)
            let height = (rowHeight + tableView.intercellSpacing.height) * CGFloat(styleSetManager.stylesCount)
            return height
        }
        return nil
    }
    
    private var scrollViewAvailableVerticalSpace: CGFloat {
        
        var totalAvailableVerticalSpace = self.view.bounds.size.height
        
        totalAvailableVerticalSpace -= markdownToolsSidebarButtonVerticalTopSpaceConstraint.constant
        totalAvailableVerticalSpace -= markdownToolsSidebarButton.frame.height
        totalAvailableVerticalSpace -= styleScrollViewVerticalTopSpaceConstraint.constant
        totalAvailableVerticalSpace -= styleScrollViewVerticalBottomSpaceConstraint.constant
        totalAvailableVerticalSpace -= progressBar.frame.height
        // this consraint is negative
        totalAvailableVerticalSpace += progressBatVerticalBottomSpaceConstraint.constant
        
        return totalAvailableVerticalSpace
    }
    
    @IBAction func styleButtonClicked(_ sender: AnyObject?) {
        
        if enabled {
            let styleButton = sender as? NSView
            
            assert(styleButton != nil)
            if let styleButton = styleButton {
            
                let cellView = styleButton.superview as? SidebarStyleTableCellView
                
                assert(cellView != nil)
                assert(self.windowController != nil)
                if let cellView = cellView {
                
                    let rowIndex = self.tableView.row(for: cellView)
                    windowController?.selectStyle(at: rowIndex)
                }
            }
        }
    }
    
    override func viewWillAppear() {
        
        subscribeToDocumentManager()
        
        stylesScrollView.contentView.postsBoundsChangedNotifications = true
        stylesScrollView.contentView.postsFrameChangedNotifications = true
        
        NotificationCenter.default.addObserver(forName: NSView.boundsDidChangeNotification, object: stylesScrollView.contentView, queue: nil) { [weak self](notification) in
            
            if let clipView = notification.object as? NSClipView {
                self?.updateProgressBarScroller(clipView: clipView)
            }
        }
        
        NotificationCenter.default.addObserver(forName: NSView.frameDidChangeNotification, object: stylesScrollView.contentView, queue: nil) { [weak self](notification) in
            
            if let clipView = notification.object as? NSClipView {
                self?.updateProgressBarScroller(clipView: clipView)
            }
        }
        
        self.view.postsFrameChangedNotifications = true
        
        NotificationCenter.default.addObserver(forName: NSView.frameDidChangeNotification, object: self.view, queue: nil) { [weak self](notification) in
            
            assert(self?.tableViewHeight != nil)
            if let tableViewHeight = self?.tableViewHeight {
                
                self?.manageProgressBarHiddenState(forScrollViewHeight: tableViewHeight)
            }
        }
        
        self.tableView.reloadData()
        self.layoutStylesScrollView()
        
        super.viewWillAppear()
    }
    
    private func disableUserInteractions() {
                
        fatalError()
    }
    
    private func enableUserInteractions() {
        
        fatalError()
    }

    private func subscribeToDocumentManager() {
        
        if self.documentManager?.userInteractionsEnabled.subscribed(observer: self) == false {
            
            self.documentManager?.userInteractionsEnabled.subscribe({ [weak self](userInteractionsEnabled) in
                if userInteractionsEnabled {
                    self?.enableUserInteractions()
                }
                else {
                    self?.disableUserInteractions()
                }
            }, observer: self)
        }
    }
    
    private func unsubscribeFromDocumentManager() {
    
        self.documentManager?.userInteractionsEnabled.unsubscribe(observer: self)
    }
    
    func sidebarStyleTableCellView(for styleName: String, tableColumn: NSTableColumn?) -> SidebarStyleTableCellView? {
        
        if let sidebarStyleTableCellView = sidebarStyleTableCellViews[styleName] {
            return sidebarStyleTableCellView
        }
        
        guard let sidebarStyleTableCellView = createSidebarStyleTableCellView(for: styleName, tableColumn: tableColumn) else {
            assertionFailure("Error: created sidebarStyleTableCellView is nil")
            return nil
        }
        
        sidebarStyleTableCellViews[styleName] = sidebarStyleTableCellView
        return sidebarStyleTableCellView
    }
    
    func createSidebarStyleTableCellView(for styleName: String, tableColumn: NSTableColumn?) -> SidebarStyleTableCellView? {
        
        guard let tableColumn = tableColumn else{
            assertionFailure("Error: tableColumn is nil")
            return nil
        }
        
        let cellView = tableView.makeView(withIdentifier: tableColumn.identifier, owner: self) as! SidebarStyleTableCellView
        
        assert(self.styleSetManager != nil)
        if let styleManager = styleSetManager?.styleManagerByName(styleName) {
            
            cellView.update(with: styleManager)
            cellView.styleButton.action = #selector(styleButtonClicked(_:))
            cellView.styleButton.target = self
            cellView.styleButton.isEnabled = self.enabled
            return cellView
        }
        return nil
    }
    
    func disableAllButtons() {
        
        self.enabled = false
        
        for (_, cellView) in self.sidebarStyleTableCellViews {
            cellView.styleButton.isEnabled = false
        }
        
        markdownToolsSidebarButton?.isEnabled = false
    }
    
    func enableAllButtons() {
        
        self.enabled = true 
        
        for (_, cellView) in self.sidebarStyleTableCellViews {
            cellView.styleButton.isEnabled = true
            cellView.styleButton.updateAppearance()
        }
        
        markdownToolsSidebarButton?.isEnabled = true
    }
    
    private func updateProgressBarScroller(clipView: NSClipView) {
        
        let start = clipView.bounds.origin.y/self.tableView.frame.height
        let end = (clipView.bounds.origin.y + clipView.bounds.size.height)/self.tableView.frame.height
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("clipView.bounds.origin.y: %@", %%clipView.bounds.origin.y)
        os_log("self.tableView.frame.height: %@", %%self.tableView.frame.height)
        os_log("clipView.bounds.size.height: %@", %%clipView.bounds.size.height)
        #endif
        
        self.progressBar.percentRange = (start, end)
    }
    
    private func layoutStylesScrollView() {
        
        assert(self.tableViewHeight != nil)
        assert(self.styleSetManager != nil)
        if let styleSetManager = self.styleSetManager, let tableViewHeight = self.tableViewHeight {
            
            if styleSetManager.stylesCount > 0 {
                
                stylesScrollView.isHidden = false
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Styles table row number is %d", styleSetManager.stylesCount)
                os_log("Setting styles table view height to %f", tableViewHeight)
                os_log("Setting styles table intercell spacing height to %f", tableView.intercellSpacing.height)
                #endif
                
                if scrollViewHeightConstraint.constant != tableViewHeight {
                    
                    setTableViewHeight(tableViewHeight)
                    manageProgressBarHiddenState(forScrollViewHeight: tableViewHeight)
                
                    if !progressBar.isHidden {
                        scrollViewVerticalCenterConstraint.isActive = false
                        stylesScrollView.verticalScrollElasticity = .allowed
                    }
                    else {
                        scrollViewVerticalCenterConstraint.isActive = true
                        stylesScrollView.verticalScrollElasticity = .none
                    }
                    self.view.needsUpdateConstraints = true
                }
            }
            else {
                
                stylesScrollView.isHidden = true
            }
        }
    }
    
    private func manageProgressBarHiddenState(forScrollViewHeight height: CGFloat) {
        
        if height > scrollViewAvailableVerticalSpace {
            
            self.progressBar.isHidden = false
            scrollViewVerticalCenterConstraint.isActive = false
            stylesScrollView.verticalScrollElasticity = .allowed
        }
        else {
            self.progressBar.isHidden = true
            scrollViewVerticalCenterConstraint.isActive = true
            stylesScrollView.verticalScrollElasticity = .none
        }
        self.view.needsUpdateConstraints = true
    }
    
    /// Method to set the table view height.
    private func setTableViewHeight(_ tableHeight: CGFloat) {
        
        os_log("Setting styles table height to %f", tableHeight)
        scrollViewHeightConstraint.constant = tableHeight
    }
}
