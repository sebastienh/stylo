//
//  Range.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-01-09.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation
import Common
import os

//    const unsigned short START_TO_START = 0;
//    const unsigned short START_TO_END = 1;
//    const unsigned short END_TO_END = 2;
//    const unsigned short END_TO_START = 3;
enum How : UInt8 {
    case start_TO_START = 0;
    case start_TO_END = 1;
    case end_TO_END = 2;
    case end_TO_START = 3;
}

enum DomRangeRelativePosition {
    
    case before
    case equal
    case after
}

//see https://dom.spec.whatwg.org/#range
//interface Range {
//    readonly attribute Node startContainer;
//    readonly attribute unsigned long startOffset;
//    readonly attribute Node endContainer;
//    readonly attribute unsigned long endOffset;
//    readonly attribute boolean collapsed;
//    readonly attribute Node commonAncestorContainer;
//    
//    void setStart(Node node, unsigned long offset);
//    void setEnd(Node node, unsigned long offset);
//    void setStartBefore(Node node);
//    void setStartAfter(Node node);
//    void setEndBefore(Node node);
//    void setEndAfter(Node node);
//    void collapse(optional boolean toStart = false);
//    void selectNode(Node node);
//    void selectNodeContents(Node node);
//    
//    const unsigned short START_TO_START = 0;
//    const unsigned short START_TO_END = 1;
//    const unsigned short END_TO_END = 2;
//    const unsigned short END_TO_START = 3;
//    short compareBoundaryPoints(unsigned short how, Range sourceRange);
//    
//    void deleteContents();
//    [NewObject] DocumentFragment extractContents();
//    [NewObject] DocumentFragment cloneContents();
//    void insertNode(Node node);
//    void surroundContents(Node newParent);
//    
//    [NewObject] Range cloneRange();
//    void detach();
//    
//    boolean isPointInRange(Node node, unsigned long offset);
//    short comparePoint(Node node, unsigned long offset);
//    
//    boolean intersectsNode(Node node);
//    
//    stringifier;
//};

// see https://dom.spec.whatwg.org/#concept-range
final class DOMRange {
    
    var document: Document
    
    /// readonly attribute Node startContainer;
    var startContainer: Node
    
    /// readonly attribute unsigned long startOffset;
    var startOffset: Int
    
    /// readonly attribute Node endContainer;
    var endContainer: Node
    
    /// readonly attribute unsigned long endOffset;
    var endOffset: Int
    
    /// Returns true if range's start and end are the same,
    /// and false otherwise.
    /// readonly attribute boolean collapsed;
    var collapsed: Bool {
    
        return self.startContainer == self.endContainer
    }
    
    /// readonly attribute Node commonAncestorContainer;
    /// see : https://dom.spec.whatwg.org/#dom-range-commonancestorcontainer
    var commonAncestorContainer: Node {

        // 1. Let container be start node.
        var container = startContainer
            
        // 2. While container is not an inclusive ancestor of end node,
        // let container be container's parent.
        while !container.isInclusiveAncestor(of: endContainer) {
                
            if let _parentNode = container.parentNode {
                
                container = _parentNode
            }
            else {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Container has no parentNode!", log: Log.Web.all, type: .error)
                #endif
            }
        }
        
        // 3. Return container.
        return container
    }
    
    /// The root of a range is the root of its start node.
    /// see https://dom.spec.whatwg.org/#concept-range-root
    var root: Node {
        
        return startContainer.root
    }
    
    /// The Range() constructor must return a new range with
    /// (global object's associated document, 0) as its start and end.
    /// see https://dom.spec.whatwg.org/#dom-range
    init(document: Document) {
        
        self.document = document
        
        self.startContainer = document
        self.startOffset = 0
        self.endContainer = document
        self.endOffset = 0
    }
    
    /// void setStart(Node node, unsigned long offset);
    /// see https://dom.spec.whatwg.org/#dom-range-setstart
    func setStart(_ node: Node, offset: Int, exception: inout Exception) {
        
        // 1. If node is a doctype, throw an InvalidNodeTypeError exception.
        if node.nodeType == NodeType.document_type_node {
            
            exception.code = ExceptionCode.invalidNodeTypeError
            return
        }
        
        // 2. If offset is greater than node's length, throw an IndexSizeError exception.
        if offset > node.length {
            
            exception.code = ExceptionCode.indexSizeError
            return
        }
        
        // 3. Let bp be the boundary point (node, offset).
        let bp = (node, offset)
        
        // 4. If bp is after the range's end, 
        // or if range's root is not equal to node's root, 
        // set range's end to bp.
        if DomRangeRelativePosition.after == relativePosition(of: bp, relativeTo:(endContainer, endOffset))
            || node.root != self.root {
            
            setEnd(node, offset: offset, exception: &exception)
                
            if exception.isError() {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                #endif
                return
            }
        }
        
        // 5. Set range's start to bp.
        self.startContainer = node
        self.startOffset = offset
    }
    
    /// void setEnd(Node node, unsigned long offset);
    /// see https://dom.spec.whatwg.org/#dom-range-setend
    func setEnd(_ node: Node, offset: Int, exception: inout Exception) {
        
        // 1. If node is a doctype, throw an InvalidNodeTypeError exception.
        if node.nodeType == NodeType.document_type_node {
            
            exception.code = ExceptionCode.invalidNodeTypeError
            return
        }
        
        // 2. If offset is greater than node's length, throw an IndexSizeError exception.
        if offset > node.length {
            
            exception.code = ExceptionCode.indexSizeError
            return
        }
        
        // 3. Let bp be the boundary point (node, offset).
        let bp = (node, offset)
        
        // 4. If bp is before the range's start, or if range's root is not equal to node's root, set range's start to bp.
        if DomRangeRelativePosition.before == relativePosition(of: bp, relativeTo:(startContainer, startOffset))
            || node.root != self.root {
                
            setStart(node, offset: offset, exception: &exception)
                
            if exception.isError() {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                #endif
                return
            }
        }
        
        // 5. Set range's end to bp.
        self.endContainer = node
        self.endOffset = offset
    }
    
    /// void setStartBefore(Node node);
    /// see https://dom.spec.whatwg.org/#dom-range-setstartbefore
    func setStartBefore(_ node: Node, exception: inout Exception) {

        // 1. Let parent be node's parent.
        if let _parent = node.parentNode {
            
            // 3. Set the start of the context object 
            // to boundary point (parent, node's index).
            setStart(_parent, offset: node.index, exception: &exception)
            
            if exception.isError() {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                #endif
                return
            }
        }
        // 2. If parent is null, throw an InvalidNodeTypeError exception.
        else {
            
            exception.code = ExceptionCode.invalidNodeTypeError
            return
        }
    }
    
    /// void setStartAfter(Node node);
    /// see https://dom.spec.whatwg.org/#dom-range-setstartafter
    func setStartAfter(_ node: Node, exception: inout Exception) {

        // 1. Let parent be node's parent.
        if let _parent = node.parentNode {
            
            // 3. Set the start of the context object
            // to boundary point (parent, node's index plus one).
            setStart(_parent, offset: node.index + 1, exception: &exception)
            
            if exception.isError() {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                #endif
                return
            }
        }
        // 2. If parent is null, throw an InvalidNodeTypeError exception.
        else {
            
            exception.code = ExceptionCode.invalidNodeTypeError
            return
        }
    }
    
