//
//  StyloXMLSerializer.swift
//  Web
//
//  Created by Sébastien Hamel on 2016-05-27.
//  Copyright © 2016 NM. All rights reserved.
//

import Foundation
import Common
import os

///
/// [Constructor]
/// interface XMLSerializer {
///    DOMString serializeToString (Node root);
/// };
///
/// https://www.w3.org/TR/DOM-Parsing/#the-xmlserializer-interface
///
public final class StyloXMLSerializer {
    
    var codePreStack: TupleStack<String>
    
    public  init() {
    
        self.codePreStack = TupleStack<String>()
    }
    
    ///
    /// https://www.w3.org/TR/DOM-Parsing/#widl-XMLSerializer-serializeToString-DOMString-Node-root
    ///
    public func serializeToString(_ root: Node) -> DOMString {
        
        /// https://www.w3.org/TR/DOM-Parsing/#dfn-concept-serialize-xml
        
        // To produce an XML serialization of a Node node given a flag
        // require well-formed, run the following steps:
        
        // 1. Let context namespace be null. The context namespace is changed when
        // a node serializes a different default namespace definition from its parent.
        // The algorithm assumes no namespace to start.
        var contextNamespace: String? = nil
        
        // 2. Let namespace prefix map be a new map for associating namespaceURI and namespace prefix pairs,
        // where namespaceURI values are the map's keys, and prefix values are the map's key values.
        var namespacePrefixMap = [String: String]()
        
        // 3. Initialize the namespace prefix map with the XML namespace key and string "xml" as the key value.
        namespacePrefixMap["xml"] = §Namespace.XML
        
        // 4. Let generated namespace prefix index be an integer with a value of 1.
        var generatedNamespacePrefixIndex: Int = 1
        
        // 5. Return the result of running the XML serialization algorithm on node
        // passing the context namespace, namespace prefix map, generated namespace
        // prefix index reference, and the flag require well-formed.
        return try! xmlSerialize(root, contextNamespace: &contextNamespace, namespacePrefixMap: namespacePrefixMap, generatedNamespacePrefixIndex: &generatedNamespacePrefixIndex)!
    }
    
