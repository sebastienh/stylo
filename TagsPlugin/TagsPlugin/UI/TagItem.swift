//
//  TagTokenField.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-05-01.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa
import StyloCoreMac

class TagItem: NSView {
    
    static let font = NSFont.systemFont(ofSize: 14.0, weight: .regular)
    
    @IBOutlet var textField: TokenTextField!
    
    private var removeHighlightTimer: Timer?
    
    @objc var text: String = "" {
        didSet {
            textField.attributedStringValue = self.attributedString
            self.textField.invalidateIntrinsicContentSize()
            self.updateColor()
        }
    }
    
    var selected: Bool = false {
        didSet {
            self.updateColor()
        }
    }

    func flash() {
        
        self.layer?.borderColor = cgColor(named: "tag-navigation-highlight-border-color", bundle: self.bundle)
        self.layer?.borderWidth = 1.5
        self.layer!.backgroundColor = cgColor(named: "tag-navigation-highlight-background-color", bundle: self.bundle)
        scheduleRemoveFlash()
    }
    
    private func scheduleRemoveFlash() {
        
        self.removeHighlightTimer?.invalidate()
        self.removeHighlightTimer = Timer.scheduledTimer(withTimeInterval: StyloConstants.Tags.FlashDelaySeconds, repeats: false, block: { [weak self](_) in
            self?.removeFlash()
        })
    }
    
    func removeFlash() {
        
        self.removeHighlightTimer?.invalidate()
        self.layer?.borderWidth = 0.0
        updateColor()
    }
    
    func highlight() {
        
        self.layer?.borderWidth = 1.5
        self.layer?.borderColor = cgColor(named: "tag-highlight-border-color", bundle: self.bundle)
    }
    
    func resetHighlight() {
        
        self.layer?.borderWidth = 0.0
    }
    
    private var attributedString: NSAttributedString {
        
        return NSAttributedString(string: text, attributes: [.font : TagItem.font])
    }
    
    private func updateColor() {
        
        if !selected {
            self.layer!.backgroundColor = cgColor(named: "tag-unselected-background-color", bundle: self.bundle)
            self.textField.textColor = nsColor(named: "tag-unselected-text-color", bundle: self.bundle)
        }
        else {
            resetHighlight()
            self.layer!.backgroundColor = cgColor(named: "tag-selected-background-color", bundle: self.bundle)
            self.textField.textColor = nsColor(named: "tag-selected-text-color", bundle: self.bundle)
        }
    }
    
}
