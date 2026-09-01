//
//  CSSCompletionsTstDictionaryFactory.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2016-02-12.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation
import Common
import Web
import Common
import Markdown

public final class CSSCompletionsTstDictionaryFactory: CompletionsTstDictionaryFactory {
    
    private static var dictionaryInstance: TstDictionary<CompletionValue>?
    
    @discardableResult
    public static func GetCssTstDictionary() -> TstDictionary<CompletionValue> {
        
        if let dictionaryInstance = dictionaryInstance {
            
            return dictionaryInstance
        }
        
        let tstDictionary = TstDictionary<CompletionValue>()
        
        // temporarly we will just create a dictionary with strings,
        // a the value will the definition of the string key, an explanation
        // (localized) of the key and in which context it can be used.
    
        tstDictionary.addColorCompletions()
        
        tstDictionary.addBackgroundColorCompletions()
        
        tstDictionary.addColorKeywordsValuesCompletions()
        
        tstDictionary.addFontFamilyCompletions()

        tstDictionary.addFontStyleCompletions()
        
        tstDictionary.addFontSizeCompletions()
        
        tstDictionary.addTextDecorationColorCompletions()
        
        tstDictionary.addTextDecorationLineCompletions()
        
        tstDictionary.addTextDecorationStyleCompletions()

        tstDictionary.addFontWeightCompletions()
        
        tstDictionary.addHtmlCompletions()
        
        tstDictionary.addMarkdownCompletions()
        
        
        // Test additions....
//        try! add("otherLanguage",  value: CompletionValue(desc: NSLocalizedString("otherLanguage", comment: "HTML \"ul\" element description for otherLanguage."), value: "otherLanguage", language: Language.Stella))
        
        //        try! tstDictionary.add("Something really long to test the width", value: CompletionValue(desc: NSLocalizedString("Message for something really long that is really really really really really really long too, really long.", comment: "CSS \"font-size\" property description for autocompletion."), value: §CSSProperty.Color))
        
        dictionaryInstance = tstDictionary
        
        return tstDictionary
    }
}

extension TstDictionary where T == CompletionValue {
    
    func addColorCompletions() {
        
        try! add(§CSSProperty.color, value:
            CompletionValue(
                    desc: NSLocalizedString("\"color\" CSS property.",
                    comment: "CSS \"color\" property description for autocompletion."),
                    completionValue: §CSSProperty.color + ":",
                    completionDisplay: §CSSProperty.color,
                    language: Language.CSS,
                    type: AutocompletionType.cssProperty(name: AutocompletionTypeName.CSS.CssColorProperty)))
    }
    
    func addBackgroundColorCompletions() {
        
        try! add(§CSSProperty.backgroundColor, value:
            CompletionValue(
                desc: NSLocalizedString("\"background-color\" CSS property.",
                comment: "CSS \"background-color\" property description for autocompletion."),
                completionValue: §CSSProperty.backgroundColor + ":",
                completionDisplay: §CSSProperty.backgroundColor,
                language: Language.CSS,
                type: AutocompletionType.cssProperty(name: AutocompletionTypeName.CSS.CssGenericProperty)
            )
        )
    }
    
    func addColorKeywordsValuesCompletions() {
        
        for colorKeyword in ColorKeyword.values {
        
            try! add(colorKeyword.rawValue, value: constructColorKeywordValueCompletionValue(colorKeywordValue: colorKeyword.rawValue))
        }
    }
    
    func addFontFamilyCompletions() {
        
        try! add(§CSSProperty.fontFamily, value:
            CompletionValue(
                desc: NSLocalizedString("\"font-family\" CSS property.",
                comment: "CSS \"font-family\" property description for autocompletion."),
                completionValue: §CSSProperty.fontFamily + ":",
                completionDisplay: §CSSProperty.fontFamily,
                language: Language.CSS,
                type: AutocompletionType.cssProperty(name: AutocompletionTypeName.CSS.CssGenericProperty)
            )
        )
        
        #if DEBUG
        var fontsString = ""
        #endif
        
        for fontFamilyValue in NSFontManager.shared.availableFontFamilies {
            
            #if DEBUG
            fontsString += fontFamilyValue + "\n"
            #endif
            
            try! add(fontFamilyValue, value: constructFontFamilyValueCompletionValue(fontFamilyValue: fontFamilyValue))
        }
        
        #if DEBUG
        print(fontsString)
        #endif
    }
    
    func addTextDecorationLineCompletions() {
        
        try! add(§CSSProperty.textDecorationLine, value:
            CompletionValue(
                desc: NSLocalizedString("\"text-decoration-line\" CSS property.",
                comment: "CSS \"text-decoration-line\" property description for autocompletion."),
                completionValue: §CSSProperty.textDecorationLine + ":",
                completionDisplay: §CSSProperty.textDecorationLine,
                language: Language.CSS,
                type: AutocompletionType.cssProperty(name: AutocompletionTypeName.CSS.CssGenericPropertyValue)
            )
        )
        
        for value in CSSTextDecorationLineKeyword.values {
            
            try! add(value.rawValue, value: constructTextDecorationLineKeywordValueCompletionValue(textDecorationLineKeywordValue: value.rawValue))
        }
    }
    