    /// void setEndBefore(Node node);
    /// see https://dom.spec.whatwg.org/#dom-range-setendbefore
    func setEndBefore(_ node: Node, exception: inout Exception) {

        // 1. Let parent be node's parent.
        if let _parent = node.parentNode {
            
            // 3. Set the end of the context object 
            // to boundary point (parent, node's index).
            setEnd(_parent, offset: node.index, exception: &exception)
            
            if exception.isError() {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                #endif
                return
            }
        }
        // 2. If parent is null, throw an InvalidNodeTypeError exception.
        else {
            
            exception.code = ExceptionCode.invalidNodeTypeError
            return
        }
    }
    
    /// void setEndAfter(Node node);
    /// see https://dom.spec.whatwg.org/#dom-range-setendafter
    func setEndAfter(_ node: Node, exception: inout Exception) {

        // 1. Let parent be node's parent.
        if let _parent = node.parentNode {
            
            // 3. Set the end of the context object 
            // to boundary point (parent, node's index plus one).
            setEnd(_parent, offset: node.index + 1, exception: &exception)
            
            if exception.isError() {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                #endif
                return
            }
        }
        // 2. If parent is null, throw an InvalidNodeTypeError exception.
        else {
            
            exception.code = ExceptionCode.invalidNodeTypeError
            return
        }
    }
    
    
    /// The collapse(toStart) method must if toStart is true,
    /// set end to start, and set start to end otherwise.
    ///
    /// void collapse(optional boolean toStart = false);
    /// see https://dom.spec.whatwg.org/#dom-range-collapse
    func collapse(_ toStart: Bool, exception: inout Exception) {

        if toStart {
            
            setEnd(self.startContainer, offset: self.startOffset, exception: &exception)
            
            if exception.isError() {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                #endif
                return
            }
        }
        else {
            
            setStart(self.endContainer, offset: self.endOffset, exception: &exception)
            
            if exception.isError() {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                #endif
                return
            }
        }
    }
    
    
    /// Call https://dom.spec.whatwg.org/#concept-range-select
    /// void selectNode(Node node);
    /// see https://dom.spec.whatwg.org/#dom-range-selectnode
    func selectNode(_ node: Node, exception: inout Exception) {
        
        // 1. Let parent be node's parent.
        if let _parent = node.parentNode {
            
            // 3. Let index be node's index.
            let index = node.index
            
            // 4. Set range's start to boundary point (parent, index).
            setStart(_parent, offset: index, exception: &exception)
            
            if exception.isError() {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                #endif
                return
            }
            
            // 5. Set range's end to boundary point (parent, index plus one).
            setEnd(_parent, offset: index + 1, exception: &exception)
            
            if exception.isError() {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                #endif
                return
            }
        }
        // 2. If parent is null, throw an InvalidNodeTypeError.
        else {
            exception.code = ExceptionCode.invalidNodeTypeError
            return
        }
    }
    
    /// void selectNodeContents(Node node);
    /// see https://dom.spec.whatwg.org/#dom-range-selectnodecontents
    func selectNodeContents(_ node: Node, exception: inout Exception) {

        // 1. If node is a doctype, throw an InvalidNodeTypeError.
        if node.nodeType == NodeType.document_type_node {
            exception.code = ExceptionCode.invalidNodeTypeError
            return
        }
        
        // 2. Let length be the length of node.
        let length = node.length
        
        // 3. Set start to the boundary point (node, 0).
        setStart(node, offset: 0, exception: &exception)
        
        if exception.isError() {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
            #endif
            return
        }
        
        // 4. Set end to the boundary point (node, length).
        setEnd(node, offset: length, exception: &exception)
        
        if exception.isError(){
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
            #endif
            return
        }
    }
    
    /// short compareBoundaryPoints(unsigned short how, Range sourceRange);
    /// see https://dom.spec.whatwg.org/#dom-range-compareboundarypoints
    func compareBoundaryPoints(_ how: How, sourceRange: DOMRange, exception: Exception) -> Int8 {

        // 1. If how is not one of
        // START_TO_START,
        // START_TO_END,
        // END_TO_END, and
        // END_TO_START
        // throw a NotSupportedError exception.
        if how != How.start_TO_START
            && how != How.start_TO_END
            && how != How.end_TO_END
            && how != How.end_TO_START {
            
            exception.code = ExceptionCode.notSupportedError
            return -2
        }
        
        // 2. If context object's root is not the same as sourceRange's root, 
        // throw a WrongDocumentError exception.
        if root != sourceRange.root {
            exception.code = ExceptionCode.wrongDocumentError
            return -2
        }
        
        // If how is:
        
        var thisPoint: (Node, Int)
        var otherPoint: (Node, Int)
        
        switch how {
            
        case .start_TO_START:
            
            // Let this point be the context object's start.
            thisPoint = (startContainer, startOffset)
            
            // Let other point be sourceRange's start.
            otherPoint = (sourceRange.startContainer, sourceRange.startOffset)
            
        case .start_TO_END:
            
            // Let this point be the context object's end.
            thisPoint = (endContainer, endOffset)
            
            // Let other point be sourceRange's start.
            otherPoint = (sourceRange.startContainer, sourceRange.startOffset)
            
        case .end_TO_END:
            
            // Let this point be the context object's end.
            thisPoint = (endContainer, endOffset)
            
            // Let other point be sourceRange's end.
            otherPoint = (sourceRange.endContainer, sourceRange.endOffset)
            
        case .end_TO_START:
            
            // Let this point be the context object's start.
            thisPoint = (startContainer, startOffset)
            
            // Let other point be sourceRange's end.
            otherPoint = (sourceRange.endContainer, sourceRange.endOffset)
        }
        
        // 4. If the position of this point relative to other point is
        let position = relativePosition(of: thisPoint, relativeTo: otherPoint)
        
        switch position {
            
        // before : return -1
        case .before:
            return -1
            
        // equal : return 0
        case .equal:
            return 0
            
        // after : Return 1.
        case .after:
            return 1
            
        }
    }
    
