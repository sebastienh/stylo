//
//  StyleViewController.swift
//  StyleEditorPlugin
//
//  Created by Sebastien Hamel on 2020-08-16.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa
import Common
import WriterCommon
import StyloCoreMac
import os

class StyleViewController: NSViewController {
    
    weak var cssViewController: CSSViewController?
    
    var styleManager: StyleManager? {
        return representedObject as? StyleManager
    }
    
    @IBOutlet var contentStackView: NSStackView?
    
    @IBOutlet var styleActionsPanelView: ColoredView?
    
    @objc dynamic var hasPendingChanges: Bool = false
    
    weak var documentManager: DocumentManager? {
        didSet {
            subscribe(toDocumentManager: self.documentManager)
        }
    }
    
    var editedStylesheetViewController: StylesheetViewController?
    
    var captureViewTag = 1001
    
    private var segue: TransitionSegue?
    
    weak var styleEditorPlugin: StyleEditorPlugin?
    
    var editors: [StylesheetId: StylesheetViewController] = [:]
    
    private lazy var stylesheetsViewController: StylesheetsViewController? = {
        
        guard let storyboard = self.storyboard else {
            assertionFailure("Error: storyboard is nil")
            return nil
        }
        
        return storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(string: "StylesheetsViewController" )) as? StylesheetsViewController
    }()
    
    @objc dynamic var styleTitle: String = "Untitled"
    
    override var representedObject: Any? {
        didSet {
            guard let styleManager = self.styleManager else {
                assertionFailure("Error: self.styleManager is nil")
                return
            }
            self.subscribe(toStyleManager: styleManager)
        }
    }
    
    @objc func controlTextDidChange(_ obj: Notification) {
        
        let textField: StyleHeaderStyleNameTextField = obj.object as! StyleHeaderStyleNameTextField
        textField.invalidateIntrinsicContentSize()
    }
    
    @objc func controlTextDidEndEditing(_ obj: Notification) {
        
        let textField: NSTextField = obj.object as! NSTextField
        styleManager?.title = textField.stringValue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initPreviousSegue()
        self.initContentStackView()
    }
    
    //    override func viewWillAppear() {
    //        super.viewWillAppear()
    //        self.styleTitle = self.styleManager?.dynamicTitle.value ?? "eee"
    //        print("styleTitle: \(self.styleTitle)")
    //    }
    
    //    override func viewDidAppear() {
    //        super.viewDidAppear()
    //        print("titleLabel?.stringValue: \(titleLabel?.stringValue)")
    
    //        self.styleTitle = self.styleManager?.dynamicTitle.value ?? "eee"
    //        print("styleTitle: \(self.styleTitle)")
    //    }
    
    @IBAction func addStylesheet(_ sender: AnyObject?) {
        
        self.stylesheetsViewController?.appendStylesheet()
    }
    
    @IBAction func applyStyleChanges(_ sender: AnyObject?) {
        
        assert(self.styleManager != nil)
        self.styleManager?.clearStyleAssemblies()
        self.windowController?.reapplyCurrentStyle()
        self.hasPendingChanges = false
    }
    
    @IBAction func goBack(_ sender: Any? = nil) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("self.parent: %@", %%self.parent)
        #endif
        
        switch StyloConstants.CSS.editorPresentationAnimationMode {
        case .present:
            
            assert(self.cssViewController != nil)
            if let cssViewController = cssViewController {
                
                cssViewController.editedStyleViewController = nil
                cssViewController.dismiss(self)
            }
            
        case .transition:
            
            assert(self.cssViewController != nil)
            cssViewController?.editedStyleViewController = nil
            
            if let capture = self.viewImageView {
                capture.frame = view.frame
                capture.tag = captureViewTag
                view.addSubview(capture, positioned: NSWindow.OrderingMode.above, relativeTo: nil)
            }
            segue?.perform()
        }
    }
    
    @IBAction func editStylesheetButtonClicked(_ sender: AnyObject?) {
        
        guard let stylessheetEditButton = sender as? StylesheetEditButton else {
            assertionFailure("Error: sender is not StylesheetEditButton")
            return
        }
        
        guard let stylesheetTableCellView = stylessheetEditButton.stylesheetTableCellView else {
            assertionFailure("Error: stylesheetTableCellView is nil")
            return
        }
        
        guard let stylesheetManager = stylesheetTableCellView.stylesheetManager else {
            assertionFailure("Error: stylesheetManager is nil")
            return
        }
        
        guard let styleManager = self.styleManager else {
            assertionFailure("Error: styleManager is nil")
            return
        }
        
        let stylesheetViewController = prepareStylesheetViewController(for: stylesheetManager, styleManager: styleManager)
        self.editedStylesheetViewController = stylesheetViewController
        stylesheetViewController?.cssEditorViewController?.resourceEditorView.needsDisplay = true
        
        assert(self.styleEditorPlugin != nil)
        styleEditorPlugin?.editedStyleManager = stylesheetViewController?.parentStyleManager
        
        assert(stylesheetViewController != nil)
        if let stylesheetViewController = stylesheetViewController {
            
            switch StyloConstants.CSS.editorPresentationAnimationMode {
            case .present:
                self.present(stylesheetViewController, animator: PushAnimator())
            case .transition:
                let segue = TransitionSegue(identifier: "next", source: self, destination: stylesheetViewController as Any, performHandler: { () -> Void in })
                segue.perform()
            }
        }
        else {
            
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("stylesheetViewController was nil", log: Log.StyleEditor.all, type: .error)
            #endif
        }
    }
    
    @discardableResult
    func prepareStylesheetViewController(for stylesheetManager: StylesheetManager, styleManager: StyleManager) -> StylesheetViewController? {
        
        if stylesheetManager.undoManager == nil {
            assert(self.styloDocument?.undoManager != nil)
            stylesheetManager.undoManager = self.styloDocument?.undoManager
        }
        
        if stylesheetManager.styleManager.value == nil {
            self.setStyle(toStylesheetManager: stylesheetManager)
        }
        
        let _stylesheetViewController = self.storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("StylesheetViewController")) as? StylesheetViewController
        
        
        guard let stylesheetViewController = _stylesheetViewController else {
            assertionFailure("Error: stylesheetViewController is nil")
            return nil
        }
        
        if let stylesheetViewController = self.editors[stylesheetManager.id] {
            return stylesheetViewController
        }
        
        self.editors[stylesheetManager.id] = stylesheetViewController
        stylesheetViewController.parentStyleManager = styleManager
        stylesheetViewController.stylesheetManager = stylesheetManager
        stylesheetViewController.documentManager = self.documentManager
        assert(stylesheetViewController.stylesheetManager != nil)
        stylesheetViewController.styleViewController = self
        stylesheetViewController.loadView()
        
        let cssEditorSplitViewController = self.cssEditorSplitViewController()
        
        assert(cssEditorSplitViewController != nil)
        if let cssEditorSplitViewController = cssEditorSplitViewController {
            
            stylesheetViewController.addChild(cssEditorSplitViewController)
            let contentFrame = stylesheetViewController.containerView.frame
            cssEditorSplitViewController.view.autoresizingMask = [NSView.AutoresizingMask.height, NSView.AutoresizingMask.width]
            cssEditorSplitViewController.view.frame = NSMakeRect(0, 0, contentFrame.width, contentFrame.height)
            stylesheetViewController.containerView.addSubview(cssEditorSplitViewController.view)
        }
        
        stylesheetViewController.cssEditorViewController?.editableManager = stylesheetManager
        
        assert(stylesheetViewController.cssEditorViewController?.editableManager != nil)
        stylesheetViewController.cssEditorViewController?.prepareViewController(window: self.view.window!)
        return stylesheetViewController
        
    }
    
    private func setStyle(toStylesheetManager stylesheetManager: StylesheetManager) {
        
        let defaultStyleManager = StyloApplication.shared.cssStyleSetManager.selectedOrDefaultStyleManager
        
        assert(defaultStyleManager != nil)
        if let defaultStyleManager = defaultStyleManager {
            try? stylesheetManager.setStyle(withStyleManager: defaultStyleManager, visibleRanges: nil)
        }
        else {
            assertionFailure("Error: defaultStyleManager is nil")
        }
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
    
    private func initContentStackView() {
        
        //        self.contentStackView = NSStackView()
        //        self.contentStackView?.orientation = .vertical
        //
        //        self.contentStackView?.alignment = .centerX
        //        self.contentStackView?.distribution = .fill
        
        //        guard let contentStackView = self.contentStackView else {
        //            assertionFailure("Error: self.contentStackView is nil")
        //            return
        //        }
        
        //        guard let scrollView = self.scrollView else {
        //            assertionFailure("Error: self.scrollView is nil")
        //            return
        //        }
        //
        
        
        //        scrollView.documentView = contentStackView
        
        guard let stylesheetsViewController = self.stylesheetsViewController else {
            assertionFailure("Error: stylesheetsViewController is nil")
            return
        }
        
        //        guard let containerView = self.containerView else {
        //            assertionFailure("Error: self.containerView is nil")
        //            return
        //        }
        
        stylesheetsViewController.representedObject = self.styleManager
        //        self.view.addSubview(stylesheetsViewController.view)
        ////
        //        stylesheetsViewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        //        stylesheetsViewController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        //        stylesheetsViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        //
        //        stylesheetsViewController.view.topAnchor.constraint(equalTo: self.styleActionsPanelView!.bottomAnchor).isActive = true
        
        contentStackView?.insertArrangedSubview(stylesheetsViewController.view, at: 0)
    }
    
    
    private func initPreviousSegue() {
        
        self.view.wantsLayer = true
        
        if StyloConstants.CSS.editorPresentationAnimationMode == .transition {
            self.view.autoresizingMask = [.height, .width]
            assert(self.cssViewController != nil)
            segue = TransitionSegue(identifier: "previous", source: self, destination: self.cssViewController as Any, performHandler: { () -> Void in })
        }
    }
    
    private func subscribe(toDocumentManager documentManager: DocumentManager?) {
        
        assert(documentManager != nil)
        documentManager?.appearanceMode.subscribe({ [weak self](appearanceMode) in
            self?.handleAppearanceModeChanged(appearanceMode)
        }, observer: self)
    }
    
    private func subscribe(toStyleManager styleManager: StyleManager) {
        
        self.styleTitle = styleManager.dynamicTitle.value
        styleManager.dynamicTitle.subscribe({ [weak self](newName) in
            self?.styleTitle = newName
        }, observer: self)
        styleManager.hasPendingChanges.subscribe({ [weak self](newValue) in
            self?.hasPendingChanges = newValue
        }, observer: self)
    }
    
    private func handleAppearanceModeChanged(_ appearanceMode: AppearanceMode) {
        
        for (_, stylesheetViewController) in self.editors {
            stylesheetViewController.applyAppearanceMode(appearanceMode)
        }
    }
    
    private func updateHasPendingChanges() {
        
        for (_, stylesheetManager) in self.editors {
            if stylesheetManager.hasPendingChanges {
                self.hasPendingChanges = true
                return
            }
        }
        
        self.hasPendingChanges = false
    }
}