    func addTextDecorationColorCompletions() {
        
        try! add(§CSSProperty.textDecorationColor, value:
            CompletionValue(
                desc: NSLocalizedString("\"text-decoration-color\" CSS property.",
                comment: "CSS \"text-decoration-color\" property description for autocompletion."),
                completionValue: §CSSProperty.textDecorationColor + ":",
                completionDisplay: §CSSProperty.textDecorationColor,
                language: Language.CSS,
                type: AutocompletionType.cssProperty(name: AutocompletionTypeName.CSS.CssGenericPropertyValue)
            )
        )
    }
    
    func addTextDecorationStyleCompletions() {
        
        try! add(§CSSProperty.textDecorationStyle, value:
            CompletionValue(
                desc: NSLocalizedString("\"text-decoration-style\" CSS property.",
                comment: "CSS \"text-decoration-style\" property description for autocompletion."),
                completionValue: §CSSProperty.textDecorationStyle + ":",
                completionDisplay: §CSSProperty.textDecorationStyle,
                language: Language.CSS,
                type: AutocompletionType.cssProperty(name: AutocompletionTypeName.CSS.CssGenericPropertyValue)
            )
        )
        
        for value in CSSTextDecorationStyleKeyword.values {
            
            try! add(value.rawValue, value: constructTextDecorationStyleKeywordCompletionValue(textDecorationStyleKeywordValue: value.rawValue))
        }
    }
    
    func addFontSizeCompletions() {
     
        try! add(§CSSProperty.fontSize, value:
            CompletionValue(
                desc: NSLocalizedString("\"font-size\" CSS property.",
                comment: "CSS \"font-size\" property description for autocompletion."),
                completionValue: §CSSProperty.fontSize + ":",
                completionDisplay: §CSSProperty.fontSize,
                language: Language.CSS,
                type: AutocompletionType.cssProperty(name: AutocompletionTypeName.CSS.CssGenericPropertyValue)
            )
        )
        
        for value in CSSFontSizeKeyword.values {
            
            try! add(value.rawValue, value: constructFontSizeKeywordCompletionValue(fontSizeKeywordValue: value.rawValue))
        }
    }
    
    func addFontStyleCompletions() {
        
        try! add(§CSSProperty.fontStyle, value:
            CompletionValue(
                desc: NSLocalizedString("\"font-style\" CSS property.",
                comment: "CSS \"font-style\" property description for autocompletion."),
                completionValue: §CSSProperty.fontStyle + ":",
                completionDisplay: §CSSProperty.fontStyle,
                language: Language.CSS,
                type: AutocompletionType.cssProperty(name: AutocompletionTypeName.CSS.CssGenericPropertyValue)
            )
        )
        
        
        for value in CSSFontStyleKeywordValue.values {
            
            try! add(value.rawValue, value: constructFontStyleKeywordCompletionValue(fontStyleKeywordValue: value.rawValue))
        }
        
    }
    
    ///////////////////////////////////
    /// Start: font-Weight
    ///////////////////////////////////
    func addFontWeightCompletions() {
        
        try! add(§CSSProperty.fontWeight, value:
            CompletionValue(
                desc: NSLocalizedString("\"font-weight\" CSS property.",
                comment: "CSS \"font-weight\" property description for autocompletion."),
                completionValue: §CSSProperty.fontWeight,
                language: Language.CSS,
                type: AutocompletionType.cssProperty(name: AutocompletionTypeName.CSS.CssGenericPropertyValue)
            )
        )
        
        try! add(§CSSFontWeigthRelativeValue.bolder, value:
            CompletionValue(
                desc: NSLocalizedString("\"bolder\" font-weight property value.",
                comment: "CSS \"font-weight: bolder\" property value description for autocompletion."),
                completionValue: §CSSFontWeigthRelativeValue.bolder,
                language: Language.CSS,
                type: AutocompletionType.cssProperty(name: AutocompletionTypeName.CSS.CssGenericPropertyValue)
            )
        )
        
        try! add(§CSSFontWeigthRelativeValue.lighter, value:
            CompletionValue(
                desc: NSLocalizedString("\"lighter\" font-weight property value.",
                comment: "CSS \"font-weight: lighter\" property value description for autocompletion."),
                completionValue: §CSSFontWeigthRelativeValue.lighter,
                language: Language.CSS,
                type: AutocompletionType.cssProperty(name: AutocompletionTypeName.CSS.CssGenericPropertyValue)
            )
        )
    
//        try! add(§CSSFontWeigthAbsoluteValue.normal, value: CompletionValue(desc: NSLocalizedString("\"normal\" font-weight property value.", comment: "CSS \"font-weight: normal\" property value description for autocompletion."), value: §CSSFontWeigthAbsoluteValue.normal))
        
        try! add(§CSSFontWeigthAbsoluteValue.bold, value:
            CompletionValue(
                desc: NSLocalizedString("\"bold\" font-weight property value.",
                comment: "CSS \"font-weight: bold\" property value description for autocompletion."),
                completionValue: §CSSFontWeigthAbsoluteValue.bold,
                language: Language.CSS,
                type: AutocompletionType.cssProperty(name: AutocompletionTypeName.CSS.CssGenericPropertyValue)
            )
        )
    }

