//
//  DomInspectorOutlineView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2016-01-08.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import Web
import WriterCommon

final class DomInspectorOutlineView: NSOutlineView {
    
    var isInLiveResize: Bool = false
    
    var appearanceMode: AppearanceMode?
    
    private let minusCharacterString = "\u{2212}"
    private let plusCharacterString = "+"

    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        self.backgroundColor = NSColor.clear
        self.appearance = NSAppearance(named: NSAppearance.Name.vibrantDark)
        self.appearanceMode = AppearanceMode.dark
    }
    
    override func makeView(withIdentifier identifier: NSUserInterfaceItemIdentifier, owner: Any?) -> NSView? {
        
        let view = super.makeView(withIdentifier: identifier, owner: owner)
        
        if identifier == NSOutlineView.disclosureButtonIdentifier {
            
            let disclosureButton = view as! NSButton
            
            if let appearanceMode = appearanceMode {
                
                switch appearanceMode {
                case .dark:
                    darkButton(disclosureButton: disclosureButton)
                case .light:
                    lightButton(disclosureButton: disclosureButton)
                }
            }
            else {
             
                lightButton(disclosureButton: disclosureButton)
            }
        }
        
        return view 
    }
    
    override func frameOfCell(atColumn column: Int, row: Int) -> NSRect {
        
        var frame = super.frameOfCell(atColumn: column, row: row)
        
        if isRowEndRow(row) {
            
            frame.origin.x -= self.indentationPerLevel
        }
        else if let delegate = delegate as? DomInspectorViewController , delegate.document is HtmlDocument && row == 0 {
            
            frame.origin.x -= self.indentationPerLevel
        }
        else if let delegate = delegate as? DomInspectorViewController , delegate.document is HtmlDocument && row == 1 {
            
            frame.origin.x -= self.indentationPerLevel
        }
        
        return frame
    }
    
    override func viewWillStartLiveResize() {
        
        isInLiveResize = true
        super.viewWillStartLiveResize()
    }
    
    override func viewDidEndLiveResize() {
        
        isInLiveResize = false
        super.viewDidEndLiveResize()
    }
    
    override func mouseDown(with theEvent: NSEvent) {
        
        let globalLocation: NSPoint = theEvent.locationInWindow
        let localLocation: NSPoint = convert(globalLocation, from: nil)
        let clickedRow: NSInteger = row(at: localLocation)
        
        super.mouseDown(with: theEvent)
        
        if (clickedRow != -1) {
            
            if let extendedDelegate = delegate as? ExtendedOutlineViewDelegate {
                
                extendedDelegate.outlineView(self, didClickedRow: clickedRow)
            }
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: private implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////

    private func isRowEndRow(_ row: Int) -> Bool {
        
        return false
    }
    
    private func lightButton(disclosureButton: NSButton) {
        
        disclosureButton.alternateImage = NSImage.image(withString: minusCharacterString)
        disclosureButton.image = NSImage.image(withString: plusCharacterString)
    }
    
    private func darkButton(disclosureButton: NSButton) {
        
        let white = NSColor.white
        let gray = NSColor.clear// (calibratedRed: 42/255, green: 41/255, blue: 40/255, alpha: 1).withAlphaComponent(textBackgroundAlphaValue)
        let black = NSColor.black
        
        let minusAttributedString = NSMutableAttributedString(string: minusCharacterString)
        minusAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: white, range:NSMakeRange(0,1))
        
        let plusAttributedString = NSMutableAttributedString(string: plusCharacterString)
        plusAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: white, range:NSMakeRange(0,1))
        
        disclosureButton.alternateImage = NSImage.image(with: minusAttributedString, backgroundColor: gray)
        disclosureButton.image = NSImage.image(with: plusAttributedString, backgroundColor: gray)
    }


}
