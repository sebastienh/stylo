//
//  StyloWindowController+ProjectTools.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-12-05.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa
import Common
import os

extension StyloWindowController {
    
    @IBAction func showHideNavigator(_ sender: AnyObject? = nil) {
        
        if navigatorShown {
            hideNavigator()
        }
        else {
            showNavigator()
        }
    }
    
    private var oldProjectSidebarWitdh: CGFloat {
        
        return oldProjectInspectorPanelWidth ?? InterfaceConstants.ProjectSidebar.ProjectTabInitialWidth
    }
    
    private func hideNavigator() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("hideNavigator", log: Log.StyloCore.all, type: .info)
        #endif
        
        // show the sidebar
        guard let globalMenuPanelViewController = self.globalMenuPanelViewController else {
            assertionFailure("Error: self.globalMenuPanelViewController is nil")
            return
        }
        
        StyloNotification.willHideNavigator.sendNotification(self.window!)
        
        NSAnimationContext.runAnimationGroup({ context in
            // Customize the animation parameters.
            context.duration = 0.15
            context.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
            self.toggleNavigator()
        }, completionHandler: {
            
            StyloNotification.didHideNavigator.sendNotification(self.window!)
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(50)) {
//                globalMenuPanelViewController.hideSidebars()
            }
        })
    }
    
    private func showNavigator() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("showNavigator", log: Log.StyloCore.all, type: .info)
        #endif
        
        self.toggleNavigator()
    }
    
    func toggleNavigator() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("toggleNavigator", log: Log.StyloCore.all, type: .info)
        #endif
        
        guard let styloStyleInspectorSplitViewController = self.styloStyleInspectorSplitViewController else {
            assertionFailure("Error: styloStyleInspectorSplitViewController is nil")
            return
        }
            
        let navigatorSplitViewItem = styloStyleInspectorSplitViewController.splitViewItems[§StyloStyleInspectorSplitViewController.SplitItem.navigator]
        
        guard let projectOutlineTitleViewController = navigatorSplitViewItem.viewController as? NavigatorViewController else {
            assertionFailure("Error: projectSidebarSplitViewItem.viewController is not ProjectOutlineTitleViewController")
            return
        }
        
        if navigatorSplitViewItem.isCollapsed {
            
            StyloNotification.willShowNavigator.sendNotification(self.window!)
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("inspectorSplitViewControllerSplitViewItem.isCollapsed", log: Log.StyloCore.all, type: .info)
            #endif
            
            // see https://stackoverflow.com/questions/34574478/how-can-i-set-the-position-of-a-nssplitview-nowadays-setpositionofdivideratind
            styloStyleInspectorSplitViewController.splitView.setPosition(oldProjectSidebarWitdh, ofDividerAt: 0)
            styloStyleInspectorSplitViewController.splitView.setPosition(oldProjectSidebarWitdh, ofDividerAt: 0)
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(10)) {
                StyloNotification.didShowNavigator.sendNotification(self.window!)
            }
            
        }
        else {
            
            StyloNotification.willHideNavigator.sendNotification(self.window!)
            
            // keep old width value
            oldProjectInspectorPanelWidth = projectOutlineTitleViewController.view.frame.size.width
            // we use isCollapsed instead of setting the divider position because
            // setting the divider position cause unsatisfyable layout constraints
            navigatorSplitViewItem.isCollapsed = true
            
            DispatchQueue.main.async {
                StyloNotification.didHideNavigator.sendNotification(self.window!)
            }
        }
    }
}
