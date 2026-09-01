//
//  EditorSplitViewItem.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-02-17.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa

class EditorSplitViewItem: NSView {
    
    let viewController: NSViewController
    
    var trailingConstraint: NSLayoutConstraint?
    
    var leadingConstraint: NSLayoutConstraint?
    
    init(viewController: NSViewController) {
        
        self.viewController = viewController
        super.init(frame: .zero)
        self.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        self.translatesAutoresizingMaskIntoConstraints = false
        snapContainedView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func snapContainedView() {
        
        let content = viewController.view
        self.addSubview(content)
        
        NSLayoutConstraint(item: content, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: content, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: content, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: content, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        self.needsUpdateConstraints = true
    }
    
}

