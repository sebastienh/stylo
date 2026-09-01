//
//  ResourceStyleRenderTree.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-06-14.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Web
import Common

/// Head of a render tree.
public final class ResourceStyleRenderTree: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        
        let renderTreeSerializer = RenderTreeSerializer.shared
        let serializedRenderTree = renderTreeSerializer.serializeRenderObject(renderObject: self.parentRenderObject)
        return "\(serializedRenderTree)"
    }
    
    /// StylableStringContainer reference since we can't reference a RenderableResource
    /// because we we a type association. we keept a reference to
    weak var stylableStringContainer: StylableStringContainer!
    
    /// The parentRenderObject is a reference to the root of the RenderTree.
    /// It should be populated by the documentElement.
    var parentRenderObject: RenderObject!
    
    /// The topRenderableRenderObject is the RenderObject that is used to
    /// do the rendering. In Html this object is body sine head and html are
    /// not per say rendered. This object is used by the incremental compilation
    /// process to now where to put new elements.
    var topRenderableRenderObject: RenderObject!
    
    /// Pointer to the resource computed style computed for the document
    /// and the DOM tree.
    var resourceComputedStyle: ResourceComputedStyle? {
        
        didSet {
            
            //loggingPrint("setting resourceComputedStyle in ResourceStyleRenderTree: \(resourceComputedStyle)")
        }
    }
    
    /// Keeps a list of the elements that are eimpacted by pseudo-elements.
    //var elementsImpactedByPseudoElements: [Element: [NSRange]]
    
    
    fileprivate init(stylableStringContainer: StylableStringContainer?, parentRenderObject: RenderObject? = nil) {
        
        self.parentRenderObject = parentRenderObject
        self.stylableStringContainer = stylableStringContainer
        
    }
    
    ///
    convenience init(parentRenderObject: RenderObject? = nil) {
        
        self.init(stylableStringContainer: nil, parentRenderObject: parentRenderObject)
    }
    
    /// Since the ResourceStyleRenderTree is not stateless 
    /// we need to clear the renering info before each pass.
    func clearRenderingInfo() {
        
       // elementsImpactedByPseudoElements.removeAll(keepingCapacity: true)
    }
    
    /// Delete all the render tree nodes associated with the deleted DOM nodes
    func deleteRenderTreeNodesChilds(fromTopRenderNode topRenderNode: RenderObject, associatedWithTopDomNodes: ContiguousArray<Node>?) -> RenderObject? {
        
        var associatedWithTopDomNodesIndex = 0
        var child: RenderObject? = topRenderNode.firstChild as? RenderObject
        var associatedDomElement: Element? = nil
        var nextSibling: RenderObject? = nil
        
        if let associatedWithTopDomNodes = associatedWithTopDomNodes {
            
//            debugPrint("associatedWithTopDomNodes.count: \(associatedWithTopDomNodes.count)")
//            debugPrint("associatedWithTopDomNodesIndex: \(associatedWithTopDomNodesIndex)")
            
            func nextAssociatedDomElement() -> Element? {
                
                for i in associatedWithTopDomNodesIndex..<associatedWithTopDomNodes.count {
                    
                    if associatedWithTopDomNodes[i].nodeType == .element_node {
                        
                        // start at the next index the next time
                        associatedWithTopDomNodesIndex = i + 1
                        return associatedWithTopDomNodes[i] as! Element
                    }
                }
                return nil
            }
            
            associatedDomElement = nextAssociatedDomElement()
            
            while let _child = child {
                
//                debugPrint("_child element: \(_child.element!.localName)")
                
                child = _child.nextSibling as? RenderObject
                
                if let _associatedDomElement = associatedDomElement {
                    
//                    debugPrint("associatedDomElement: \(_associatedDomElement.localName)")
                    
                    // update the next sibling
                    nextSibling = child
                    
                    if _child.element == _associatedDomElement {
                        
                        topRenderNode.removeChild(_child)
                        associatedDomElement = nextAssociatedDomElement()
                    }
                }
                else {
                    
                    break
                }
            }
        }
        return nextSibling
    }
    
    
    func insertSubtree(subtree: RenderDocumentFragment, underParent parent: RenderObject, before: RenderObject? = nil) {
            
        var child: RenderObject? = subtree.firstChild as? RenderObject
        
        // going forward
        while let _child = child {
            
            child = _child.nextSibling as? RenderObject
            
            if let before = before {
                parent.addChild(_child, beforeChild: before)
            }
            else {
                parent.append(_child)
            }
        }
    }
    
}