    /// void deleteContents();
    /// see https://dom.spec.whatwg.org/#dom-range-deletecontents
    func deleteContents(_ exception: inout Exception) {

        // 1. If start equals end, terminate these steps.
        if startContainer == endContainer
            && startOffset == endOffset {
            
            return
        }
        
        // 2. Let original start node, original start offset, original end node, 
        // and original end offset be the context object's start node, 
        // start offset, end node, and end offset, respectively.
        let originalStartNode = startContainer
        let originalStartOffset = startOffset
        let originalEndNode = endContainer
        let originalEndOffset = endOffset
        
        // 3. If original start node and original end node are the same, 
        // and they are a Text, ProcessingInstruction, or Comment node, 
        // replace data with node original start node, offset original start offset, 
        // count original end offset minus original start offset, 
        // and data the empty string, and then terminate these steps.
        if originalStartNode == originalEndNode
            && originalStartNode.isTextOrProcessingOrComment() {
            
            if let characterData = originalStartNode as? CharacterData {
            
                characterData.replaceData(originalStartOffset, count: originalEndOffset - originalStartOffset, data: "", exception: &exception)
                return
            }
        }
        
        // 4. Let "nodes to remove" be a list of all the nodes that are contained in the context object,
        // in tree order, omitting any node whose parent is also contained in the context object.
        let nodesToRemove = LiveNodeList(root: self.root, filter: RangeContainedNodesFilter(self))
        
        // 5. If original start node is an inclusive ancestor of original end node, 
        // set new node to original start node and new offset to original start offset.
        var newNode: Node?
        var newOffset: Int?
        
        if originalStartNode.isInclusiveAncestor(of: originalEndNode) {
            
            newNode = originalStartNode
            newOffset = originalStartOffset
        }
        // Otherwise:
        else {
            
            // 1. Let "reference node" equal original start node.
            var referenceNode = originalStartNode
            
            // 2. While reference node's parent is not null and is not 
            // an inclusive ancestor of original end node, 
            // set reference node to its parent.
            while referenceNode.parentNode != nil && !referenceNode.isInclusiveAncestor(of: originalEndNode) {
                
                referenceNode = referenceNode.parentNode!
            }
            
            // 3. Set new node to the parent of reference node, and 
            // new offset to one plus the index of reference node.
            // Note : it is assumed that we will reach the "isInclusiveAncestor"
            // before the other otherwise referenceNode's parent would be nil
            // and then newNode...
            if let _parentNode = referenceNode.parentNode {
                
                newNode = _parentNode
                newOffset = referenceNode.index + 1
            }
            else {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Parent of reference node is nil.", log: Log.Web.all, type: .error)
                #endif
            }
        }
        
        // 7. If original start node is a Text, ProcessingInstruction, or Comment node, 
        // replace data with node original start node, offset original start offset, 
        // count original start node's length minus original start offset, data the empty string.
        if originalStartNode.isTextOrProcessingOrComment() {
                    
            if let characterData = originalStartNode as? CharacterData {
                        
                characterData.replaceData(originalStartOffset, count: originalStartNode.length - originalStartOffset, data: "", exception: &exception)
                
                if exception.isError() {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                    #endif
                    return
                }
            }
        }
        
        // 8. For each node in nodes to remove, in tree order, remove node from its parent.
        for nodeToRemove in nodesToRemove {
            
            if let _parent = nodeToRemove.parentNode {
                
                var exception = Exception()
                
                _parent.removeChild(nodeToRemove, exception: &exception)
                
                if exception.isError() {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                    #endif
                    return
                }
            }
        }
        
        // 9. If original end node is a Text, ProcessingInstruction, or Comment node, 
        // replace data with node original end node, offset 0, 
        // count original end offset and data the empty string.
        if originalStartNode.isTextOrProcessingOrComment() {
                
            if let characterData = originalEndNode as? CharacterData {
                    
                characterData.replaceData(0, count: originalEndOffset, data: "", exception: &exception)
                
                if exception.isError() {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                    #endif
                    return
                }
            }
        }
        
        if let newNode = newNode, let newOffset = newOffset {
        
            // 10. Set start and end to (new node, new offset).
            setStart(newNode, offset: newOffset, exception: &exception)
        
            if exception.isError() {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                #endif
                return
            }
        
            setEnd(newNode, offset: newOffset, exception: &exception)
            
            if exception.isError() {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                #endif
                return
            }
        }
        else {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("newNode and newOffset shouldn't be nil.", log: Log.Web.all, type: .error)
            #endif
        }
    }
    
