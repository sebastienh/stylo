//
//  TextEditorsPanelHighlightView.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-02-12.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa
import WriterCommon

class TextEditorsPanelHighlightView: ColoredView {
    
    var collapsed: Bool = false
    
    var selected: FilesOutlineManager.SelectionState = .single {
        didSet {
            self.updateBackgroundColor()
        }
    }
    
    var firstTextBackgroundColor: NSColor? {
        didSet {
            self.updateBackgroundColor()
        }
    }
    
    override func viewDidChangeEffectiveAppearance() {
        super.viewDidChangeEffectiveAppearance()
        self.updateBackgroundColor()
    }
    
    func updateBackgroundColor() {
        
        let alpha: CGFloat = {
            switch StyloApplication.shared.computedAppearanceOrDefault {
            case .dark:
                return 0.7
            case .light:
                return 1
            }
        }()
        
        switch self.selected {
        case .selected:
            self.backgroundColor = NSColor.controlAccentColor.withAlphaComponent(alpha)
        case .unselected: fallthrough
        case .single:
            if let firstTextBackgroundColor = self.firstTextBackgroundColor, self.collapsed {
                self.backgroundColor = firstTextBackgroundColor
            }
            else {
                self.backgroundColor = nsColor(named: "UnselectedPanelColor")
            }
        }
    }
    
    
}
