//
//  EditorsViewController.swift
//  Stylo
//
//  Created by Sebastien Hamel on 2019-12-30.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import WriterCommon

protocol EditorsViewController: class {
    
    var contentViews: [EditorContentView] { get }
    
    var visibleEditors: [EditableView] { get }
    
    var textLeftSideViews: [EditorSideView] { get }
    
    var textRightSideViews: [EditorSideView] { get }
    
    var isLeftSplitViewItem: Bool { get }
    
    var isRightSplitViewItem: Bool { get }
    
    var scrollView: ProjectTextEditorsScrollView! { get }
    
    var projectTextEditorsListSplitViewController: ProjectTextEditorsListSplitViewController? { get }
    
    var representedObject: Any? { get set }
    
    var projectTextEditorViewControllers: [TextId: ProjectTextEditorViewController] { get }
    
    func disableScrolling()
    
    func enableScrolling()
}
