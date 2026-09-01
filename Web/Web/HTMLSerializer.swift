//
//  HTMLSerializer.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-12-20.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation
import Common
import os

enum EscapeStringMode {
    
    case attribute
    case notAttribute
}

/// [HTMLSerializer](http://www.w3.org/TR/DOM-Parsing/)
public final class HTMLSerializer {
    
    enum Mode {
        
        case normal
        case strip
        case rename
    }
    
    let rangesEnabled: Bool
    
    private let mode: Mode
    
    private let includeGeneratedIds: Bool
    
    public static func createWithGeneratedIds(rangesEnabled: Bool = false) -> HTMLSerializer {
        
        return HTMLSerializer(mode: .normal, rangesEnabled: rangesEnabled, includeGeneratedIds: true)
    }
    
    
    public static func createDefault(rangesEnabled: Bool = false) -> HTMLSerializer {
        
        return HTMLSerializer(mode: .normal, rangesEnabled: rangesEnabled)
    }
    
    /// This serializer renames the markdown elements to
    /// div elements. This is used to output the HTML for the
    /// HTML preview where we want to keep the number of body
    /// children count the same as in the generated Document from
    /// the MarkdownDomRenderer since we use the index in the children
    /// to synchronize between the text and the html preview views.
    public static func createPreview(rangesEnabled: Bool = false) -> HTMLSerializer {
        
        return HTMLSerializer(mode: .rename, rangesEnabled: rangesEnabled)
    }
    
    /// This serializer strips the Markdown elements completely. It should
    /// be used for outputing the flat HTML.
    public static func createFlat(rangesEnabled: Bool = false) -> HTMLSerializer {
        
        return HTMLSerializer(mode: .strip, rangesEnabled: rangesEnabled)
    }

//    public static func createBodyContentFlat(rangesEnabled: Bool = false) -> HTMLSerializer {
//
//        return HTMLSerializer(mode: .strip, rangesEnabled: rangesEnabled, bodyContentOnly: true)
//    }
    
    private init(mode: Mode, rangesEnabled: Bool, includeGeneratedIds: Bool = false) {
        
        self.mode = mode
        self.includeGeneratedIds = includeGeneratedIds
        self.rangesEnabled = rangesEnabled
    }
    
    /// Serializing HTML fragments
    /// [](http://www.w3.org/TR/html5/syntax.html#serializing-html-fragments)
    public func serializeHTMLFragment(_ document: Document) -> String {
        
        return commonSerializeHTMLFragment(document)
    }

    /// Serializing HTML fragments
    /// [](http://www.w3.org/TR/html5/syntax.html#serializing-html-fragments)
    public func serializeHTMLFragment(_ documentFragment: DocumentFragment) -> String {
        
        return commonSerializeHTMLFragment(documentFragment)
    }
    
    /// Serializing HTML fragments
    /// [](http://www.w3.org/TR/html5/syntax.html#serializing-html-fragments)
    public func serializeHTMLFragment(_ element: Element) -> String {
        
        return commonSerializeHTMLFragment(element)
    }
    
