//
//  RenderBlock.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-06-07.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import Web

final class RenderBlock: RenderObject {
    
    override func paintTemporary(contentString: StylableString, resourceComputedStyle: ResourceComputedStyle) {
        
        super.paintTemporary(contentString: contentString, resourceComputedStyle: resourceComputedStyle)
    }
    
    override func paint(contentString: StylableString, resourceComputedStyle: ResourceComputedStyle) {
        
        // only executes if the element for which we want to layout
        // still exists. We need this because once the render tree is
        // created the DOM cleanup and DOM update could still run and
        // delete elements in the DOM tree.
        if let element = element {
            
            if documentAttributesElement {
                
                layoutDocumentAttributes(resourceComputedStyle: resourceComputedStyle)
                paintDocumentAttributes(contentString: contentString)
            }
            else {
                
                if let computedStyle = resourceComputedStyle.computedStyleForElement(element) {
                    
                    let textStylizer = TextStylizer.shared
                    let textAttributes = textStylizer.blockStyle(from: computedStyle, element: element)
                    let ranges = computeRanges(for: element)!
                    
                    if let textAttributes = textAttributes, textAttributes.count > 0 && ranges.count > 0  {
                        
                        for range in ranges {
                            
    //                        printDebugInfo(element: element!, textAttributes: textAttributes, range: range)
                            
                            // http://stackoverflow.com/questions/25007289/swift-editing-uitextview-from-inside-callback-crashes-app
                            if contentString.isValidRange(range) {
                                
                                contentString.addAttributes(textAttributes, range: range)
                            }
                        }
                    }
                }
            }
        }
        
        super.paint(contentString: contentString, resourceComputedStyle: resourceComputedStyle)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: RenderTreeVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // 1. Traverse the left subtree.
    // 2. Visit the root.
    // 3. Traverse the right subtree.
    override func accept<Visitor: RenderTreeVisitor>(_ visitor: Visitor) -> Visitor.NodeInfoType? {
        
        let nodeInfo = visitor.visit(self)
        
        if let _nodeInfo = nodeInfo {
        
            visitor.push(_nodeInfo)
        
            var child: RenderObject? = firstChild as? RenderObject
        
            while let _child = child {
                
                _ = _child.accept(visitor)
            
                child = _child.nextSibling as? RenderObject
            }
        
            visitor.pop()
        }
        
        return nodeInfo
    }
    
}
