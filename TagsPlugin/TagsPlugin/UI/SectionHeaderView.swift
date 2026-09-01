//
//  SectionHeaderView.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-05-05.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa
import StyloCoreMac

class SectionHeaderView: NSVisualEffectView {
    
    static let reuseIdentifier = NSUserInterfaceItemIdentifier(rawValue: "SectionHeader")
    
    @IBOutlet weak var sectionTitle: NSTextField!
    
    @IBOutlet weak var coverView: ColoredView!
    
    @IBOutlet weak var tagsCount: NSTextField!
    
    override var isEmphasized: Bool {
        set{}
        get{return false}
    }
    
    @objc dynamic var font: NSFont = NSFont.monospacedSystemFont(ofSize: 16.0, weight: .regular)

     override open func viewDidMoveToWindow() {
         super.viewDidMoveToWindow()
         updateAppearance()
     }
     
     override open func viewDidChangeEffectiveAppearance() {
         updateAppearance()
         super.viewDidChangeEffectiveAppearance()
     }
     
     private func updateAppearance() {
         
         let appearanceName = self.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua])
         switch appearanceName {
         case .darkAqua?:
             self.blendingMode = .behindWindow
             self.material = .sidebar
             self.coverView.backgroundColor = NSColor.black.withAlphaComponent(0.1)
         case .aqua?:
             self.blendingMode = .behindWindow
             self.material  = .sidebar
            self.coverView.backgroundColor = NSColor.white.withAlphaComponent(0.2)
         default:
             assert(false)
         }
     }
    
}

