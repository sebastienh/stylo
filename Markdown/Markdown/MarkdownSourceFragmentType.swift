//
//  MarkdownSourceFragmentType.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-29.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

public enum MarkdownSourceFragmentType: String, Hashable {
    
    case All = "all"
    case Content = "content"
    case Tag = "tag"
//    case OpeningTag = "opening-tag"
//    case ClosingTag = "closing-tag"
    case Params = "params"
    case Label = "label"
    case Destination = "destination"
    case Text = "text"
    case Title = "title"
    case NotText = "not-text"
    case AttributeValue = "attr-value"
    case ElementName = "element-name"
    case AttributeName = "attr-name"
    case AttributeIndicator = "attr-indicator"
}
