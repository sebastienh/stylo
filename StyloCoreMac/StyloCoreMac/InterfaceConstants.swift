//
//  InterfaceConstants.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-11-22.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Cocoa

public struct InterfaceConstants {
    
    public struct Configuration {
        public static let HideEditorsHeadersOnKeyPressed: Bool = true
        public static let ShowTextEditorsPanelSeparators: Bool = true
        public static let TextEditorsPanelSeparatorsAnimationDuration = 0.75
    }
    
    public struct Load {
        public static let EmptyFilenamePlaceholder: String = "Loading Stylo file..."
    }
    
    public struct Export {
        public static let EmptyDocumentNamePlaceholder: String = "Exporting Stylo document"
    }
    
    public struct MenuItems {
    
        public struct Identifiers {
            public static let SpellingAndGrammar: String = "_NS:290"
            public static let Substitutions: String = "_NS:298"
            public static let Copy: String = "_NS:26"
            public static let LayoutOrientation: String = "_NS:337"
        }
    }
    
//    public struct TagsView {
//        
//        public static let cellHeight: CGFloat = 22.0
//        public static let sectionHeight: CGFloat = 22.0
//        public static let textFieldLeading: CGFloat = 8.0
//        public static let textFieldTrailing: CGFloat = 8.0
//
//        public static let topContentInset: CGFloat = 8.0
//        public static let bottomContentInset: CGFloat = 8.0
//        public static let leftContentInset: CGFloat = 12.0
//        public static let rightContentInset: CGFloat = 12.0
//        
//        public static let leftItemInset: CGFloat = 12.0
//        public static let rightItemInset: CGFloat = 12.0
//        
//    }
    
    
    public struct IssuesReporter {
        
        public static let TableViewBackgroundColor = InterfaceConstants.Colors.GrayColor
        public static let SelectedTitleColor = NSColor(calibratedRed: 155/255, green: 155/255, blue: 155/255, alpha: 1)
        public static let NotSelectedTitleColor = NSColor(calibratedRed: 78/255, green: 75/255, blue: 75/255, alpha: 1)
        public static let SelectedCellColor = NSColor.clear
        public static let NotSelectedCellColor = InterfaceConstants.Colors.GrayColor
        public static let NoIssuesViewBackgroundColor = InterfaceConstants.Colors.GrayColor
    }
    
    public struct Global {
        public static let TopMenuHeight: CGFloat = 22.0
        public static let TopMouseMovedTrackingHeight: CGFloat = 74.0
        public static let SidesMouseMovedTrackingWidth: CGFloat = 84.0
        public static let MinimumAlpha: CGFloat = 0.8
        public static let millisecondsWaitBeforeDisplayingWorkingWindow = 100
        public static let showSidebarsAtStartup: Bool = false
        
    }
    
    public struct Colors {
        public static let GrayColor = NSColor(calibratedRed: 42/255, green: 41/255, blue: 40/255, alpha: 1)
        public static let DarkGrayColor = NSColor(calibratedRed: 48/255, green: 47/255, blue: 46/255, alpha: 1)
        public static let DarkDarkGrayColor = NSColor(calibratedRed: 36/255, green: 35/255, blue: 34/255, alpha: 1)
        public static let SelectedTextColor = NSColor(calibratedRed: 155/255, green: 155/255, blue: 155/255, alpha: 1)
        public static let NotSelectedTextColor = NSColor(calibratedRed: 78/255, green: 75/255, blue: 75/255, alpha: 1)
    }
    
    public struct EditorTools {
        
        public struct TitlePanel {
            public static let BackgroundColor = InterfaceConstants.Colors.DarkDarkGrayColor
            public static let ErrorsButtonWithErrorsLabelColor = NSColor.red
        }
        
        public struct DomInspector {
            public static let TitleBarColor = InterfaceConstants.Colors.DarkDarkGrayColor
            public static let BackgroundColor = InterfaceConstants.Colors.GrayColor
        }
    }
    
    public struct TextStatistics {
        
        public struct TitlePanel {
            public static let BackgroundColor = InterfaceConstants.Colors.DarkDarkGrayColor
            
        }
        
        public struct MainPanel {
            public static let BackgroundColor = InterfaceConstants.Colors.GrayColor
        }
    }
    
    public struct Autocompletion {
        
        public struct Table {
            public static let BackgroundColor = InterfaceConstants.Colors.DarkGrayColor
        }
        
        public struct Selection {
            public static let Color = InterfaceConstants.Colors.SelectedTextColor
        }
    }
    
    public struct EditorsPanel {
        
        public static let MinimumWidth: CGFloat = 340.0
        public static let DividerWidth: CGFloat = 2.0
    }
    
    public struct Markdown {
        
        public struct Editor {
            
            // used in the project text editor
            public static let MinimumSideWidth: CGFloat = 100.0
            public static let MaximumSideWidth: CGFloat = 145.0
            
            public static let LeftSideMinimumWidth: CGFloat = 80.0
            public static let RightSideMinimumWidth: CGFloat = 36.0
            
            public static let ShouldAddInsets: Bool = true 
            public static let Insets: NSSize = NSMakeSize(0.0, 20.0)
            
            public static let MillisecondsFlashInterval: Int = 5000
        }
    }
    
    public struct TitlePanel {
        
        public static let BackgroundColor = InterfaceConstants.Colors.DarkDarkGrayColor
    }
    
    public struct Sidebar {
        
        public static let BackgroundColor = InterfaceConstants.Colors.DarkGrayColor
        public static let Width: CGFloat = 45.0
        public static let StyleIconSize: CGFloat = 26.0
    }
    
    public struct ToolsSidebar {
        
        public static let ToolsTabInitialWidth: CGFloat = 350
        
    }
    
    public struct ProjectSidebar {
        
        public static let ProjectTabInitialWidth: CGFloat = 350
        public static let ProjectTabInitialMinimumWidth: CGFloat = 200
    }
    
    public struct ProjectEditor {
        
        public static let NumberOfViewsPerTextElement = 2
    }
    
    public struct EditorSide {
    
        
    }
    
    public struct EditorsPanesSplitView {
    
        public static let DividerPriority = NSLayoutConstraint.Priority(rawValue: 254)
        public static let MovingDividerPriority = NSLayoutConstraint.Priority(rawValue: 251)
        public static let FixedDividerPriority = NSLayoutConstraint.Priority(rawValue: 256)
    }
}


