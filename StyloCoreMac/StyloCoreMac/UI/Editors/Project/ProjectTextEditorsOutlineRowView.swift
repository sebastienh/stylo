//
//  ProjectTextEditorsOutlineRowView.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-08-24.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import WriterCommon
import Common

class ProjectTextEditorsOutlineRowView: NSTableRowView, TextBackgroundColorListener {
    
    var editorId: EditorId?
    
    var projectTextEditorView: ProjectTextEditor? {
        assert(self._titleOutlineCellView == nil, "request from the wrong index...")
        return _projectTextEditorView
    }

    var titleOutlineCellView: TitleOutlineCellView? {
        assert(self._projectTextEditorView == nil, "request from the wrong index...")
        return _titleOutlineCellView
    }
    
    private var _projectTextEditorView: ProjectTextEditor? {
        for subview in subviews {
            if let editorOutlineCellView = subview as? EditorOutlineCellView {
                return editorOutlineCellView.textEditor
            }
        }
        return nil
    }
    
    private var _titleOutlineCellView: TitleOutlineCellView? {
        for subview in subviews {
            if let titleOutlineCellView = subview as? TitleOutlineCellView {
                return titleOutlineCellView
            }
        }
        return nil
    }
    
    private let textManager: TextManager?
    
    init(textManager: TextManager? = nil, editorId: EditorId) {
        
        self.textManager = textManager
        self.editorId = editorId
        super.init(frame: .zero)
        
        guard let textManager = textManager else {
            assertionFailure("Error: textManager is nil")
            return
        }
        self.startListening(to: textManager)
    }
    
    required init?(coder decoder: NSCoder) {
        self.textManager = nil
        super.init(coder: decoder)
    }
    
    override func didAddSubview(_ subview: NSView) {
        super.didAddSubview(subview)
        
        if subview.className == "NSBannerView" {
            subview.isHidden = true
        }
        else if let cellView = subview as? NSTableCellView {
            
            NSLayoutConstraint(item: cellView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier:1, constant:0).isActive = true
            NSLayoutConstraint(item: cellView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier:1, constant:0).isActive = true
            NSLayoutConstraint(item: cellView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier:1, constant:0).isActive = true
            NSLayoutConstraint(item: cellView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier:1, constant:0).isActive = true
        }
    }
    
    func updateBackgroundColor(with color: NSColor) {
        
        self.handleTextManagerBackgroundColorChange(color)
    }
    
    private func handleTextManagerBackgroundColorChange(_ newColor: NSColor?) {
        
        guard let newColor = newColor else {
            assertionFailure("Error: newColor is nil")
            return
        }
        
        self.backgroundColor = newColor
        self.updateAppearance(from: newColor)
        self.needsDisplay = true
    }

    private func updateAppearance(from color: NSColor?) {

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
    
    deinit {
        
        if let textManager = self.textManager {
            self.stopListening(to: textManager)
        }
    }
}
