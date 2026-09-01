//
//  StylesheetTableCellView.swift
//  StyleEditorPlugin
//
//  Created by Sebastien Hamel on 2020-08-17.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon
import Common
import StyloCoreMac

final class StylesheetTableCellView: NSTableCellView {
    
    var stylesheetManager: StylesheetManager?
    
//    var isEnabled: Bool = true
//
//    @IBOutlet weak var stackView: NSStackView!
//    
//    @objc dynamic weak var associatedStyleManager: StyleManager! {
//        willSet {
//            if let associatedStyleManager = associatedStyleManager {
//                associatedStyleManager.selectedStyle.unsubscribe(observer: self)
//                associatedStyleManager.stylePreview.unsubscribe(observer: self)
//            }
//        }
//        didSet {
//            
//            // set initial values
//            self.selected = associatedStyleManager.selectedStyle.value
//            self.styleIcon.styleManager = associatedStyleManager
//            associatedStyleManager.selectedStyle.subscribe({
//                [unowned self] in
//                self.selected = $0
//            }, observer: self)
//        }
//    }
//    
//    @IBOutlet var styleIcon: ConicalStyleButton!
//    
//    @IBOutlet var numberOfIssuesLabel: NSTextField!
//    
//    @IBOutlet var titleLable: StyleNameTextField! {
//        
//        didSet {
//            
//            titleLable?.textColor = NSColor.secondaryLabelColor
//            
//            // NW-1501: remove the style table cell view name text view glow when choosing
////            titleLable?.refusesFirstResponder = true
//            
//            
//            if let titleLable = titleLable {
//                
//                NotificationCenter.default.addObserver(forName: NSControl.textDidChangeNotification, object: titleLable, queue: nil) { [weak self](notification) in
//                    self?.controlTextDidChange(notification)
//                }
//            }
//        }
//    }
//    
//    // see https://stackoverflow.com/questions/11268631/how-to-change-nstextfield-text-color-on-row-selection/12008103
//    override var backgroundStyle: NSView.BackgroundStyle {
//        get {
//            return super.backgroundStyle
//        }
//        set {
//            super.backgroundStyle = .normal
//        }
//    }
//    
//    @IBOutlet var editButton: NSButton!{
//        didSet {
//            self.editButton.appearance = StyloApplication.shared.computedAppearance.value?.appearance ?? AppearanceMode.dark.appearance
//        }
//    }
//    
//    @IBOutlet var deleteButton: NSButton!{
//        didSet {
//            self.deleteButton.appearance = StyloApplication.shared.computedAppearance.value?.appearance ?? AppearanceMode.dark.appearance
//        }
//    }
//    
//    private var deselectingStyle: Bool = false
//    
//    private var selectingStyle: Bool = false
//    
//    var selected: Bool {
//        
//        didSet {
//            
//            self.needsLayout = true
//            titleLable?.selected = selected
//            
//            if oldValue && !selected {
//                deselectingStyle = true
//                selectingStyle = false
//            }
//            else {
//                deselectingStyle = false
//                selectingStyle = true
//            }
//        }
//    }
//    
//    private var trackingArea: NSTrackingArea!
//    
//    private var listening: Bool = false
//    
//    private var mouseOver: Bool = false
//    
//    required init?(coder: NSCoder) {
//        
//        selected = false
//        isEnabled = true
//        super.init(coder: coder)
//        self.wantsLayer = true
//        createTrackingArea()
//    }
//    
//    func layoutByApplyingConstraints() {
//        
//        self.needsUpdateConstraints = true
//        self.updateConstraintsForSubtreeIfNeeded()
//        
//        self.needsLayout = true
//        self.layoutSubtreeIfNeeded()
//    }
//    
//    @objc func controlTextDidChange(_ obj: Notification) {
//        
//        let textField: StyleNameTextField = obj.object as! StyleNameTextField
//        textField.invalidateIntrinsicContentSize()
//    }
//    
//    override func viewDidChangeEffectiveAppearance() {
//        
//        self.needsLayout = true
//        super.viewDidChangeEffectiveAppearance()
//    }
//    
//    override func layout() {
//        
//        self.updateButtonsHiddenState()
//        self.updateTitleLableTextColor()
//
//        if mouseOver {
//            
//            if !selectingStyle {
//            
//                if !selected {
//                    self.styleIcon.animateMixed()
//                }
//            }
//            else {
//                
//                // do nothing, we are already in the good state
//                assert(!deselectingStyle)
//            }
//        }
//        else {
//            
//            if !selected {
//                // selecting style can be false when loading
//                self.styleIcon.animateOff()
//            }
//        }
//            
//        self.deselectingStyle = false
//        self.selectingStyle = false
//        super.layout()
//    }
//    
//    func resetState() {
//        
//        self.isEnabled = true
//        self.selected = false
//        self.mouseOver = false
//        self.needsLayout = true
//    }
//    
//    override func mouseEntered(with event: NSEvent) {
//        
//        handleMouseOver(true)
//    }
//    
//    override func mouseExited(with event: NSEvent) {
//        
//        handleMouseOver(false)
//    }
//    
//    func setInitialNumberOfErrorsStringValue(failableManager: Failable/*Manager*/) {
//        
//        handleErrorMessagesChange(messagesArray: failableManager.errors, failable: failableManager)
//    }
//    
//    func listenToDidUpdateIssuesArray(failableManager: Failable/*Manager*/) {
//        
//        if !listening {
//            
//            let stylesheetManager = failableManager as! StylesheetManager
//            
//            stylesheetManager.subscribeToMessages(observer: self) { [weak self] (change: DynamicArray<Message>.Change) -> Void in
//                
//                switch change {
//                case .insert(_, _, let messagesArray):
//                    self?.handleErrorMessagesChange(messagesArray: messagesArray, failable: failableManager)
//                case .deletes(_, _, let messagesArray):
//                    self?.handleErrorMessagesChange(messagesArray: messagesArray, failable: failableManager)
//                case .inserts(_, _, let messagesArray):
//                    self?.handleErrorMessagesChange(messagesArray: messagesArray, failable: failableManager)
//                case .move(_, _, _, let messagesArray):
//                    self?.handleErrorMessagesChange(messagesArray: messagesArray, failable: failableManager)
//                case .end: fallthrough
//                case .start:
//                    break
//                }
//            }
//            
//            listening = true
//        }
//    }
//    
//    //////////////////////////////////////////////////////////////////////////////////////////////////////////
//    //                                  MARK: private implementation
//    //////////////////////////////////////////////////////////////////////////////////////////////////////////
//    
//    private func handleMouseOver(_ over: Bool) {
//        
//        self.mouseOver = over
//        self.needsLayout = true
//    }
//    
//    private func updateTitleLableTextColor() {
//        
//        if selected || mouseOver {
//            titleLable.textColor = NSColor.selectedControlTextColor
//        } else {
//            titleLable.textColor = Constants.CSS.StylesListCell.NotSelectedTitleColor
//        }
//    }
//    
//    private func updateButtonsHiddenState() {
//        
//        if selected {
//            editButton.isHidden = false
//            deleteButton.isHidden = true
//        }
//        else {
//            editButton.isHidden = true
//            if mouseOver {
//                deleteButton.isHidden = false
//            }
//            else {
//                deleteButton.isHidden = true
//            }
//        }
//    }
//    
//    private func createTrackingArea() {
//        
//        let options = NSTrackingArea.Options.activeInActiveApp.union(.mouseEnteredAndExited).union(.inVisibleRect)
//        self.trackingArea = NSTrackingArea(rect: self.bounds, options: options, owner: self, userInfo: nil)
//        self.addTrackingArea(self.trackingArea)
//    }
//    
//    private func handleErrorMessagesChange(messagesArray: [Message], failable: Failable) {
//        
//        if !messagesArray.isEmpty {
//            
//            let issuesString = Strings.shared.numberOfIssuesString(with: messagesArray.count)
//            
//            if stackView.views.count == 1 {
//                self.stackView.addView(numberOfIssuesLabel, in: NSStackView.Gravity.bottom)
//            }
//            self.numberOfIssuesLabel.stringValue = issuesString
//        }
//        else {
//            
//            if stackView.views.count == 2 {
//                self.stackView.removeView(self.numberOfIssuesLabel)
//            }
//        }
//    }
//    
//    func stopToListenToDidUpdateErrorsArray(stylesheetManager: StylesheetManager) {
//        
//        stylesheetManager.unsubscribeToMessages(observer: self)
//    }
//    
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
}
