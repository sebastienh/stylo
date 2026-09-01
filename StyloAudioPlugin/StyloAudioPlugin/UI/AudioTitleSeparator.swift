//
//  AudioTitleSeparator.swift
//  StyloAudioPlugin
//
//  Created by Sebastien Hamel on 2020-05-26.
//  Copyright © 2020 Sebastien Hamel. All rights reserved.
//

import Cocoa
import StyloCoreMac

class AudioTitleSeparator: NSView {
    
    public override var isOpaque: Bool {
          
          #if ALPHA_COLOR_ENABLED
          return false
          #else
          return true
          #endif
      }
      
      @IBInspectable var backgroundColor: NSColor? {
          didSet {
              self.needsLayout = true
          }
      }

      @IBInspectable var cornerRadius: CGFloat = 0 {
          
          didSet {
          
              layer!.cornerRadius = cornerRadius
              layer!.masksToBounds = cornerRadius > 0
          }
      }
      @IBInspectable var borderWidth: CGFloat = 0 {
          
          didSet {
              layer!.borderWidth = borderWidth
          }
      }
      
      override init(frame frameRect: NSRect) {
          
          super.init(frame: frameRect)
          self.wantsLayer = true
      }

      required init?(coder: NSCoder) {

          super.init(coder: coder)
          self.wantsLayer = true
      }
      
      public override func layout() {
          
        self.backgroundColor = NSColor(named: NSColor.Name(string: "TitleSeparatorColor" ), bundle: nil)
          self.layer!.backgroundColor = backgroundColor?.cgColor
          super.layout()
      }
    
    override func viewDidChangeEffectiveAppearance() {
        
        self.needsLayout = true
        super.viewDidChangeEffectiveAppearance()
    }
    
}
