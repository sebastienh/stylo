//
//  CSSViewController.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2015-07-22.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import Common
import WriterCommon
import StyloCoreMac
import Web
import os

/// The CSSViewController view controller is the controller for the
/// CSS files array view:
final class CSSViewController: NSViewController {
    
    @IBOutlet var widthConstraint: NSLayoutConstraint!
    
    @IBOutlet var stylesTableView: CSSStyleTableView! {
        didSet {
            stylesTableView.registerForDraggedTypes([StyloConstants.DragTypes.StyleType])
        }
    }
    
    @IBOutlet var stylesTitles: NSTextField!
    
    @IBOutlet var addStylesheetButton: StyloButton!
    
    @IBOutlet var panelTitleView: StylesListTitlePanelView!
    
    @IBOutlet var backgroundContentView: StylesBackgroundView!
    
    var editors: [String: StyleViewController]
    
    // A unowned link to the pseudo css resource manager. Meaning that if
    // the CSSResourceMaanger does not exist, there is no reason for
    // this CCSSViewController to exists...
    var styleSetManager: StyleSetManager! {
        
        return documentManager?.styleSetManager
    }
    
    weak var styleEditorPlugin: StyleEditorPlugin?
    
    var documentManager: DocumentManager? {
     
        return representedObject as? DocumentManager
    }
    
    override var representedObject: Any? {
        didSet {
            self.editedStyleViewController = nil
            self.editors.removeAll()
        }
    }
    
    var selectedStyleTableViewCell: CSSStyleTableCellView? {
        
        let selectedStyleManagerIndex = self.styleSetManager?.selectedStyleManagerIndex
        
        if let selectedStyleManagerIndex = selectedStyleManagerIndex {
        
            return stylesTableView.cssStyleTableViewCell(at: selectedStyleManagerIndex)
        }
        return nil
    }
    
    var textBackgroundColor: NSColor?
    
    // The content view contains:
    // TODO: add the views references
    
    var initialized: Bool = false
    
    weak var editedStyleViewController: StyleViewController?
    
    var dragOperationInProgress: Bool = false
    
    private var segue: TransitionSegue?
    
    private var listeningToStyleSetManager: Bool = false
    
    required init?(coder: NSCoder) {
        
        self.editors = [String: StyleViewController]()
        super.init(coder: coder)
    }

    func prepare(with documentManager: DocumentManager) {
        
        // create the autocompletion instance
        CSSCompletionsTstDictionaryFactory.GetCssTstDictionary()
        _ = CssResourceEditorView.autocompleteWindowController
        
        self.representedObject = documentManager
        self.loadView()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("CSSViewController view frame(1): %@", log: Log.StyleEditor.all, type: .info, %%view.frame)
        os_log("window frame(1): %@", log: Log.StyleEditor.all, type: .info, %%view.window?.contentView?.frame)
        #endif
        assert(self.view.layer != nil)
        self.view.layer?.isOpaque = true
        view.autoresizingMask = [NSView.AutoresizingMask.height, NSView.AutoresizingMask.width]
        self.updateViewConstraints()
        self.view.updateConstraintsForSubtreeIfNeeded()
        self.stylesTableView.reloadData()
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("CSSViewController view frame(2): %@", log: Log.StyleEditor.all, type: .info, %%view.frame)
        #endif
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Styles list viewDidAppear", log: Log.StyleEditor.all, type: .info)
        #endif
        
        assert(self.styleSetManager != nil)
        handleSelectedStyleManager(styleManager: styleSetManager?.selectedStyleManager.value)
        
        if !listeningToStyleSetManager {
            startListeningToSelectedStyleManager()
            listeningToStyleSetManager = true
        }
    }
    
    private func startListeningToSelectedStyleManager() {
        
        guard let styleSetManager = self.styleSetManager else {
            assertionFailure("Error: self.styleSetManager is nil")
            return
        }
        
        styleSetManager.selectedStyleManager.subscribe({ [weak self](newSelectedStyleManager) in
            self?.handleSelectedStyleManager(styleManager: newSelectedStyleManager)
        }, observer: self)
    }
    
