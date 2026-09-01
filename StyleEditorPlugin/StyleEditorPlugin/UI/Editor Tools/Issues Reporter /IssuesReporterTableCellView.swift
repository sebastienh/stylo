//
//  IssuesReporterTableCellView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2016-01-17.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import Common
import WriterCommon
import StyloCoreMac

final class IssuesReporterTableCellView: NSTableCellView {
    
    var messageId: String!
    
    var failable: Failable!
    
    @IBOutlet weak var label: NSTextField!
    
    @IBOutlet weak var message: NSTextField!
    
    var selected: Bool {
        didSet {
            self.needsLayout = true
        }
    }
    
    @objc dynamic var labelColor: NSColor!
    
    @objc dynamic var labelFont: NSFont!
    
    private var mouseOver: Bool = false
    
    private var trackingArea: NSTrackingArea!
    
    private var backgroundColor: CGColor? {
        get {
            return self.layer?.backgroundColor
        }
        set {
            self.layer?.backgroundColor = newValue
        }
    }
    
    required init?(coder: NSCoder) {
        
        selected = false
        super.init(coder: coder)
        createTrackingArea()
    }
    
    override func layout() {
        
        self.updateState()
        super.layout()
    }
    
    func resetState() {
        
        self.selected = false
        self.mouseOver = false
        self.needsLayout = true
    }
    
    override func mouseEntered(with event: NSEvent) {
        
        self.mouseOver = true
        if !selected {
            self.needsLayout = true
        }
    }
    
    override func mouseExited(with event: NSEvent) {
        
        self.mouseOver = false
        if !selected {
            self.needsLayout = true
        }
    }
    
    override func viewDidChangeEffectiveAppearance() {
        
        self.needsLayout = true
        super.viewDidChangeEffectiveAppearance()
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: private implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    private func updateState() {
        
        self.updateSelectedBackgroundColor()
        self.updateTitleLableTextColor()
    }
    
    private func updateTitleLableTextColor() {
        
        if selected || mouseOver {
            message?.textColor = NSColor.labelColor
        } else {
            message?.textColor = nsColor(named: "SecondaryTextColor")
        }
    }
    
    private func updateSelectedBackgroundColor() {
        
        if selected || mouseOver {
            backgroundColor = cgColor(named: "SelectedTableCellViewBackgroundColor")
        } else {
            backgroundColor = cgColor(named: "UnselectedTableCellViewBackgroundColor")
        }
    }
    
    private func createTrackingArea() {
        
        let options = NSTrackingArea.Options.activeInActiveApp.union(.mouseEnteredAndExited).union(.inVisibleRect)
        self.trackingArea = NSTrackingArea(rect: self.bounds, options: options, owner: self, userInfo: nil)
        self.addTrackingArea(self.trackingArea)
    }
    
}
