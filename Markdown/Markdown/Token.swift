//
//  Token.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-22.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common
import Web
import os

extension WeakContainer {
    
    public var unsafeElement: Unmanaged<Element>? {
        
        if let value = value as? Element {
            return Unmanaged.passUnretained(value)
        }
        return nil
    }
}

/// class Token
public final class Token: CustomStringConvertible, Equatable, Positionnable {
    
    public var description: String {
 
        return toString()
    }
    
    /// MarkdownIt uses String for token type. I will use
    /// enum since it will probably be faster. We will add 
    /// an associated value if necessary.
    /// Type of the token (string, e.g. "paragraph_open")
    public internal(set) var type: TokenType
    
    /// Token#tag -> String
    ///
    /// html tag name, e.g. "p"
    public internal(set) var tag: String
    
    /// Token#attrs -> Array
    ///
    /// Could be nil.
    ///
    /// Html attributes. Format: `[ [ name1, value1 ], [ name2, value2 ] ]`
    public internal(set) var attrs: [(String, String)]?
    
    /// Token#nesting -> Number
    ///
    /// Level change (number in {-1, 0, 1} set), where:
    ///
    /// -  `1` means the tag is opening
    /// -  `0` means the tag is self-closing
    /// - `-1` means the tag is closing
    public internal(set) var nesting: Nesting
    
    /// Token#level -> Number
    ///
    /// nesting level, the same as `state.level`
    public internal(set) var level: Int 
    
    /// Token#children -> Array
    ///
    /// An array of child nodes (inline and img tokens)
    ///
    /// We modify it to be a class because we want to be able to pass 
    /// a reference to the parsers. 
    public internal(set) var children: Tokens

    /// * Token#content -> String
    /// *
    /// * In a case of self-closing tag (code, html, fence, etc.),
    /// * it has contents of this tag.
    public internal(set) var content: String
    
    ///
    /// Token#markup -> String
    ///
    /// '*' or '_' for emphasis, fence string for fence, etc.
    ///
    public internal(set) var markup: String
    
    /// Token#info -> String
    ///
    /// fence infostring
    public internal(set) var info: String?
    
    /// Token#meta -> Object
    ///
    /// A place for plugins to store an arbitrary data
    public internal(set) var meta: AnyObject?
    
    /// Token#block -> Boolean
    ///
    /// True for block-level tokens, false for inline tokens.
    /// Used in renderer to calculate line breaks
    public internal(set) var block: Bool
    
    ///
    /// Token#hidden -> Boolean
    ///
    /// If it's true, ignore this element when rendering. Used for tight lists
    /// to hide paragraphs.
    ///
    public internal(set) var hidden: Bool
    
    public internal(set) var referenceLabel: String?
    
    var attrsBlocs: [AttributesBloc]?
    
    var attr: Attribute?
    
    weak var parentTokens: Tokens?
    
    var startLine: Int?
    
    var endLine: Int?
    
    /// The start index for the token as an Int
    public var startStringIndex: Int {
        
        var fragment = sourceFragments[.All]!
        fragment.move(displacement)
        return fragment.startFragmentIndex!.integerValue
    }
    
    /// The end index for the token as an Int
    public var endStringIndex: Int? {
        
        var fragment = sourceFragments[.All]
        if displacement != 0 {
            fragment?.move(displacement)
        }
        return fragment?.endFragmentIndex?.integerValue
    }
    
    public var hasLinkingOrPotentiallyLinkingChild: Bool = false
    
    public var isLineBelowToken: Bool = false
    
    public var emptyLineAbove = false
    
    /// Token#sourceFragments
    ///
    /// Dictionary of SourceStringFragments describing the regions 
    /// encompassed by this token.
    /// The region that comprise all the content including
    /// the tagRegion.
    private var sourceFragments: [MarkdownSourceFragmentType: SourceStringFragment]
    
    private var fragmentString: String? {
        
        if let fragment = sourceStringFragment {
            
            return fragment.debugDescription
        }
        return nil
    }
    