    /// This method calls https://dom.spec.whatwg.org/#concept-range-extract
    /// [NewObject] DocumentFragment extractContents();
    /// see https://dom.spec.whatwg.org/#dom-range-extractcontents
    func extractContents(_ exception: inout Exception) -> DocumentFragment? {

        // 1. Let fragment be a new DocumentFragment node whose 
        // node document is range's start node's node document.
        let fragment: DocumentFragment = DocumentFragment(document: startContainer.document)
    
        // 2. If range's start equals its end, return fragment.
        if DomRangeRelativePosition.equal == relativePosition(of: (startContainer, startOffset), relativeTo: (endContainer, endOffset)) {
            return fragment
        }
        
        // 3. Let original start node, original start offset, original end node,
        // and original end offset be range's start node, start offset, end node,
        // and end offset, respectively.
        let originalStartNode = startContainer
        let originalStartOffset = startOffset
        let originalEndNode = endContainer
        let originalEndOffset = endOffset
    
        // 4. If original start node equals original end node, and they are a Text,
        // ProcessingInstruction, or Comment node:
        if originalStartNode == originalEndNode && originalStartNode.isTextOrProcessingOrComment() {
    
            // 1. Let clone be a clone of original start node.
            let clone = originalStartNode.cloneNode()
            
            // 2. Set the data of clone to the result of substringing data with :
            // node original start node, 
            // offset original start offset, and 
            // count original end offset minus original start offset.
            if let _characterDataClone = clone as? CharacterData {
    
                if let _originalStartNodeCharacterData = clone as? CharacterData {
                    
                    _characterDataClone.data = _originalStartNodeCharacterData.substringData(originalStartOffset, count: originalEndOffset - originalStartOffset, exception: &exception)
                    
                    if exception.isError() {
                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                        os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                        #endif
                        return nil
                    }
                }
                else {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("originalStartNode should be CharacterData...", log: Log.Web.all, type: .error)
                    #endif
                }
            }
            else {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Expecting CharacterData, probably error in isTextOrProcessingOrComment() method.", log: Log.Web.all, type: .error)
                #endif
            }

            // 3. Append clone to fragment.
            fragment.append(clone, exception: &exception)
            
            // 4. [Replace data](https://dom.spec.whatwg.org/#concept-cd-replace) with
            // node original start node,
            // offset original start offset,
            // count original end offset minus original start offset, and
            // data the empty string.
            if let characterData = originalStartNode as? CharacterData {
                
                characterData.replaceData(originalStartOffset,
                    count: originalEndOffset - originalStartOffset, data: "", exception: &exception)
                
                if exception.isError() {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                    #endif
                    return nil
                }
            }
            else {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Probably error in isTextOrProcessingOrComment() method.", log: Log.Web.all, type: .error)
                #endif
            }
            
            // 5. Return fragment.
            return fragment
        }
        // Not a Text, ProcessingInstruction, or Comment node.
        else {
            
            // 5. Let common ancestor be original start node.
            var commonAncestor = originalStartNode
            
            // 6. While common ancestor is not an inclusive ancestor 
            // of original end node, set common ancestor to its own parent.
            while !commonAncestor.isInclusiveAncestor(of: originalEndNode) {
                
                if let commonAncestorParent = commonAncestor.parentNode {
                    commonAncestor = commonAncestorParent
                }
                else {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("Missing parent in commonAncestor.", log: Log.Web.all, type: .error)
                    #endif
                }
            }
            
            // 7. Let first partially contained child be null.
            var firstPartiallyContained: Node? = nil
            
            // 8. If original start node is not an inclusive ancestor of original end node,
            // set first partially contained child to the first child of 
            // common ancestor that is partially contained in range.
            if !originalStartNode.isInclusiveAncestor(of: originalEndNode) {
                
                if let childNodes = commonAncestor.childNodes {
                    
                    for node in childNodes {
                     
                        if isNodePartiallyContainedInRange(node) {
                            firstPartiallyContained = node
                            break
                        }
                    }
                }
            }
            
            // 9. Let last partially contained child be null.
            var lastPartiallyContained: Node? = nil
            
            // 10. If original end node is not an inclusive ancestor of original start node, 
            // set last partially contained child to the last child of common ancestor 
            // that is partially contained in range.
            if !originalEndNode.isInclusiveAncestor(of: originalStartNode) {
                
                if let childNodes = commonAncestor.childNodes {
                    
                    for node in childNodes {
                        
                        if isNodePartiallyContainedInRange(node) {
                            lastPartiallyContained = node
                        }
                    }
                }
            }
            
            // 11. Let contained children be a list of all children of common ancestor 
            // that are contained in range, in tree order.
            let containedChildren = LiveNodeList(root: self.root, filter: RangeContainedChildrenFilter(self, root: commonAncestor))
            
            
            // 12. If any member of contained children is a doctype, 
            // throw a HierarchyRequestError exception.
            for member in containedChildren {
                if member.nodeType == NodeType.document_type_node {
                    exception.code = ExceptionCode.hierarchyRequestError
                    return nil
                }
            }
            
            // 13. If original start node is an inclusive ancestor of original end node, 
            // set new node to original start node and new offset to original start offset.
            var newNode: Node?
            var newOffset: Int?
            if originalStartNode.isInclusiveAncestor(of: originalEndNode) {
                newNode = originalStartNode
                newOffset = originalStartOffset
            }
            // 14. Otherwise:
            else {
                
                // 1. Let reference node equal original start node.
                var referenceNode = originalStartNode
                var referenceNodeParent = originalStartNode.parentNode
                
                // 2. While reference node's parent is not null and is not an inclusive ancestor
                // of original end node, set reference node to its parent.
                while let _referenceNodeParent = referenceNodeParent
                    , !_referenceNodeParent.isInclusiveAncestor(of: originalEndNode) {

                    referenceNode = _referenceNodeParent
                    referenceNodeParent = referenceNode.parentNode
                }
                
                // 3. Set new node to the parent of reference node, and new offset
                // to one plus reference node's index.
                newNode = referenceNode
                newOffset = referenceNode.index + 1
            }

            // 15. If first partially contained child is a Text, ProcessingInstruction, or Comment node:
            if let firstPartiallyContained = firstPartiallyContained , firstPartiallyContained.isTextOrProcessingOrComment() {
                
                // 1. Let clone be a clone of original start node.
                if let clone = originalStartNode.cloneNode() as? CharacterData {
                        
                    // 2. Set the data of clone to the result of substringing data 
                    // with node original start node, offset original start offset, 
                    // and count original start node's length minus original start offset.
                    if let originalStartNodeCharacterData = originalStartNode as? CharacterData {
                        
                        clone.data = originalStartNodeCharacterData.substringData(originalStartOffset, count: originalStartNode.length - originalStartOffset, exception: &exception)
                        
                        if exception.isError() {
                            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                            os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                            #endif
                            return nil
                        }
                        
                        var exception = Exception()
                        
                        // 3. Append clone to fragment.
                        fragment.appendChild(clone, exception: &exception)
                        
                        if exception.isError() {
                            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                            os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                            #endif
                            return nil
                        }
                        
                        // 4. Replace data with node original start node, offset original start offset,
                        // count original start node's length minus original start offset, and data the empty string.
                        originalStartNodeCharacterData.replaceData(originalStartOffset, count: originalStartNode.length - originalStartOffset, data: "", exception: &exception)
                        
                        if exception.isError() {
                            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                            os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                            #endif
                            return nil
                        }
                    }
                    else {
                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                        os_log("originalStartNode is not of type CharacterData.", log: Log.Web.all, type: .error)
                        #endif
                    }
                }
                else {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("Cloning CharacterData should return CharacterData.", log: Log.Web.all, type: .error)
                    #endif
                }
            }
            // 16. Otherwise, if first partially contained child is not null:
            else {
                
                if let firstPartiallyContained = firstPartiallyContained {
                    
                    // 1. Let clone be a clone of first partially contained child.
                    let clone = firstPartiallyContained.cloneNode()
                    
                    var exception  = Exception()
                    
                    // 2. Append clone to fragment.
                    fragment.appendChild(clone, exception: &exception)
                    
                    if exception.isError() {
                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                        os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                        #endif
                        return nil
                    }
                    
                    // 3. Let subrange be a new range whose start is (original start node,
                    // original start offset) and whose end is (first partially contained child,
                    // first partially contained child's length).
                    let subrange = self.document.createRange()
                    subrange.startContainer = originalStartNode
                    subrange.startOffset = originalStartOffset
                    subrange.endContainer = firstPartiallyContained
                    subrange.endOffset = firstPartiallyContained.length
                    
                    // 4. Let subfragment be the result of extracting subrange.
                    let subfragment = subrange.extractContents(&exception)
                    
                    if exception.isError() {
                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                        os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                        #endif
                        return nil
                    }
                    
                    if let subfragment = subfragment {
                        
                        
                        
                        // 5. Append subfragment to clone.
                        clone.appendChild(subfragment, exception: &exception)
                        
                        if exception.isError() {
                            
                            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                            os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                            #endif
                            return nil
                        }
                    }
                    else {
                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                        os_log("Subfragment is nil.", log: Log.Web.all, type: .error)
                        #endif
                    }
                }
                else {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("firstPartiallyContained is nil.", log: Log.Web.all, type: .error)
                    #endif
                }
            }
           
            // 17. For each contained child in contained children, append contained child to fragment.
            for containedChild in containedChildren {
                
                fragment.appendChild(containedChild, exception: &exception)
                
                if exception.isError() {
                    
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                    #endif
                    return nil
                }
            }
            
            // 18. If last partially contained child is a Text, ProcessingInstruction, or Comment node:
            if let lastPartiallyContained = lastPartiallyContained , lastPartiallyContained.isTextOrProcessingOrComment() {
                
                // 1. Let clone be a clone of original end node.
                if let clone = originalEndNode.cloneNode() as? CharacterData {
                    
                    // 2. Set the data of clone to the result of substringing data with node
                    // original end node, offset 0, and count original end offset.
                    if let originalEndNodeCharacterData = originalEndNode as? CharacterData {
                        
                        clone.data = originalEndNodeCharacterData.substringData(0, count: originalEndOffset, exception: &exception)
                        
                        if exception.isError() {
                            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                            os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                            #endif
                            return nil
                        }
                        
                        // 3. Append clone to fragment.
                        fragment.appendChild(clone, exception: &exception)
                        
                        if exception.isError() {
                            
                            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                            os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                            #endif
                            return nil
                        }
                        
                        // 4. Replace data with node original end node, offset 0, 
                        // count original end offset,
                        // and data the empty string.
                        originalEndNodeCharacterData.replaceData(0, count: originalEndOffset, data: "", exception: &exception)
                        
                        if exception.isError() {
                            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                            os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                            #endif
                            return nil
                        }
                    }
                    else {
                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                        os_log("originalEndNode is not of type CharacterData.", log: Log.Web.all, type: .error)
                        #endif
                    }
                }
                else {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("originalEndNode clone is not CharacterData", log: Log.Web.all, type: .error)
                    #endif
                }
            }
            // 19. Otherwise, if last partially contained child is not null:
            else {
                
                // 1. Let clone be a clone of last partially contained child.
                if let lastPartiallyContained = lastPartiallyContained {
                    
                    let clone = lastPartiallyContained.cloneNode()
                    
                    // 2. Append clone to fragment.
                    fragment.appendChild(clone, exception: &exception)
                    
                    if exception.isError() {
                        
                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                        os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                        #endif
                        return nil
                    }
                    
                    // 3. Let subrange be a new range whose start is (last partially contained child, 0)
                    // and whose end is (original end node, original end offset).
                    let subrange = self.document.createRange()
                    subrange.startContainer = lastPartiallyContained
                    subrange.startOffset = 0
                    subrange.endContainer = originalEndNode
                    subrange.endOffset = originalEndOffset
                    
                    // 4. Let subfragment be the result of extracting subrange.
                    let subfragment = subrange.extractContents(&exception)
                    
                    if exception.isError() {
                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                        os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                        #endif
                        return nil
                    }
                    
                    if let subfragment = subfragment {
                        
                        // 5. Append subfragment to clone.
                        clone.appendChild(subfragment, exception: &exception)
                        
                        if exception.isError() {
                            
                            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                            os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                            #endif
                            return nil
                        }
                    }
                    else {
                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                        os_log("Subfragment is nil.", log: Log.Web.all, type: .error)
                        #endif
                    }
                }
                else {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("lastPartiallyContained is nil.", log: Log.Web.all, type: .error)
                    #endif
                }
            }
            
            if let newNode = newNode, let newOffset = newOffset {
            
                // 20. Set range's start and end to (new node, new offset).
                setStart(newNode, offset: newOffset, exception: &exception)
                
                if exception.isError() {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                    #endif
                    return nil
                }
                
                setEnd(newNode, offset: newOffset, exception: &exception)
                
                if exception.isError() {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                    #endif
                    return nil
                }
            }
            // 21. Return fragment.
            return fragment
        }
    }
    
