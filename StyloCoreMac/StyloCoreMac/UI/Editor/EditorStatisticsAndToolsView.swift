//
//  EditorStatisticsAndToolsView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2015-08-04.
//  Copyright (c) 2015 Textually Inc. All rights reserved.
//

import Foundation
import WriterCommon
import Cocoa
import Common

class EditorStatisticsAndToolsView: NSView, TextKeydownListener, DisappearableView, DisappearableBottomBar {
    
    internal var visibleBackgroundColor: CGColor?
    
//    weak var topView: NSView!
    
    @IBOutlet var toolsButton: DisappearableButton!
    
    @IBOutlet var themeButton: DisappearableButton!
    
    @IBOutlet var errorsButton: DisappearableButton!
    
    @IBOutlet var domButton: DisappearableButton!
    
    @IBOutlet var horizontalLineView: ColoredLineView!
    
    let animationDuration = 0.1
    
    var visible: Bool = true
    
    @IBInspectable var backgroundColor: NSColor? {
        
        didSet {
            self.layer!.backgroundColor = backgroundColor?.cgColor
        }
    }
    
    override init(frame frameRect: NSRect) {
        
        super.init(frame: frameRect)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.wantsLayer = true
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.wantsLayer = true
        startListeningToKeydownEvents()
    }
    
    override func viewDidMoveToWindow() {
        
        super.viewDidMoveToWindow()
        startListeningToShowBottomBarNotifications()
    }
    
    fileprivate func startListeningToShowBottomBarNotifications() {
    
        if let window = self.window {
        
            NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: §StyloNotification.ShowBottomBar), object: window, queue: nil) { [weak self](notification) -> Void in
            
                if self?.visible == false {
                    self?.add()
                }
            }
        }
    }
    
    fileprivate func stopListeningToShowBottomBarNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: §StyloNotification.ShowBottomBar), object: self.window!)
    }
    
    
    func handleKeydownEvent(with event: NSEvent) {
        
        if visible {
            remove()
        }
    }
    
    /// see http://stackoverflow.com/questions/296967/animation-end-callback-for-calayer
    func add() {
        
        visible = true
        self.isHidden = false
        self.horizontalLineView?.isHidden = false 
        self.toolsButton?.isHidden = false
        self.domButton?.isHidden = false
        self.themeButton?.isHidden = false
        self.errorsButton?.isHidden = false
    }
    
    /// see http://stackoverflow.com/questions/296967/animation-end-callback-for-calayer
    func remove() {
        
        visible = false
        self.isHidden = true
        self.horizontalLineView?.isHidden = true
        self.toolsButton?.isHidden = true
        self.domButton?.isHidden = true
        self.themeButton?.isHidden = true
        self.errorsButton?.isHidden = true
    }
    
    deinit {
        
        stopListeningToKeydownEvents()
        stopListeningToShowBottomBarNotifications()
    }
}
