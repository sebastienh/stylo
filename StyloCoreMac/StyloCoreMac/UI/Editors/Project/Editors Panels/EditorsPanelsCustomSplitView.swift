//
//  EditorsPanelsCustomSplitView.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-02-17.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa
import WriterCommon
import os
import Common

public class EditorsPanelsCustomSplitView: NSViewController {

    @IBOutlet var containerView: EditorsPanelsContainerView!
    
    var splitViewItems: [EditorSplitViewItem] = []
    
    var dividers: [EditorSplitViewDivider] = []
    
    var dividerThickness: CGFloat = InterfaceConstants.EditorsPanel.DividerWidth
    
    var equalItemWidth: CGFloat {
        
        let totalAvailableWidth = self.view.frame.width
        return totalAvailableWidth/CGFloat(splitViewItems.count)
    }
    
    var didMoveDividerTimer: Timer?
    
    private var subscribedToSidebarsNotifications: Bool = false
    
    private var centerEditorSplitViewItems: ArraySlice<EditorSplitViewItem>? {
        
        guard splitViewItems.count > 2 else {
            assertionFailure("Error: splitViewItems is nil")
            return nil
        }
        
        return self.splitViewItems[1..<splitViewItems.count-1]
    }
    
    var mouseIsDown: Bool = false
    
    var mouseLocation: NSPoint?
    
    var movingDivider: EditorSplitViewDivider?
    
    var dividerBeforeMovingDivider: EditorSplitViewDivider?
    
    var dividerAfterMovingDivider: EditorSplitViewDivider?
    
    var sidebarsShown: Bool = false
    
    var toolsShown: Bool = false
    
    var projectToolsShown: Bool = false
    
    var dividersCenterPositionsBefore: [CGFloat] = []
    
    var containerViewWidthBefore: CGFloat = 0.0
    
    override public func viewDidAppear() {
        super.viewDidAppear()
        subscribeToSidebarsNotificationsIfNecessary()
    }
    
    private func subscribeToSidebarsNotificationsIfNecessary() {
        
        if !subscribedToSidebarsNotifications {
            subscribeToSidebarsNotifications()
            subscribedToSidebarsNotifications = true
        }
    }
    
    private func subscribeToSidebarsNotifications() {
        
        guard let window = self.view.window else {
            assertionFailure("Error: window is nil")
            return
        }
        
        NotificationCenter.default.addObserver(forName: StyloNotification.willHideSidebars.name, object: window, queue: nil) { [weak self](_) in
            self?.handleSidebarsWillHide()
        }
        
        NotificationCenter.default.addObserver(forName: StyloNotification.showingSidebars.name, object: window, queue: nil) { [weak self](_) in
            self?.handleSidebarsShowing()
        }
        
        NotificationCenter.default.addObserver(forName: StyloNotification.hidingSidebars.name, object: window, queue: nil) { [weak self](_) in
            self?.handleSidebarsHiding()
        }
        
        NotificationCenter.default.addObserver(forName: StyloNotification.didHideSidebars.name, object: window, queue: nil) { [weak self](_) in
            self?.handleSidebarsDidHide()
        }
        
        NotificationCenter.default.addObserver(forName: StyloNotification.willShowSidebars.name, object: window, queue: nil) { [weak self](_) in
            self?.handleSidebarsWillShow()
        }
        
        NotificationCenter.default.addObserver(forName: StyloNotification.didShowSidebars.name, object: window, queue: nil) { [weak self](_) in
            self?.handleSidebarsDidShow()
        }
        
        NotificationCenter.default.addObserver(forName: StyloNotification.willShowNavigator.name, object: window, queue: nil) { [weak self](_) in
            self?.handleProjectToolsWillShow()
        }
        
        NotificationCenter.default.addObserver(forName: StyloNotification.didShowNavigator.name, object: window, queue: nil) { [weak self](_) in
            self?.handleProjectToolsDidShow()
        }
        
        NotificationCenter.default.addObserver(forName: StyloNotification.willHideNavigator.name, object: window, queue: nil) { [weak self](_) in
            self?.handleProjectToolsWillShow()
        }
        
        NotificationCenter.default.addObserver(forName: StyloNotification.didHideNavigator.name, object: window, queue: nil) { [weak self](_) in
            self?.handleProjectToolsDidShow()
        }
        
        NotificationCenter.default.addObserver(forName: StyloNotification.willShowTools.name, object: window, queue: nil) { [weak self](_) in
            self?.handleToolsWillShow()
        }
        
        NotificationCenter.default.addObserver(forName: StyloNotification.didShowTools.name, object: window, queue: nil) { [weak self](_) in
            self?.handleToolsDidShow()
        }
        
        NotificationCenter.default.addObserver(forName: StyloNotification.willHideTools.name, object: window, queue: nil) { [weak self](_) in
            self?.handleToolsWillShow()
        }
        
        NotificationCenter.default.addObserver(forName: StyloNotification.didHideTools.name, object: window, queue: nil) { [weak self](_) in
            self?.handleToolsDidShow()
        }
        
    }
    
