//
//  ProjectOutlineCellView.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-08-06.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa
import WriterCommon
import Common


class ProjectOutlineCellView: NSTableCellView {
    
    weak var parentProjectOutlineViewController: ProjectOutlineViewController?
    
    var projectOutlineItem: ProjectOutlineItem? {
        willSet {
            projectOutlineItem?.name.unsubscribe(observer: self)
        }
        didSet {
            projectOutlineItem?.name.subscribe({ [weak self](newName) in
                if newName != self?.textField?.stringValue {
                    self?.textField?.stringValue = newName
                }
            }, observer: self)
        }
    }
    
    var selected: Bool = false
    
    override var textField: NSTextField? {
        didSet {
            if let textField = textField {

                NotificationCenter.default.addObserver(forName: NSControl.textDidEndEditingNotification, object: textField, queue: nil) { [weak self](notification) in
                    self?.controlTextDidChange(notification)
                }
            }
        }
    }
    
    private var textColor: NSColor {
        get {
            let appearanceName = self.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua])
            switch appearanceName {
            case .darkAqua?:
                return NSColor.controlTextColor
            case .aqua?:
                if self is GroupProjectOutlineCellView {
                    return NSColor(named: NSColor.Name(string: "PrimaryOutlineItemColor"))!
                }
                else {
                    return NSColor(calibratedRed: 76/255, green: 76/255, blue: 76/255, alpha: 1)
                }
            default:
                assert(false)
                return NSColor.controlTextColor
            }
        }
    }
    
    var filesOutlineManager: FilesOutlineManager? {
        willSet {
            self.filesOutlineManager?.userSelectedItems.unsubscribe(observer: self)
        }
        didSet {
            subscribeToUserSelectedItems()
        }
    }
    
    // see https://stackoverflow.com/questions/11268631/how-to-change-nstextfield-text-color-on-row-selection/12008103
    override var backgroundStyle: NSView.BackgroundStyle {
        get {
            return super.backgroundStyle
        }
        set {
            super.backgroundStyle = .normal
        }
    }
    
    override func viewDidChangeEffectiveAppearance() {
        textField?.textColor = textColor
        self.needsLayout = true
        super.viewDidChangeEffectiveAppearance()
    }
    
    private func subscribeToUserSelectedItems() {
        
        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: setting nil to self.filesOutlineManager")
            return
        }
        self.updateSelected()
        filesOutlineManager.userSelectedItems.subscribe({ [weak self](change) in
            self?.handleUserSelectedItems(change)
            }, observer: self)
    }
    
    private func handleUserSelectedItems(_ change: DynamicOrderedSet<String>.Change) {
        
        guard let projectOutlineItem = self.projectOutlineItem else {
            assertionFailure("Error: self.projectOutlineItem is nil")
            return
        }
        
        switch change {
        case .insert(let newElement, _, _):
            if !self.selected {
                if newElement == projectOutlineItem.id {
                    self.selected = true
                }
            }
        case .inserts(let newElements, _, _):
            if !self.selected {
                for newElement in newElements {
                    if newElement == projectOutlineItem.id {
                        self.selected = true
                    }
                }
            }
        case .deletes(_, let deletedValues, _):
            if self.selected {
                for deletedValue in deletedValues {
                    if deletedValue == projectOutlineItem.id {
                        self.selected = false
                    }
                }
            }
        case .move: fallthrough
        case .start:
            break
        case .end(let updatedArray):
            //            #if DEBUG
            var shouldBeSelected = false
            for item in updatedArray {
                if item == projectOutlineItem.id {
                    shouldBeSelected = true
                }
            }
            //            assert(shouldBeSelected == self.selected)
            self.selected = shouldBeSelected
            //            #endif
            return
        }
    }
    
    public func updateState() {
        
        self.updateSelected()
        self.startListeningToNavigationNotifications()
    }
    
    private var navigating: Bool = false
    
    private var willNavigateInHistoryObserver: NSObjectProtocol?
    
    private var didNavigateInHistoryObserver: NSObjectProtocol?
    
    private func startListeningToNavigationNotifications() {
        
        if let willNavigateInHistoryObserver = self.willNavigateInHistoryObserver {
            NotificationCenter.default.removeObserver(willNavigateInHistoryObserver)
        }

        if let didNavigateInHistoryObserver = self.didNavigateInHistoryObserver {
            NotificationCenter.default.removeObserver(didNavigateInHistoryObserver)
        }
        
        self.willNavigateInHistoryObserver = NotificationCenter.default.addObserver(forName: StyloNotification.willNavigateInHistory.name, object: nil, queue: nil, using: { [weak self](_) in
            self?.navigating = true
        })
        
        self.didNavigateInHistoryObserver = NotificationCenter.default.addObserver(forName: StyloNotification.didNavigateInHistory.name, object: nil, queue: nil, using: { [weak self](_) in
            self?.navigating = false
        })
    }
    
    
    @objc func controlTextDidChange(_ obj: Notification) {
        
        let textField: NSTextField = obj.object as! NSTextField
        
        guard let projectOutlineItem = self.projectOutlineItem else {
            assertionFailure("Error: self.projectOutlineItem is nil")
            return
        }
        
        do {
            try projectOutlineItem.rename(to: textField.stringValue)
        }
        catch let error {
            
            switch error {
            case let renameError as RenameError:
                
                if !navigating {
                    
                    let windowController = self.window?.windowController as? StyloWindowController
                    windowController?.notifyRenameError(error: renameError) {
                        
                        // put back the old value
                        textField.stringValue = projectOutlineItem.stringValue
                        textField.selectText(nil)
                    }
                }
                else {
                    
                    // put back the old value
                    textField.stringValue = projectOutlineItem.stringValue
                }
            default:
                assertionFailure("Error: unhandled error type: \(error)")
            }
        }
    }
    
    func updateSelected() {
        
        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: setting nil to self.filesOutlineManager")
            return
        }
        
        let change = DynamicOrderedSet<String>.Change.inserts(newElements: filesOutlineManager.userSelectedItems.values, indexes: Array(0..<filesOutlineManager.userSelectedItems.values.count), updatedOrderedSet: filesOutlineManager.userSelectedItems.values)
        
        handleUserSelectedItems(change)
        
        // trig validation in debug
        handleUserSelectedItems(DynamicOrderedSet<String>.Change.end(updatedOrderedSet: filesOutlineManager.userSelectedItems.values))
    }
    
    deinit {
        projectOutlineItem?.name.unsubscribe(observer: self)
        NotificationCenter.default.removeObserver(self)
    }
}
