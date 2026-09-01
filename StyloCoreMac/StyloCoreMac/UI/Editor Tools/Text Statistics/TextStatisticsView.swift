//
//  TextStatisticsView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-07-28.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import Common
import os

final class TextStatisticsView: NSView, BackgroundColorBindable {
 
    private let baseViewHeight: CGFloat = 310.0
    private let veticalStackViewSpacing: CGFloat = 12.0
    
    @IBInspectable var backgroundColor: NSColor? {
        
        didSet {
            self.needsLayout = true
        }
    }
 
    weak var textStatisticsViewController: TextStatisticsViewController?
    
    override var intrinsicContentSize: NSSize {
        
        assert(textStatisticsViewController != nil)
        if let textStatisticsViewController = textStatisticsViewController {
            
            switch textStatisticsViewController.currentUIState {
                
            case .initial:
                return NSMakeSize(260.0, baseViewHeight + 32.0 + veticalStackViewSpacing)
                
            case .sessionDisabled:
                return NSMakeSize(260.0, baseViewHeight)
                
            case .sessionNotStarted:
                return NSMakeSize(260.0, baseViewHeight + 16.0)
                
            case .sessionHidden:
                return NSMakeSize(260.0, baseViewHeight + 16.0)
                
            case .sessionShown:
                return NSMakeSize(260.0, baseViewHeight + 32.0 + veticalStackViewSpacing)
            }
        }
        else {
            
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("intrinsicContentSize: %@", log: Log.StyloCore.all, type: .error, %%NSMakeSize(260.0, 375.0))
            #endif
            return NSMakeSize(260.0, 375.0)
        }
    }
    
    override init(frame frameRect: NSRect) {
        
        super.init(frame: frameRect)
        self.wantsLayer = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        self.wantsLayer = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
//    override func layout() {
//
//        self.layer!.backgroundColor = backgroundColor?.cgColor
//        super.layout()
//    }
}
