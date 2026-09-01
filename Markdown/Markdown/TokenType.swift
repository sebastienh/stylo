//
//  TokenType.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-22.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation

public enum TokenType: String {
    
    case inline
    case span = "span"
    case classNameAttr = "class-name-attr"
    case classAttr = "class-attr"
    case idAttr = "id-attr"
    case keyValueAttr = "key-value-attr"
    case elementNameAttr
    case attrBlocOpen = "attr-bloc-open"
    case attrBlocClose = "attr-bloc-close"
    case attrClassesOpen
    case attrClassesClose
    case paragraphOpen = "paragraph_open"
    case paragraphClose = "paragraph_close"
    case text
    case blockquoteOpen = "blockquote_open"
    case blockquoteClose = "blockquote_close"
    case containerOpen = "container_open"
    case containerClose = "container_close"
    case softbreak
    case hardbreak
    case headingOpen = "heading_open"
    case headingClose = "heading_close"
    case codeBlock = "code_block"
    case fence
    case htmlInline = "html_inline"
    case hr
    case htmlBlock = "html_block"
    case orderedListOpen = "ordered_list_open"
    case orderedListClose = "ordered_list_close"
    case bulletListOpen = "bullet_list_open"
    case bulletListClose = "bullet_list_close"
    case listItemOpen = "list_item_open"
    case listItemClose = "list_item_close"
    case reference
    case codeInline = "code_inline"
    case linkOpen = "link_open"
    case linkClose = "link_close"
    case entity
    case strongOpen = "strong_open"
    case emOpen  = "em_open"
    case strongClose = "strong_close"
    case emClose = "em_close"
    case image
    case strikethroughOpen = "s_open"
    case strikethroughClose = "s_close"
    case tableOpen = "table_open"
    case tableClose = "table_close"
    case theadOpen = "thead_open"
    case theadClose = "thead_close"
    case trOpen = "tr_open"
    case trClose = "tr_close"
    case thOpen = "th_open"
    case thClose = "th_close"
    case tdOpen = "td_open"
    case tdClose = "td_close"
    case tBodyOpen = "tbody_open"
    case tBodyClose = "tbody_close"
    
    var isAttributesBlocStartToken: Bool {
        
        switch self {
        case .attrBlocOpen: fallthrough
        case .attrClassesOpen:
            return true
        default:
            return false
        }
    }
    
    var isAttributesBlocCloseToken: Bool {
        
        switch self {
        case .attrBlocClose: fallthrough
        case .attrClassesClose:
            return true
        default:
            return false
        }
    }
    
    var acceptInlineAttributes: Bool {
        
        switch self {
            
        case .span:
            return true
        case .paragraphOpen:
            return false
        case .paragraphClose:
            return false
        case .text:
            return false
        case .blockquoteOpen:
            return false
        case .blockquoteClose:
            return false
        case .softbreak:
            return false
        case .hardbreak:
            return false
        case .headingOpen:
            return false
        case .headingClose:
            return false
        case .codeBlock:
            return false
        case .fence:
            return false
        case .htmlInline:
            return true
        case .hr:
            return false
        case .htmlBlock:
            return false
        case .orderedListOpen:
            return false
        case .orderedListClose:
            return false
        case .bulletListOpen:
            return false
        case .bulletListClose:
            return false
        case .listItemOpen:
            return false
        case .listItemClose:
            return false
        case .reference:
            return false
        case .codeInline:
            return true
        case .linkOpen:
            return true
        case .linkClose:
            return false
        case .entity:
            return false
        case .strongOpen:
            return true
        case .emOpen:
            return true
        case .strongClose:
            return false
        case .emClose:
            return false
        case .image:
            return true
        case .strikethroughOpen:
            return true
        case .strikethroughClose:
            return false
        case .tableOpen:
            return false
        case .tableClose:
            return false
        case .theadOpen:
            return false
        case .theadClose:
            return false
        case .trOpen:
            return false
        case .trClose:
            return false
        case .thOpen:
            return false
        case .thClose:
            return false
        case .tdOpen:
            return false
        case .tdClose:
            return false
        case .tBodyOpen:
            return false
        case .tBodyClose:
            return false
        case .inline:
            return false
        case .containerOpen:
            return false
        case .containerClose:
            return false
        case .attrClassesOpen:
            return false
        case .attrClassesClose:
            return false
        case .attrBlocOpen:
            return false
        case .attrBlocClose:
            return false
        case .classNameAttr:
            return false
        case .classAttr:
            return false
        case .idAttr:
            return false
        case .keyValueAttr:
            return false
        case .elementNameAttr:
            return false
        }
        
    }
    
