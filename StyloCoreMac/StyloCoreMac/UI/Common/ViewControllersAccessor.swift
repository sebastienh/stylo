//
//  ViewControllersAccessor.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-07-03.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon

public protocol ViewControllersAccessor {
    
    var windowController: StyloWindowController? { get }
    
    /// Access is garanteed in method viewDidAppear
    /// see https://stackoverflow.com/questions/35842626/access-nsdocument-from-nsviewcontroller-and-vice-versa
    var styloDocument: MacStyloDocument? { get }
    
    var globalMenuPanelViewController: GlobalMenuPanelViewController? { get }
    
    var styloStyleInspectorSplitViewController: StyloStyleInspectorSplitViewController? { get }
    
}

extension ViewControllersAccessor {
    
    /// Access is garanteed in method viewDidAppear
    /// see https://stackoverflow.com/questions/35842626/access-nsdocument-from-nsviewcontroller-and-vice-versa
    public var styloDocument: MacStyloDocument? {
        
        return windowController?.document as? MacStyloDocument
    }
    
    public var globalMenuPanelViewController: GlobalMenuPanelViewController? {
        
        return windowController?.contentViewController as? GlobalMenuPanelViewController
    }
    
    public var styloStyleInspectorSplitViewController: StyloStyleInspectorSplitViewController? {
        
        let globalMenuPanelViewController = windowController?.contentViewController as? GlobalMenuPanelViewController
        return globalMenuPanelViewController?.children.first as? StyloStyleInspectorSplitViewController
    }
    
}
