//
//  GroupProjectOutlineCellView.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-08-07.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa
import WriterCommon
import Common

final class GroupProjectOutlineCellView: ProjectOutlineCellView {
    
    override var acceptsFirstResponder: Bool {
        return true
    }
    
    @objc dynamic var isExpanded: Bool = false {
        didSet {
            if isExpanded {
                title = "Hide"
            }
            else {
                title = "Show"
            }
        }
    }
    
    @objc dynamic var title: String = "Show"
    
    override var filesOutlineManager: FilesOutlineManager? {
        willSet {
            self.filesOutlineManager?.expandedItems.unsubscribe(observer: self)
        }
        didSet {
            subscribeToExpandedItems()
        }
    }
    
    @IBOutlet var showHideButton: NSButton? {
        didSet {
            showHideButton?.isHidden = true
        }
    }
    
    private var mouseOver: Bool = false {
        didSet {
            self.updateShowHideButtonHiddenState()
        }
    }
    
    override var selected: Bool {
        didSet {
            self.updateShowHideButtonHiddenState()
        }
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        createTrackingArea()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        createTrackingArea()
    }
    
    override public func updateState() {
        
        super.updateState()
        
        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: setting nil to self.filesOutlineManager")
            return
        }
        handleExpandedItems(filesOutlineManager.expandedItems.values)
    }

    override func mouseMoved(with event: NSEvent) {
        super.mouseMoved(with: event)
        self.mouseOver = true
    }
    
    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        self.mouseOver = true
    }
    
    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        self.mouseOver = false
    }
    
    private func createTrackingArea() {
        
        self.addTrackingArea(NSTrackingArea(rect: .zero, options: NSTrackingArea.Options.inVisibleRect.union(.activeInKeyWindow).union(.mouseEnteredAndExited).union(.mouseMoved), owner: self, userInfo: nil))
    }
    
    private func subscribeToExpandedItems() {
        
        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: setting nil to self.filesOutlineManager")
            return
        }
        
        filesOutlineManager.expandedItems.subscribe({ [weak self](setChange) in
            switch setChange {
            case .deletes(_, let updatedSet):
                self?.handleExpandedItems(updatedSet)
            case .inserts(_, let updatedSet):
                self?.handleExpandedItems(updatedSet)
            }
        }, observer: self)
    }
    
    private func handleExpandedItems( _ expandedItems: Set<String>) {
        
        guard let projectOutlineItem = self.projectOutlineItem else {
            assertionFailure("Error: self.projectOutlineItem is nil")
            return
        }
        
        if expandedItems.contains(projectOutlineItem.id) {
            self.isExpanded = true
        }
        else {
            self.isExpanded = false
        }
    }
    
    private func updateShowHideButtonHiddenState() {
        
        if self.selected {
            showHideButton?.isHidden = false
        }
        else {
            if self.mouseOver {
                showHideButton?.isHidden = false
            }
            else {
                showHideButton?.isHidden = true
            }
        }
    }
    
    deinit {
        self.filesOutlineManager?.expandedItems.unsubscribe(observer: self)
    }
}
