//
//  IssuesReporterViewController.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2016-01-15.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon
import StyloCoreMac
import Common
import os

final class IssuesReporterViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate, ErrorRenderingComponent {
    
    var failable: Failable! {

        return representedObject as! Failable?
    }
    
    @objc dynamic var hasErrors: Bool = false
    
    @IBOutlet var issuesTableView: IssuesReporterTableView!
    
    @IBOutlet var scrollView: NSScrollView!
    
    var editorSplitViewController: EditorSplitViewController? {
        
        var responder = self.nextResponder
        while responder != nil {
            if let editorSplitViewController = responder as? EditorSplitViewController {
                return editorSplitViewController
            }
            responder = responder?.nextResponder
        }
        return nil
    }
    
    var editorId: EditorId? {
        
        return self.editorSplitViewController?.editorId
    }
    
    private var selectedRow: Int?
    
    weak var documentManager: DocumentManager?
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
    }
    
    override func viewWillAppear() {
        
        super.viewWillAppear()
        scrollView.backgroundColor = InterfaceConstants.IssuesReporter.TableViewBackgroundColor
    }
    
    override func viewDidAppear() {
        
        super.viewDidAppear()
        
        listenToScrollViewDidEndLiveScroll()
//        failable.highlightAllErrors()
//        listenToTextBackgroundColor()
    }

    override func viewWillDisappear() {
        
        super.viewWillDisappear()
        NotificationCenter.default.removeObserver(self)
//        failable.clearErrorHighlight()
    }
    
    private func listenToScrollViewDidEndLiveScroll() {
    
        NotificationCenter.default.addObserver(forName: NSScrollView.didEndLiveScrollNotification, object: scrollView, queue: nil) { [weak self](notification: Notification) in
                          
            guard let editorId = self?.editorId else {
                assertionFailure("Error: self.editorId is nil")
                return
            }
            
            self?.failable.highlightAllErrors(forEditorWithId: editorId)
            self?.unselectCurrentSelection()
        }
    }
    
    func select(row index: Int) {
    
        assert(index < failable.issuesCount)
        let rowView = issuesTableView.view(atColumn: 0, row: index, makeIfNecessary: true) as! IssuesReporterTableCellView
        
        rowView.selected = true
        selectedRow = index
    }
    
    func unselectCurrentSelection() {
        
        if let selectedRow = selectedRow {
        
            // if the selection has not disappeared
            if selectedRow < failable.issuesCount {
            
                let selectRowView = issuesTableView.view(atColumn: 0, row: selectedRow, makeIfNecessary: true) as! IssuesReporterTableCellView
                selectRowView.selected = false
            }
            self.selectedRow = nil
        }
        
        if issuesTableView.selectedRow > 0 {
            issuesTableView.deselectAll(nil)
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ErrorRenderingComponent protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func reloadErrors() {
        
        issuesTableView.reloadData()
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: NSTableViewDataSource protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func numberOfRows(in aTableView: NSTableView) -> Int {
        if let failable = failable {
            return failable.issuesCount
        }
        return 0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        if let failable = self.failable, row < failable.issuesCount {
            
            let cellView = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self)
            
            assert(cellView != nil)
            assert(cellView! is IssuesReporterTableCellView)
            if let errorReporterTableCelleView = cellView as? IssuesReporterTableCellView {
                
                assert(tableColumn != nil)
                if let tableColumn = tableColumn, tableColumn.identifier == NSUserInterfaceItemIdentifier(rawValue: "Errors") {
                    
                    let errorMessage: Message = failable[row]
                    errorReporterTableCelleView.label.stringValue = "\u{25CF}"
                    errorReporterTableCelleView.resetState()
                    assert(errorReporterTableCelleView.message != nil)
                    errorReporterTableCelleView.message?.stringValue = errorMessage.localizedMessage.firstLine
                    errorReporterTableCelleView.labelColor = self.color(for: errorMessage)
//                    errorReporterTableCelleView.labelFont = self.font(for: errorMessage)
                    errorReporterTableCelleView.messageId = errorMessage.uuid
                    if let selectedRow = selectedRow {
                        errorReporterTableCelleView.selected = selectedRow == row
                    }
                    errorReporterTableCelleView.failable = failable
                }
                else {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("Unknown table column: %@", log: Log.StyleEditor.all, type: .error, %%tableColumn!.identifier)
                    #endif
                }
            }
            return cellView
        }
        return nil
    }
//
//    private func font(for message: Message) -> NSFont {
//
//        switch message.messageSeverity {
//        case .Emergency: fallthrough
//        case .Alert: fallthrough
//        case .Critical: fallthrough
//        case .Error: fallthrough
//        case .Warning: fallthrough
//        case .Notice: fallthrough
//        case .Informational: fallthrough
//        case .Debug:
//            return NSFont(name: "Helvetica Neue", size: 16.0)!
//        }
//    }
    
    private func color(for message: Message) -> NSColor {
        
        switch message.messageSeverity {
        case .Emergency:
            return NSColor.systemRed // nsColor(named: "StyloRed")
        case .Alert:
            return NSColor.systemRed //nsColor(named: "StyloRed")
        case .Critical:
            return NSColor.systemRed // nsColor(named: "StyloRed")
        case .Error:
            return NSColor.systemRed // nsColor(named: "StyloRed")
        case .Warning:
            return NSColor.systemYellow // nsColor(named: "StyloYellow")
        case .Notice:
            return NSColor.systemYellow // nsColor(named: "StyloYellow")
        case .Informational:
            return NSColor.systemYellow // nsColor(named: "StyloYellow")
        case .Debug:
            return NSColor.systemYellow // nsColor(named: "StyloYellow")
        }
    }
    
    fileprivate func attributedString(for errorMessage: Message) -> NSAttributedString {
        
        let color: NSColor
        let text: String
        
        switch errorMessage.messageSeverity {
            
        case .Emergency:
            
            color = NSColor.systemRed
            text = "!"
            
        case .Alert:
            
            color = NSColor.systemRed
            text = "!"
            
        case .Critical:
            
            color = NSColor.systemRed
            text = "!"
            
        case .Error:
            
            color = NSColor.systemRed
            text = "!"
            
        case .Warning:
            
            color = NSColor.systemYellow
            text = "!"
            
        case .Notice:
            
            color = NSColor.systemRed
            text = "!"
            
        case .Informational:
            
            color = NSColor.systemRed
            text = "!"
            
        case .Debug:
            
            color = NSColor.systemRed
            text = "!"
        }
        
        return NSAttributedString(string: text, attributes: [
            NSAttributedString.Key.font : NSFont(name: "Courrier", size: 13.0) as Any,
            NSAttributedString.Key.foregroundColor: color
        ])
    }
    
    fileprivate func imageForErrorMessage(_ errorMessage: Message) -> NSImage {
        switch errorMessage.messageSeverity {
        case .Emergency: return NSImage(named: NSImage.Name(string: "emergency_image.png"))!
        case .Alert: return NSImage(named: NSImage.Name(string: "alert_image.png"))!
        case .Critical: return NSImage(named: NSImage.Name(string: "critical_image.png"))!
        case .Error: return NSImage(named: NSImage.Name(string: "error-symbol"))!
        case .Warning: return NSImage(named: NSImage.Name(string: "warning-symbol"))!
        case .Notice: return NSImage(named: NSImage.Name(string: "notice_image.png"))!
        case .Informational: return NSImage(named: NSImage.Name(string: "info_image.png"))!
        case .Debug: return NSImage(named: NSImage.Name(string: "debug_image.png"))!
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: NSTableViewDelegate protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    
    /// FIXME: This method should not be needed fot an ordinary array
    /// but there seem to have a problem with framework.
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        
        return 26.0
    }
    
}