    fileprivate func commonSerializeHTMLFragment(_ node: ContainerNode) -> String {
        
        // 1. Let s be a string, and initialise it to the empty string.
        var s = ""
        
        // 2. If the node is a template element, then let the node instead be the template element's template contents 
        // (a DocumentFragment node).
        // TODO: THIS
        
        // 3. For each child node of the node, in tree order, run the following steps:
        if let children = node.childNodes {
        
            for child in children {
            
                // 1. Let current node be the child node being processed.
                let  currentNode = child
                
                // 2. Append the appropriate string from the following list to s:
                switch currentNode {
                
                case let element as MarkdownElement:
                
                    switch self.mode {
                        
                    case .normal: // this is used for testing 
                        
                        s += serializeOpenTag(fromElement: element)
                        s += commonSerializeHTMLFragment(element)
                        s += serializeCloseTag(fromElement: element)
                        
                    case .rename: // html preview
                        
                        // we render only the top level Markdown elements
                        // to keep the same number of elements between the
                        // Markdown DOM and the HTML preview rendered DOM.
                        // This is necessary because we use element's index
                        // for synchronisation between the editor view and
                        // the HTML preview view.
                        if element.isTopLevel {
                            
                            switch element.localName {
                            case §MarkdownElementType.HtmlBlock:
                                s += serializeOpenTag(fromElement: element, newName: "div")
                                s += commonSerializeHTMLFragment(element)
                                s += serializeCloseTag(fromElement: element, newName: "div")
                            default:
                                
                                s += serializeOpenTag(fromElement: element, newName: "div")
                                s += serializeCloseTag(fromElement: element, newName: "div")
                            }
                        }
                        
                    case .strip: // html export
                        
                        switch element.localName {
                        case §MarkdownElementType.HtmlBlock:
                            s += commonSerializeHTMLFragment(element)
                        default:
                            break
                        }
                    }
                    
                case let preservedText as PreservedText:
                    
                    s += preservedText.data
                    
                case let element as Element:
                
                    s += serializeOpenTag(fromElement: element)
                    
                    // If current node is an area, base, basefont, bgsound, br, col, embed, frame, hr, img,
                    // input, keygen, link, meta, param, source, track or wbr element, then continue on to
                    // the next child node at this point.
                    if element.localName == "area" || element.localName == "base" || element.localName == "basefont" || element.localName == "bgsound" || element.localName == "br" || element.localName == "col" || element.localName == "embed" || element.localName == "frame" || element.localName == "hr" || element.localName == "img" || element.localName == "input" || element.localName == "keygen" || element.localName == "link" || element.localName == "meta" || element.localName == "param" || element.localName == "source" || element.localName == "track" || element.localName == "wbr" {
                        
                        continue
                    }
                    
                    // If current node is a pre, textarea, or listing element, and the first child node
                    // of the element, if any, is a Text node whose character data has as its first
                    // character a "LF" (U+000A) character, then append a "LF" (U+000A) character.
                    if element.localName == "pre" || element.localName == "textarea" || element.localName == "listing" {
                        
                        if let firstTextChild = element.childNodes?.item(0) as? Text {
                            
                            if firstTextChild.data.length > 0 && firstTextChild.data.charAt(0) == 0x000a {
                                
                                s += "\u{000a}"
                            }
                        }
                    }
                    
                    // Append the value of running the HTML fragment serialization algorithm on the current
                    // node element (thus recursing into this algorithm for that element), followed by a "<" (U+003C) character,
                    // a U+002F SOLIDUS character (/), tagname again, and finally a U+003E GREATER-THAN SIGN character (>).
                    s += serializeHTMLFragment(element)
                    s += serializeCloseTag(fromElement: element)
                    
                case let text as Text:

                    // current node is a Text node
                    
                    // If the parent of current node is a style, script, xmp, iframe, noembed, noframes, or plaintext element,
                    if let parentElement = text.parentElement, parentElement.localName == "style" || parentElement.localName == "script" || parentElement.localName == "xmp" || parentElement.localName == "iframe" || parentElement.localName == "noembed" || parentElement.localName == "noframes" || parentElement.localName == "plaintext" {
                        
                        s += text.data
                    }
                    // or if the parent of current node is a noscript element and scripting is enabled for the node,
                    // then append the value of current node's data IDL attribute literally.
                    else if let parentElement = text.parentElement, parentElement.localName == "noscript" {
                        
                        assert(false, "Missing implementation. We have not implemented browsing context yet.")
                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                        os_log("Missing implementation. We have not implemented browsing context yet.", log: Log.Web.all, type: .error)
                        #endif
                    }
                    else {
                        
                        s += escpapeString(text.data, mode: EscapeStringMode.notAttribute)
                    }
                    
                case let comment as Comment:
                    
                    // current node is a Comment
                    
                    // Append the literal string <!-- (U+003C LESS-THAN SIGN, U+0021 EXCLAMATION MARK, U+002D HYPHEN-MINUS, U+002D HYPHEN-MINUS), 
                    // followed by the value of current node's data IDL attribute, followed by the literal string --> 
                    // (U+002D HYPHEN-MINUS, U+002D HYPHEN-MINUS, U+003E GREATER-THAN SIGN).
                    
                    s += "<!--" + comment.data + "-->"
                    
                case let processingInstruction as ProcessingInstruction:
                    
                    // current node is a ProcessingInstruction
                    
                    // Append the literal string <? (U+003C LESS-THAN SIGN, U+003F QUESTION MARK), followed by the value of 
                    // current node's target IDL attribute, followed by a single U+0020 SPACE character, followed by the value 
                    // of current node's data IDL attribute, followed by a single ">" (U+003E) character.
                    s += "<?" + processingInstruction.target + " " + processingInstruction.data + ">"
                    
                case let documentType as DocumentType:
                    
                    s += serializeDocumentType(documentType)
                    
                default:
                    
                    break
                }
            }
        }
        
        // 4. The result of the algorithm is the string s.
        return s
    }
    
    public func serializeDocumentType(_ documentType: DocumentType) -> String {
        
        // current node is a DocumentType
        
        // Append the literal string <!DOCTYPE (U+003C LESS-THAN SIGN, U+0021 EXCLAMATION MARK, U+0044 LATIN CAPITAL LETTER D,
        // U+004F LATIN CAPITAL LETTER O, U+0043 LATIN CAPITAL LETTER C, U+0054 LATIN CAPITAL LETTER T,
        // U+0059 LATIN CAPITAL LETTER Y, U+0050 LATIN CAPITAL LETTER P, U+0045 LATIN CAPITAL LETTER E),
        // followed by a space (U+0020 SPACE), followed by the value of current node's name IDL attribute,
        // followed by the literal string > (U+003E GREATER-THAN SIGN).
        return "<!DOCTYPE " + documentType.name + ">"
    }
    