    /// A node is partially contained in a range if it is an inclusive ancestor 
    /// of the range's start node but not its end node, or vice versa.
    /// see https://dom.spec.whatwg.org/#partially-contained
    func isNodePartiallyContainedInRange(_ node: Node) -> Bool {
        
        if node.isInclusiveAncestor(of: startContainer) {
            
            if !node.isInclusiveAncestor(of: endContainer) {
                
                return true
            }
        }
        else if node.isInclusiveAncestor(of: endContainer) {
            
            if !node.isInclusiveAncestor(of: startContainer) {
                
                return true
            }
        }
        return false
    }
    
    /// Clone content method. Cloning the context object.
    /// [NewObject] DocumentFragment cloneContents();
    /// see https://dom.spec.whatwg.org/#dom-range-clonecontents
    /// see https://dom.spec.whatwg.org/#concept-range-clone
    func cloneContents(_ exception: inout Exception) -> DocumentFragment? {
        
        // 1. Let fragment be a new DocumentFragment node whose 
        // [node document](https://dom.spec.whatwg.org/#concept-node-document)
        // is range's start node's node document.
        let fragment = DocumentFragment(document: startContainer.document, host: nil)
        
        // 2. If range's start equals its end, return fragment.
        if startContainer == endContainer {
            
            if startOffset == endOffset {
                
                return fragment
            }
        }
        
        // 3. Let original start node, original start offset, original end node, 
        // and original end offset be range's start node, start offset, end node, 
        // and end offset, respectively.
        let originalStartNode = startContainer
        let originalStartOffset = startOffset
        let originalEndNode = endContainer
        let originalEndOffset = endOffset
        
        // 4. If original start node equals original end node, and they are a Text, ProcessingInstruction, 
        // or Comment node:
        if originalStartNode == originalEndNode && originalStartNode.isTextOrProcessingOrComment() {
            
            // 1. Let clone be a clone of original start node.
            let clone = originalStartNode.cloneNode()
            
            // 2. Set the data of clone to the result of substringing data with :
            // node original start node,
            // offset original start offset, and
            // count original end offset minus original start offset.
            if let _characterDataClone = clone as? CharacterData {
                
                if let _originalStartNodeCharacterData = clone as? CharacterData {
                    
                    _characterDataClone.data = _originalStartNodeCharacterData.substringData(originalStartOffset, count: originalEndOffset - originalStartOffset, exception: &exception)
                    
                    if exception.isError() {
                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                        os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                        #endif
                        return nil
                    }
                }
                else {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("originalStartNode should be CharacterData...", log: Log.Web.all, type: .error)
                    #endif
                }
            }
            else {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Expecting CharacterData, probably error in isTextOrProcessingOrComment() method.", log: Log.Web.all, type: .error)
                #endif
            }
            
            // 3. Append clone to fragment.
            fragment.append(clone, exception: &exception)
            
            // 4. Return fragment.
            return fragment
        }
        
        // 5. Let common ancestor be original start node.
        var commonAncestor = originalStartNode
        
        // 6. While common ancestor is not an inclusive ancestor of original end node, 
        // set common ancestor to its own parent.
        while !commonAncestor.isInclusiveAncestor(of: originalEndNode) {
            
            if let ancestorParent = commonAncestor.parentNode {
            
                commonAncestor = ancestorParent
            }
            else {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("commonAncestor parent is nil.", log: Log.Web.all, type: .error)
                #endif
            }
        }
        
        // 7. Let "first partially contained child" be null.
        var firstPartiallyContained: Node? = nil
        
        // 8. If original start node is not an inclusive ancestor of original end node, 
        // set first partially contained child to the first child of common ancestor 
        // that is partially contained in range.
        if !originalStartNode.isInclusiveAncestor(of: originalEndNode) {
            
            if let childNodes = commonAncestor.childNodes {
                
                for node in childNodes {
                    
                    if isNodePartiallyContainedInRange(node) {
                        firstPartiallyContained = node
                        break
                    }
                }
            }
        }
        
        // 9. Let "last partially contained child" be null.
        var lastPartiallyContained: Node? = nil
        
        // 10. If original end node is not an inclusive ancestor of original start node, 
        // set last partially contained child to the last child of common ancestor 
        // that is partially contained in range.
        if !originalEndNode.isInclusiveAncestor(of: originalStartNode) {
            
            if let childNodes = commonAncestor.childNodes {
                
                for node in childNodes {
                    
                    if isNodePartiallyContainedInRange(node) {
                        lastPartiallyContained = node
                    }
                }
            }
        }
        
        // 11. Let contained children be a list of all children of common ancestor 
        // that are contained in range, in tree order.
        let containedChildren = LiveNodeList(root: self.root, filter: RangeContainedChildrenFilter(self, root: commonAncestor))
        
        // 12. If any member of contained children is a doctype, 
        // throw a HierarchyRequestError exception.
        for member in containedChildren {
            if member.nodeType == NodeType.document_type_node {
                exception.code = ExceptionCode.hierarchyRequestError
                return nil
            }
        }
        
        // 13. If first partially contained child is a Text, ProcessingInstruction, or Comment node:
        if let firstPartiallyContained = firstPartiallyContained , firstPartiallyContained.isTextOrProcessingOrComment() {
            
            // 1. Let clone be a clone of original start node.
            if let clone = originalStartNode.cloneNode() as? CharacterData {
                
                if let originalStartNodeCharacterData = originalStartNode as? CharacterData {
                    
                    // 2. Set the data of clone to the result of substringing data 
                    // with node original start node, offset original start offset, 
                    // and count original start node's length minus original start offset.
                    clone.data = originalStartNodeCharacterData.substringData(originalStartOffset, count: originalStartNode.length - originalStartOffset, exception: &exception)
                    
                    if exception.isError() {
                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                        os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                        #endif
                        return nil
                    }
                    
                    // 3. Append clone to fragment.
                    fragment.appendChild(clone, exception: &exception)
                    
                    if exception.isError() {
                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                        os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                        #endif
                        return nil
                    }
                }
                else {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("originalStartNode is not of type CharacterData.", log: Log.Web.all, type: .error)
                    #endif
                }
            }
            else {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Cloning CharacterData should return CharacterData.", log: Log.Web.all, type: .error)
                #endif
            }
        }
        // 14. Otherwise, if first partially contained child is not null:
        else {
            
            if let firstPartiallyContained = firstPartiallyContained {
                
                // 1. Let clone be a clone of first partially contained child.
                let clone = firstPartiallyContained.cloneNode()
                
                // 2. Append clone to fragment.
                fragment.appendChild(clone, exception: &exception)
                
                if exception.isError() {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                    #endif
                    return nil
                }
                
                // 3. Let subrange be a new range whose start is (original start node,
                // original start offset) and whose end is (first partially contained child, 
                // first partially contained child's length).
                let subrange = self.document.createRange()
                subrange.startContainer = originalStartNode
                subrange.startOffset = originalStartOffset
                subrange.endContainer = firstPartiallyContained
                subrange.endOffset = firstPartiallyContained.length
                
                // 4. Let subfragment be the result of cloning subrange.
                let subfragment = subrange.extractContents(&exception)
                
                if exception.isError() {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                    #endif
                    return nil
                }
                
                // 5. Append subfragment to clone.
                if let subfragment = subfragment {
                    
                    clone.appendChild(subfragment, exception: &exception)
                    
                    if exception.isError() {
                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                        os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                        #endif
                        return nil
                    }
                }
            }
            else {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("firstPartiallyContained is nil.", log: Log.Web.all, type: .error)
                #endif
            }
        }
    
        // 15. For each contained child in contained children:
        for containedChild in containedChildren {
            
            // 1. Let clone be a clone of contained child with the clone children flag set.
            let clone = containedChild.cloneNode(true)
            
            // 2. Append clone to fragment.
            fragment.append(clone, exception: &exception)
            
            if exception.isError() {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                #endif
                return nil
            }
        }
        
        // 16. If last partially contained child is a Text, ProcessingInstruction, or Comment node:
        if let lastPartiallyContained = lastPartiallyContained , lastPartiallyContained.isTextOrProcessingOrComment() {
         
            // 1. Let clone be a clone of original end node.
            if let clone = originalEndNode.cloneNode() as? CharacterData {
            
                // 2. Set the data of clone to the result of substringing data with node
                // original end node, offset 0, and count original end offset.
                if let originalEndNodeCharacterData = originalEndNode as? CharacterData {
                    
                    clone.data = originalEndNodeCharacterData.substringData(0, count: originalEndOffset, exception: &exception)
                
                    if exception.isError() {
                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                        os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                        #endif
                        return nil
                    }
                
                    // 3. Append clone to fragment.
                    fragment.appendChild(clone, exception: &exception)
                    
                    if exception.isError() {
                        
                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                        os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                        #endif
                        return nil
                    }
                }
                else {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("originalEndNode is not of type CharacterData.", log: Log.Web.all, type: .error)
                    #endif
                }
            }
            else {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("originalEndNode is not of type CharacterData.", log: Log.Web.all, type: .error)
                #endif
            }
        }
        
        // 17. Otherwise, if last partially contained child is not null:
        else {
            
            // 1. Let clone be a clone of last partially contained child.
            if let lastPartiallyContained = lastPartiallyContained {
                
                let clone = lastPartiallyContained.cloneNode()
                
                // 2. Append clone to fragment.
                fragment.appendChild(clone, exception: &exception)
                
                if exception.isError() {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                    #endif
                    return nil
                }
                
                // 3. Let subrange be a new range whose start is (last partially contained child, 0)
                // and whose end is (original end node, original end offset).
                let subrange = self.document.createRange()
                subrange.startContainer = lastPartiallyContained
                subrange.startOffset = 0
                subrange.endContainer = originalEndNode
                subrange.endOffset = originalEndOffset
                
                // 4. Let subfragment be the result of 
                // [cloning]() subrange.
                let subfragment = subrange.cloneContents(&exception)
                
                if exception.isError() {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                    #endif
                    return nil
                }
                
                if let subfragment = subfragment {
                    
                    // 5. Append subfragment to clone.
                    clone.appendChild(subfragment, exception: &exception)
                    
                    if exception.isError() {
                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                        os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                        #endif
                        return nil
                    }
                }
                else {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("Subfragment is nil.", log: Log.Web.all, type: .error)
                    #endif
                }
            }
            else {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("lastPartiallyContained is nil.", log: Log.Web.all, type: .error)
                #endif
            }
        }
        
        // 18. Return fragment.
        return fragment
    }

