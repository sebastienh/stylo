//
//  Constants.swift
//  StyleEditorPlugin
//
//  Created by Sebastien Hamel on 2019-12-31.
//  Copyright © 2019 Sebastien hamel. All rights reserved.
//

import Foundation
import StyloCoreMac
import Common
import WriterCommon

#if os(OSX)
import Cocoa
#elseif os(iOS)
import UIKit
#endif

public struct Constants {
    
    public struct Plugin {
        public static let Name = §TextuallyPlugin.editorStyle
        public static let StylesDirectoryName = "styles"
    }
    
    public struct CSS {
        
        public struct Editor {
            
            public static let EditorToolsToggleButtonActiveImageName: NSImage.Name = NSImage.Name(string: "open-low-panel-blue")
            public static let EditorToolsToggleButtonInactiveImageName: NSImage.Name = NSImage.Name(string: "open-low-panel-gray")
            public static let Insets: NSSize = NSMakeSize(0.0, 0.0)
            public static let BackgroundColor = InterfaceConstants.Colors.GrayColor
            public static let EnabledApplyButtonColor = InterfaceConstants.Colors.SelectedTextColor
            public static let DisabledApplyButtonColor = InterfaceConstants.Colors.NotSelectedTextColor
        }
        
        public struct HelpPanel {
            
            public static let BackgroundColor = InterfaceConstants.Colors.GrayColor
        }
        
        public struct StylesListCell {
            public static let SelectedTitleColor = InterfaceConstants.Colors.SelectedTextColor
            public static let NotSelectedTitleColor = InterfaceConstants.Colors.NotSelectedTextColor
            public static let SelectedCellColor = NSColor.black
            public static let NotSelectedCellColor = NSColor(calibratedRed: 30/255, green: 30/255, blue: 30/255, alpha: 1)
            public static let CellHeight: CGFloat = 70.0
        }
        
        public struct StylesList {
            
            public static let TitlePanelBackgroundColor = NSColor(calibratedRed: 30/255, green: 30/255, blue: 30/255, alpha: 1)
            public static let TableViewBackgroundColor = InterfaceConstants.Colors.DarkGrayColor
            public static let TableViewSeparatorColor = InterfaceConstants.Colors.GrayColor
            public static let styleButtonOnAnimationDuration = 0.1
            public static let styleButtonOffAnimationDuration = 0.1
            
        }
    }
}