    func handleProjectToolsDidShow() {
        
        // nothing to do
//        self.projectToolsShown = true
    }
    
    func handleProjectToolsWillShow() {
        
        // nothing to do
    }
    
    func handleProjectToolsDidHide() {
        
        // nothing to do
//        self.projectToolsShown = false
    }
    
    func handleProjectToolsWillHide() {
        
        // nothing to do
    }
    
    func handleToolsDidShow() {
        
        // nothing to do
//        self.toolsShown = true
    }
    
    func handleToolsWillShow() {
        
        // nothing to do
    }
    
    func handleToolsDidHide() {
        
        // nothing to do
//        self.toolsShown = false
    }
    
    func handleToolsWillHide() {
        
        // nothing to do
    }
    
    func handleSidebarsShowing() {
        
        // nothing to do
    }
    
    func handleSidebarsHiding() {
        
        // nothing to do
    }
    
    func handleSidebarsWillShow() {
        
        self.dividersCenterPositionsBefore.removeAll()
        self.containerViewWidthBefore = self.containerView.frame.width
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("handleSidebarsWillShow()", log: Log.StyloCore.all, type: .info)
        os_log("self.containerView.frame.width: %@", log: Log.StyloCore.all, type: .info, %%self.containerView.frame.width)
        #endif
        
        guard let contentView = self.view.window?.contentView else {
            assertionFailure("Error")
            return
        }
        
        for divider in self.dividers {
            
            self.dividersCenterPositionsBefore.append(divider.frame.midX)
            
            let centerConstraint = NSLayoutConstraint(item: divider, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: divider.frame.midX)
            
            centerConstraint.priority = .defaultHigh
            centerConstraint.isActive = true
            divider.centerConstraint?.isActive = false
            divider.centerConstraint = centerConstraint
        }
        self.updateViewConstraints()
    }
    
    func handleSidebarsDidShow() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("handleSidebarsDidShow()", log: Log.StyloCore.all, type: .info)
        os_log("self.containerView.frame.width: %@", log: Log.StyloCore.all, type: .info, %%self.containerView.frame.width)
        #endif
        
        guard let containerView = self.containerView else {
            assertionFailure("Error: self.containerView is nil")
            return
        }
        
        self.sidebarsShown = true
        let actualContainerWidth = self.containerViewWidthBefore-(InterfaceConstants.Sidebar.Width*2)
        