    /// Insert a node into the contrext object. Calling 
    /// https://dom.spec.whatwg.org/#concept-range-insert
    /// void insertNode(Node node);
    /// see https://dom.spec.whatwg.org/#dom-range-insertnode
    func insertNode(_ node: Node, exception: inout Exception) {

        // 1. If range's start node is either a ProcessingInstruction or Comment node, 
        // or a Text node whose parent is null, throw an HierarchyRequestError exception.
        if startContainer.isTextOrProcessingOrComment() {
        
            exception.code = ExceptionCode.hierarchyRequestError
            return
        }
        
        // 2. Let referenceNode be null.
        var referenceNode: Node? = nil
        
        // 3. If range's start node is a Text node, set referenceNode to that Text node.
        if let textNode = startContainer as? Text {
            
            assert(textNode.nodeType == NodeType.text_node)
            
            referenceNode = textNode
        }
        // 4. Otherwise, set referenceNode to the child of start node whose index is start offset, 
        // and null if there is no such child.
        else {
            
            if let startNodeChildList = startContainer.childNodes {
            
                assert(startContainer is ContainerNode)
                
                for child in startNodeChildList {
                    
                    if child.index == startOffset {
                        
                        referenceNode = child
                        break
                    }
                }
            }
        }
        
        // 5. Let parent be range's start node if referenceNode is null, 
        // and referenceNode's parent otherwise.
        var parent: ContainerNode?
        
        if let _ = referenceNode {
            
            parent = startContainer.parentNode
        }
        // null...
        else {
            
            if let parentContainer = startContainer as? ContainerNode {
                
                parent = parentContainer
            }
            else {
                // FIXME: maybe that all methods for insertion should move to Node
                assert(false, "Here we try to insert a node into another one which is not a container node...")
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Here we try to insert a node into another one which is not a container node...", log: Log.Web.all, type: .error)
                #endif
            }
        }
        
        // 6. Ensure pre-insertion validity of node into parent before referenceNode.
        if let parent = parent {
         
            // This validation ensure that
            parent.ensurePreInsertionValidity(node, child: referenceNode, exception: &exception)
            
            if exception.isError() {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                #endif
                return
            }
        }
        
        // 7. If range's start node is a Text node, split it with offset range's start offset, 
        // set referenceNode to the result, and set parent to referenceNode's parent.
        if let textNode = startContainer as? Text {
        
            assert(textNode.nodeType == NodeType.text_node)
            
            if let result = textNode.splitText(startOffset, exception: &exception) {
                
                assert(!exception.isError())
                
                // ... set referenceNode to the result
                referenceNode = result
                
                // ... set parent to referenceNode's parent
                parent = result.parentNode
            }
            else {
             
                if exception.isError() {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                    #endif
                    return
                }
            }
        }
            
        // 8. If node equals referenceNode, set referenceNode to its next sibling.
        if node == referenceNode {
            
            referenceNode = node.nextSibling
        }
        
        // 9. If node's parent is not null, 
        // [remove](https://dom.spec.whatwg.org/#concept-node-remove) node from its parent.
        if let parent = node.parentNode {
            
            parent.remove(node, exception: &exception)
            
            if exception.isError() {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                #endif
                return
            }
        }
        
        // 10. Let newOffset be parent's length if referenceNode is null, and referenceNode's index otherwise.
        var newOffset: Int
        
        if let referenceNode = referenceNode {
            
            newOffset = referenceNode.index
        }
        else {
            
            if let parent = parent {
                
                newOffset = parent.length
            }
            else {
                assert(false, "parent is nil.")
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("parent is nil.", log: Log.Web.all, type: .error)
                #endif
                return
            }
        }

        // 11. Increase newOffset by node's length if node is a DocumentFragment node, and one otherwise.
        if node.nodeType == NodeType.document_fragment_node {

            newOffset += node.length
        }
        else {
            
            newOffset += 1
        }
        
        // 12. Pre-insert node into parent before referenceNode.
        if let parent = parent {

            parent.preInsert(node, before: referenceNode, exception: &exception)
            
            if exception.isError() {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                #endif
                return
            }
        }
        
        // 13. If range's start and end are the same, set range's end to (parent, newOffset).
        if startContainer == endContainer {
            
            if startOffset == endOffset {
                
                if let parent = parent {
                    
                    endContainer = parent
                }
                else {
                    
                    assert(false, "parent is nil.")
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("parent is nil.", log: Log.Web.all, type: .error)
                    #endif
                }
                endOffset = newOffset
            }
        }
    }

