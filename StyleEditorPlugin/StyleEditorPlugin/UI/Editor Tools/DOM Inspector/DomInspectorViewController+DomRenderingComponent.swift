//
//  DomInspectorViewController+DomRenderingComponent.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-02-13.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon
import Web

extension DomInspectorViewController: DomRenderingComponent {
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: DomRenderingComponent protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func reveal(node: DomInspectable) {
        
        if outlineView.row(forItem: node) != -1 {
            
            let inspectableChain = constructInspectableRevealChain(from: node)
            
            for inspectable in inspectableChain {
                
                outlineView.expandItem(inspectable)
            }
            scrollToItem(node: node)
        }
        else {
            
            self.scrollItem = node
            
            let inspectableChain = constructInspectableRevealChain(from: node)
            
            for inspectable in inspectableChain {
                
                expandedItemsPaths.append(inspectable.inspectablePath)
            }
        }
    }
    
    /// For keeping scroll position
    /// see https://forums.macrumors.com/threads/nsoulineview-scroll-position.764193/
    func reload() {
        
        let currentScrollPosition: NSPoint = scrollView.contentView.bounds.origin
        outlineView.reloadData()
        
        initExpansions(from: self.document!)
        
        if let scrollItem = scrollItem {
            
            scrollToItem(node: scrollItem)
            self.scrollItem = nil
        }
        else {
            
            scrollView.documentView?.scroll(currentScrollPosition)
        }
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: private implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /// Method that scrolls to an item in the outline view
    func scrollToItem(node: DomInspectable) {
        
        let row = outlineView.row(forItem: node)
        let rect = outlineView.rect(ofRow: row)
        outlineView.scroll(rect.origin)
    }
    
    func isExpanded(inspectable: DomInspectable) -> Bool {
        
        let inspectablePath = inspectable.inspectablePath
        
        for path in expandedItemsPaths {
            
            if path == inspectablePath {
                
                return true
            }
        }
        
        return false
    }
    
    func initExpansions(from root: DomInspectable) {
        
        for path in expandedItemsPaths {
            
            if let expandedItem = root.inspectable(at: path) {
                
                outlineView.expandItem(expandedItem)
            }
        }
    }
    
    private func constructInspectableRevealChain(from inspectable: DomInspectable) -> [DomInspectable] {
        
        var inspectableChain = [DomInspectable]()
        
        var nodeToReveal: DomInspectable? = inspectable
        
        while let _nodeToReveal = nodeToReveal {
            
            if !outlineView.isItemExpanded(_nodeToReveal) && outlineView.isExpandable(_nodeToReveal) {
                
                inspectableChain.insert(_nodeToReveal, at: 0)
            }
            nodeToReveal = _nodeToReveal.inspectableParent
        }
        
        return inspectableChain
    }

}