    func addHtmlCompletions() {
        
        for htmlValue in HtmlBlock.allValues {
            
            try! add(§htmlValue, value: constructHtmlCompletion(htmlBlock: htmlValue))
        }
    }
    
    func addMarkdownCompletions() {
        
        for markdownValue in MarkdownElementType.allCases {
            
            try! add(§markdownValue, value: constructMarkdownCompletion(markdownElement: markdownValue))
        }
    }

    private func constructMarkdownCompletion(markdownElement: MarkdownElementType) -> CompletionValue {
        
        return CompletionValue(
            desc: NSLocalizedString(§markdownElement,
                                    comment: "Markdown HTML \"" + §markdownElement + "\" element description for autocompletion."),
            completionValue: §markdownElement,
            language: Language.markdownHtml,
            type: AutocompletionType.htmlElement(name: AutocompletionTypeName.HTML.MarkdownHtmlElement)
        )
    }
    
    private func constructHtmlCompletion(htmlBlock: HtmlBlock) -> CompletionValue {
        
        return CompletionValue(
            desc: NSLocalizedString(§htmlBlock,
            comment: "HTML \"" + §htmlBlock + "\" element description for autocompletion."),
            completionValue: §htmlBlock,
            language: Language.HTML,
            type: AutocompletionType.htmlElement(name: AutocompletionTypeName.HTML.HtmlGenericElement)
        )
    }
    
    private func constructFontFamilyValueCompletionValue(fontFamilyValue: String) -> CompletionValue {
        
        var completionValue = fontFamilyValue
        
        if completionValue.contains(" ") {
            completionValue = "\"" + completionValue + "\""
        }
        
        return CompletionValue(
            desc: NSLocalizedString("\"" + fontFamilyValue + "\" font-family property value.",
            comment: "CSS \"" + fontFamilyValue + "\" font-family property value dscription for autocompletion."),
            completionValue: completionValue,
            language: Language.CSS,
            type: AutocompletionType.cssProperty(name: AutocompletionTypeName.CSS.CssFontFamilyPropertyValue)
        )
    }
    
    private func constructColorKeywordValueCompletionValue(colorKeywordValue: String) -> CompletionValue {
        
        return CompletionValue(
            desc: NSLocalizedString("\"" + colorKeywordValue + "\" color propety value.",
            comment: "CSS \"" + colorKeywordValue + "\" color property value description for autocompletion."),
            completionValue: colorKeywordValue,
            language: Language.CSS,
            type: AutocompletionType.cssProperty(name: AutocompletionTypeName.CSS.CssColorPropertyValue)
        )
    }
    
    private func constructTextDecorationLineKeywordValueCompletionValue(textDecorationLineKeywordValue: String) -> CompletionValue {
     
        return CompletionValue(
            desc: NSLocalizedString("\"" + textDecorationLineKeywordValue + "\" value of text-decoration-line property.",
            comment: "CSS \"" + textDecorationLineKeywordValue + "\" text-decoration-line property value description for autocompletion."),
            completionValue: textDecorationLineKeywordValue,
            language: Language.CSS,
            type: AutocompletionType.cssProperty(name: AutocompletionTypeName.CSS.CssGenericPropertyValue)
        )
    }
    
    private func constructTextDecorationStyleKeywordCompletionValue(textDecorationStyleKeywordValue: String) -> CompletionValue {
     
        return CompletionValue(
            desc: NSLocalizedString("\"" + textDecorationStyleKeywordValue + "\" value of text-decoration-style property.",
            comment: "CSS \"" + textDecorationStyleKeywordValue + "\" text-decoration-style property value description for autocompletion."),
            completionValue: textDecorationStyleKeywordValue,
            language: Language.CSS,
            type: AutocompletionType.cssProperty(name: AutocompletionTypeName.CSS.CssGenericPropertyValue)
        )
    }
    
    private func constructFontSizeKeywordCompletionValue(fontSizeKeywordValue: String) -> CompletionValue {
        
        return CompletionValue(
            desc: NSLocalizedString("\"" + fontSizeKeywordValue + "\" value of font-size property.",
            comment: "CSS \"" + fontSizeKeywordValue + "\" font-size property value description for autocompletion."),
            completionValue: fontSizeKeywordValue,
            language: Language.CSS,
            type: AutocompletionType.cssProperty(name: AutocompletionTypeName.CSS.CssGenericPropertyValue)
        )
    }
    
    private func constructFontStyleKeywordCompletionValue(fontStyleKeywordValue: String) -> CompletionValue {
     
        return CompletionValue(
            desc: NSLocalizedString("\"" + fontStyleKeywordValue + "\" value of font-style property.",
            comment: "CSS \"" + fontStyleKeywordValue + "\" font-style property value description for autocompletion."),
            completionValue: fontStyleKeywordValue,
            language: Language.CSS,
            type: AutocompletionType.cssProperty(name: AutocompletionTypeName.CSS.CssGenericPropertyValue)
        )
    }
    
}


