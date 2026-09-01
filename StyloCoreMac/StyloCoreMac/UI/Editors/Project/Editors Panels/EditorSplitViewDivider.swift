//
//  EditorSplitViewDivider.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-02-17.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa
import os
import Common

protocol SplitViewDividerDelegate: class {
    
    var sidebarsShown: Bool { get }
    
    func mouseMoved(with event: NSEvent, in divider: EditorSplitViewDivider?)
    
    func mouseDown(with event: NSEvent, in divider: EditorSplitViewDivider)
    
    func mouseUp(with event: NSEvent, in divider: EditorSplitViewDivider)
}




final class EditorSplitViewDivider: ColoredView {

    enum DividersEvent: CaseIterable {
        
        case didShow
        case didHide
    }
    
    let dividerThickness: CGFloat
    
    override public var allowsVibrancy: Bool {
        
        return false
    }
    
    var centerConstraint: NSLayoutConstraint?
    
    var sidebarsShownMutliplier: CGFloat = 0
    
    var sidebarsHiddenMutliplier: CGFloat = 0
    
    private weak var splitViewDividerDelegate: SplitViewDividerDelegate?
    
    private var locationConstraint: NSLayoutConstraint?
    
    private var leadingPositionInSuperview: CGFloat {
        
        return frame.minX
    }
    
    private var mouseIsDown: Bool = false {
        didSet {
            if !mouseIsDown {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("SplitViewDividerDelegate.mouseIsDown -> NSCursor.arrow.set()", log: Log.StyloCore.all, type: .info)
                #endif
                NSCursor.arrow.set()
            }
            else {
                NSCursor.resizeLeftRight.set()
            }
        }
    }
    
    convenience init(dividerThickness: CGFloat, splitViewDividerDelegate: SplitViewDividerDelegate) {
        
        self.init(frame: .zero, dividerThickness: dividerThickness, splitViewDividerDelegate: splitViewDividerDelegate)
    }
    
    init(frame frameRect: NSRect, dividerThickness: CGFloat, splitViewDividerDelegate: SplitViewDividerDelegate) {
        self.dividerThickness = dividerThickness
        self.splitViewDividerDelegate = splitViewDividerDelegate
        super.init(frame: frameRect)
        self.wantsLayer = true
        self.backgroundColor = nsColor(named: "EditorsPaneSeparatorColor", bundle: Bundle(for: type(of: self)))
        self.addTrackingArea(NSTrackingArea(rect: NSZeroRect, options: NSTrackingArea.Options.inVisibleRect.union(.activeInKeyWindow).union(.mouseEnteredAndExited), owner: self, userInfo: nil))
        self.widthAnchor.constraint(equalToConstant: 2.0).isActive = true
        self.needsUpdateConstraints = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidChangeEffectiveAppearance() {
        self.updateBackgroundColor()
        self.needsLayout = true
        super.viewDidChangeEffectiveAppearance()
    }
    
    private func updateBackgroundColor() {
        
        let appearanceName = self.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua])
        switch appearanceName {
        case .darkAqua?:
            self.backgroundColor = nsColor(named: "EditorsPaneSeparatorColor", bundle: Bundle(for: type(of: self)))
        case .aqua?:
            self.backgroundColor = nsColor(named: "EditorsPaneSeparatorColor", bundle: Bundle(for: type(of: self)))
        default:
            assert(false)
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        
        assert(self.splitViewDividerDelegate != nil)
        splitViewDividerDelegate?.mouseUp(with: event, in: self)
        self.mouseIsDown = false
    }
    
    override func mouseDown(with event: NSEvent) {
        
        assert(self.splitViewDividerDelegate != nil)
        splitViewDividerDelegate?.mouseDown(with: event, in: self)
        self.mouseIsDown = true
    }
    
    func setDividerAbsolutePosition() {
        
        guard let superview = self.superview else {
            assertionFailure("Error: self.superview is nil")
            return
        }
        
        let constant = self.frame.midX
        
        let centerConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1, constant: constant)
        
        centerConstraint.priority = InterfaceConstants.EditorsPanesSplitView.DividerPriority
        centerConstraint.isActive = true
        
        
        self.centerConstraint?.isActive = false
        self.centerConstraint = centerConstraint
        self.superview?.needsUpdateConstraints = true
    }
    
    func setRelativeCenterConstraint() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("setRelativeCenterConstraint(...)", log: Log.StyloCore.all, type: .info)
        #endif
        
        
        guard let superview = self.superview else {
            assertionFailure("Error: self.superview is nil")
            return
        }

        let percent = self.frame.midX/superview.frame.width
        
        let centerConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .right, multiplier: percent, constant: 0)
        centerConstraint.priority = InterfaceConstants.EditorsPanesSplitView.DividerPriority
        
        centerConstraint.isActive = true
        
        self.centerConstraint?.isActive = false
        self.centerConstraint = centerConstraint
        self.superview?.needsUpdateConstraints = true
    }
    
    // In the textfield subclass:
    override func mouseEntered(with event: NSEvent) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("EditorSplitViewDivider mouseEntered", log: Log.StyloCore.all, type: .info)
        #endif

        if !mouseIsDown {
            NSCursor.resizeLeftRight.set()
        }
    }
    
    // In the textfield subclass:
    override func mouseExited(with event: NSEvent) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("EditorSplitViewDivider mouseExited", log: Log.StyloCore.all, type: .info)
        #endif
        if !mouseIsDown {
            //        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("mouseExited -> NSCursor.arrow.set() from EditorSplitViewDivider", log: Log.StyloCore.all, type: .info)
            //        #endif
            NSCursor.arrow.set()
        }
    }
    
    override func mouseMoved(with event: NSEvent) {

        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("EditorSplitViewDivider mouseMoved", log: Log.StyloCore.all, type: .info)
        #endif
        
        splitViewDividerDelegate?.mouseMoved(with: event, in: self)
    }
    
    func initLocationConstraint() {
        
        guard let superview = self.superview else {
            assertionFailure("Error: self.superview is nil")
            return
        }
        
        self.locationConstraint = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1, constant: self.frame.minX)
        self.locationConstraint?.priority = .windowSizeStayPut
        assert(self.locationConstraint?.isActive == false)
        self.superview?.needsUpdateConstraints = true
    }
    
    func fixLocation() {
        
        guard let superview = self.superview else {
            assertionFailure("Error")
            return
        }
        
        self.locationConstraint = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1, constant: self.frame.minX)
        self.locationConstraint?.priority = InterfaceConstants.EditorsPanesSplitView.FixedDividerPriority
        self.locationConstraint?.isActive = true
        self.superview?.needsUpdateConstraints = true
    }
    
    func unfixLocation() {
        
        self.locationConstraint?.isActive = false
        self.superview?.needsUpdateConstraints = true
    }
}

