//
//  TextContainerView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2015-10-22.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import Common
import os

public final class TextContainerView: NSView, BackgroundColorBindable {
    
    weak var rightView: EditorSideView!
    weak var leftView: EditorSideView!
    
    weak var rightScrollView: EditorSideScrollView!
    weak var leftScrollView: EditorSideScrollView!
    
    @IBOutlet var lineNumberingGreaterOrEqualWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet var lineNumberingEqualWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet var rightScrollViewEqualWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet var rightScrollViewGreaterOrEqualWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet var editorScrollView: EditorSynchronizedScrollView!
    
    @IBInspectable var variableSizeSides: Bool = false

    @IBInspectable var backgroundColor: CGColor {
        
        get {
            return self.layer!.backgroundColor!
        }
        set {
            self.layer!.backgroundColor = newValue
        }
    }
    
    override init(frame frameRect: NSRect) {
        
        super.init(frame: frameRect)
        self.wantsLayer = true
        self.backgroundColor = NSColor.clear.cgColor
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        self.wantsLayer = true
        self.backgroundColor = NSColor.clear.cgColor
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// see https://stackoverflow.com/a/37191964/2915955
    override public func mouseDown(with event: NSEvent) {
        
        // Do nothing to not propagate the click event to descendant views
    }

    override public func awakeFromNib() {
        
        super.awakeFromNib()
        
        lineNumberingGreaterOrEqualWidthConstraint?.constant = InterfaceConstants.Markdown.Editor.LeftSideMinimumWidth
        lineNumberingEqualWidthConstraint?.constant = InterfaceConstants.Markdown.Editor.LeftSideMinimumWidth
        
        rightScrollViewEqualWidthConstraint?.constant = InterfaceConstants.Markdown.Editor.RightSideMinimumWidth
        rightScrollViewGreaterOrEqualWidthConstraint?.constant = InterfaceConstants.Markdown.Editor.RightSideMinimumWidth
    }
    
    public func addAllConstraints() {
        
        if variableSizeSides {
            addScrollViewsConstraints()
        }
        
        addEditorScrollViewCondtraints()
        addLeftViewHeightConstraint()
        addRightViewHeightConstraint()
        addLineNumberingViewWidthConstraint()
        addMessageViewWidthConstraint()
        
        needsUpdateConstraints = true
    }
    
    func addEditorScrollViewCondtraints() {
        
        // Create a constraint of the form "view1.attr1 <relation> view2.attr2 * multiplier + constant".
        let editorScrollViewBottomConstraint = NSLayoutConstraint(item: editorScrollView, attribute:NSLayoutConstraint.Attribute.bottom, relatedBy:NSLayoutConstraint.Relation.equal, toItem:self, attribute:NSLayoutConstraint.Attribute.bottom, multiplier:1, constant:0)
        
        addConstraint(editorScrollViewBottomConstraint)
    }
    
    func addScrollViewsConstraints() {
        
        if let leftScrollView = leftScrollView, let rightScrollView = rightScrollView {
            
            // Create a constraint of the form "view1.attr1 <relation> view2.attr2 * multiplier + constant".
            let leftViewBottomConstraint = NSLayoutConstraint(item: leftScrollView, attribute:NSLayoutConstraint.Attribute.bottom, relatedBy:NSLayoutConstraint.Relation.equal, toItem:editorScrollView, attribute:NSLayoutConstraint.Attribute.bottom, multiplier:1, constant:0)
            
            // Create a constraint of the form "view1.attr1 <relation> view2.attr2 * multiplier + constant".
            let rightViewBottomConstraint = NSLayoutConstraint(item: rightScrollView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy:NSLayoutConstraint.Relation.equal, toItem: editorScrollView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier:1, constant:0)
            
            addConstraint(leftViewBottomConstraint)
            addConstraint(rightViewBottomConstraint)
        }
    }
    
    func addMessageViewWidthConstraint() {
        
        if let rightScrollView = rightScrollView, let rightView = rightView {
            
            let rightScrollViewClipView: NSClipView = rightScrollView.contentView
            
            let rightViewEqualWidthConstraint = NSLayoutConstraint(item: rightView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: rightScrollViewClipView, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 0)
            
            addConstraint(rightViewEqualWidthConstraint)
        }
    }
    
    func addLineNumberingViewWidthConstraint() {
        
        if let leftScrollView = leftScrollView, let leftView = leftView {
            
            let leftScrollViewClipView: NSClipView = leftScrollView.contentView
            
            let leftViewEqualWidthConstraint = NSLayoutConstraint(item: leftView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: leftScrollViewClipView, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 0)
            
            addConstraint(leftViewEqualWidthConstraint)
        }
    }
    
    func addLeftViewHeightConstraint() {
        
        if let leftScrollView = leftScrollView {
            
            let textEditorView: NSView = editorScrollView.documentView!
            
            assert(leftScrollView.documentView != nil)
            assert(leftView != nil)
            
            let leftViewEqualHeightConstraint = NSLayoutConstraint(item: leftView!, attribute:NSLayoutConstraint.Attribute.height, relatedBy:NSLayoutConstraint.Relation.equal, toItem:textEditorView, attribute:NSLayoutConstraint.Attribute.height, multiplier:1, constant:0)
            
            addConstraint(leftViewEqualHeightConstraint)
        }
    }
    
    func addRightViewHeightConstraint() {
        
        if let rightScrollView = rightScrollView {
            
            let textEditorView = editorScrollView.documentView
            
            assert(rightScrollView.documentView != nil)
            assert(rightView != nil)
            
            let rightViewEqualHeightConstraint = NSLayoutConstraint(item:rightView!, attribute:NSLayoutConstraint.Attribute.height, relatedBy:NSLayoutConstraint.Relation.equal, toItem:textEditorView, attribute:NSLayoutConstraint.Attribute.height, multiplier:1, constant:0)
            
            addConstraint(rightViewEqualHeightConstraint)
        }
    }
    
    func updateBackgroundColor(with color: NSColor) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("setting background in text container color to %@", log: Log.StyloCore.all, type: .info, %%color)
        #endif
        self.backgroundColor = color.cgColor
    }
    
}

