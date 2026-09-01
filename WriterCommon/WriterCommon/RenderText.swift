//
//  RenderText.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-05-02.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import Web

final class RenderText : RenderObject {
    
    override func paintTemporary(contentString: StylableString, resourceComputedStyle: ResourceComputedStyle) {
        
        super.paintTemporary(contentString: contentString, resourceComputedStyle: resourceComputedStyle)
        
        let textStylizer = TextStylizer.shared
        
        if let element = element, let computedStyle = resourceComputedStyle.computedStyleForElement(element) {
            
            let textAttributes = textStylizer.textStyle(from: computedStyle, element: element)
            let ranges = computeRanges(for: element)!
            
            // just making sure
            if let textAttributes = textAttributes, textAttributes.count > 0 && ranges.count > 0  {
                
                for range in ranges {
                    
                    // http://stackoverflow.com/questions/25007289/swift-editing-uitextview-from-inside-callback-crashes-app
                    if contentString.isValidRange(range) {
                        
    //                    self.contentString.addTemporaryAttributes(textAttributes, forCharacterRange: range)
                    }
                }
            }
        }
    }
    
    override func paint(contentString: StylableString, resourceComputedStyle: ResourceComputedStyle) {
        
        super.paint(contentString: contentString, resourceComputedStyle: resourceComputedStyle)
        
        let textStylizer = TextStylizer.shared
        
        if let element = element, let computedStyle = resourceComputedStyle.computedStyleForElement(element) {
            
            let textAttributes = textStylizer.textStyle(from: computedStyle, element: element)
            
            let isImpactedByPseudo = hasExclusionRanges(element: element)
            let ranges = computeRanges(for: element)!
            
            // just making sure
            if let textAttributes = textAttributes, textAttributes.count > 0 && ranges.count > 0  {
                
                for range in ranges {
                    
                    if isImpactedByPseudo {
                        
                        let elementSpecificRanges = rangesMinusImpactedRange(for: element, range: range)
                        
                        for elementSpecificRange in elementSpecificRanges {
                            
                            apply(attributes: textAttributes, to: elementSpecificRange, contentString: contentString)
                        }
                    }
                    else {
                        
                        apply(attributes: textAttributes, to: range, contentString: contentString)
                    }
                }
            }
        }
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: RenderTreeVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // 1. Traverse the left subtree.
    // 2. Visit the root.
    // 3. Traverse the right subtree.
    override func accept<Visitor: RenderTreeVisitor>(_ visitor: Visitor) -> Visitor.NodeInfoType? {

        //loggingPrint("RenderText visited by: \(visitor)")
        
        let nodeInfo = visitor.visit(self)
        
        // it's possible for a RenderText to have a child 
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
