//
//  StylesTableRowView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-02-07.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import Common
import os
import StyloCoreMac

import WriterCommon


extension NSWindow.OrderingMode: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .above:
            return "above"
        case .below:
            return "below"
        case .out:
            return "out"
        @unknown default:
            assertionFailure("unknown")
            return "unknown"
        }
    }
    
}


/// see https://stackoverflow.com/questions/26884021/custom-selection-style-for-view-based-source-list-nsoutlineview
final class StylesTableRowView: NSTableRowView {
    
    private var selectionView = CustomStyleHighlightRowSelectionView(frame: NSRect.zero)
    
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
        
        if view.className != "NSBackgroundColorView" {
            super.addSubview(view, positioned: place, relativeTo: otherView)
        }
        else {
            if self.selectionView.superview == nil {
                super.addSubview(self.selectionView, positioned: .below, relativeTo: otherView)
                self.selectionView.frame = self.bounds
            }
        }
    }
}


