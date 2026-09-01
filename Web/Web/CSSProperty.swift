//
//  File.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-16.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common

// Eventually all ePub elements should be supported
// see : http://www.idpf.org/accessibility/guidelines/content/style/reference.php#css025-css21

// Those elements are defined to conform to the spec :
// http://dev.w3.org/csswg/cssom/#supported-css-property
public enum CSSProperty : String {
    
//    case Background = "background"
//    case BackgroundAttachment = "background-attachment"
    
//    case BackgroundImage = "background-image"
//    case BackgroundPosition = "background-position"
//    case BackgroundRepeat = "background-repeat"
//    case Border = "border"
//    case BorderTop = "border-top"
//    case BorderRight = "border-right"
//    case BorderBottom = "border-bottom"
//    case BorderLeft = "border-left"
//    case BorderCollapse = "border-collapse"
//    case BorderColor = "border-color"
//    case BorderTopColor = "border-top-color"
//    case BorderRightColor = "border-right-color"
//    case BorderBottomColor = "border-bottom-color"
//    case BorderLeftColor = "border-left-color"
//    case BorderSpacing = "border-spacing"
//    case BorderStyle = "border-style"
//    case BorderTopStyle = "border-top-style"
//    case BorderRightStyle = "border-right-style"
//    case BorderBottomStyle = "border-bottom-style"
//    case BorderLeftStyle = "border-left-style"
//    case BorderWidth = "border-width"
//    case BorderTopWidth = "border-top-width"
//    case BorderRightWidth = "border-right-width"
//    case BorderBottomWidth = "border-bottom-width"
//    case BorderLeftWidth = "border-left-width"
//    case Bottom = "bottom"
//    case Left = "left"
//    case Right = "right"
//    case Top = "top"
//    case CaptionSide = "caption-side"
//    case Clear = "clear"
//    case Clip = "clip"

//    case Content = "content"
//    case CounterIncrement = "counter-increment"
//    case CounterReset = "counter-reset"
//    case Cursor = "cursor"
//    case Direction = "direction"
//    case Display = "display"
//    case EmptyCells = "empty-cells"
//    case Float = "float"
    
    
    
    /// Color Module
    case caretColor = "caret-color"
    case color = "color"
    case backgroundColor = "background-color"
    
    
    
    /// Font Module
    /// see http://www.w3.org/TR/css3-fonts/
//    case Font = "font"
    case fontFamily = "font-family"
    case fontSize = "font-size"
    case fontStyle = "font-style"
//    case FontStretch = "font-stretch"
//    case FontVariant = "font-variant"
    case fontWeight = "font-weight"
    
    
    
//    case Height = "height"
//    case LetterSpacing = "letter-spacing"
//    case LineHeight = "line-height"
//    case ListStyle = "list-style"
//    case ListStyleImage = "list-style-image"
//    case ListStylePosition = "list-style-position"
//    case ListStyleType = "list-style-type"
//    case Margin = "margin"
//    case MarginTop = "margin-top"
//    case MarginRight = "margin-right"
//    case MarginBottom = "margin-bottom"
//    case MarginLeft = "margin-left"
//    case MaxHeight = "max-height"
//    case MaxWidth = "max-width"
//    case MinHeight = "min-height"
//    case MinWidth = "min-width"
//    case Orphans = "orphans"
//    case Widows = "widows"
//    case Outline = "outline"
//    case OutlineColor = "outline-color"
//    case OutlineStyle = "outline-style"
//    case OutlineWidth = "outline-width"
//    case Overflow = "overflow"
//    case Padding = "padding"
//    case PaddingTop = "padding-top"
//    case PaddingRight = "padding-right"
//    case PaddingBottom = "padding-bottom"
//    case PaddingLeft = "padding-left"
//    case PageBreakAfter = "page-break-after"
//    case PageBreakBefore = "page-break-before"
//    case PageBreakInside = "page-break-inside"
//    case Position = "position"
//    case Quotes = "quotes"
//    case TableLayout = "table-layout"
    
    
    
    
    /// Text Decoration Module
//    case TextDecoration = "text-decoration"
    case textDecorationLine = "text-decoration-line"
    case textDecorationColor = "text-decoration-color"
    case textDecorationStyle = "text-decoration-style"
    
