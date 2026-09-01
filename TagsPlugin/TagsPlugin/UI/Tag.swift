//
//  Tag.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-05-01.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa
import Common
import WriterCommon

class Tag: NSCollectionViewItem {

    static let reuseIdentifier = NSUserInterfaceItemIdentifier(rawValue: "Tag")
    
    @IBOutlet var tokenField: TagItem!
    
    @objc dynamic var font: NSFont = TagItem.font
    
    override var isSelected: Bool {
        didSet {
            tokenField.selected = self.isSelected
        }
    }

    override var highlightState: NSCollectionViewItem.HighlightState {
        didSet {
            switch self.highlightState {
            case .asDropTarget:
                break
            case .forDeselection:
                break
            case .forSelection:
                tokenField.highlight()
            case .none:
                tokenField.resetHighlight()
                break
            @unknown default:
                assertionFailure("Error: unhandled case: \(self.highlightState)")
                break
            }
        }
    }
    
    func removeFlash() {
        
        tokenField.removeFlash()
    }
    
    func flash() {
        
        tokenField.flash()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        guard let tagText = self.representedObject as? String else {
            assertionFailure("Error: self.representedObject is not String but \(type(of: self.representedObject))")
            return
        }
        
        tokenField.text = tagText
    }
}
