//
//  EditorViewController.swift
//  MacWriterCommon
//
//  Created by Sebastien Hamel on 2020-01-01.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon
import Web
import Common

fileprivate enum ToolType {
    
    case none
    case styles
    case htmlPreview
}

/// The editor view controller is responsible for managing all task related
/// to the editor:
///  - text editor itself
///  - message side view
///  - statistics bar at the bottom
///
/// This is also the editor as a whole... meaning that any background
/// color set for the displayed document should be reflected here.
open class EditorViewController: NSViewController {
    
    public weak var editableManager: AnyEditable?
    
    public var resourceEditorView: ResourceEditorView!
    
    @objc dynamic var showErrorsTool: Bool = false
    
    @objc dynamic var showHtmlPreviewAndStylesButtons: Bool = true
    
    @IBOutlet var showToolsButton: NSButton!
    
    @IBOutlet var showThemeChooserButton: NSButton!
    
    fileprivate var displayedTool: ToolType = .none
    
    @IBOutlet public var textContainerView: TextContainerView!
    
    @IBOutlet public var resourceEditorScrollView: EditorSynchronizedScrollView!
    
    public var editorViewInitialized: Bool = false
    
    private var editor: ResourceEditorView {
        
        return resourceEditorScrollView.documentView as! ResourceEditorView
    }
    
    var editorDelegate: ResourceEditorDelegate!
    
    open func initEditorScrollViewScroller() {
        
        assert(Thread.isMainThread)
        resourceEditorScrollView.verticalScroller = HiddenScroller()
        resourceEditorScrollView.borderType = NSBorderType.noBorder
        resourceEditorScrollView.hasVerticalScroller = true
        resourceEditorScrollView.hasHorizontalScroller = false
        resourceEditorScrollView.needsDisplay = true
    }

    public func hideEditorVerticalScroller() {
        
        assert(resourceEditorScrollView.verticalScroller != nil)
        resourceEditorScrollView.hasVerticalScroller = false
    }
    
    public func showEditorVerticalScroller() {
        
        assert(resourceEditorScrollView.verticalScroller != nil)
        resourceEditorScrollView.hasVerticalScroller = true
    }
    
    open func initializeEditorView() {
        
        assert(self.editableManager != nil)
        if let editableManager = self.editableManager {

            // no need to compute the height, the NSLayoutManager along with the NSTextContainer
            // will set it properly
            self.createResourceEditorView(with: resourceEditorScrollView.contentSize)
        }
    }
    
    open func createResourceEditorView(with size: NSSize) {
        
        fatalError("missing implementation")
    }
}

