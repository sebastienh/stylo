//
//  Text.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-19.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common
import os

//https://dom.spec.whatwg.org/#text
//interface Text : CharacterData {
//    [NewObject] Text splitText(unsigned long offset);
//    readonly attribute DOMString wholeText;
//};

public class Text: CharacterData, HtmlDomVisitable, HtmlRendererVisitable {
    
    /**
     *  The wholeText attribute must return a concatenation of the
     *  data of the contiguous Text nodes of the context object, in tree order.
     *
     *
     *  @dom : attribute DOMString wholeText;
     */
    var wholeText: DOMString {
    
        var concatenatedTextData: DOMString = ""
            
        let contiguousTextNodes: [Text] = self.contiguousTextNodes()
        
        for textNode in contiguousTextNodes {
                
            concatenatedTextData += textNode.data
        }
        return concatenatedTextData
    }
    
    public override init(sourceStringFragment: SourceStringFragment?, document: Document?, data: DOMString) {
        
        super.init(sourceStringFragment: sourceStringFragment, document: document, data: data)
        nodeType = NodeType.text_node
        self.nodeName = "#text"
    }
    
    public convenience init(document: Document?, data: DOMString = "") {
        
        self.init(sourceStringFragment: nil, document: document, data: data)
    }
    
    /// Splits data at the given offset and returns the remainder as Text node.
    /// [NewObject] Text splitText(unsigned long offset);
    /// see https://dom.spec.whatwg.org/#dom-text-splittext
    func splitText(_ offset: Int, exception: inout Exception) -> Text? {

        return split(offset, exception: &exception)
    }
    
    ///
    /// see https://dom.spec.whatwg.org/#concept-text-split
    fileprivate func split(_ offset: Int, exception: inout Exception) -> Text? {
        
        // 1. Let length be node's length attribute value.
        let length = self.length
        
        // 2. If offset is greater than length, throw an IndexSizeError exception.
        if offset > length {

            exception.code = ExceptionCode.indexSizeError
            return nil
        }
        
        // 3. Let count be length minus offset.
        let count = length - offset
        
        // 4. Let "new data" be the result of substringing data with node node,
        // offset offset, and count count.
        let newData = substringData(offset, count: count, exception: &exception)
        
        if exception.isError() {
            
            return nil
        }
        
        // 5. Let "new node" be a new Text node, with the same node document as node.
        // Set new node's data to "new data".
        let newNode = Text(document: document , data: newData)
        
        // 6. Let parent be node's parent.
        // 7. If parent is not null, run these substeps:
        if let parent = self.parentNode {
            
            // 1. Insert "new node" into parent before node's next sibling.
            parent.insertBefore(newNode, before: self.nextSibling, exception: &exception)
            
            if exception.isError() {
                
                return nil
            }
            
            // 2. For each range whose start node is node and start offset is greater than offset, 
            // set its start node to new node and decrease its start offset by offset.
            for range in document.ranges {
                
                // start node is node
                if range.startContainer == self {
                    
                    // start offset is greater than offset
                    if range.startOffset > offset {
                     
                        // set its start node to new node
                        range.startContainer = newNode
                        
                        // decrease its start offset by offset
                        range.startOffset = range.startOffset - offset
                    }
                }
            }
            
            // 3. For each range whose end node is node and end offset is greater than offset, 
            // set its end node to new node and decrease its end offset by offset.
            for range in document.ranges {
             
                // end node is node
                if range.endContainer == self {
                
                    // end offset is greater than offset
                    if range.endOffset > offset {
                        
                        // set its end node to new node
                        range.endContainer = newNode
                        
                        // decrease its end offset by offset
                        range.endOffset = range.endOffset - offset
                    }
                }
            }
            
            // 4. For each range whose start node is parent and start offset is equal to 
            // the index of node + 1, increase its start offset by one.
            for range in document.ranges {
                
                // range whose start node is parent
                if range.startContainer == parent {
                    
                    // start offset is equal to the index of node + 1
                    if range.startOffset == (self.index + 1) {
                        
                        // increase its start offset by one
                        range.startOffset = range.startOffset + 1
                    }
                }
            }
            
            // 5. For each range whose end node is parent and end offset is equal to 
            // the index of node + 1, increase its end offset by one.
            for range in document.ranges {
                
                // range whose end node is parent
                if range.endContainer == parent {
                 
                    // end offset is equal to the index of node + 1
                    if range.endOffset == (self.index + 1) {
                        
                        // increase its end offset by one
                        range.endOffset = range.endOffset + 1
                    }
                }
            }
        }
        
        // 8. "Replace data":https://dom.spec.whatwg.org/#concept-cd-replace
        // with node node, offset offset, count count, and data the empty string.
        replaceData(offset, count: count, data: "", exception: &exception)
        
        if exception.isError() {
            
            return nil
        }
        
        // 9. If parent is null, run these substeps:
        if self.parentNode == nil {
            
            // 1. For each range whose start node is node and start offset is greater than offset,
            // set its start offset to offset.
            for range in document.ranges {
                
                // range whose start node is node
                if range.startContainer == self {
                
                    // start offset is greater than offset
                    if range.startOffset > offset {
                     
                        // set its start offset to offset
                        range.startOffset = offset
                    }
                }
            }
            
            
            // 2. For each range whose end node is node and end offset is greater than offset,
            // set its end offset to offset.
            for range in document.ranges {
                
                // range whose end node is node
                if range.endContainer == self {
                 
                    // end offset is greater than offset
                    if range.endOffset > offset {
                        
                        // set its end offset to offset
                        range.endOffset = offset
                    }
                }
            }
        }
        
        return nil
    }
    
    
    // MARK: Utitility methods
    
