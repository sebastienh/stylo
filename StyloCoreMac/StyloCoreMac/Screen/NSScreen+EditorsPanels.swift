//
//  NSScreen+EditorsPanels.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-03-11.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa

extension NSScreen {
    
    func allowsAddingOtherEditorsPanel(forFilesOutlinesCount filesOutlinesCount: Int) -> Bool {
    
        var currentMaximumMinimumWidth = filesOutlinesCount*Int(InterfaceConstants.EditorsPanel.MinimumWidth)
        currentMaximumMinimumWidth += Int(InterfaceConstants.Sidebar.Width*2)
        currentMaximumMinimumWidth += Int(InterfaceConstants.EditorsPanel.DividerWidth)*(filesOutlinesCount-1)
        currentMaximumMinimumWidth += Int(InterfaceConstants.ProjectSidebar.ProjectTabInitialMinimumWidth)
        
        // to allow adding a new editors panel, we must be below maximum main screen after the addition
        if (currentMaximumMinimumWidth + Int(InterfaceConstants.EditorsPanel.MinimumWidth+InterfaceConstants.EditorsPanel.DividerWidth)) <= Int(self.visibleFrame.width) {
            return true
        }
        return false
    }
    
}