    private func handleSelectedStyleManager(styleManager: StyleManager?) {
        
        guard let styleManager = styleManager else {
            assertionFailure("Error: styleManager is nil")
            return
        }
        
        guard let selectedStyleManagerIndex = self.styleSetManager.index(of: styleManager) else {
            assertionFailure("Error: unable to get index for style manager with title: \(styleManager.title)")
            return
        }
                
        // The table may be nil if we have not opened
        // the styles list
        if let stylesTableView = self.stylesTableView {
            
            let index = IndexSet(arrayLiteral: selectedStyleManagerIndex)
            stylesTableView.selectRowIndexes(index, byExtendingSelection: false)
        }
        
        if self.editors[styleManager.id] == nil {

//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                fatalError("missing implementation")
//                self.prepareStylesheetViewController(for: StylesheetManager, for: styleManager)
//            }
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("window frame(1): %@", log: Log.StyleEditor.all, type: .info, %%view.window?.contentView?.frame)
        #endif
    }
    
    
    func disableStylesTable() {

        stylesTableView?.disableAllTableCellViews()
    }
    
    func enableStylesTable() {
        
        stylesTableView?.enableAllTableCellViews()
    }

    @IBAction func editStyleButtonClicked(_ sender: AnyObject?) {
        
        let cssStyleTableCellView = sender?.superview as? CSSStyleTableCellView
        
        assert(cssStyleTableCellView != nil)
        if let cssStyleTableCellView = cssStyleTableCellView {
            
            if cssStyleTableCellView.selected {
                
                guard let styleViewController = prepareStyleViewController(sender: sender) else {
                    assertionFailure("Error: styleViewController is nil")
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("stylesheetViewController was nil", log: Log.StyleEditor.all, type: .error)
                    #endif
                    return
                }
                
                self.editedStyleViewController = styleViewController
//                styleViewController?.cssEditorViewController?.resourceEditorView.needsDisplay = true
                
                assert(self.styleEditorPlugin != nil)
                styleEditorPlugin?.editedStyleManager = styleViewController.styleManager
                    
                switch StyloConstants.CSS.editorPresentationAnimationMode {
                case .present:
                    
                    self.present(styleViewController, animator: PushAnimator())
                    
                case .transition:
                    
                    segue = TransitionSegue(identifier: "next", source: self, destination: editedStyleViewController as Any, performHandler: { () -> Void in })
                    
                    segue?.perform()
                }
            }
        }
    }
    
    @IBAction func addStyle(_ sender: AnyObject?) {
        
        if let windowController = self.windowController, let styloDocument = self.styloDocument {
            
            let styleManager = styloDocument.addStyleManager()
            
            assert(styleManager != nil)
            if let styleManager = styleManager {
                
                windowController.applyStyle(from: styleManager)
            }
        }
        // FIXME: could use the more optimized version of reload data
        stylesTableView.reloadData()
    }
    
    @IBAction func deleteStyle(_ sender: AnyObject?) {
        
        let cssStyleTableCellView = sender?.superview as! CSSStyleTableCellView
        let associatedStyleManager = cssStyleTableCellView.associatedStyleManager!

        let answer = dialogOKCancel(question: "Are you sure you want to delete the style with name: \(associatedStyleManager.title)?", text: "The style will be removed from the document. You cant undo this action.")
        
        if answer {
            self.deleteStyleManager(associatedStyleManager)
        }
    }
    
    func dialogOKCancel(question: String, text: String) -> Bool {
        let alert = NSAlert()
        alert.messageText = question
        alert.informativeText = text
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Delete")
        alert.addButton(withTitle: "Cancel")
        return alert.runModal() == .alertFirstButtonReturn
    }
    
    public func deleteStyleManager(_ styleManager: StyleManager) {
        
        assert(styloDocument != nil)
        styloDocument?.delete(styleManager: styleManager)
        self.editors.removeValue(forKey: styleManager.id)
        stylesTableView.reloadData()
    }

    var cachedStylesheetViewController: StylesheetViewController?
    
    func prepareStyleViewController(at rowIndex: Int) {
        
        assert(self.styleSetManager != nil)
        assert(rowIndex < styleSetManager.stylesCount)
        if let styleSetManager = self.styleSetManager, rowIndex < styleSetManager.stylesCount {
            
            if let styleManager: StyleManager = styleSetManager[rowIndex] {
                if self.editors[styleManager.id] == nil {


                }
            }
            else {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Trying to access styleSetManager style at index: %@ with stylesCount: %@", log: Log.StyleEditor.all, type: .error, %%rowIndex, %%styleSetManager.stylesCount)
                #endif
            }
        }
        else {
            
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Trying to access styleSetManager style at index: %@ with stylesCount: %@", log: Log.StyleEditor.all, type: .error, %%rowIndex, %%styleSetManager.stylesCount)
            #endif
        }
    }
    
    func prepareStyleViewController(sender: Any?) -> StyleViewController? {
        
        let rowIndex = arrayIndexFromSender(sender! as AnyObject)
        var preparedStyleViewController: StyleViewController?
        
        assert(rowIndex != nil)
        if let rowIndex = rowIndex {
            
            assert(styloDocument != nil)
            assert(self.styleSetManager != nil)
            assert(rowIndex < styleSetManager.stylesCount)
            if let styleSetManager = self.styleSetManager {
            
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Trying to access styleSetManager style at index: %@ with stylesCount: %@", log: Log.StyleEditor.all, type: .info, %%rowIndex, %%styleSetManager.stylesCount)
                #endif
                
                if let styleManager: StyleManager = styleSetManager[rowIndex] {
                    
//                    let styleViewController = self.editors[styleManager.id]
//
//                    // may be nil when we just created the style
//                    // or we have not opened it yet...
//                    if let styleViewController = styleViewController {
//                        preparedStyleViewController = styleViewController
//                    }
//                    else {

                        preparedStyleViewController = prepareStyleViewController(for: styleManager)
//                    }

                    preparedStyleViewController?.styleEditorPlugin = self.styleEditorPlugin
                    
                    assert(preparedStyleViewController != nil)
                    return preparedStyleViewController
                }
                else {
                    
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("Trying to access styleSetManager style at index: %@ with stylesCount: %@", log: Log.StyleEditor.all, type: .error, %%rowIndex, %%styleSetManager.stylesCount)
                    #endif
                }
            }
            else {
                
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Erro: trying to access styleSetManager style at index: %@ with stylesCount: %@", log: Log.StyleEditor.all, type: .error, %%rowIndex, %%styleSetManager.stylesCount)
                #endif
            }
        }
        return nil
    }

    @discardableResult
    func prepareStyleViewController(for styleManager: StyleManager) -> StyleViewController? {

        guard let styleViewController = self.storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("StyleViewController")) as? StyleViewController else {
            assertionFailure("Error: styleViewController is nil")
            return nil
        }

        self.editors[styleManager.id] = styleViewController
        styleViewController.representedObject = styleManager
        styleViewController.cssViewController = self
        styleViewController.documentManager = self.documentManager
        styleViewController.loadView()
        return styleViewController
    }
    
