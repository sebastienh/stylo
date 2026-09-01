//
//  Strings.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-08-03.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa

public struct Strings {
    
    public static let shared = Strings()
    
    public let showPreview = "Show Preview"
    
    public let hidePreview = "Hide Preview"
    
    public let showToolsSidebar = "Show Tools"
    
    public let showStylePicker = "Show Style Picker"
    
    public let hideStylePicker = "Hide Style Picker"
    
    public let hideTools = "Hide Tools"
    
    public let showTools = "Show Tools"
    
    public let hideStyles = "Hide Styles"
    
    public let showStyles = "Show Styles"
    
    public let deleteStyle = "Delete Style"
    
    public let openStyleInspector = "Open Style Inspector"
    
    public let addStyle = "Add Style"
    
    public let dismissStyle = "Dismiss Style"
    
    public let showIssues = "Show Issues"
    
    public let dismissIssues = "Hide Issues"
    
    public let updateDocumentStyle = "Update Document Style"
    
    public let themeBackButtonTitle = "Themes"
    
    public let dismissThemes = "Dismiss Themes"
    
    public let showThemes = "Show Themes"
    
    public let errorUpdatingIssues = "Error updating issues..."
    
    public let enableTextStatisticsSessionTools = "Enable Session Tools"
    
    public let disableTextStatisticsSessionTools = "Disable Session Tools"
    
    public let preview = "Preview..."
    
    public let showNavigator = "Show Navigator"
    
    public let hideNavigator = "Hide Navigator"
    
    public let disableFocus = "Disable"
    
    public func numberOfIssuesString(with issuesCount: Int) -> String {
     
        if issuesCount != 0 {
            
            if issuesCount == 1 {
            
                return "\(issuesCount) issue"
            }
            else {
                return "\(issuesCount) issues"
            }
        }
        return "0 issue"
    }
    
}
