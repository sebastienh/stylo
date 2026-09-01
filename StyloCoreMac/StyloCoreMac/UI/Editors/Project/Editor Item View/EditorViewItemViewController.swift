//
//  EditorViewItemViewController.swift
//  Stylo
//
//  Created by Sebastien Hamel on 2019-12-30.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa
import WriterCommon
import Common
import os

class EditorViewItemViewController: NSViewController {
    
    @IBOutlet var stackView: NSStackView!
    
    @IBOutlet var titleView: NSView!
    
    var editorView: NSView? {
        
        return projectTextEditorViewController?.view
    }
    
    var resourceEditorView: MarkdownResourceEditorView? {
        
        return projectTextEditorViewController?.resourceEditorView
    }
    
    var leftView: EditorSideView? {
        
        return nil
    }

    var rightView: EditorSideView? {
        
        return nil
    }
    
    var documentManager: DocumentManager?
    
    weak var filesOutlineManager: FilesOutlineManager?
    
    var collapsed: Bool {
        
        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: self.filesOutlineManager is nil")
            return false
        }

        guard let textManagerId = self.textManagerId else {
            assertionFailure("Error: self.textManagerId is nil")
            return false
        }
        
        return filesOutlineManager.isTextManagerCollapsed(with: textManagerId)
    }
    
    var textManagerId: String? {
        
        return textManager?.id
    }
    
    private var textEditor: ProjectTextEditor? {
        
        return projectTextEditorViewController?.resourceEditorView
    }
    
    private var textManager: TextManager? {
        
        return self.representedObject as? TextManager
    }
    
    var projectTextEditorViewController: ProjectTextEditorViewController?
    
    weak var editorsViewController: EditorsViewController?
    
    @IBAction func toggleEditor(_ sender: AnyObject?) {
        if self.collapsed {
            expand()
        }
        else {
            collapse()
        }
    }
    
    @IBAction func addTextManager(_ sender: Any?) {
        
        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: self.filesOutlineManager is nil")
            return
        }
        
        guard let textManagerId = self.textManagerId else {
            assertionFailure("Error: self.textManagerId is nil")
            return
        }
        
        filesOutlineManager.addTextManager(afterItemWithId: textManagerId)
    }
    
    override func viewDidLoad() {
        
        self.instantiateProjectTextEditorViewController()
        self.subscribeToCollapsedItems()
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
        
        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: self.filesOutlineManager  is nil")
            return
        }

        handleCollapsedItems(filesOutlineManager.collapsedEditorItems.values)
    }
    
    func desiredHeight(forWidth width: CGFloat) -> CGFloat {
                
        guard let textEditor = self.textEditor else {
            assertionFailure("Error: textEditor is nil")
            return 0
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Returning editor height: %@", log: Log.StyloCore.all, type: .debug, %%textEditor.intrinsicContentSize.height)
        #endif
        if collapsed {
            return 24.0
        }
        else {
            return textEditor.actualTextSize(withWidth: width).height
        }
    }
    
    func collapse() {
        
        guard let projectTextEditorViewController = self.projectTextEditorViewController else {
            assertionFailure("Error: self.projectTextEditorViewController is nil")
            return
        }
        
        if stackView.arrangedSubviews.count == 1 {
            stackView.removeArrangedSubview(projectTextEditorViewController.view)
        }
    }
    
    func expand() {
        
        guard let projectTextEditorViewController = self.projectTextEditorViewController else {
            assertionFailure("Error: self.projectTextEditorViewController is nil")
            return
        }
        
        if stackView.arrangedSubviews.count == 0 {
            stackView.insertArrangedSubview(projectTextEditorViewController.view, at: 0)
        }
        
        WriterNotification.didChangeTemporaryAttributes.sendNotification(self.resourceEditorView)
    }
    
    private func instantiateProjectTextEditorViewController() {
    
        guard let textManager = self.textManager else {
            assertionFailure("Error: self.textManager is nil.")
            return
        }
        
        let bundle = Bundle(for: EditorViewItemViewController.self)
        let projectTextEditorStoryboard = NSStoryboard(name: NSStoryboard.Name("ProjectTextEditor"), bundle: bundle)
        
        guard let projectTextEditorViewController = projectTextEditorStoryboard.instantiateInitialController() as? ProjectTextEditorViewController else {
            assertionFailure("Error: projectTextEditorStoryboard is nil")
            return
        }
        
        projectTextEditorViewController.representedObject = textManager
        assert(self.editorsViewController != nil)
        projectTextEditorViewController.editorsViewController = self.editorsViewController
        projectTextEditorViewController.filesOutlineManager = self.filesOutlineManager
        let view = projectTextEditorViewController.view
        self.projectTextEditorViewController = projectTextEditorViewController
        self.stackView.insertArrangedSubview(view, at: 0)
        
        let views = ["view": projectTextEditorViewController.view]
        
        let horizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[view]|",
            metrics: nil,
            views: views)
        
        self.stackView.addConstraints(horizontalConstraints)
    }
    
    private func subscribeToCollapsedItems() {
        
        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: self.filesOutlineManager  is nil")
            return
        }
        
        handleCollapsedItems(filesOutlineManager.collapsedEditorItems.values)
        filesOutlineManager.collapsedEditorItems.subscribe({ [weak self](setChange) in
            switch setChange {
            case .deletes(_, let updatedSet):
                self?.handleCollapsedItems(updatedSet)
            case .inserts(_, let updatedSet):
                self?.handleCollapsedItems(updatedSet)
            }
        }, observer: self)
    }
    
    private func handleCollapsedItems(_ collapsedItems: Set<String>) {
        
        guard let textManagerId = self.textManagerId else {
            assertionFailure("Error: self.textManagerId is nil")
            return
        }
        
        if !collapsedItems.contains(textManagerId) {
            self.expand()
        }
        else {
            self.collapse()
        }
    }
    
    private func unsubscribeToCollapsedItems() {
     
        filesOutlineManager?.collapsedEditorItems.unsubscribe(observer: self)
    }
    
    deinit {
        unsubscribeToCollapsedItems()
    }
}