        var totalFractions: CGFloat = 0
        for (index, divider) in self.dividers.enumerated() {
            
            let dividerCenterPosition = self.dividersCenterPositionsBefore[index]-InterfaceConstants.Sidebar.Width
            let multiplier = dividerCenterPosition/actualContainerWidth
            
            let centerConstraint = NSLayoutConstraint(item: divider, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .right, multiplier: multiplier, constant: 0)
            
            totalFractions += multiplier
            centerConstraint.priority = InterfaceConstants.EditorsPanesSplitView.DividerPriority
            centerConstraint.isActive = true
            divider.centerConstraint?.isActive = false
            divider.centerConstraint = centerConstraint
        }
        self.updateViewConstraints()
    }
    
    func handleSidebarsWillHide() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("handleSidebarsWillHide()", log: Log.StyloCore.all, type: .info)
        os_log("self.containerView.frame.width: %@", log: Log.StyloCore.all, type: .info, %%self.containerView.frame.width)
        #endif
        
        self.dividersCenterPositionsBefore.removeAll()
        
        self.containerViewWidthBefore = self.containerView.frame.width
        
        guard let contentView = self.view.window?.contentView else {
            assertionFailure("Error")
            return
        }
        
        for divider in self.dividers {
            
            self.dividersCenterPositionsBefore.append(divider.frame.midX)
            
            let centerConstraint = NSLayoutConstraint(item: divider, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: divider.frame.midX+InterfaceConstants.Sidebar.Width)
            
            centerConstraint.priority = .defaultHigh
            centerConstraint.isActive = true
            divider.centerConstraint?.isActive = false
            divider.centerConstraint = centerConstraint
        }
        
        self.updateViewConstraints()
    }

    func handleSidebarsDidHide() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("handleSidebarsDidHide()", log: Log.StyloCore.all, type: .info)
        os_log("self.containerView.frame.width: %@", log: Log.StyloCore.all, type: .info, %%self.containerView.frame.width)
        #endif
        
        self.sidebarsShown = false
        
        for (index, divider) in self.dividers.enumerated() {
            
            let multiplier = (self.dividersCenterPositionsBefore[index]+InterfaceConstants.Sidebar.Width)/(self.containerViewWidthBefore+(InterfaceConstants.Sidebar.Width*2))
            
            let centerConstraint = NSLayoutConstraint(item: divider, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .right, multiplier: multiplier, constant: 0)
            
            centerConstraint.priority = InterfaceConstants.EditorsPanesSplitView.DividerPriority
            centerConstraint.isActive = true
            divider.centerConstraint?.isActive = false
            divider.centerConstraint = centerConstraint
        }
        
        self.updateViewConstraints()
    }
    
    func removeSplitViewItem(_ splitViewItemToRemove: EditorSplitViewItem) {
        for (index, splitViewItem) in splitViewItems.enumerated() {
            if splitViewItem === splitViewItemToRemove {
                self.removeItem(atIndex: index)
                break
            }
        }
    }
    
    func insertSplitViewItem(_ splitViewItem: EditorSplitViewItem, at index: Int) {
        
        if index == 0 {
            insertItemFirst(splitViewItem)
        }
        else if index == splitViewItems.count {
            append(splitViewItem)
        }
        else {
            insertItemMiddle(splitViewItem, atIndex: index)
        }
    }
    
    func insertItemFirst(_ splitViewItem: EditorSplitViewItem) {
        
        addItemAsSubview(splitViewItem, atIndex: 0)
        
        if !splitViewItems.isEmpty {
            
            splitViewItems.insert(splitViewItem, at: 0)
            let divider = EditorSplitViewDivider(dividerThickness: self.dividerThickness, splitViewDividerDelegate: self)
            addDividerAsSubview(divider, atIndex: 1)
            dividers.insert(divider, at: 0)
            setEqualWidth()
        }
        else {
            splitViewItems.append(splitViewItem)
            setEqualWidth()
        }
    }
    
    func append(_ item: EditorSplitViewItem) {
        
        if !splitViewItems.isEmpty {
            
            let divider = EditorSplitViewDivider(dividerThickness: self.dividerThickness, splitViewDividerDelegate: self)
            addDividerAsSubview(divider, atIndex: self.containerView.arrangedSubviews.count)
            dividers.append(divider)
            addItemAsSubview(item, atIndex: self.containerView.arrangedSubviews.count)
            splitViewItems.append(item)
            setEqualWidth()
        }
        else {
            insertItemFirst(item)
        }
    }
    
    func insertItemMiddle(_ splitViewItem: EditorSplitViewItem, atIndex index: Int) {
        
        assert(splitViewItems.count-1 == dividers.count)
        
        guard index > 0 && index < splitViewItems.count else {
            assertionFailure("Error: connot remove in empty splitViewItems array")
            return
        }
        
        guard index-1 >= 0 && index-1 < dividers.count else {
            assertionFailure("Error: cannot remove in empty dividers array ")
            return
        }
        
        let itemIndex = index*2
        
        addItemAsSubview(splitViewItem, atIndex: itemIndex)
        splitViewItems.insert(splitViewItem, at: index)
        
        let divider = EditorSplitViewDivider(dividerThickness: self.dividerThickness, splitViewDividerDelegate: self)
        addDividerAsSubview(divider, atIndex: itemIndex+1)
        dividers.insert(divider, at: index)
        
        setEqualWidth()
    }
    
    func removeItem(atIndex index: Int) {
        
        if index == 0 {
            self.removeFirstItem()
        }
        else if index == splitViewItems.count-1 {
            removeLastItem()
        }
        else {
            removeMiddleItem(atIndex: index)
        }
    }
    
    func removeFirstItem() {
        
        guard !splitViewItems.isEmpty else {
            assertionFailure("Error: connot remove in empty splitViewItems array")
            return
        }
        
        guard !dividers.isEmpty else {
            assertionFailure("Error: cannot remove in empty dividers array ")
            return
        }
        
        let firstItem = splitViewItems.removeFirst()
        self.containerView.removeArrangedSubview(firstItem)
        
        let firstDivider = dividers.removeFirst()
        self.containerView.removeArrangedSubview(firstDivider)
        
        firstItem.removeFromSuperview()
        firstDivider.removeFromSuperview()
        
        setEqualWidth()
    }
    
    func removeLastItem() {
        
        guard !splitViewItems.isEmpty else {
            assertionFailure("Error: connot remove in empty splitViewItems array")
            return
        }
        
        guard !dividers.isEmpty else {
            assertionFailure("Error: cannot remove in empty dividers array ")
            return
        }
        
        let lastItem = splitViewItems.removeLast()
        self.containerView.removeArrangedSubview(lastItem)
        
        let lastDivider = dividers.removeLast()
        self.containerView.removeArrangedSubview(lastDivider)
        
        lastItem.removeFromSuperview()
        lastDivider.removeFromSuperview()
        
        setEqualWidth()
    }
    
    private func removeMiddleItem(atIndex index: Int) {
     
        assert(splitViewItems.count-1 == dividers.count)
        
        guard index > 0 && index < splitViewItems.count else {
            assertionFailure("Error: connot remove in empty splitViewItems array")
            return
        }
        
        guard index-1 >= 0 && index-1 < dividers.count else {
            assertionFailure("Error: cannot remove in empty dividers array ")
            return
        }
        
        let item = splitViewItems.remove(at: index)
        let divider = dividers.remove(at: index-1)
        
        self.containerView.removeArrangedSubview(item)
        self.containerView.removeArrangedSubview(divider)
        
        item.removeFromSuperview()
        divider.removeFromSuperview()
        
        setEqualWidth()
    }
    
    private func addItemAsSubview(_ item: EditorSplitViewItem, atIndex index: Int) {
     
        #if DEBUG
        // make sure the view is not already added
        for subview in self.containerView.subviews {
            if subview === item {
                assertionFailure("Error: the view is already in the hierarchy")
            }
        }
        #endif
        
        let itemView = item
        
        self.containerView.insertArrangedSubview(itemView, at: index)
    }
 
    private func addDividerAsSubview(_ divider: EditorSplitViewDivider, atIndex index: Int) {
        
        self.containerView.insertArrangedSubview(divider, at: index)
        divider.initLocationConstraint()
    }
        
    private func setEqualWidth() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("setEqualWidth()", log: Log.StyloCore.all, type: .info)
        #endif
        
        let equalItemWidth = self.equalItemWidth
        var currentWidth = equalItemWidth
        
        for (index, item) in self.dividers.enumerated() {
            
            let percent = CGFloat(index+1)/CGFloat(self.dividers.count+1)
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("percent at index %@: %@", log: Log.StyloCore.all, type: .info, %%index, %%percent)
            #endif
            
            let centerConstraint = NSLayoutConstraint(item: item, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: percent, constant: 0)
            
            centerConstraint.priority = InterfaceConstants.EditorsPanesSplitView.DividerPriority
            item.centerConstraint?.isActive = false
            centerConstraint.isActive = true
            item.centerConstraint = centerConstraint
            currentWidth += equalItemWidth
        }
        self.updateViewConstraints()
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
}

