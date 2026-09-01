//
//  PreservedText.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2016-05-26.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation
import Common

///
/// This is used to be able to pass HTML block of text
/// to the XMLSerializer without it to be transformed by the serializer.
/// We can not use the DOM Text node for this purpose since this node content
/// will be transformed in order to not interfere with the final serialisation
/// with anything that could confuse an HTML parser removed. 
///
/// In our case we want to pass the text as is, it is supposed to be HTML already
/// serialized so we don't want to tranform it, hence this class.
///
public final class PreservedText: Text {

    public override init(sourceStringFragment: SourceStringFragment?, document: Document?, data: DOMString) {
        
        super.init(sourceStringFragment: sourceStringFragment, document: document, data: data)
        nodeType = NodeType.text_node
        self.nodeName = "#text"
    }
    
    public convenience init(document: Document?, data: DOMString = "") {
        
        self.init(sourceStringFragment: nil, document: document, data: data)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: HtmlDomVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // 1. Traverse the left subtree.
    // 2. Visit the root.
    // 3. Traverse the right subtree.
    public override func accept<Visitor: HtmlDomVisitor>(_ visitor: Visitor) -> Visitor.NodeInfoType? {
        
        return visitor.visit(self)
    }
    
    @discardableResult
    public override func acceptSingle<Visitor: HtmlDomVisitor>(_ visitor: Visitor) -> Visitor.NodeInfoType? {
        
        return visitor.visit(self)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: HtmlRendererVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    @discardableResult
    public override func acceptRenderer<Visitor: HtmlRendererVisitor>(_ visitor: Visitor) -> Visitor.NodeInfoType? {
        
        return visitor.visit(self)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ClonableNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias ClonableNodeType = PreservedText
    
    override public func cloneNode(_ deep: Bool = false) -> PreservedText {
        
        // The super.cloneNode() function is supposed to call
        // our implementations of cloneFields and createInstance.
        return super.cloneNode(deep) as! PreservedText
    }
    
    override public func createInstance() -> PreservedText {
        
        return PreservedText(document: nil, data: self.data)
    }
    
    func cloneFields(_ copy: inout PreservedText) {
        
        var node = copy as CharacterData
        
        super.cloneFields(&node)
    }
    
}