    /// References to the DOM Nodes that has been created with this 
    /// Token. They are created by the MarkdownDomRenderer.
    private var associatedDomNodes: ContiguousArray<WeakContainer<Node>>
    
    var validTopLevelBlockStartToken: Bool {
        
        if block
            && (nesting == .opening || nesting == .selfClosing)
            && level == 0
            // we never partially compile a table
            && tag != "tr"
            && tag != "td"
            && tag != "th"
            && tag != "tbody"
            && tag != "thead" {
            
            return true
        }
        return false
    }
    
    var validTopLevelBlockEndToken: Bool {
        
        if block
            && (nesting == .closing || nesting == .selfClosing)
            && level == 0
            // we never partially compile a table
            && tag != "tr"
            && tag != "td"
            && tag != "th"
            && tag != "tbody"
            && tag != "thead" {
            
            return true 
        }
        return false
    }
    
    /// Token(type, tag, nesting)
    ///
    /// Create new token and fill passed properties.
    init(type: TokenType, tag: String, nesting: Nesting) {
        
        self.type = type
        self.tag = tag
        self.nesting = nesting
        self.level = 0
        self.children = Tokens()
        self.content = ""
        self.markup = ""
        self.block = false
        self.hidden = false
        self.sourceFragments = [MarkdownSourceFragmentType: SourceStringFragment]()
        self.associatedDomNodes = ContiguousArray<WeakContainer<Node>>()
        
        // end
        self.children.parentToken = self 
    }
    
    public func isTokenLineBelow(_ token: Token) -> Bool {
        
        if let endLine = endLine, let startLine = token.startLine, endLine == startLine {
            
            return true
        }
        return false
    }
    
    public func replaceContent(with other: Token) {
        
        self.type = other.type
        self.tag = other.tag
        self.nesting = other.nesting
        self.level = other.level
        self.children = other.children
        self.content = other.content
        self.markup = other.markup
        self.block = other.block
        self.hidden = other.hidden
        self.sourceFragments = other.sourceFragments
    }
    
    public func addAssociatedDomNode(_ node: Node) {
        
        associatedDomNodes.append(WeakContainer<Node>(value: node))
    }
    
    public func getAssociatedDomNodes() -> [Node] {
        
        return associatedDomNodes.compactMap{$0.value}
    }
    
    public func sourceFragment(for tag: MarkdownSourceFragmentType) -> SourceStringFragment? {
    
        if displacement != 0 {
            applyDisplacement()
        }
        return sourceFragments[tag]
    }
    
    public func setSourceFragment(_ sourceStringFragment: SourceStringFragment?, for tag: MarkdownSourceFragmentType) {
        
        if let sourceStringFragment = sourceStringFragment {
            self.sourceFragments[tag] = sourceStringFragment
        }
    }
    
