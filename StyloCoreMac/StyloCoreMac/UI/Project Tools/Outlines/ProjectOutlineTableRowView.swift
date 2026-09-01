//
//  ProjectOutlineTableRowView.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-08-05.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import WriterCommon

/// see https://stackoverflow.com/questions/26884021/custom-selection-style-for-view-based-source-list-nsoutlineview
final class ProjectOutlineTableRowView: NSTableRowView {
    
    private var selectionView = CustomHighlightRowSelectionView(frame: NSRect.zero)
    
    override var isEmphasized: Bool {
        didSet {
            self.selectionView.isEmphasized = isEmphasized
        }
    }
        
    override var isSelected: Bool {
        didSet {
            self.selectionView.selected = isSelected
        }
    }
    
    override var frame: NSRect {
        didSet {
            self.selectionView.frame = self.bounds
        }
    }
    
    override var bounds: NSRect {
        didSet {
            self.selectionView.frame = self.bounds
        }
    }
    
    override func addSubview(_ view: NSView, positioned place: NSWindow.OrderingMode, relativeTo otherView: NSView?) {

        if place != .below {
            super.addSubview(view, positioned: place, relativeTo: otherView)
        }
        else {
            if self.selectionView.superview == nil {
                super.addSubview(self.selectionView, positioned: place, relativeTo: otherView)
                self.selectionView.frame = self.bounds
            }
        }
    }
}
