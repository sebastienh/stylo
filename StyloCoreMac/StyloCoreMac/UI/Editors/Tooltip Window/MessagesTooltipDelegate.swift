//
//  MessagesTooltipDelegate.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-03-20.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Common
import Cocoa
import WriterCommon
import os

public class MessagesTooltipDelegate: NSObject, TooltipDelegate, Observer {
    
    public var priority: ObserverPriority {
        return .ui
    }
    
    let popover: NSPopover
    
    var tooltipShownTimer: Timer?
    
    var tooltipPopoverViewController: TooltipViewController?
    
    weak var editable: AnyEditable?
    
    public init(editable: AnyEditable?) {
        
        assert(editable != nil)
        self.editable = editable
        
        self.popover = NSPopover()
        super.init()
        
        initializePopover()
        listenToLastEditDate()
    }
    
    public func showMessageTooltip(with message: Message, relativeTo positioningRect: NSRect, in positioningView: NSView) {
        
        if positioningView.window != nil {
        
            if let editable = editable {
            
                if let lastEditDate = editable.lastEditDate.value {
                
                    let timeInterval = abs(lastEditDate.timeIntervalSinceNow)
                    
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("timeInterval since last edit: %@", log: Log.StyloCore.all, type: .info, %%timeInterval)
                    #endif
                    
                    if timeInterval > StyloConstants.MessageTooltips.LastEditTimeIntervalAllowedMessageTooltipDisplay {
                        
                        _showMessageTooltip(with: message, relativeTo: positioningRect, in: positioningView)
                    }
                    else {
                        
                        #if DEBUG
                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                        os_log("timeInterval since last edit: %@ is not greater than %@.", log: Log.StyloCore.all, type: .info, %%timeInterval, %%StyloConstants.MessageTooltips.LastEditTimeIntervalAllowedMessageTooltipDisplay)
                        #endif
                        #endif
                    }
                }
                else {
                    _showMessageTooltip(with: message, relativeTo: positioningRect, in: positioningView)
                }
            }
            else {
                _showMessageTooltip(with: message, relativeTo: positioningRect, in: positioningView)
            }
        }
    }
    
    @objc public func removeDisplayedMessageTooltip() {
        
        if popover.isShown {
            
            popover.performClose(self)
            self.tooltipShownTimer?.invalidate()
            self.tooltipShownTimer = nil
        }
    }
    
    private func _showMessageTooltip(with message: Message, relativeTo positioningRect: NSRect, in positioningView: NSView) {
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("positioningRect: %@", log: Log.StyloCore.all, type: .info, %%NSStringFromRect(positioningRect))
        #endif
        
        assert(tooltipPopoverViewController != nil)
        tooltipPopoverViewController?.representedObject = message
        
        popover.show(relativeTo: positioningRect, of: positioningView, preferredEdge: .maxY)
        
        self.tooltipShownTimer = Timer.scheduledTimer(timeInterval: StyloConstants.MessageTooltips.MessageTooltipLifetime, target: self, selector: #selector(self.removeDisplayedMessageTooltip), userInfo: nil, repeats: false)
    }
    
    private func initializePopover() {
        
        let bundle = Bundle(for: MessagesTooltipDelegate.self)
        let mainStoryboard: NSStoryboard = NSStoryboard(name: NSStoryboard.Name(string: "Tooltip"), bundle: bundle)
        
        self.tooltipPopoverViewController = mainStoryboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(string: "Tooltip")) as? TooltipViewController
        
        popover.contentViewController = tooltipPopoverViewController
        popover.behavior = .transient
    }
    
    /// NW-887: A message popover should disappear if the user writes.
    private func listenToLastEditDate() {
        
        assert(editable != nil)
        if let editable = editable {
            
            editable.lastEditDate.subscribe({ [weak self] (editDate) in
                self?.removeDisplayedMessageTooltip()
            }, observer: self)
        }
    }
    
}