    public func serializeCloseTag(fromElement element: Element, newName: String? = nil) -> String {
        
        if let newName = newName {
            return "</" + newName + ">"
        }
        else {
            return "</" + tagnameFromElement(element) + ">"
        }
    }
    
    public func serializeOpenTag(fromElement element: Element, newName: String? = nil) -> String {
        
        var s = ""
        
        // Append a "<" (U+003C) character, followed by tagname.
        if let newName = newName {
            s += "<" + newName
        }
        else {
            s += "<" + tagnameFromElement(element)
        }
        
        // For each attribute that the element has, append a U+0020 SPACE character,
        // the attribute's serialized name as described below, a "=" (U+003D) character,
        // a U+0022 QUOTATION MARK character ("), the attribute's value, escaped as described
        // below in attribute mode, and a second U+0022 QUOTATION MARK character (").
        //
        // for performance purpose we divide the strip and the normal
        // serialization process since strip is only used for export.
        if self.mode == .strip {
            
            for attribute in element.attributeList {
                
                let serializedName = attributeSerializedName(attribute)
                
                if serializedName == §MarkdownAttributeType.highlight {
                    // do nothing
                    // we remove the highlight attribute that we keep only for internal use
                }
                else {
                    if serializedName == "nw-element-id" && includeGeneratedIds {
                        // s += " " + "id=" + "\"" + escpapeString(attribute.nodeValue, mode: .attribute) + "\""
                        s += " id=" + "\"" + attribute.nodeValue + "\""
                    }
                    else if serializedName != "nw-element-id" {
                        
                        if attribute.nodeValue.isEmpty {
                            s += " " + serializedName + "=" + "\"\""
                        }
                        else {
                            s += " " + serializedName + "=" + "\"" + escpapeString(attribute.nodeValue, mode: .attribute) + "\""
                        }
                    }
                }
            }
        }
        else {
            for attribute in element.attributeList {
                
                let serializedName = attributeSerializedName(attribute)

                if serializedName == "nw-element-id" && includeGeneratedIds {
                    // s += " " + "id=" + "\"" + escpapeString(attribute.nodeValue, mode: .attribute) + "\""
                    s += " id=" + "\"" + attribute.nodeValue + "\""
                }
                else if serializedName != "nw-element-id" {
                    
                    if attribute.nodeValue.isEmpty {
                        s += " " + serializedName
                    }
                    else {
                        s += " " + serializedName + "=" + "\"" + escpapeString(attribute.nodeValue, mode: .attribute) + "\""
                    }
                }
            }
        }
        
        if rangesEnabled {
            s += serializeRangeAttribute(element)
        }
        
        // Append a ">" (U+003E) character.
        
        // If current node is an area, base, basefont, bgsound, br, col, embed, frame, hr, img,
        // input, keygen, link, meta, param, source, track or wbr element, then continue on to
        // the next child node at this point.
        if element.localName == "area" || element.localName == "base" || element.localName == "basefont" || element.localName == "bgsound" || element.localName == "br" || element.localName == "col" || element.localName == "embed" || element.localName == "frame" || element.localName == "hr" || element.localName == "img" || element.localName == "input" || element.localName == "keygen" || element.localName == "link" || element.localName == "meta" || element.localName == "param" || element.localName == "source" || element.localName == "track" || element.localName == "wbr" {
            
            // 1. " " (U+0020 SPACE);
            s += " "
            
            // 2. "/" (U+002F SOLIDUS).
            s += "/"
            
            // 3. ">"
            s += ">"
        }
        else {
        
            s += ">"
        }
        
        return s
    }
    
    public func serializeSelfClosingTag(fromElement element: Element) -> String {
        
        var s = ""
        
        // Append a "<" (U+003C) character, followed by tagname.
        s += "<" + tagnameFromElement(element)
        
        // For each attribute that the element has, append a U+0020 SPACE character,
        // the attribute's serialized name as described below, a "=" (U+003D) character,
        // a U+0022 QUOTATION MARK character ("), the attribute's value, escaped as described
        // below in attribute mode, and a second U+0022 QUOTATION MARK character (").
        for attribute in element.attributeList {
            
            let serializedName = attributeSerializedName(attribute)
            
            s += " " + serializedName + "=" + "\"" + escpapeString(attribute.nodeValue, mode: .attribute) + "\""
        }
        
        // Append a ">" (U+003E) character.
        s += " />"
        
        return s
        
    }
    
