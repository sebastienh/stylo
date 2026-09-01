//
//  MarkdownSource.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2016-08-22.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation
import Common

protocol MarkdownSource: CoreString, HtmlString {
    
    /// js re: /^(?:=+|-+) *$/
    func matchSetexHeaderLine(fromPosition position: Int, options: AnyObject...) -> [Match]?
    
    /// "^&(?:
    /// unicode entity: #x[a-f0-9]{1,8}|
    /// number entity:  #[0-9]{1,8}|
    /// named entity:   [a-z][a-z0-9]{1,31});"
    func matchHtmlEntity(fromPosition position: Int) -> [Match]?
    
    // js re: ATTRIBUTENAME = '[a-zA-Z_:][a-zA-Z0-9:._-]*';
    func matchHtmlAttributeName(fromPosition position: Int) -> [Match]?
    
    // HTMLCOMMENT = "<!---->|<!--(?:-?[^>-])(?:-?[^-])*-->";
    func matchHtmlComment(fromPosition position: Int) -> [Match]?
    
    /// js re UNQUOTEDVALUE = "[^\"'=<>`\\x00-\\x20]+";
    func matchHtmlUnquoted(fromPosition position: Int) -> [Match]?
    
    // SINGLEQUOTEDVALUE = "'[^']*'";
    func matchHtmlSingleQuoted(fromPosition position: Int) -> [Match]?
    
    // DOUBLEQUOTEDVALUE = '"[^"]*"';
    func matchHtmlDoubleQuoted(fromPosition position: Int) -> [Match]?
    
    // ATTRIBUTEVALUE = "(?:" + UNQUOTEDVALUE + "|" + SINGLEQUOTEDVALUE + "|" + DOUBLEQUOTEDVALUE + ")";
    func matchHtmlAttributeValue(fromPosition position: Int) -> [Match]?
    
    // = '(?:\\s+' + attr_name + '(?:\\s*=\\s*' + attr_value + ')?)';
    // ATTRIBUTE = "(?:" + "\\s+" + ATTRIBUTENAME + ATTRIBUTEVALUESPEC + "?)";
    func matchHtmlAttribute(fromPosition position: Int) -> [Match]?
    
    // (OPENTAG | CLOSETAG) + '\\s*$'
    func matchOpenOrCloseTag(fromPosition position: Int) -> [Match]?
    
    // js re: TAGNAME = '[A-Za-z][A-Za-z0-9-]*'
    func matchHtmlTagName(fromPosition position: Int) -> [Match]?
    
    // ATTRIBUTEVALUESPEC = "(?:" + "\\s*=" + "\\s*" + ATTRIBUTEVALUE + ")";
    func matchHtmlAttributeValueSpec(fromPosition position: Int) -> [Match]?
    
    func matchHtmlElement(fromPosition position: Int) -> [Match]?
    
    func matchHtmlTag(_ tag: HtmlElement, fromPosition position: Int) -> HtmlElement?
    
    // PROCESSINGINSTRUCTION = "[<][?].*?[?][>]";
    func matchHtmlProcessingInstruction(fromPosition position: Int) -> [Match]?
    
    /// DECLARATION = "<![A-Z]+" + "\\s+[^>]*>";
    ///
    /// Prelude: <!
    /// Identifier: [A-Z]+
    /// Whitespaces: \\s+
    /// Conclusion: [^>]*>
    func matchHtmlDeclaration(fromPosition position: Int) -> [Match]?
    
    /// CDATA = "<!\\[CDATA\\[[\\s\\S]*?\\]\\]>";
    func matchHtmlCDATA(fromPosition position: Int) -> [Match]?
    
    func matchHtmlBlock(fromPosition position: Int) -> [Match]?
    
    /// js re: ^<\/?(block1|block2...)(?=(\s|\/?>|$))
    func matchOpenCloseHtmlBlock(fromPosition position: Int) -> [Match]?
    
    func matchEmpty() -> [Match]?
    
    //var HTMLTAG = "(?:" + OPENTAG + "|" + CLOSETAG + "|" + HTMLCOMMENT + "|" +
    //    PROCESSINGINSTRUCTION + "|" + DECLARATION + "|" + CDATA + ")";
    func matchHtmlOpenOrCloseTag(fromPosition position: Int) -> [Match]?
    
    /// /^<(script|pre|style)(?=(\s|>|$))/i
    func matchScriptPreStyleOpen(fromPosition position: Int) -> [Match]?
    
    /// "<\\/(script|pre|style)>/i"
    func matchScriptPreStyleClose() -> [Match]?
    
    /// js re: /^<!--/
    func matchHtmlCommentOpen(fromPosition position: Int) -> [Match]?
    
    /// js re: /-->/
    func matchHtmlCommentClose() -> [Match]?
    
    /// js re: /^<\?/
    func matchProcessingInstructionOpen(fromPosition position: Int) -> [Match]?
    
    /// js re: /\?>/
    func matchProcessingInstructionClose() -> [Match]?
    
    /// js re: /^<![A-Z]/
    func matchHtmlDocTypeOpen(fromPosition position: Int) -> [Match]?
    
    /// js re: />/
    func matchHtmlDocTypeClose() -> [Match]?
    
    /// js re: /^<!\[CDATA\[/
    func matchHtmlCDATAOpen(fromPosition position: Int) -> [Match]?
    
    /// js re: /\]\]>/
    func matchHtmlCDATAClose() -> [Match]?
    
    /// Try to match email autolink including first <, returning num of chars matched.
    ///
    /// js re:
    /// 1. /^<([a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+
    /// 2. @
    /// 3. [a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*)>
    //
    /// Note: The emailString include the start and end less and greater than signs.
    func matchEmailAutolink(fromPosition position: Int) -> [Match]?
    
    // /^:?-+:?$/
    func matchTableRowSeparator(fromPosition position: Int) -> [Match]?
}

extension String: MarkdownSource {
    
}