    ///
    /// https://www.w3.org/TR/DOM-Parsing/#dfn-concept-xml-serialization-algorithm
    ///
    func xmlSerialize(_ root: Node, contextNamespace namespace: inout String?, namespacePrefixMap: [String: String], generatedNamespacePrefixIndex prefixIndex: inout Int, requireWellFormed: Bool = false) throws -> String? {
        
        switch root {
            
        case let preservedText as PreservedText:
            
            // 1. Let markup be the value of node's data.
            return preservedText.data
            
        case let element as Element:
            
            // 1. If the require well-formed flag is set (its value is true), and this node's localName
            // attribute contains the character ":" (U+003A COLON) or does not match the XML Name production [XML10],
            // then throw an exception; the serialization of this node would not be a well-formed element.
            if requireWellFormed && (element.localName.contains(":") || !XMLValidator.validateNameProduction(element.localName)){
                
                throw DOMException.invalidStateError
            }
            
            // 2. Let markup be the string "<" (U+003C LESS-THAN SIGN).
            var markup: String = "<"
            
            // 3. Let qualified name be an empty string.
            var qualifiedName = ""
            
            // 4. Let a skip end tag flag have the value false.
            var skipEndTag = false
            
            // 5. Let an ignore namespace definition attribute flag have the value false.
            var ignoreNamespaceDefinitionAttribute = false
            
            // 6. Let map be a copy of the prefix map.
            // It is a copy since it is a struct...
            var map = namespacePrefixMap
            
            // 7. Let element prefixes list be an empty list.
            var elementPrefixesList = [String]()
            
            // 8. Let duplicate prefix definition be null.
            var duplicatePrefixDefinition: String? = nil
            
            // 9. Let local default namespace be the result of recording the namespace information
            // for node given map, element prefixes list, and duplicate prefix definition.
            let localDefaultNamespace = recordNamespaceInformation(element, namespacePrefixMap: &map, elementPrefixesList: &elementPrefixesList, duplicatePrefixDefinition: &duplicatePrefixDefinition)
            
            // 10. Let inherited ns be a copy of namespace.
            var inheritedNS = namespace
            
            // 11. Let ns be the value of node's namespaceURI attribute.
            let ns = element.namespaceURI
            
            // 12. If inherited ns is equal to ns, then:
            if inheritedNS == ns {
                
                // 1. If local default namespace is not null, then set ignore namespace definition attribute to true.
                if let _ = localDefaultNamespace {
                    
                    ignoreNamespaceDefinitionAttribute = true
                }
                
                // 2. If ns is the XML namespace, then let qualified name be the concatenation of the string "xml:"
                // and the value of node's localName.
                if ns == §Namespace.XML {
                    
                    qualifiedName = "xml:\(element.localName)"
                }
                    // 3. Otherwise, let qualified name be the value of node's localName.
                    // The node's prefix is always dropped.
                else {
                    
                    qualifiedName = element.localName
                }
                
                // 4. Append the value of qualified name to markup.
                markup += qualifiedName
            }
                
                // 13. Otherwise, inherited ns is not equal to ns (the node's own namespace is
                // different from the context namespace of its parent).
                // Run these sub-steps:
            else {
                
                // 1. Let prefix be the value of node's prefix attribute.
                var prefix = element.prefix
                
                // 2. Let candidate prefix be a value from map where there exists a key in map
                // that matches the value of ns or if there is no such key, then let candidate prefix be null.
                var candidatePrefix: String?
                
                if let ns = ns , map[ns] != nil {
                    
                    candidatePrefix = map[ns]
                }
                
                // 3. If candidate prefix is not null (a suitable namespace prefix is
                // defined which maps to ns), then:
                if let candidatePrefix = candidatePrefix {
                    
                    // 1. Let qualified name be the concatenation of candidate prefix, ":" (U+003A COLON), and node's localName.
                    qualifiedName = "\(candidatePrefix):\(element.localName)"
                    
                    // 2. If local default namespace is not null (there exists a locally-defined default namespace declaration attribute),
                    // then let inherited ns get the value of ns.
                    if let _ = localDefaultNamespace  {
                        
                        inheritedNS = ns
                    }
                    
                    // 3. Append the value of qualified name to markup.
                    markup += qualifiedName
                }
                    // 4. Otherwise, if prefix is not null and local default namespace is null, then:
                else if let _prefix = prefix , localDefaultNamespace == nil {
                    
                    // 1. If the element prefixes list contains the value of prefix,
                    // then let prefix be the result of generating a prefix providing
                    // as input the namespace prefix map map, node's ns string, and the prefix index integer.
                    if elementPrefixesList.contains(_prefix) {
                        
                        prefix = generatePrefix(&map, newNamespace: ns!, generatedNamespacePrefixIndex: &prefixIndex)
                    }
                        // 2. Otherwise, append to map a new key ns whose key value is prefix.
                    else {
                        
                        map[ns!] = _prefix
                    }
                    
                    // 3. Let qualified name be the concatenation of prefix, ":" (U+003A COLON),
                    // and node's localName.
                    qualifiedName = "\(prefix!):\(element.localName)"
                    
                    // 4. Append the value of qualified name to markup.
                    markup += qualifiedName
                    
                    // 5. Append the following to markup, in the order listed:
                    
                    // 1. " " (U+0020 SPACE);
                    markup += " "
                    
                    // 2. The string "xmlns:";
                    markup += "xmlns:"
                    
                    // 3. The value of prefix;
                    markup += prefix!
                    
                    // 4. "="" (U+003D EQUALS SIGN, U+0022 QUOTATION MARK);
                    markup += "=\""
                    
                    // 5. The result of serializing an attribute value given ns and
                    // the require well-formed flag as input;
                    markup += try! serializeAttributeValue(ns, requireWellFormed: requireWellFormed)
                    
                    // 6. """ (U+0022 QUOTATION MARK).
                    markup += "\""
                }
                    // 5. Otherwise, if local default namespace is null, or local default namespace is not null
                    // and its value is not equal to ns, then:
                else if localDefaultNamespace == nil || localDefaultNamespace! != ns {
                    
                    // 1. Set the ignore namespace definition attribute flag to true.
                    ignoreNamespaceDefinitionAttribute = true
                    
                    // 2. Let qualified name be the value of node's localName.
                    qualifiedName = element.localName
                    
                    // 3. Let the value of inherited ns be ns.
                    inheritedNS = ns
                    
                    // 4. Append the value of qualified name to markup.
                    markup += qualifiedName
                    
                    // 5. Append the following to markup, in the order listed:
                    
                    // 1. " " (U+0020 SPACE);
                    markup += " "
                    
                    // 2. The string "xmlns";
                    markup += "xmlns"
                    
                    // 3. "="" (U+003D EQUALS SIGN, U+0022 QUOTATION MARK);
                    markup += "=\""
                    
                    // 4. The result of serializing an attribute value given ns and the require well-formed flag as input;
                    markup += try! serializeAttributeValue(ns, requireWellFormed: requireWellFormed)
                    
                    // 5. """ (U+0022 QUOTATION MARK).
                    markup += "\""
                }
                    // 6. Otherwise, the node has a local default namespace that matches ns.
                    // Let qualified name be the value of node's localName, let the value of inherited ns be ns,
                    // and append the value of qualified name to markup.
                else {
                    
                    assert(localDefaultNamespace == ns)
                    
                    qualifiedName = element.localName
                    
                    inheritedNS = ns
                    
                    markup += qualifiedName
                }
            }
            
            codePreStack.push(qualifiedName)
            
            // 14. Append to markup the result of the XML serialization of node's attributes
            // given the namespace prefix map map, the generated prefix index prefix index,
            // the flag ignore namespace definition attribute and the value of duplicate prefix definition.
            markup += try! serializeXMLAttributes(element, namespacePrefixMap: &map , generatedNamespacePrefixIndex: &prefixIndex, ignoreNamespaceDefinitionAttribute: ignoreNamespaceDefinitionAttribute, duplicatePrefixDefinition: duplicatePrefixDefinition, requireWellFormed: requireWellFormed)
            
            // 15. If ns is the HTML namespace, and the node's list of children is empty, and the node's localName
            // matches any one of the following void elements: "area", "base", "basefont", "bgsound", "br", "col", "embed",
            // "frame", "hr", "img", "input", "keygen", "link", "menuitem", "meta", "param", "source", "track", "wbr";
            // then append the following to markup, in the order listed:
            if ns == §Namespace.HTML && element.childNodes!.length == 0 {
                
                if element.localName == "area" || element.localName == "base" || element.localName == "basefont" || element.localName == "bgsound" || element.localName == "br" || element.localName == "col" || element.localName == "embed" || element.localName == "frame" || element.localName == "hr" || element.localName == "img" || element.localName == "input" || element.localName == "keygen" || element.localName == "link" || element.localName == "menuitem" || element.localName == "meta" || element.localName == "param" || element.localName == "source" || element.localName == "track" || element.localName == "wbr" {
                    
                    // 1. " " (U+0020 SPACE);
                    markup += " "
                    
                    // 2. "/" (U+002F SOLIDUS).
                    markup += "/"
                    
                    skipEndTag = true
                }
            }
                // 16. If ns is not the HTML namespace, and the node's list of children is empty,
                // then append "/" (U+002F SOLIDUS) to markup and set the skip end tag flag to true.
            else if ns != §Namespace.HTML && element.childNodes!.length == 0 {
                
                markup += "/"
                
                skipEndTag = true
            }
            
            // 17. Append ">" (U+003E GREATER-THAN SIGN) to markup.
            markup += ">"
            
            // 18. If the value of skip end tag is true, then return the value of markup
            // and skip the remaining steps. The node is a leaf-node.
            if skipEndTag {
                
                return markup
            }
            
            // 19. If ns is the HTML namespace, and the node's localName matches the string "template",
            // then this is a template element. Append to markup the result of running the XML serialization algorithm
            // on the template element's template contents (a DocumentFragment), providing the value of inherited ns
            // for the context namespace, map for the namespace prefix map, prefix index for the generated namespace prefix index,
            // and the value of the require well-formed flag.
            if ns == §Namespace.HTML && element.localName == "template" {
                
                let templateElement = element as! HTMLTemplateElement
                
                markup += try! xmlSerialize(templateElement.content, contextNamespace: &inheritedNS, namespacePrefixMap: map, generatedNamespacePrefixIndex: &prefixIndex)!
            }
                // 20. Otherwise, append to markup the result of running the XML serialization algorithm on each of node's children,
                // in tree order, providing the value of inherited ns for the context namespace, map for the namespace prefix map,
                // prefix index for the generated namespace prefix index, and the value of the require well-formed flag.
            else {
                
                if let childNodes = element.childNodes {
                    
                    for child in childNodes {
                        
                        markup += try! xmlSerialize(child, contextNamespace: &inheritedNS, namespacePrefixMap: map, generatedNamespacePrefixIndex: &prefixIndex, requireWellFormed: requireWellFormed)!
                    }
                }
            }
            
            // 21. Append the following to markup, in the order listed:
            
            // 1. "</" (U+003C LESS-THAN SIGN, U+002F SOLIDUS);
            markup += "</"
            
            // 2. The value of qualified name;
            markup += qualifiedName
            
            // 3. ">" (U+003E GREATER-THAN SIGN).
            markup += ">"
            
            return markup
            
        case let document as Document:
            
            // If the require well-formed flag is set (its value is true),
            // and this node has no documentElement (the documentElement attribute's value is null),
            // then throw an exception; the serialization of this node would not be a well-formed document.
            if requireWellFormed {
                
                if document.documentElement == nil {
                    
                    throw DOMException.invalidStateError
                }
            }
            else {
                
                // 1. Let serialized document be an empty string.
                var serializedDocument = ""
                
                // 2. Append to serialized document the string produced by running the steps to
                // produce a DocumentType serialization of node's doctype attribute provided
                // the require well-formed flag if node's doctype attribute is not null.
                serializedDocument += try! serializeDocumenType(document.doctype!, requireWellFormed: requireWellFormed)
                
                // 3. For each child child of node, in tree order, run the XML serialization algorithm
                // on the child given a context namespace namespace, a namespace prefix map prefix map,
                // a reference to a generated namespace prefix index prefix index, flag require well-formed,
                // and append the result to serialized document.
                if let childNodes = document.childNodes {
                    
                    for child in childNodes {
                        
                        serializedDocument += try! xmlSerialize(child, contextNamespace: &namespace, namespacePrefixMap: namespacePrefixMap, generatedNamespacePrefixIndex: &prefixIndex, requireWellFormed: requireWellFormed)!
                    }
                }
                
                return serializedDocument
            }
            
        case let comment as Comment:
            
            // If the require well-formed flag is set (its value is true), and node's data contains characters
            // that are not matched by the XML Char production [XML10] or contains "--" (two adjacent U+002D HYPHEN-MINUS characters)
            // or that ends with a "-" (U+002D HYPHEN-MINUS) character, then throw an exception; the serialization
            // of this node's data would not be well-formed.
            if requireWellFormed {
                
                if !XMLValidator.validateCharProduction(comment.data)
                    || comment.data.contains("--")
                    || comment.data.endsWith("-") {
                    
                    throw DOMException.invalidStateError
                }
            }
            
            return "<!--" + comment.data + "-->"
            
        case let text as Text:
            
            // 1. If the require well-formed flag is set (its value is true), and node's data contains characters
            // that are not matched by the XML Char production [XML10], then throw an exception; the serialization
            // of this node's data would not be well-formed.
            if requireWellFormed {
                
                if !XMLValidator.validateCharProduction(text.data) {
                    
                    throw DOMException.invalidStateError
                }
            }
            
            // 2. Let markup be the value of node's data.
            var markup = text.data
            
            // 3. Replace any occurrences of "&" in markup by "&amp;".
            markup = markup.replacingOccurrences(of: "&", with: "&amp;")
            
            // 4. Replace any occurrences of "<" in markup by "&lt;".
            markup = markup.replacingOccurrences(of: "<", with: "&lt;")
            
            // 5. Replace any occurrences of ">" in markup by "&gt;".
            markup = markup.replacingOccurrences(of: ">", with: "&gt;")
            
            // Stylo
            markup = markup.replacingOccurrences(of: "\"", with: "&quot;")
            
            // 6. Return the value of markup.
            return markup
            
        case let documentFragment as DocumentFragment:
            
            // 1. Let markup the empty string.
            var markup = ""
            
            // 2. For each child child of node, in tree order, run the XML serialization algorithm on the child given
            // a context namespace namespace, a namespace prefix map prefix map, a reference to a generated
            // namespace prefix index prefix index, and flag require well-formed. Concatenate the result to markup.
            if let childNodes = documentFragment.childNodes {
                
                for child in childNodes {
                    
                    markup += try! xmlSerialize(child, contextNamespace: &namespace, namespacePrefixMap: namespacePrefixMap, generatedNamespacePrefixIndex: &prefixIndex, requireWellFormed: requireWellFormed)!
                }
            }
            // 3. Return the value of markup.
            return markup
            
        case let documentType as DocumentType:
            
            // Run the steps to produce a DocumentType serialization of node given the require well-formed flag,
            // and return the string this produced.
            return try! serializeDocumenType(documentType, requireWellFormed: requireWellFormed)
            
        case let processingInstruction as ProcessingInstruction:
            
            // 1. If the require well-formed flag is set (its value is true), and node's target
            // contains a ":" (U+003A COLON) character or is an ASCII case-insensitive match for the string "xml",
            // then throw an exception; the serialization of this node's target would not be well-formed.
            if requireWellFormed {
                
                if processingInstruction.target.contains(":")
                    || processingInstruction.target.lowercased().contains("xml") {
                    
                    throw DOMException.invalidStateError
                }
            }
            
            // 2. If the require well-formed flag is set (its value is true), and node's data contains characters
            // that are not matched by the XML Char production [XML10] or contains the
            // string "?>" (U+003F QUESTION MARK, U+003E GREATER-THAN SIGN), then throw an exception;
            // the serialization of this node's data would not be well-formed.
            if requireWellFormed {
                
                if !XMLValidator.validateCharProduction(processingInstruction.data)
                    || processingInstruction.data.contains("?>") {
                    
                    throw DOMException.invalidStateError
                }
            }
            
            // 3. Let markup be the concatenation of the following, in the order listed:
            
            // 1. "<?" (U+003C LESS-THAN SIGN, U+003F QUESTION MARK);
            var markup = "<?"
            
            // 2. The value of node's target;
            markup += processingInstruction.target
            
            // 3. " " (U+0020 SPACE);
            markup += " "
            
            // 4. The value of node's data;
            markup += processingInstruction.data
            
            // 5. "?>" (U+003F QUESTION MARK, U+003E GREATER-THAN SIGN).
            markup += "?>"
            
            // 4. Return the value of markup.
            return markup
            
        default:
            
            assert(false)
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("unsupported type: %@", log: Log.Web.all, type: .error, %%root)
            #endif
            break
        }
        
        // FIXME: to remove
        return nil
    }
    