    public func plainStringStyleSerializedSelfClosingTag(fromElement element: Element) -> String {
        
        var s = ""
        
        // Append a "<" (U+003C) character, followed by tagname.
        s += tagnameFromElement(element)
        
        // For each attribute that the element has, append a U+0020 SPACE character,
        // the attribute's serialized name as described below, a "=" (U+003D) character,
        // a U+0022 QUOTATION MARK character ("), the attribute's value, escaped as described
        // below in attribute mode, and a second U+0022 QUOTATION MARK character (").
        for attribute in element.attributeList {
            
            let serializedName = attributeSerializedName(attribute)
            
            s += " " + serializedName + "=" + "\"" + escpapeString(attribute.nodeValue, mode: .attribute) + "\""
        }
        
        return s
    }
    
    fileprivate func serializeRangeAttribute(_ element: Element) -> String {
        
        var rangeString = ""
        
        if let fragment = element.sourceStringFragment {
            
            rangeString += " range=\"\(fragment.stringRepresentation)\" "
        }
        
        for key in element.pseudoElementsFragments.keys {
            
            rangeString += "\(key)-pseudo-range=\"\(element.pseudoElementsFragments[key]!.stringRepresentation)\" "
        }
        
        return rangeString
    }
    
    fileprivate func tagnameFromElement(_ element: Element) -> String {
        
        var tagname: String = ""
        
        // If current node is an element in the HTML namespace, the MathML namespace,
        // or the SVG namespace, then let tagname be current node's local name. Otherwise,
        // let tagname be current node's qualified name.
        // In our case we also add the Markdown namespace.
        if let namespace = element.namespaceURI, namespace == §Namespace.HTML || namespace == §Namespace.SVG || namespace == §Namespace.MATHML || namespace == §Namespace.MD || namespace == §Namespace.CSS {
            
            tagname = element.localName
        }
        else {
            
            assert(false, "Missing implementation see above for what to implement")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Missing implementation see above for what to implement", log: Log.Web.all, type: .error)
            #endif
            //                  tagname = element.qualifiedName
        }
        return tagname
    }
    
    fileprivate func attributeSerializedName(_ attribute: Attr) -> String {
        

        if let attributeNamespace = attribute.namespaceURI {
            
            // If the attribute is in the XML namespace
            // The attribute's serialized name is the string "xml:" followed by the attribute's local name.
            if attributeNamespace == §Namespace.XML {
            
                return "xml:" + attribute.localName
            }
            // If the attribute is in the XLink namespace
            // The attribute's serialized name is the string "xlink:" followed by the attribute's local name.
            else if attributeNamespace == §Namespace.XLINK {
             
                return "xlink:" + attribute.localName
            }
            else if attributeNamespace == §Namespace.XMLNS {
             
                // If the attribute is in the XMLNS namespace and the attribute's local name is xmlns
                // The attribute's serialized name is the string "xmlns".
                if attribute.localName == "xmlns" {
                        
                    return "xmlns"
                }
                // If the attribute is in the XMLNS namespace and the attribute's local name is not xmlns
                // The attribute's serialized name is the string "xmlns:" followed by the attribute's local name.
                else {
                        
                    return "xmlns:" + attribute.localName
                }
            }
            
            // If the attribute is in some other namespace
            // The attribute's serialized name is the attribute's qualified name.
            return "xmlns:" + attribute.localName
        }
        
        // if If the attribute has no namespace
        // The attribute's serialized name is the attribute's local name.
        return attribute.localName
    }
    
    
    fileprivate func escpapeString(_ string: String, mode: EscapeStringMode) -> String {
        
        var localString = string
        
        // Escaping a string (for the purposes of the algorithm above) consists of running the following steps:
        
        // Replace any occurrence of the "&" character by the string "&amp;".
        localString = localString.replacingOccurrences(of: "&", with: "&amp;")
        
        // Replace any occurrences of the U+00A0 NO-BREAK SPACE character by the string "&nbsp;".
        localString = localString.replacingOccurrences(of: "\\u00A0", with: "&nbsp;")
        
        if mode == .attribute {

            // If the algorithm was invoked in the attribute mode, replace any occurrences of the """ character by the string "&quot;".
            localString = localString.replacingOccurrences(of: "\"", with: "&quot;")
        }
        else {

            // If the algorithm was not invoked in the attribute mode, replace any occurrences of 
            // the "<" character by the string "&lt;", and any occurrences of the ">" character by the string "&gt;".
            localString = localString.replacingOccurrences(of: ">", with: "&gt;")
            localString = localString.replacingOccurrences(of: "<", with: "&lt;")
            localString = localString.replacingOccurrences(of: "\"", with: "&quot;")
        }
        
        return localString
    }
    
}