    /// Execute a procedure on this token, and calling excute 
    /// on all children
    public func execute(_ procedure: (Token) -> ()) {
        
        // execute the procedure on the children 
        children.execute(procedure)
        
        // execute the procedure on the token itself
        procedure(self)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Positionnable protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    private var displacement: Int = 0
    
    /// This method translate the position of the fragment using
    // the count from which moving the fragment by adding this count
    // to the start and end index.
    public func move(_ count: Int, env: Env) {
        
        displacement += count

        for domNodeWeakContainer in associatedDomNodes {
            if let element = domNodeWeakContainer.unsafeElement {
                element._withUnsafeGuaranteedRef {
                    $0.move(count)
                }
            }
        }
        
        if self.attrsBlocs != nil {
            for i in 0..<self.attrsBlocs!.count {
                self.attrsBlocs![i].move(count)
            }
        }
            
        // Create an Unmanaged reference.
        let _children : Unmanaged<Tokens> = Unmanaged.passUnretained(children)
        
        _children._withUnsafeGuaranteedRef {
            $0.move(count, env: env)
        }
    }
    
    private func applyDisplacement() {
        
        if displacement != 0 {
            for (sourceFragmentName, _) in sourceFragments {
                self.sourceFragments[sourceFragmentName]!.move(displacement)
            }
            self.displacement = 0
        }
    }
    
    public var sourceStringFragment: SourceStringFragment? {
        
        get {
            if displacement != 0 {
                applyDisplacement()
            }
            return self.sourceFragment(for: .All)
        }
        set {
            fatalError("should not use this")
        }
    }
    
    /// Method that return true if the token contains the
    /// specified index in the .All fragment
    public func indexRelativePositionFromAllFragment(_ index: Int) -> RelativePosition? {
        
        if displacement != 0 {
            applyDisplacement()
        }
        
        return self.sourceFragments[.All]?.indexRelativePosition(index)
    }
    
    /// Token.attrIndex(name) -> Number
    ///
    /// Search attribute index by name.
    public func attrIndex(_ name: String) -> Int? {
    
        if let attrs = attrs {
            
            for (index, (attrName, _)) in attrs.enumerated() {
                
                if attrName == name {
                    
                    return index
                }
            }
        }
        return nil
    }
    
    /// Method that compare the content of the two tokens 
    /// and return true if they are equal.
    public func equals(to other: Token, comparePositions: Bool = false, compareChildren: Bool = false) -> Bool {
        
        if type != other.type {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Not equals: token type are different.", log: Log.Markdown.all, type: .debug)
            #endif
            return false
        }
        
        if tag != other.tag {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Not equals: tag are different.", log: Log.Markdown.all, type: .debug)
            #endif
            return false
        }
        
        if let attrs = attrs {
        
            if let otherAttrs = other.attrs {
            
                if attrs.count != otherAttrs.count {
            
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: attrs.count are different.", log: Log.Markdown.all, type: .debug)
                    #endif
                    return false
                }
        
                for (index, attr) in attrs.enumerated() {
            
                    let otherAttr = otherAttrs[index]
                    
                    if attr.0 != otherAttr.0 {
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: attr.0 are different.", log: Log.Markdown.all, type: .debug)
                        #endif
                        return false
                    }
                    if attr.1 != otherAttr.1 {
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: attr.1 are different.", log: Log.Markdown.all, type: .debug)
                        #endif
                        return false
                    }
                }
            }
            else {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other.attrs is nil.", log: Log.Markdown.all, type: .debug)
                #endif
                return false
            }
        }
        else if let _ = other.attrs {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Not equals: other.attrs is not nil.", log: Log.Markdown.all, type: .debug)
            #endif
            return false
        }
        
        if nesting != other.nesting {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Not equals: nesting are different.", log: Log.Markdown.all, type: .debug)
            #endif
            return false
        }
        
        if level != other.level {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Not equals: level are different.", log: Log.Markdown.all, type: .debug)
            #endif
            return false
        }
        
        if compareChildren {
            
            if !children.equals(to: other.children, comparePositions: comparePositions, compareChildren: compareChildren) {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: children are different.", log: Log.Markdown.all, type: .debug)
                #endif
                return false
            }
        }
        
        if comparePositions {
            
            if self.sourceFragments.count != other.sourceFragments.count {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: sourceFragments.count are different.", log: Log.Markdown.all, type: .debug)
                #endif
                return false
            }
            
            for (sourceFragmentType, sourceFragmentsValue) in sourceFragments {
                
                if let otherFragmentValue = other.sourceFragment(for: sourceFragmentType) {
                    
                    if !sourceFragmentsValue.equals(to: otherFragmentValue) {
                    
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: sourceFragmentsValue are different.", log: Log.Markdown.all, type: .debug)
                        #endif
                        return false
                    }
                }
                else {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: other fragment named: %@ is nil.", log: Log.Markdown.all, type: .debug, %%sourceFragmentType)
                    #endif
                    return false
                }
            }
        }
        
        if content != other.content {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Not equals: content are different.", log: Log.Markdown.all, type: .debug)
            #endif
            return false
        }
        
        if markup != other.markup {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Not equals: markup are different.", log: Log.Markdown.all, type: .debug)
            #endif
            return false
        }
        
        if let info = info {
            
            if let otherInfo = other.info {
                
                if info != otherInfo {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: info are different.", log: Log.Markdown.all, type: .debug)
                    #endif
                    return false
                }
            }
            else {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other info is nil.", log: Log.Markdown.all, type: .debug)
                #endif
                return false
            }
        }
        else if let _ = other.info {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Not equals: other info is not nil.", log: Log.Markdown.all, type: .debug)
            #endif
            return false
        }
        
        // public internal(set) var meta: AnyObject?

        if block != other.block {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Not equals: block are different.", log: Log.Markdown.all, type: .debug)
            #endif
            return false
        }
        
        if hidden != other.hidden {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Not equals: hidden are different.", log: Log.Markdown.all, type: .debug)
            #endif
            return false
        }
        
        if let referenceLabel = referenceLabel {
            
            if let otherReferenceLabel = other.referenceLabel {
            
                if referenceLabel != otherReferenceLabel {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: referenceLabel are different.", log: Log.Markdown.all, type: .debug)
                    #endif
                    return false
                }
            }
            else {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other referenceLabel is nil.", log: Log.Markdown.all, type: .debug)
                #endif
                return false
            }
        }
        else if other.referenceLabel != nil {
                
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Not equals: other referenceLabel is not nil.", log: Log.Markdown.all, type: .debug)
            #endif
            return false
        }
        
        return true
    }
    
    /// Token.attrPush(attrData)
    ///
    /// Add `[ name, value ]` attribute to list. Init attrs if necessary
    func attrPush(_ attrData: (String, String)) {
        
        if attrs != nil {
        
            attrs!.append(attrData)
        }
        else {
        
            self.attrs = [(String, String)]()
            self.attrs!.append(attrData)
        }
    }
    
    func toString(includePosition: Bool = false) -> String {
        
        var str = "{\n"
        
        str += "\"type\": \"\(§type)\",\n"
        str += "\"tag\": \"\(tag)\",\n"
        str += "\"attrs\":"
        
        if let fragmentString = fragmentString, includePosition {

            str += "\"position\": \"\(String(describing: fragmentString))\",\n"
        }
        
        if let attrs = attrs {
            
            str += "\n ["
            
            for (index,(attrName,attrValue))  in attrs.enumerated() {
                
                if index != 0{
                    str += ","
                }
                
                if let intValue = Int(attrValue) {
                    str += "[\"\(attrName)\", \(intValue)]\n"
                }
                else {
                    str += "[\"\(attrName)\", \"\(attrValue)\"]\n"
                }
            }
            str += "],\n"
        }
        else {
            
            str += " null,\n"
        }
        
        str += "\"nesting\": \(§nesting),\n"
        str += "\"level\": \(level),\n"
        str += "\"children\": "
        
        if children.length > 0 {

            str += "[\n"
            
            for (index, child) in children.enumerated() {
            
                if index != children.length - 1 {
                    str += child.toString() + ",\n"
                }
                else {
                    str += child.toString() + "\n"
                }
            }
            str += "],\n"
        }
        else {
            
            str += "null,\n"
        }
        
        let displayContent = content.replacingOccurrences(of: "\n", with: "\\n").replacingOccurrences(of: "\r", with: "\\r")
        
        str += "\"content\": \"\(displayContent)\",\n"
        str += "\"markup\": \"\(markup)\",\n"
        if let info = info {
        
            str += "\"info\": \"\(info)\",\n"
        }
        else {
            
            str += "\"info\": \"\",\n"
        }
        str += "\"meta\":"
        if let meta = meta {
            
            str += " \(meta),\n"
        }
        else {
            
            str += " null,\n"
        }
        str += "\"block\": \(block),\n"
        str += "\"hidden\": \(hidden)\n"
        str += "}"
        return str
    }
}

extension Token: Hashable {
    
    public var hashValue: Int {
        
        return ObjectIdentifier(self).hashValue
    }
}

public func ==(lhs: Token, rhs: Token) -> Bool {
    
    return lhs === rhs
}