    var acceptAttributes: Bool {
        
        switch self {
        case .span:
            return true
        case .paragraphOpen:
            return false
        case .paragraphClose:
            return true
        case .text:
            return false
        case .blockquoteOpen:
            return false
        case .blockquoteClose:
            return true
        case .softbreak:
            return false
        case .hardbreak:
            return false
        case .headingOpen:
            return false
        case .headingClose:
            return true
        case .codeBlock:
            return true
        case .fence:
            return true
        case .htmlInline:
            return true
        case .hr:
            return true
        case .htmlBlock:
            return true
        case .orderedListOpen:
            return false
        case .orderedListClose:
            return true
        case .bulletListOpen:
            return false
        case .bulletListClose:
            return true
        case .listItemOpen:
            return false
        case .listItemClose:
            return true
        case .reference:
            return true
        case .codeInline:
            return true
        case .linkOpen:
            return false
        case .linkClose:
            return true
        case .entity:
            return false
        case .strongOpen:
            return false
        case .emOpen:
            return false
        case .strongClose:
            return true
        case .emClose:
            return true
        case .image:
            return true
        case .strikethroughOpen:
            return false
        case .strikethroughClose:
            return true
        case .tableOpen:
            return false
        case .tableClose:
            return true
        case .theadOpen:
            return false
        case .theadClose:
            return true
        case .trOpen:
            return false
        case .trClose:
            return true
        case .thOpen:
            return false
        case .thClose:
            return true
        case .tdOpen:
            return false
        case .tdClose:
            return true
        case .tBodyOpen:
            return false
        case .tBodyClose:
            return true
        case .inline:
            return false
        case .containerOpen:
            return false
        case .containerClose:
            return true
        case .attrClassesOpen:
            return false
        case .attrClassesClose:
            return false
        case .attrBlocOpen:
            return false
        case .attrBlocClose:
            return false
        case .classNameAttr:
            return false
        case .classAttr:
            return false
        case .idAttr:
            return false
        case .keyValueAttr:
            return false
        case .elementNameAttr:
            return false
        }
    }
    