    ///
    /// To produce a DocumentType serialization of a Node node, given a require well-formed flag,
    /// the user agent must return the result of the following algorithm:
    ///
    /// https://www.w3.org/TR/DOM-Parsing/#dfn-concept-serialize-doctype
    ///
    func serializeDocumenType(_ node: DocumentType, requireWellFormed: Bool) throws -> String {
        
        // 1. If the require well-formed flag is true and the node's publicId attribute contains characters
        // that are not matched by the XML PubidChar production [XML10], then throw an exception;
        // the serialization of this node would not be a well-formed document type declaration.
        if requireWellFormed {
            
            for unicodeScalar in node.publicId.unicodeScalars {
                
                if !XMLValidator.validatePubidCharProduction(unicodeScalar) {
                    
                    throw DOMException.invalidStateError
                }
            }
        }
        
        // 2. If the require well-formed flag is true and the node's systemId attribute contains characters
        // that are not matched by the XML Char production [XML10] or that contains both a """ (U+0022 QUOTATION MARK)
        // and a "'" (U+0027 APOSTROPHE), then throw an exception; the serialization of this node
        // would not be a well-formed document type declaration.
        if requireWellFormed {
            
            if !XMLValidator.validateCharProduction(node.systemId) {
                
                throw DOMException.invalidStateError
            }
        }
        
        // 3. Let markup be an empty string.
        var markup = ""
        
        // 4. Append the string "<!DOCTYPE" to markup.
        markup += "<!DOCTYPE"
        
        // 5. Append " " (U+0020 SPACE) to markup.
        markup += " "
        
        // 6. Append the value of the node's name attribute to markup. For a node belonging to an HTML document,
        // the value will be all lowercase.
        markup += node.name
        
        // 7. If the node's publicId is not the empty string then append the following,
        // in the order listed, to markup:
        
        // 1. " " (U+0020 SPACE);
        markup += " "
        
        // 2. The string "PUBLIC";
        markup += "PUBLIC"
        
        // 3. " " (U+0020 SPACE);
        markup += " "
        
        // 4. """ (U+0022 QUOTATION MARK);
        markup += "\""
        
        // 5. The value of the node's publicId attribute;
        markup += node.publicId
        
        // 6. """ (U+0022 QUOTATION MARK).
        markup += "\""
        
        // 8. If the node's systemId is not the empty string and the node's publicId is set to the empty string,
        // then append the following, in the order listed, to markup:
        if node.systemId.length != 0 && node.publicId.length == 0 {
            
            // 1. " " (U+0020 SPACE);
            markup += " "
            
            // 2. The string "SYSTEM".
            markup += "SYSTEM"
        }
        
        // 9. If the node's systemId is not the empty string then append the following, in the order listed, to markup:
        if node.systemId.length != 0 {
            
            // 1. " " (U+0020 SPACE);
            markup += " "
            
            // 2. """ (U+0022 QUOTATION MARK);
            markup += "\""
            
            // 3. The value of the node's systemId attribute;
            markup += node.systemId
            
            // 4. """ (U+0022 QUOTATION MARK).
            markup += "\""
        }
        
        // 10. Append ">" (U+003E GREATER-THAN SIGN) to markup.
        markup += ">"
        
        return markup
    }
    
