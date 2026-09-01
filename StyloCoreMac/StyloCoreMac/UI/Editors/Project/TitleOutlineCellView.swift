//
//  TitleOutlineCellView.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-08-24.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa
import WriterCommon
import Common
import PathKit
import os

class TitleOutlineCellView: TextEditorsOutlineCellView {
    
    @IBOutlet var backgroundView: ColoredView!
    
    @IBOutlet var viewCover: ColoredView!
    
    @IBOutlet var editorControlsStackView: EditorControlsStackView!
    
    @IBOutlet var editorSeparator: EditorSeparator?
    
    @IBOutlet var infoButton: FileInfoButton?
    
    var textManagerId: String?
    
    var editorId: String? {
        willSet {
            assert(self.textManagerId != nil)
            unsubscribeToTextManager()
        }
        didSet {
            assert(self.textManagerId != nil)
            subscribeToTextManager()
        }
    }
    
    weak var documentManager: DocumentManager?
    
    var separatorIsHidden: Bool = false {
        didSet {
            self.editorSeparator?.isHidden = self.separatorIsHidden
        }
    }
    
    private var dinkusBackgroundView: ColoredView?
    
    private var sourceSetManager: SourceSetManager? {
        
        return documentManager?._sourceSetManager.value
    }
    
    private var textManager: TextManager? {
        
        guard let textManagerId = self.textManagerId else {
            return nil
        }
        
        guard let sourceSetManager = self.sourceSetManager else {
            assertionFailure("Error: self.sourceSetManager is nil")
            return nil
        }
        
        guard let itemManager = sourceSetManager.directoryItemManager(withId: textManagerId) else {
            return nil
        }
        
        guard let textManager = itemManager as? TextManager else {
            assertionFailure("Error: itemManager is not TextManager")
            return nil
        }

        return textManager
    }
    
    private var editor: AnyEditor? {
    
        guard let textManager = self.textManager else {
            assertionFailure("Error: self.textManager is nil")
            return nil
        }
        
        guard let editorId = self.editorId else {
            assertionFailure("Error: self.editorId is nil")
            return nil
        }
        
        guard let editorManager = textManager.editor(for: editorId) else {
            assertionFailure("Error: editorManager is nil")
            return nil
        }
        return editorManager
    }
    
    @objc dynamic var collapsed: Bool = false
    
    private var pluginForcesRightButtonsDisplay: Bool = false {
        didSet {
            if pluginForcesRightButtonsDisplay {
                self.showButtons()
            }
            else {
                hideButtons()
            }
        }
    }

    private var outlineView: NSOutlineView? {
        var view: NSView? = self
        while view != nil {
            if let outlineView = view as? NSOutlineView {
                return outlineView
            }
            view = view?.superview
        }
        return nil
    }
    
    private var projectTextEditorsOutlineRowView: ProjectTextEditorsOutlineRowView? {
        var view: NSView? = self
        while view != nil {
            if let projectTextEditorsOutlineRowView = view as? ProjectTextEditorsOutlineRowView {
                return projectTextEditorsOutlineRowView
            }
            view = view?.superview
        }
        return nil
    }
    
    var isFirstTitle: Bool = false
    
    private weak var subscribedProjectTextEditorsOutlineRowView: ProjectTextEditorsOutlineRowView?
    
    private var fileInfoPopover = NSPopover()
    
    lazy var fileInfoViewController: FileInfoViewController? = {
        
        let bundle = Bundle(for: StyloWindowController.self)
        let mainStoryboard: NSStoryboard = NSStoryboard(name: NSStoryboard.Name(string: "FileInfo"), bundle: bundle)
        
        guard let fileInfoViewController = mainStoryboard.instantiateInitialController() as? FileInfoViewController else {
            
            assert(false, "FileInfoViewController instantiateInitialController() returns nil.")
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("fileInfoViewController is nil", log: Log.StyloCore.all, type: .error)
            #endif
            return nil
        }
        fileInfoViewController.textManager = self.textManager
        fileInfoViewController.editor = self.editor
        fileInfoViewController.loadView()
        fileInfoViewController.fileInfoView.invalidateIntrinsicContentSize()
        return fileInfoViewController
    }()
    
