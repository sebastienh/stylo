//
//  AddTextOutlineCellView.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-08-24.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa
import WriterCommon
import Common

class AddTextOutlineCellView: TextEditorsOutlineCellView, TextBackgroundColorListener {
    
    var editorId: EditorId?
    
    @IBOutlet var backgroundView: ColoredView!
    
    @IBOutlet var addButton: AddTextButton!
    
    var textManagerId: String? {
        willSet {
            unsubscribeToTextManager()
        }
        didSet {
            subscribeToTextManager()
        }
    }
    
    weak var documentManager: DocumentManager?
    
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
    
    func updateBackgroundColor(with color: NSColor) {

        self.backgroundView.backgroundColor = color
        self.updateAppearance(from: color)
    }
    
    private func handleDocumentAttributes(_ documentAttributes: DocumentAttributes?) {
        
        let backgroundColor = documentAttributes?.backgroundColor
        
        if let backgroundColor = backgroundColor {
            self.updateBackgroundColor(with: backgroundColor)
            self.needsDisplay = true
        }
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
        
//        guard let textManager = self.textManager else {
//            assertionFailure("Error: self.textManager is nil")
//            return
//        }
//
//        self.handleDocumentAttributes(textManager.documentAttributes.value)
//        textManager.documentAttributes.subscribe({ [weak self](documentAttributes) in
//            self?.handleDocumentAttributes(documentAttributes)
//        }, observer: self)
    }
    
    private func unsubscribeToTextManager() {
        
        if let textManager = self.textManager {
            
//            textManager.backgroundColor.unsubscribe(observer: self)
            textManager.pluginsBackgroundActivities.unsubscribe(observer: self)
        }
    }
    
    deinit {
        unsubscribeToTextManager()
    }
}