    ///
    /// The XML serialization of the attributes of an Element element together with a namespace prefix map map,
    /// a generated prefix index prefix index reference, a flag ignore namespace definition attribute,
    /// a duplicate prefix definition value, and a flag require well-formed, is the result of the following algorithm:
    ///
    /// https://www.w3.org/TR/DOM-Parsing/#dfn-concept-serialize-xml-attributes
    ///
    func serializeXMLAttributes(_ element: Element, namespacePrefixMap: inout [String: String], generatedNamespacePrefixIndex prefixIndex: inout Int, ignoreNamespaceDefinitionAttribute: Bool, duplicatePrefixDefinition: String?, requireWellFormed: Bool) throws -> String {
        
        // 1. Let result be the empty string.
        var result = ""
        
        // 2. Let localname set be a new empty namespace localname set.
        // This localname set will contain tuples of unique attribute namespaceURI and localName pairs,
        // and is populated as each attr is processed.
        var localnameSet = Set<NamespaceLocalname>()
        
        // 3. For each attribute attr in element's attributes,
        // in the order they are specified in the element's attribute list:
        for attribute in element.attributeList {
            
            let namespaceLocalname = NamespaceLocalname(namespaceURI: attribute.namespaceURI, localname: attribute.localName)
            
            // 1. If the require well-formed flag is set (its value is true),
            // and the localname set contains a tuple whose values match those
            // of a new tuple consisting of attr's namespaceURI attribute and localName attribute,
            // then throw an exception; the serialization of this attr would fail to
            // produce a well-formed element serialization.
            if requireWellFormed {
                
                if localnameSet.contains(namespaceLocalname) {
                    
                    throw DOMException.invalidStateError
                }
            }
            
            // 2. Create a new tuple consisting of attr's namespaceURI attribute and localName attribute,
            // and add it to the localname set.
            localnameSet.insert(namespaceLocalname)
            
            // 3. Let attribute namespace be the value of attr's namespaceURI value.
            let attributeNamespace = attribute.namespaceURI
            
            // 4. Let candidate prefix be null.
            var candidatePrefix: String? = nil
            
            // 5. If attribute namespace is not null, then run these sub-steps:
            if let attributeNamespace = attributeNamespace {
                
                // 1. If the value of attribute namespace is the XMLNS namespace
                // and either the attr's prefix is null and the ignore namespace definition attribute flag is true
                // or the attr's prefix is not null and the attr's localName matches the value of duplicate prefix definition,
                // then stop running these steps and goto Main to visit the next attribute.
                if attributeNamespace == §Namespace.XMLNS {
                    
                    if (attribute.prefix == nil && ignoreNamespaceDefinitionAttribute) || (attribute.prefix != nil && attribute.localName == duplicatePrefixDefinition) {
                        
                        continue
                    }
                }
                    // 2. Otherwise, if there exists a key in map that matches the value of attribute namespace,
                    // then let candidate prefix be that key's value from the map.
                else if namespacePrefixMap[attributeNamespace] != nil {
                    
                    candidatePrefix = namespacePrefixMap[attributeNamespace]
                }
                    // 3. Otherwise, there is no key matching attribute namespace in map and the attribute namespace is not the XMLNS namespace.
                    // Run these steps:
                else {
                    
                    // 1. Let candidate prefix be the result of generating a prefix providing map,
                    // attribute namespace, and prefix index as input.
                    candidatePrefix = generatePrefix(&namespacePrefixMap, newNamespace: attributeNamespace, generatedNamespacePrefixIndex: &prefixIndex)
                    
                    // 2. Append the following to result, in the order listed:
                    
                    // 1. " " (U+0020 SPACE);
                    result += " "
                    
                    // 2. The string "xmlns:";
                    result += "xmlns:"
                    
                    // 3. The value of candidate prefix;
                    result += candidatePrefix!
                    
                    // 4. "="" (U+003D EQUALS SIGN, U+0022 QUOTATION MARK);
                    result += "=\""
                    
                    // 5. The result of serializing an attribute value given attribute namespace
                    // and the require well-formed flag as input;
                    result += try! serializeAttributeValue(attributeNamespace, requireWellFormed: requireWellFormed)
                    
                    // 6. """ (U+0022 QUOTATION MARK).
                    result += "\""
                }
            }
            
            // 6. Append a " " (U+0020 SPACE) to result.
            result += " "
            
            // 7. If candidate prefix is not null, then append to result
            // the concatenation of candidate prefix with ":" (U+003A COLON).
            if let candidatePrefix = candidatePrefix {
                
                result += "\(candidatePrefix):"
            }
            
            // 8. If the require well-formed flag is set (its value is true), and this attr's localName attribute
            // contains the character ":" (U+003A COLON) or does not match the XML Name production [XML10]
            // or equals "xmlns" and attribute namespace is null, then throw an exception; the serialization
            // of this attr would not be a well-formed attribute.
            if requireWellFormed {
                
                if attribute.localName.contains(":")
                    || !XMLValidator.validateNameProduction(attribute.localName)
                    || attribute.localName == "xmlns" && attributeNamespace == nil {
                    
                    throw DOMException.invalidStateError
                }
            }
            
            // 9. Append the following strings to result, in the order listed:
            
            // 1. The value of attr's localName;
            result += attribute.localName
            
            // 2. "="" (U+003D EQUALS SIGN, U+0022 QUOTATION MARK);
            result += "=\""
            
            // 3. The result of serializing an attribute value given attr's value attribute and the require well-formed flag as input;
            result += try! serializeAttributeValue(attribute.nodeValue, requireWellFormed: requireWellFormed)
            
            // 4. """ (U+0022 QUOTATION MARK).
            result += "\""
        }
        
        // 4. Return the value of result.
        return result
    }
    
    
    ///
    /// To serialize an attribute value given an attribute value and require well-formed flag,
    /// the user agent must run the following steps:
    ///
    /// https://www.w3.org/TR/DOM-Parsing/#dfn-concept-serialize-attr-value
    ///
    func serializeAttributeValue(_ attributeValue: String?, requireWellFormed: Bool) throws -> String {
        
        // 1. If the require well-formed flag is set (its value is true), and attribute value contains characters
        // that are not matched by the XML Char production [XML10], then throw an exception; the serialization
        // of this attribute value would fail to produce a well-formed element serialization.
        if requireWellFormed {
            
            if !XMLValidator.validateCharProduction(attributeValue) {
                
                throw DOMException.invalidStateError
            }
        }
        
        var localAttributeValue = attributeValue
        
        // 2. If attribute value is null, then return the empty string.
        if attributeValue == nil {
            
            localAttributeValue = ""
        }
            // 3. Otherwise, attribute value is a string. Return the value of attribute value,
            // first replacing any occurrences of the following:
        else if let attributeValue = attributeValue {
            
            // 2. "&" with "&amp;"
            localAttributeValue = localAttributeValue!.replacingOccurrences(of: "&", with: "&amp;")
        
            // 1. """ with "&quot;"
            localAttributeValue = attributeValue.replacingOccurrences(of: "\"", with: "&quot;")
            
            // 3. "<" with "&lt;"
            localAttributeValue = localAttributeValue!.replacingOccurrences(of: "<", with: "&lt;")
            
            // 4. ">" with "&gt;"
            localAttributeValue = localAttributeValue!.replacingOccurrences(of: ">", with: "&gt;")
        }
        
        return localAttributeValue!
    }
    