    private var stylePreviewAttributes: [TextStylePreview.Element : [NSAttributedString.Key : Any]]?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.wantsLayer = true
        self.layer?.backgroundColor = cgColor(named: "TitleViewBackgroundColor")
        self.addTrackingArea(NSTrackingArea(rect: frameRect, options: NSTrackingArea.Options.inVisibleRect.union(NSTrackingArea.Options.activeInKeyWindow).union(NSTrackingArea.Options.mouseEnteredAndExited), owner: self, userInfo: nil))
        startListeningToNavigationNotifications()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        self.wantsLayer = true
        self.layer?.backgroundColor = cgColor(named: "TitleViewBackgroundColor")
        self.addTrackingArea(NSTrackingArea(rect: NSZeroRect, options: NSTrackingArea.Options.inVisibleRect.union(NSTrackingArea.Options.activeInKeyWindow).union(NSTrackingArea.Options.mouseEnteredAndExited), owner: self, userInfo: nil))
        startListeningToNavigationNotifications()
    }
    
    // see http://stackoverflow.com/questions/32264008/themeChooserPopover-segue-cocoa-storyboard-changing-position-in-xcode-7-beta-6-on-el-capitan
    @IBAction func toggleTextStatisticsSessionToolsEnabledState(_ sender: AnyObject? = nil) {
        
        StyloApplication.shared.revertTextStatisticsSessionToolsEnabledValue()
        StyloNotification.textStatisticsSessionEnabledStateChanged.sendNotification()
    }
    
    func hideInformationButton() {
        
        NSAnimationContext.runAnimationGroup({ context in
            
            // Customize the animation parameters.
            context.duration = StyloConstants.EditorsPane.CollapseAnimationTime
            context.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            context.allowsImplicitAnimation = true
            
            self.infoButton?.alphaValue = 0
        })
    }
    
    func showInformationButton() {
        
        NSAnimationContext.runAnimationGroup({ context in
            
            // Customize the animation parameters.
            context.duration = StyloConstants.EditorsPane.CollapseAnimationTime
            context.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            context.allowsImplicitAnimation = true
            
            self.infoButton?.alphaValue = 1
        })
    }
    
    override func mouseDown(with event: NSEvent) {
        
        self.window?.performDrag(with: event)
    }
    
    override func mouseUp(with event: NSEvent) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("TitleOutlineCellView.mouseUp -> NSCursor.arrow.set()", log: Log.StyloCore.all, type: .info)
        #endif
        NSCursor.arrow.set()
        super.mouseUp(with: event)
    }
    
    override func mouseEntered(with event: NSEvent) {
        showButtons()
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("TitleOutlineCellView.mouseEntered -> NSCursor.arrow.set()", log: Log.StyloCore.all, type: .info)
        #endif
        NSCursor.arrow.set()
    }
    
    override func mouseExited(with event: NSEvent) {
        
        guard let trackingArea = self.trackingAreas.first else {
            assertionFailure("Error: trackingAreas.first is nil")
            return
        }
        
        let point = self.convert(event.locationInWindow, from: nil)
        
        // We do this check because we receive mouseExited events when
        // we exit from the text field.
        if !NSPointInRect(point, trackingArea.rect) {
            if !pluginForcesRightButtonsDisplay {
                hideButtons()
            }
        }
    }
    
    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
     
        self.listenToWindowMouseMoveNotifications()
        self.listenToEditorsNotifications()
    }
    
    override func viewDidChangeEffectiveAppearance() {
        self.layer?.backgroundColor = cgColor(named: "TitleViewBackgroundColor")
        self.needsLayout = true 
        super.viewDidChangeEffectiveAppearance()
    }
    
    @IBAction func displayFileInfo(_ sender: AnyObject) {
        
        guard let fileInfoViewController = self.fileInfoViewController else {
            assertionFailure("Error: self.fileInfoViewController is nil")
            return
        }
        
        guard let infoButton = self.infoButton else {
            assertionFailure("Error: self.infoButton is nil")
            return
        }
            
        // we do this once
        if fileInfoPopover.contentViewController == nil {
            fileInfoPopover.contentViewController = fileInfoViewController
            fileInfoPopover.behavior = .semitransient
            fileInfoPopover.animates = true
            fileInfoViewController.parentPopover = fileInfoPopover
        }
        
        let computedAppearance: AppearanceMode = {
            if let computedAppearance = StyloApplication.shared.computedAppearance.value {
                return computedAppearance
            }
            assertionFailure("Error: computedAppearance is nil")
            return AppearanceMode.dark
        }()
        
        fileInfoPopover.appearance = computedAppearance.appearance
        fileInfoPopover.show(relativeTo: infoButton.bounds, of: infoButton, preferredEdge: .maxY)
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
    
    private var stackViewLeadingContraint: NSLayoutConstraint?
    
    func updateStackViewLeadingConstraint() {
    
        guard let editorControlsStackView = self.editorControlsStackView else {
            assertionFailure("Error: self.editorControlsStackView is nil")
            return
        }
        
        var maxWidth: CGFloat = 0
        
        for view in editorControlsStackView.views {
            
            guard let textEditorControl = view as? TextEditorControl else {
                assertionFailure("Error: editorControlView is not TextEditorControl")
                continue
            }
            
            maxWidth += textEditorControl.maxWidth
        }
        
        // note: this constraint needs to follow the width constraint of the
        // controlsBackgroundCenteringView in the storyboard.
        if let stackViewLeadingContraint = self.stackViewLeadingContraint {
            
            stackViewLeadingContraint.constant = -(maxWidth+Constants.Configuration.TextEditorControlRightPadding)
        }
        else {
            
            let stackViewLeadingContraint = NSLayoutConstraint(item: editorControlsStackView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -(maxWidth+Constants.Configuration.TextEditorControlRightPadding))
            stackViewLeadingContraint.priority = .dragThatCannotResizeWindow
            self.addConstraint(stackViewLeadingContraint)
            self.stackViewLeadingContraint = stackViewLeadingContraint
        }
        self.needsUpdateConstraints = true
    }
    
    private func hideButtons() {
        
        self.editorControlsStackView.isHidden = true
    }
    
    private func showButtons() {
        
        self.editorControlsStackView.isHidden = false
    }
    
    func updateBackgroundColor(with color: NSColor) {
        
        self.backgroundView.backgroundColor = color
        self.dinkusBackgroundView?.backgroundColor = color
        self.updateAppearance(from: color)
    }
    
    func updateAppearance(from color: NSColor?) {
        
        let appearance = self.appearance(from: color)
        self.changeAppearance(appearance)
    }
    
    private func appearance(from color: NSColor?) -> AppearanceMode {
        
        if let color = color, !isLight(color: color) {
            return AppearanceMode.dark
        }
        return AppearanceMode.light
    }
    
    private func isLight(color: NSColor) -> Bool {
        
        if let color = DynamicColor(cgColor: color.cgColor) {
            
            return color.isLight()
        }
        return true
    }
    
    func changeAppearance(_ appearanceMode: AppearanceMode) {
        
        // see http://stackoverflow.com/questions/29952202/changing-the-background-color-of-the-unified-nstoolbar-in-yosemite
        // This method is called when the background color of the text change.
        switch appearanceMode {
        case .dark:
            self.appearance = NSAppearance(named: NSAppearance.Name.vibrantDark)
        case .light:
            self.appearance = NSAppearance(named: NSAppearance.Name.vibrantLight)
        }
    }
    
    private func subscribeToTextManager() {
        
        guard let textManager = self.textManager else {
            assertionFailure("Error: self.textManager is nil")
            return
        }
        
        guard let editorId = self.editorId else {
            assertionFailure("Error: self.editorId is nil")
            return
        }
        
        guard let editorManager = textManager.editor(for: editorId) else {
            assertionFailure("Error: editorManager is nil")
            return
        }
        
        guard let globalAttributes = editorManager.globalAttributes.value else {
            assertionFailure("Error: globalAttributes is nil")
            return
        }
        
        self.handleGlobalAttributes(globalAttributes)
        
        editorManager.globalAttributes.subscribe({ [weak self](globalAttributes) in
            self?.handleGlobalAttributes(globalAttributes)
        }, observer: self)
        
        handlePluginBackgroundActivity(textManager.pluginsBackgroundActivities.values)
        textManager.pluginsBackgroundActivities.subscribe({ [weak self](dictionaryChange) in
            
            switch dictionaryChange {
            case .deletes(_, let udpatedValues):
                self?.handlePluginBackgroundActivity(udpatedValues)
            case .updates(_, let udpatedValues):
                self?.handlePluginBackgroundActivity(udpatedValues)
            case .start: fallthrough
            case .end:
                assertionFailure("Error: unsupported case")
                break
            }
        }, observer: self)
    }
    
    func updateAppearanceFromGlobalAttributes() {
        
        guard let textManager = self.textManager else {
            assertionFailure("Error: self.textManager is nil")
            return
        }
        
        guard let editorId = self.editorId else {
            assertionFailure("Error: self.editorId is nil")
            return
        }
        
        guard let editorManager = textManager.editor(for: editorId) else {
            assertionFailure("Error: editorManager is nil")
            return
        }
        
        guard let globalAttributes = editorManager.globalAttributes.value else {
            assertionFailure("Error: globalAttributes is nil")
            return
        }
        
        self.handleGlobalAttributes(globalAttributes)
    }
    
    private func handleGlobalAttributes(_ globalAttributes: GlobalAttributes?) {
        
        let backgroundColor = globalAttributes?.backgroundColor
        
        if let backgroundColor = backgroundColor {
            if isLight(color: backgroundColor) {
                let darkGray = NSColor.lightGray.usingColorSpace(.genericRGB)
                let coverColor = darkGray!.withAlphaComponent(0.1)
                self.viewCover.backgroundColor = NSColor.clear // coverColor
                self.updateBackgroundColor(with: backgroundColor)
            }
            else {
                let lightGray = NSColor.lightGray.usingColorSpace(.genericRGB)
                let coverColor = lightGray!.withAlphaComponent(0.05)
                self.viewCover.backgroundColor = NSColor.clear // coverColor
                self.updateBackgroundColor(with: backgroundColor)
            }
            self.needsDisplay = true
        }
        
        guard let textStylePreview = globalAttributes?.stylePreview as? TextStylePreview else {
            assertionFailure("Error: globalAttributes?.stylePreview is not TextStylePreview")
            return
        }
        
        self.handleStylePreviewAttributesChange(textStylePreview.attributesValue)
    }
    
    private func handleStylePreviewAttributesChange(_ stylePreviewAttributes: [TextStylePreview.Element : [NSAttributedString.Key : Any]]?) {
        
        self.stylePreviewAttributes = stylePreviewAttributes
    }
    
    private func handlePluginBackgroundActivity(_ activities: Dictionary<String, BackgroundActivity>) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("textManager %@ activities: %@", log: Log.StyloCore.all, type: .info, %%textManager?.name.value, %%activities)
        #endif
        debugPrint()
        var _pluginForcesRightButtonsDisplay = false
        for (_, activity) in activities {
            
            if activity.requiresEditorControlsDisplay {
                _pluginForcesRightButtonsDisplay = true
                break
            }
        }
        self.pluginForcesRightButtonsDisplay = _pluginForcesRightButtonsDisplay
    }
    
    private func unsubscribeToTextManager() {
        
        if let textManager = self.textManager {
            textManager.name.unsubscribe(observer: self)
            textManager.pluginsBackgroundActivities.unsubscribe(observer: self)
            if let editorId = self.editorId {
                
                guard let editor = textManager.editor(for: editorId) else {
                    return
                }
                
                editor.globalAttributes.unsubscribe(observer: self)
            }
        }
    }
    
    deinit {
        
        if let willNavigateInHistoryObserver = self.willNavigateInHistoryObserver {
            NotificationCenter.default.removeObserver(willNavigateInHistoryObserver)
        }

        if let didNavigateInHistoryObserver = self.didNavigateInHistoryObserver {
            NotificationCenter.default.removeObserver(didNavigateInHistoryObserver)
        }
        
        unsubscribeToTextManager()
        NotificationCenter.default.removeObserver(self)
    }
}