    /// Surround content method.
    /// void surroundContents(Node newParent);
    /// see https://dom.spec.whatwg.org/#dom-range-surroundcontents
    func surroundContents(_ newParent: ContainerNode, exception: inout Exception) {
        
        // 1. If a non-Text node is [partially contained](https://dom.spec.whatwg.org/#partially-contained ) 
        // in the context object, throw an InvalidStateError exception.
        // TODO: this validation need to be included
        
        // 2. If newParent is a Document, DocumentType, or DocumentFragment node, 
        // throw an InvalidNodeTypeError exception.
        if let document = newParent as? Document {
            
            assert(document.nodeType == NodeType.document_node)
            
            exception.code = ExceptionCode.invalidNodeTypeError
            return
        }
        
//        if let documentType = newParent as? DocumentType {
//            
//            assert(documentType.nodeType == NodeType.DOCUMENT_TYPE_NODE)
//            
//            exception.code = ExceptionCode.InvalidNodeTypeError
//            return
//        }
        
        if let documentFragment = newParent as? DocumentFragment {
            
            assert(documentFragment.nodeType == NodeType.document_fragment_node)
            
            exception.code = ExceptionCode.invalidNodeTypeError
            return
        }
        
        // 3. Let fragment be the result of [extracting](https://dom.spec.whatwg.org/#concept-range-extract )
        // context object.
        let fragment = extractContents(&exception)
        
        if exception.isError() {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
            #endif
            return
        }
        
        // 4. If newParent has children, [replace all](https://dom.spec.whatwg.org/#concept-node-replace-all )
        // with null within newParent.
        newParent.replaceAll(nil, exception: &exception)
        
        if exception.isError() {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
            #endif
            return
        }
        
        // 5. [Insert](https://dom.spec.whatwg.org/#concept-range-insert )
        // newParent into context object.
        insertNode(newParent, exception: &exception)
        
        if exception.isError() {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
            #endif
            return
        }
        
        // 6. [Append](https://dom.spec.whatwg.org/#concept-node-append )
        // fragment to newParent.
        if let fragment = fragment {
            
            newParent.append(fragment, exception: &exception)
        }
        else {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("fragment is nil.", log: Log.Web.all, type: .error)
            #endif
            assert(false, "fragment is nil.")
            return
        }
        
        // 7. [Select](https://dom.spec.whatwg.org/#concept-range-select )
        // newParent within context object.
        selectNode(newParent, exception: &exception)
        
        if exception.isError() {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
            #endif
            return
        }
    }

    /// Returns a new range with the same start and end as the context object.
    /// [NewObject] Range cloneRange();
    /// see https://dom.spec.whatwg.org/#dom-range-clonerange
    func cloneRange(_ exception: inout Exception) -> DOMRange? {
        
        let range = DOMRange(document: document)
        
        range.setStart(startContainer, offset: startOffset, exception: &exception)
        
        if exception.isError() {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
            #endif
            return nil
        }
        
        range.setEnd(endContainer, offset: endOffset, exception: &exception)
        
        if exception.isError() {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
            #endif
            return nil
        }
        
        return range
    }

    /// Mjst do nothing.
    /// Its functionality (disabling a Range object) was removed, 
    /// but the method itself is preserved for compatibility.
    /// void detach();
    /// see https://dom.spec.whatwg.org/#dom-range-detach
    func detach() {

        // Nothing to do
    }
    