    /// Text Module
//    case TextIndent = "text-indent"
//    case TextTransform = "text-transform"
//    case TextAlign = "text-align"
    
    
    
    
//    case UnicodeBidi = "unicode-bidi"
//    case VerticalAlign = "vertical-align"
//    case Visibility = "visibility"
//    case WhiteSpace = "white-space"
//    case Width = "width"
//    case WordSpacing = "word-spacing"
//    case ZIndex = "z-index"
//    case Azimuth = "azimuth"
//    case Cue = "cue"
//    case CueAfter = "cue-after"
//    case CueBefore = "cue-before"
//    case Elevation = "elevation"
//    case Pause = "pause"
//    case PauseAfter = "pause-after"
//    case PauseBefore = "pause-before"
//    case Pitch = "pitch"
//    case PitchRange = "pitch-range"
//    case PlayDuring = "play-during"
//    case Richness = "richness"
//    case Speak = "speak"
//    case SpeakHeader = "speak-header"
//    case SpeakNumeral = "speak-numeral"
//    case SpeakPunctuation = "speak-punctuation"
//    case SpeechRate = "speech-rate"
//    case Stress = "stress"
//    case VoiceFamily = "voice-family"
//    case Volume = "volume"
//    
//    // CSS Speech Module
//    case EpubCue = "-epub-cue" // (cue)
//    case EpubPause = "-epub-pause" // (pause)
//    case EpubRest = "-epub-rest" // (rest)
//    case EpubSpeak = "-epub-speak" // (speak)
//    case EpubSpeakAs = "-epub-speak-as" // (speak-as)
//    case EpubVoiceFamily = "-epub-voice-family" // (voice-family)
//    
//    // CSS Text Level 3
//    case EpubHyphens = "-epub-hyphens" // (hyphens)
//    case EpubLineBreak = "-epub-line-break" // (line-break)
//    case EpubTextAlignLast = "-epub-text-align-last" // (text-align-last)
//    case EpubTextEmphasis = "-epub-text-emphasis" // (text-emphasis)
//    case EpubTextEmphasisColor = "-epub-text-emphasis-color" // (text-emphasis-color)
//    case EpubTextEmphasisStyle = "-epub-text-emphasis-style" // (text-emphasis-style)
//    case EpubWordBreak = "-epub-word-break" // (word-break)
//    
//    // CSS Writing Modes Module Level 3
//    case EpubTextCombineHorizontal = "-epub-text-combine-horizontal" // (text-combine-horizontal)
//    case EpubTextCombineMode = "-epub-text-combine-mode" // (text-combine-mode)
//    case EpubTextOrientation = "-epub-text-orientation" // (text-orientation)
//    case EpubWritingMode = "-epub-writing-mode" // (writing-mode)
//    
//    // CSS Multi-column Layout Module
//    case BreakAfter = "break-after"
//    case BreakBefore = "break-before"
//    case BreakInside = "break-inside"
//    case ColumnCount = "column-count"
//    case ColumnFill = "column-fill"
//    case ColumnGap = "column-gap"
//    case ColumnRule = "column-rule"
//    case ColumnRuleColor = "column-rule-color"
//    case ColumnRuleStyle = "column-rule-style"
//    case ColumnRuleWidth = "column-rule-width"
//    case ColumnSpan = "column-span"
//    case ColumnWidth = "column-width"
//    case Columns = "columns"
    
    
    static func convertToCSSProperty(_ string: DOMString) -> CSSProperty? {
        
        if let cssProperty = CSSProperty(rawValue: string) {
            return cssProperty;
        }
        return nil;
    }
    
    static func isSupportedCSSProperty(_ string: DOMString) -> Bool {
        
        if let _ = CSSProperty(rawValue: string) {
            return true;
        }
        return false;
    }
    
    static func isCustomProperty(_ string: DOMString) -> Bool {
        
        if string.starts(with: "--") {
            return true
        }
        return false
    }
    
}