    private func cssEditorSplitViewController() -> CssEditorSplitViewController? {
        
        let bundle = Bundle(for: CSSViewController.self)
        let storyboardName = NSStoryboard.Name(string: "CSSEditor")
        let cssEditorStoryboard: NSStoryboard = NSStoryboard(name: storyboardName, bundle: bundle)
        
        let cssEditorSplitViewController = cssEditorStoryboard.instantiateInitialController() as? CssEditorSplitViewController
        
        assert(cssEditorSplitViewController != nil)
        if cssEditorSplitViewController == nil {
            
            assert(false, "cssEditorSplitViewController() returns nil.")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("cssEditorSplitViewController is nil", log: Log.StyleEditor.all, type: .error)
            #endif
        }
        return cssEditorSplitViewController
    }
    
    func hide() {
        
        panelTitleView.isHidden = true
        stylesTableView.isHidden = true
    }
    
    func unhide() {
        
        panelTitleView.isHidden = false
        stylesTableView.isHidden = false
    }
    
    func completeAfterDismissale() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Dismissed the editor", log: Log.StyleEditor.all, type: .debug)
        #endif
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: SelectedIndexContainer protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    var selectedIndex: Int? {
        
        return self.styleSetManager?.selectedStyleManagerIndex
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Private implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////

    private func arrayIndexFromSender(_ sender: AnyObject) -> Int? {
        
        if let button = sender as? NSButton {
            
            let buttonPosition = CGPoint(x: button.frame.midX, y: button.frame.midY)
            let localLocation: NSPoint = button.superview!.convert(buttonPosition, to: stylesTableView)
        
            // we use the button center position to know which row we are in
            return  self.stylesTableView.row(at: localLocation)
        }
        else {
            
            return self.selectedIndex
        }
    }
    
    deinit {

    }
}
