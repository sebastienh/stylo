//
//  CSSStyleTableCellView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2015-08-30.
//  Copyright (c) 2015 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon
import Common
import StyloCoreMac

final class ThemesTableCellView: NSTableCellView {
    
    override var isOpaque: Bool {
        
        return true
    }
    
    var isEnabled: Bool {
     
        didSet {
//            styleIcon.isEnabled = isEnabled
            self.editButton.isEnabled = isEnabled
            self.deleteButton.isEnabled = isEnabled
//            styleIcon.updateAppearance()
        }
    }
    
    @IBOutlet weak var stackView: NSStackView!
    
    @objc var associatedThemeManager: ThemeManager? {
        
        willSet {
            if let associatedThemeManager = associatedThemeManager {
                associatedThemeManager.selectedTheme.unsubscribe(observer: self)
            }
        }
        didSet {
            
            if let associatedThemeManager = associatedThemeManager {
            
                // set initial values
                self.selected = associatedThemeManager.selectedTheme.value
                
                associatedThemeManager.selectedTheme.subscribe({
                    [unowned self] in
                    self.selected = $0
                }, observer: self)
            }
        }
    }
    
    @objc dynamic var name: String {
        
        get {
            return associatedThemeManager?.name.value ?? ""
        }
        set {
            associatedThemeManager?.name.setValue(newValue)
        }
    }
    
    weak var associatedTextManager: TextManager?
    
    @IBOutlet var numberOfIssuesLabel: NSTextField!
    
    @IBOutlet var titleLable: ThemeNameTextField! {
        
        didSet {
            
            titleLable.themesTableCellView = self
            titleLable.textColor = NSColor.secondaryLabelColor
        }
    }
    
    @IBOutlet var editButton: NSButton!
    
    @IBOutlet var deleteButton: NSButton!
    
    var selected: Bool {
        
        didSet {
            
            updateButtonsHiddenState()
            updateSelectedBackgroundColor()
            updateTitleLableTextColor()
        }
    }
    
    private var trackingArea: NSTrackingArea!
    
    private var listening: Bool = false
    
    private var mouseOver: Bool = false
    
    private var backgroundColor: CGColor? {
        
        get {
            return self.layer!.backgroundColor
        }
        set {
            self.layer!.backgroundColor = newValue
        }
    }
    
    required init?(coder: NSCoder) {
        
        selected = false
        isEnabled = true
        super.init(coder: coder)
        self.wantsLayer = true
        createTrackingArea()
    }
    
    override func viewDidChangeEffectiveAppearance() {
        
        self.needsLayout = true
        super.viewDidChangeEffectiveAppearance()
    }
    
    override func updateLayer() {
        
        self.updateSelectedBackgroundColor()
        super.updateLayer()
    }
    
    override func layout() {
        
        self.updateTitleLableTextColor()
        super.layout()
    }
    
    override func mouseEntered(with event: NSEvent) {
        
        if !selected && isEnabled {
            handleMouseOver(true)
        }
    }
    
    override func mouseExited(with event: NSEvent) {
        
        if !selected && isEnabled {
            handleMouseOver(false)
        }
    }
    
    func setInitialNumberOfErrorsStringValue(failableManager: Failable/*Manager*/) {
        
        handleErrorMessagesChange(messagesArray: failableManager.errors, failable: failableManager)
    }
    
    func listenToDidUpdateIssuesArray(failableManager: Failable/*Manager*/) {
        
        if !listening {
            
            let stylesheetManager = failableManager as! StylesheetManager
            
            stylesheetManager.subscribeToMessages(observer: self) { [weak self] (change: DynamicArray<Message>.Change) -> Void in
                
                switch change {
                case .deletes(_, _, let messagesArray):
                    self?.handleErrorMessagesChange(messagesArray: messagesArray, failable: failableManager)
                case .inserts(_, _, let messagesArray):
                    self?.handleErrorMessagesChange(messagesArray: messagesArray, failable: failableManager)
                case .insert(_, _, let messagesArray):
                    self?.handleErrorMessagesChange(messagesArray: messagesArray, failable: failableManager)
                case .move(_, _, _, let messagesArray):
                    self?.handleErrorMessagesChange(messagesArray: messagesArray, failable: failableManager)
                case .end: fallthrough
                case .start:
                    break
                }
            }
            
            listening = true
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: private implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////

    private func handleMouseOver(_ over: Bool) {
        
        self.mouseOver = over
        updateMouseOverTextColor()
//        styleIcon.handleMouseOver(over)
    }
    
    private func updateMouseOverTextColor() {
        
        if self.mouseOver {
            titleLable.textColor = Constants.Themes.StylesListCell.SelectedTitleColor
        }
        else {
            titleLable.textColor = Constants.Themes.StylesListCell.NotSelectedTitleColor
        }
    }
    
    private func updateSelectedBackgroundColor() {
        
        if selected {
            backgroundColor = cgColor(named: "SelectedTableCellViewBackgroundColor")
        } else {
            backgroundColor = cgColor(named: "UnselectedTableCellViewBackgroundColor")
        }
    }
    
    private func updateTitleLableTextColor() {
        
        if selected {
            
            titleLable.textColor = Constants.Themes.StylesListCell.SelectedTitleColor
        } else {
            
            titleLable.textColor = Constants.Themes.StylesListCell.NotSelectedTitleColor
        }
    }
    
    private func updateButtonsHiddenState() {
        
        if selected {
            
            editButton.isHidden = false
            deleteButton.isHidden = false
        } else {
            
            editButton.isHidden = true
            deleteButton.isHidden = true
        }
    }
    
    private func createTrackingArea() {
        
        let options = NSTrackingArea.Options.activeInActiveApp.union(.mouseEnteredAndExited).union(.inVisibleRect)
        self.trackingArea = NSTrackingArea(rect: self.bounds, options: options, owner: self, userInfo: nil)
        self.addTrackingArea(self.trackingArea)
    }
    
    private func handleErrorMessagesChange(messagesArray: [Message], failable: Failable) {
        
        if !messagesArray.isEmpty {
        
            let issuesString = Strings.shared.numberOfIssuesString(with: messagesArray.count)
            
            if stackView.views.count == 1 {
                self.stackView.addView(numberOfIssuesLabel, in: NSStackView.Gravity.bottom)
            }
            self.numberOfIssuesLabel.stringValue = issuesString
        }
        else {
            
            if stackView.views.count == 2 {
                self.stackView.removeView(self.numberOfIssuesLabel)
            }
        }
    }
    
    func stopToListenToDidUpdateErrorsArray(stylesheetManager: StylesheetManager) {
        
        stylesheetManager.unsubscribeToMessages(observer: self)
    }
}