    ///
    /// Method that return the contiguous text nodes in tree order.
    ///
    /// def : A tree is a finite hierarchical tree structure.
    /// In tree order is preorder, depth-first traversal of a tree.
    ///
    /// def : The contiguous Text nodes of a node are the node itself,
    /// the previous sibling Text node (if any) and its contiguous Text nodes,
    /// and the next sibling Text node (if any) and its contiguous Text nodes,
    /// avoiding any duplicates.
    ///
    /// In our case the tree order starts at the leftmost previous sibling
    /// and run through the rightmost sibling
    ///
    public func contiguousTextNodes() -> [Text] {
        
        var contiguousTextNodes = [Text]()
        
        var previousContiguousTextNodes = [Text]()
        
        var followingContiguousTextNodes = [Text]()
        
        // populate previousContiguousTextNodes array
        var previousSibling: Node? = self.previousSibling
        
        while let _previousSibling = previousSibling {
            
            if let textNode = _previousSibling as? Text {
                
                assert(textNode.nodeType == NodeType.text_node)
                
                previousContiguousTextNodes.append(textNode)
                
                previousSibling = textNode.previousSibling
            }
            else {
                
                break
            }
        }
        
        // populate followingContiguousTextNodes array
        var nextSibling: Node? = self.nextSibling
        
        while let _nextSibling = nextSibling {
            
            if let textNode = _nextSibling as? Text {
                
                assert(textNode.nodeType == NodeType.text_node)
                
                followingContiguousTextNodes.append(textNode)
                
                nextSibling = textNode.nextSibling
            }
            else {
                
                break
            }
        }
        
        // invert previousContiguousTextNodes array 
        let reversePreviousContiguousTextNodesArray = Array(previousContiguousTextNodes.reversed())
        
        for textNode in reversePreviousContiguousTextNodesArray {
            
            contiguousTextNodes.append(textNode)
        }
        
        contiguousTextNodes.append(self)
        
        for textNode in followingContiguousTextNodes {
            
            contiguousTextNodes.append(textNode)
        }
        
        return contiguousTextNodes
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Positionnable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    private var displacement: Int = 0
    
    override public var sourceStringFragment: SourceStringFragment? {
        
        get {
            displaceSourceFragmentValues()
            return super.sourceStringFragment
        }
        set {
            super.sourceStringFragment = newValue
        }
    }
    
    /// This method translate the position of the fragment using
    // the count from which moving the fragment by adding this count
    // to the start and end index.
    public func move(_ count: Int) {
        
        displacement += count
    }
    
    private func displaceSourceFragmentValues() {
        
        if displacement != 0 {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("move text element by count: %d", log: Log.Web.all, type: .info, displacement)
            #endif
            super.sourceStringFragment?.move(displacement)
            self.displacement = 0
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: HtmlDomVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // 1. Traverse the left subtree.
    // 2. Visit the root.
    // 3. Traverse the right subtree.
    public func accept<Visitor: HtmlDomVisitor>(_ visitor: Visitor) -> Visitor.NodeInfoType? {
        
        return visitor.visit(self)
    }
    
    @discardableResult
    public func acceptSingle<Visitor: HtmlDomVisitor>(_ visitor: Visitor) -> Visitor.NodeInfoType? {
        
        return visitor.visit(self)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: HtmlRendererVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    @discardableResult
    public func acceptRenderer<Visitor: HtmlRendererVisitor>(_ visitor: Visitor) -> Visitor.NodeInfoType? {
        
        return visitor.visit(self)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: DomInspectable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public override var numberOfChildren: Int {
     
        assert(false, "Text element is not supposed to have children.")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Text element is not supposed to have children.", log: Log.Web.all, type: .error)
        #endif
        return 0
    }
    
    public override var expandable: Bool {
        
        return false
    }
    
    public override var expandedOpenElementString: String {
        
        assert(false, "Text element is not supposed to have an expandedOpenElementString.")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Text element is not supposed to have an expandedOpenElementString.", log: Log.Web.all, type: .error)
        #endif
        return ""
    }
    
    public override var unexpandedElementString: String {
        
        return data.trimmed()
    }
    
    public override func childAtIndex(_ index: Int) -> DomInspectable? {
        
        assert(false, "childAtIndex is not supported in Text")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("childAtIndex is not supported in Text", log: Log.Web.all, type: .error)
        #endif
        return nil
    }
    
    /// This method returns true is the current ContainerNode
    /// has only text nodes.
    public override func hasOnlyChildTextNodes() -> Bool {
        
        assert(false, "hasOnlyChildTextNodes is not supported in Text")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("hasOnlyChildTextNodes is not supported in Text", log: Log.Web.all, type: .error)
        #endif
        return false
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ClonableNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias ClonableNodeType = Text
    
    override public func cloneNode(_ deep: Bool = false) -> Text {
        
        // The super.cloneNode() function is supposed to call
        // our implementations of cloneFields and createInstance.
        return super.cloneNode(deep) as! Text
    }
    
    override public func createInstance() -> Text {
        
        return Text(document: nil, data: self.data)
    }
    
    func cloneFields(_ copy: inout Text) {
        
        var node = copy as CharacterData
        
        super.cloneFields(&node)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    open override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
        
        if let other = other {
            
            if let other = other as? Text {
                
                if !super.equals(to: other, comparePositions: comparePositions) {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: super is different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                    
                if wholeText != other.wholeText {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: wholeText are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
            }
            else {

                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not Text.", log: Log.Web.all, type: .debug)
                #endif
                return false
            }
        }
        else {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Not equals: other is nil.", log: Log.Web.all, type: .debug)
            #endif
            return false
        }
        return true
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias EquatableNodeType = Text
    
    /// https://dom.spec.whatwg.org/#dom-node-isequalnode
    override func isEqualNode(_ node: Node?) -> Bool {
        
        if !super.isEqualNode(node) {
            
            return false
        }
        
        if let otherText = node as? Text {
        
            if wholeText != otherText.wholeText {
                
                return false
            }
        }
        return true
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Hashable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override public var hashValue: Int {
        
        // FIXME: Test the proformance of this hash and make sure it is not
        // too slow in critical operations.

        return UInt(bitPattern: ObjectIdentifier(self)).hashValue
//        var h: Int = nodeType.hashValue ^ nodeName.hashValue ^ super.hashValue
//        
//        h = h ^ wholeText.hashValue
//        
//        return h
    }
    
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                  MARK: Equatable protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////

func == (lhs: Text, rhs: Text) -> Bool {
    
    return lhs.isEqualNode(rhs)
}

