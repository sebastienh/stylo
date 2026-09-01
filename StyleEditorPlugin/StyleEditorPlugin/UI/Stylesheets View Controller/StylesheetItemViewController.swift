//
//  StylesheetItemViewController.swift
//  StyleEditorPlugin
//
//  Created by Sebastien Hamel on 2020-08-17.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Foundation
import Common
import WriterCommon
import StyloCoreMac
import os

class StylesheetItemViewController: NSViewController {

    @IBOutlet var appearanceButton: NSPopUpButton!
    
    @IBOutlet var nameTextField: StylesheetNameTextField? {
        didSet {
            NotificationCenter.default.addObserver(forName: NSControl.textDidChangeNotification, object: nameTextField, queue: nil) { [weak self](notification) in
                self?.controlTextDidChange(notification)
            }
            NotificationCenter.default.addObserver(forName: NSControl.textDidEndEditingNotification, object: nameTextField, queue: nil) { [weak self](notification) in
                self?.controlTextDidEndEditing(notification)
            }
        }
    }
    
    override var representedObject: Any? {
        didSet {
            guard let stylesheetManager = representedObject as? StylesheetManager else {
                assertionFailure("Error: representedObject is not StylesheetManager")
                return
            }
            self.subscribe(toStylesheetManager: stylesheetManager)
        }
    }
    
    private var stylesheetManager: StylesheetManager? {
        
        return self.representedObject as? StylesheetManager
    }
    
    private var stylesheetsViewController: StylesheetsViewController? {
        
        var responder: NSResponder? = self.nextResponder
        while responder != nil {
            if let stylesheetsViewController = responder as? StylesheetsViewController {
                return stylesheetsViewController
            }
            responder = responder?.nextResponder
        }
        return nil
    }
    
    @IBAction func delete(_ sender: AnyObject?) {
        
        guard let stylesheetsViewController = self.stylesheetsViewController else {
            assertionFailure("Error: stylesheetsViewController is nil")
            return
        }
        
        guard let stylesheetManager = self.stylesheetManager else {
            assertionFailure("Error: self.stylesheetManager is nil")
            return
        }
        
        let answer = dialogOKCancel(question: "Are you sure you want to delete the stylesheet with name: \(stylesheetManager.title)?", text: "The stylesheet will be removed from the style. You cant undo this action.")
        
        if answer {
            stylesheetsViewController.delete(stylesheetWithId: stylesheetManager.id)
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
    
    @IBAction func updateAppearances(_ sender: AnyObject?) {
        
        guard let stylesheetManager = self.stylesheetManager else {
            assertionFailure("Error: self.stylesheetManager is nil")
            return
        }
        
        switch appearanceButton.indexOfSelectedItem {
        case 0:
            stylesheetManager.addAppearance(.light)
            stylesheetManager.removeAppearance(.dark)
        case 1:
            stylesheetManager.addAppearance(.dark)
            stylesheetManager.removeAppearance(.light)
        case 2:
            stylesheetManager.addAppearance(.light)
            stylesheetManager.addAppearance(.dark)
        default:
            assertionFailure("Error: unsupported index: \(appearanceButton.indexOfSelectedItem)")
            break
        }
        
        self.styleViewController?.hasPendingChanges = true
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        guard let stylesheetManager = self.stylesheetManager else {
            assertionFailure("Error: self.stylesheetManager is nil")
            return
        }
        
        self.updateAppearances(fromAppearances: stylesheetManager.appearances.values)
    }
    
    @objc func controlTextDidChange(_ obj: Notification) {
        
        let textField: NSTextField = obj.object as! NSTextField
        textField.invalidateIntrinsicContentSize()
    }
    
    @objc func controlTextDidEndEditing(_ obj: Notification) {
        
        let textField: NSTextField = obj.object as! NSTextField
        stylesheetManager?.name.setValue(textField.stringValue) 
    }
    
    private func subscribe(toStylesheetManager stylesheetManager: StylesheetManager) {
        
        self.updateAppearances(fromAppearances: stylesheetManager.appearances.values)
        stylesheetManager.appearances.subscribe({ [weak self](change) in
            switch change {
            case .deletes(_, let appearances):
                self?.updateAppearances(fromAppearances: appearances)
            case .inserts(_, let appearances):
                self?.updateAppearances(fromAppearances: appearances)
            }
        }, observer: self)
        
        stylesheetManager.name.subscribe({ [weak self](name) in
            self?.nameTextField?.stringValue = name
        }, observer: self)
    }
    
    private func updateAppearances(fromAppearances appearances: Set<AppearanceMode>) {

        guard let appearanceButton = self.appearanceButton else {
            return
        }
        
        guard appearances.count <= 2 else {
            assertionFailure("Error: unsupported count: \(appearances.count)")
            return
        }
        
        if appearances.count == 2 {
            appearanceButton.selectItem(at: 2)
        }
        else if appearances.count == 1 {
            
            let appearance = appearances.first!
            switch appearance {
            case .dark:
                appearanceButton.selectItem(at: 1)
            case .light:
                appearanceButton.selectItem(at: 0)
            }
        }
    }
    
    private var styleViewController: StyleViewController? {
        
        var responder: NSResponder? = self.nextResponder
        while responder != nil {
            if let styleViewController = responder as? StyleViewController {
                return styleViewController
            }
            responder = responder?.nextResponder
        }
        return nil
    }
    
    @IBAction func editStylesheetButtonClicked(_ sender: AnyObject?) {
     
        self.styleViewController?.editStylesheetButtonClicked(sender)
    }
    
    override func viewDidLoad() {
        self.updateDisplayedStylesheetName()
    }
    
    private func updateDisplayedStylesheetName() {
        
        guard let stylesheetManager = self.stylesheetManager else {
            assertionFailure("Error: stylesheetManager is nil")
            return
        }
        
        assert(self.nameTextField != nil)
        self.nameTextField?.stringValue = stylesheetManager.name.value
    }
}