    /// Return if point is in range.
    /// boolean isPointInRange(Node node, unsigned long offset);
    /// see https://dom.spec.whatwg.org/#dom-range-ispointinrange
    func isPointInRange(_ node: Node, offset: Int, exception: inout Exception) -> Bool? {

        // 1. If node's root is different from the context object's root, return false.
        if node.root != self.root {
            
            return false
        }
        
        // 2. If node is a doctype, throw an InvalidNodeTypeError exception.
        if node.nodeType == NodeType.document_type_node {
            
            exception.code = ExceptionCode.invalidNodeTypeError
            return nil
        }
        
        // 3. If offset is greater than node's length, throw an IndexSizeError exception.
        if offset > node.length {
            
            exception.code = ExceptionCode.indexSizeError
            return nil
        }
        
        // 4. If (node, offset) is [before](https://dom.spec.whatwg.org/#concept-range-bp-before ) 
        // start or after end, return false.
        if relativePosition(of: (node, offset), relativeTo: (startContainer, startOffset)) == DomRangeRelativePosition.before {
            
            return false
        }
        
        if relativePosition(of: (node, offset), relativeTo: (endContainer, endOffset)) == DomRangeRelativePosition.after {
                
                return false
        }
        
        // 5. Return true.
        return true
    }
    
    /// Returns −1 if the point is before the range, 0 if the point is in the range, 
    /// and 1 if the point is after the range.
    /// short comparePoint(Node node, unsigned long offset);
    /// see https://dom.spec.whatwg.org/#dom-range-comparepoint
    func comparePoint(_ node: Node, offset: Int, exception: inout Exception) -> Int? {

        // 1. If node's root is different from the context object's root, 
        // throw a WrongDocumentError exception.
        if node.root != root {
            
            exception.code = ExceptionCode.wrongDocumentError
            return nil
        }
        
        // 2. If node is a doctype, 
        // throw an InvalidNodeTypeError exception.
        if node.nodeType == NodeType.document_type_node {
            
            exception.code = ExceptionCode.invalidNodeTypeError
            return nil
        }
        
        // 3. If offset is greater than node's length, 
        // throw an IndexSizeError exception.
        if offset > node.length {
            
            exception.code = ExceptionCode.indexSizeError
            return nil
        }
        
        // 4. If (node, offset) is before start, return −1.
        if relativePosition(of: (node, offset), relativeTo: (startContainer, startOffset)) == DomRangeRelativePosition.before {
            
            return -1
        }
        
        // 5. If (node, offset) is after end, return 1.
        if relativePosition(of: (node, offset), relativeTo: (endContainer, endOffset)) == DomRangeRelativePosition.after {

            return -1
        }
        
        // 6. Return 0.
        return 0
    }
    
    /// Returns whether range intersects node.
    /// boolean intersectsNode(Node node);
    /// see https://dom.spec.whatwg.org/#dom-range-intersectsnode
    func intersectsNode(_ node: Node) -> Bool {

        // 1. If node's root is different from the context object's root, return false.
        if node.root != root {
            
            return false
        }
        
        // 2. Let parent be node's parent.
        if let parent = node.parentNode {
        
            // 4. Let offset be node's index.
            let offset = node.index
            
            // 5. If (parent, offset) is before end and (parent, offset + 1) is after start, return true.
            if relativePosition(of: (parent, offset+1), relativeTo: (startContainer, startOffset)) == DomRangeRelativePosition.after {
                
                return true
            }
        }
        else {
        
            // 3. If parent is null, return true.
            return true
        }
        
        // 6. Return false.
        return false
        
    }
    
    /// Return string representation of the range context object.
    /// stringifier;
    func stringifier(_ exception: inout Exception) -> DOMString {

        // 1. Let s be the empty string.
        var s: String = ""
        
        // 2. If start node equals end node, and it is a Text node, 
        // return the substring of that Text node's data beginning at start offset and ending at end offset.
        if startContainer == endContainer {
            
            if let textNode = startContainer as? Text {
                
                assert(textNode.nodeType == NodeType.text_node)
                
                return textNode.substringData(startOffset, count: endOffset - startOffset, exception: &exception)
            }
        }
        
        // 3. If start node is a Text node, append to s the substring of that node's data 
        // from the start offset until the end.
        if let textNode = startContainer as? Text {
            
            assert(textNode.nodeType == NodeType.text_node)
            
            s += textNode.substringData(startOffset, count: textNode.length, exception: &exception)
        }
        
        // 4. Append to s the concatenation, in tree order, of the data of all Text nodes 
        // that are [contained](https://dom.spec.whatwg.org/#contained ) in the context object.
        let containedNodes = LiveNodeList(root: self.root, filter: RangeContainedNodesFilter(self))
        
        for node in containedNodes {
            
            if let textNode = node as? Text {
                
                assert(node.nodeType == NodeType.text_node)

                s += textNode.data
            }
        }
        
        // 5. If end node is a Text node, append to s the substring of that node's data 
        // from its start until the end offset.
        if let textNode = endContainer as? Text {
            
            assert(textNode.nodeType == NodeType.text_node)
            
            // FIXME: need to verify the offsets.
            s += textNode.substringData(0, count: endOffset, exception: &exception)
        }
        
        // 6. Return s.
        return s
    }
    
    
    /// If the two nodes of boundary points (node A, offset A)
    /// and (node B, offset B) have the same root,
    /// the position of the first relative to the second is either
    /// before, equal, or after, as returned by the following algorithm:
    /// see : https://dom.spec.whatwg.org/#concept-range-bp-position
    func relativePosition(of first: (Node, Int), relativeTo second: (Node, Int)) -> DomRangeRelativePosition {
        
        let (nodeA, offsetA) = first
        let (nodeB, offsetB) = second
        
        // 1. If node A is the same as node B,
        // return equal if offset A is the same as offset B,
        // before if offset A is less than offset B, 
        // and after if offset A is greater than offset B.
        if nodeA == nodeB {
            
            if offsetA == offsetB {
                return DomRangeRelativePosition.equal
            }
            
            if offsetA < offsetB {
                return DomRangeRelativePosition.before
            }
            
            if offsetA > offsetB {
                return DomRangeRelativePosition.after
            }
        }
        
        // 2. If node A is following node B, 
        // compute the position of (node B, offset B) relative to (node A, offset A). 
        // If it is before, return after. 
        // If it is after, return before.
        if nodeA.isFollowing(nodeB) {
            
            let position = relativePosition(of: second, relativeTo: first)
            
            if position == DomRangeRelativePosition.before {
                
                return DomRangeRelativePosition.after
            }
            
            if position == DomRangeRelativePosition.after {
                
                return DomRangeRelativePosition.before
            }
        }

        // 3. If node A is an ancestor of node B:
        if nodeA.isInclusiveAncestor(of: nodeB) {
            
            // 1. Let child equal node B.
            var child: Node = nodeB
            
            // 2. While child is not a child of node A, set child to its parent.
            while child.parentNode != nodeA {
                
                if let _childParent = child.parentNode {
                
                    child = _childParent
                }
                else {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("Ancestor of nodeB does not have any parent while nodeA.isInclusiveAncestor(of: nodeB) has returned yes...", log: Log.Web.all, type: .error)
                    #endif
                }
            }
            
            // 3. If the index of child is less than offset A, return after.
            if child.index < offsetA {
                
                return DomRangeRelativePosition.after
            }
        }
        
        return DomRangeRelativePosition.before
    }
    

    
    
}