    var correspondindOpeningType: TokenType? {
    
        switch self {
            
        case .span:
            return .span
        case .paragraphClose:
            return .paragraphOpen
        case .paragraphOpen:
            return nil
        case .text:
            return .text
        case .blockquoteClose:
            return .blockquoteOpen
        case .blockquoteOpen:
            return nil
        case .softbreak:
            return nil
        case .hardbreak:
            return nil
        case .headingClose:
            return .headingOpen
        case .headingOpen:
            return nil
        case .codeBlock:
            return .codeBlock
        case .fence:
            return .fence
        case .htmlInline:
            return .htmlInline
        case .hr:
            return .hr
        case .htmlBlock:
            return .htmlBlock
        case .orderedListClose:
            return .orderedListOpen
        case .orderedListOpen:
            return nil
        case .bulletListClose:
            return .bulletListOpen
        case .bulletListOpen:
            return nil
        case .listItemClose:
            return .listItemOpen
        case .listItemOpen:
            return nil
        case .reference:
            return .reference
        case .codeInline:
            return .codeInline
        case .linkClose:
            return .linkOpen
        case .linkOpen:
            return nil
        case .entity:
            return .entity
        case .strongClose:
            return .strongOpen
        case .emClose:
            return .emOpen
        case .strongOpen:
            return nil
        case .emOpen:
            return nil
        case .image:
            return .image
        case .strikethroughClose:
            return .strikethroughOpen
        case .strikethroughOpen:
            return nil
        case .tableClose:
            return .tableOpen
        case .tableOpen:
            return nil
        case .theadClose:
            return .theadOpen
        case .theadOpen:
            return nil
        case .trClose:
            return .trOpen
        case .trOpen:
            return nil
        case .thClose:
            return .thOpen
        case .thOpen:
            return nil
        case .tdClose:
            return .tdOpen
        case .tdOpen:
            return nil
        case .tBodyClose:
            return .tBodyOpen
        case .tBodyOpen:
            return nil
        case .inline:
            return .inline
        case .containerClose:
            return .containerOpen
        case .containerOpen:
            return nil
        case .attrClassesClose:
            return .attrClassesOpen
        case .attrClassesOpen:
            return nil
        case .attrBlocClose:
            return .attrBlocOpen
        case .attrBlocOpen:
            return nil
        case .classNameAttr:
            return .classNameAttr
        case .classAttr:
            return .classAttr
        case .idAttr:
            return .idAttr
        case .keyValueAttr:
            return .keyValueAttr
        case .elementNameAttr:
            return .elementNameAttr
        }
    }
        
    var correspondindClosingType: TokenType? {
        
        switch self {
            
        case .span:
            return nil
        case .paragraphOpen:
            return .paragraphClose
        case .paragraphClose:
            return nil
        case .text:
            return nil
        case .blockquoteOpen:
            return .blockquoteClose
        case .blockquoteClose:
            return nil
        case .softbreak:
            return nil
        case .hardbreak:
            return nil
        case .headingOpen:
            return .headingClose
        case .headingClose:
            return nil
        case .codeBlock:
            return nil
        case .fence:
            return nil
        case .htmlInline:
            return nil
        case .hr:
            return nil
        case .htmlBlock:
            return nil
        case .orderedListOpen:
            return .orderedListClose
        case .orderedListClose:
            return nil
        case .bulletListOpen:
            return .bulletListClose
        case .bulletListClose:
            return nil
        case .listItemOpen:
            return .listItemClose
        case .listItemClose:
            return nil
        case .reference:
            return nil
        case .codeInline:
            return nil
        case .linkOpen:
            return .linkClose
        case .linkClose:
            return nil
        case .entity:
            return nil
        case .strongOpen:
            return .strongClose
        case .emOpen:
            return .emClose
        case .strongClose:
            return nil
        case .emClose:
            return nil
        case .image:
            return nil
        case .strikethroughOpen:
            return .strikethroughClose
        case .strikethroughClose:
            return nil
        case .tableOpen:
            return .tableClose
        case .tableClose:
            return nil
        case .theadOpen:
            return .theadClose
        case .theadClose:
            return nil
        case .trOpen:
            return .trClose
        case .trClose:
            return nil
        case .thOpen:
            return .thClose
        case .thClose:
            return nil
        case .tdOpen:
            return .tdClose
        case .tdClose:
            return nil
        case .tBodyOpen:
            return .tBodyClose
        case .tBodyClose:
            return nil
        case .inline:
            return nil
        case .containerOpen:
            return .containerClose
        case .containerClose:
            return nil
        case .attrClassesOpen:
            return .attrClassesClose
        case .attrClassesClose:
            return nil
        case .attrBlocOpen:
            return .attrBlocClose
        case .attrBlocClose:
            return nil
        case .classNameAttr: fallthrough
        case .classAttr: fallthrough
        case .idAttr: fallthrough
        case .keyValueAttr: fallthrough
        case .elementNameAttr:
            return nil
        }
    }
    
}