    ///
    /// https://www.w3.org/TR/DOM-Parsing/#dfn-concept-generate-prefix
    ///
    func generatePrefix(_ namespacePrefixMap: inout [String: String], newNamespace: String, generatedNamespacePrefixIndex prefixIndex: inout Int) -> String {
        
        // 1. Let generated prefix be the concatenation of the string "ns" and the current numerical value of prefix index.
        let generatedPrefix = "ns\(prefixIndex)"
        
        // 2. Let the value of prefix index be incremented by one.
        prefixIndex += 1
        
        // 3. Append to map a new key new namespace whose key value is the generated prefix.
        namespacePrefixMap[newNamespace] = generatedPrefix
        
        // 4. Return the value of generated prefix.
        return generatedPrefix
    }
    
    ///
    /// https://www.w3.org/TR/DOM-Parsing/#dfn-concept-record-namespace-info
    ///
    func recordNamespaceInformation(_ element: Element, namespacePrefixMap: inout [String: String], elementPrefixesList: inout [String], duplicatePrefixDefinition: inout String?) -> String? {
        
        // 1. Let default namespace attr value be null.
        var defaultNamespaceAttrValue: String? = nil
        
        // 2. Main: For each attribute attr in element's attributes, in the order
        // they are specified in the element's attribute list:
        for attribute in element.attributeList {
            
            // 1. Let attribute namespace be the value of attr's namespaceURI value.
            let attributeNamespace = attribute.namespaceURI
            
            // 2. Let attribute prefix be the value of attr's prefix.
            let attributePrefix = attribute.prefix
            
            // 3. If the attribute namespace is the XMLNS namespace, then:
            if attributeNamespace == §Namespace.XMLNS {
                
                // 1. If attribute prefix is null, then attr is a default namespace declaration.
                // Set the default namespace attr value to attr's value and stop running these steps,
                // returning to Main to visit the next attribute.
                if attributePrefix == nil {
                    
                    defaultNamespaceAttrValue = attribute.value
                }
                    // 2. Otherwise, the attribute prefix is not null and attr is a namespace prefix definition.
                    // Run the following steps:
                else {
                    
                    // 1. Let prefix definition be the value of attr's localName.
                    let prefixDefinition = attribute.localName
                    
                    // 2. Let namespace definition be the value of attr's value.
                    let namespaceDefinition = attribute.value
                    
                    // 3. If a key matching the value of namespace definition already exists in map,
                    // and the key's value matches prefix definition, then this is a duplicate namespace prefix definition.
                    // Set the value of duplicate prefix definition to prefix definition.
                    if namespacePrefixMap[namespaceDefinition] != nil && namespacePrefixMap[namespaceDefinition] == prefixDefinition {
                        
                        duplicatePrefixDefinition = prefixDefinition
                    }
                        // 4. Otherwise, if the key matching the value of namespace definition already exists in map,
                        // but the key's value does not match prefix definition, then update the key's value to be prefix definition.
                    else if namespacePrefixMap[namespaceDefinition] != nil && namespacePrefixMap[namespaceDefinition] != prefixDefinition {
                        
                        namespacePrefixMap[namespaceDefinition] = prefixDefinition
                    }
                        // 5. Otherwise, no key matching the value of namespace definition exists;
                        // append to map a new key namespace definition whose key value is the prefix definition.
                    else {
                        
                        namespacePrefixMap[namespaceDefinition] = namespaceDefinition
                    }
                    
                    // 6. Append the value of prefix definition to element prefixes list.
                    elementPrefixesList.append(prefixDefinition)
                }
            }
        }
        
        // 3. Return the value of default namespace attr value.
        return defaultNamespaceAttrValue
    }
    
}

