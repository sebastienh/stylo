//
//  WriterCommonCssTests.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-03-31.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import XCTest
@testable import Web
import Markdown
import Common
@testable import WriterCommon

class WriterCommonCssTests: WriterCommonTests {

    func loadStylesheet(named name: String, origin: CSSOrigin) -> CSSStyleSheet {
        
        let url = WriterCommonTests.urlOfFile(named: name)
        let stylesheetString = try! String(contentsOf: url!, encoding: String.Encoding.utf8)
        let syntaxModule = CSSOMModule.shared
        let styleSheet: CSSStyleSheet = syntaxModule.parseStyleSheet(stylesheetString as NSString, origin: origin)!
        return styleSheet
    }
    
    func computeElementsStyle(styleDefinition: StyleDefinition, document: Document) -> ResourceComputedStyle {
        
        let resourceComputedStyle = ResourceComputedStyle(styleDefinition: styleDefinition)
        
        resourceComputedStyle.computeElementsStyles(document: document, filterContext: FilterContext())
        
        return resourceComputedStyle
    }
    
    
    func createMarkdownHtmlDocument(from filename: String) -> HtmlDocument? {
        
        fatalError("should fix this method with pull method")
        
//        let url = urlOfFile(named: filename)
//        let markdownString = try! String(contentsOf: url!, encoding: String.Encoding.utf8)
//        let env = StyloMarkdownEnv()
//
//        let sourceStringChangeDescription = SourceStringChangeDescription(range: NSMakeRange(0, 0), stringReplacement: "", changeLength: 0, sourceString: NSMutableAttributedString(string: markdownString))
//
//        let changeRequest = MarkdownChangeRequest(changeRequestType: ChangeRequestType.dom, sourceStringChangeDescription: sourceStringChangeDescription)
//        changeRequest.env = env
//
//        let markdownTokensCreateOperation = MarkdownTokensCreateOperation(stringContainer: changeRequest, markdownChangeRequest: changeRequest, markdownPresetName: nil, completionBlock: nil)
//
//        markdownTokensCreateOperation.start()
//
//        let markdownHtmlDomOperation = MarkdownHtmlDomOperation(changeRequest: changeRequest)
//
//        markdownHtmlDomOperation.start()
//
//        return changeRequest.htmlDocument
    }
    
//    func compileCssSourceFile(from filename: String) -> CssChangeRequest? {
    
//        let stylesheetDocumentStore = StylesheetDocumentStore(origin: .author)
//        
//        let url = urlOfFile(named: filename)
//        let loadAction = StylableStoreAction.loadString(url: url)
//        stylesheetDocumentStore.dispatch(action: loadAction)
//        
//        
//        
//        
//        let description = SourceStringChangeDescription(range: <#T##NSRange#>, stringReplacement: <#T##String#>, changeLength: <#T##Int#>, sourceString: <#T##NSMutableAttributedString#>)
//            
//        .sourceStringChanged(let description)
//        
//
//        
//        
//        
        
//
//        let cssString = try! String(contentsOf: url!, encoding: String.Encoding.utf8)
//        let cssNSString = NSString(string: cssString)
//
//        let origin = stylesheetOrigin(from: filename) ?? .author
//
//        let styleSheetOperation = StyleSheetOperation(origin: origin, stringContainer: cssNSString, styleSheetResource: styleSheetResource, computePropertyValues: true)
//
//        styleSheetOperation.start()
//
//        let sourceStringChangeDescription = SourceStringChangeDescription(range: NSMakeRange(0, 0), stringReplacement: "", changeLength: 0, sourceString: cssNSString)
//
//        let cssChangeRequest = CssChangeRequest(changeRequestType: ChangeRequestType.all, sourceStringChangeDescription: sourceStringChangeDescription)
//        let stringResourceModelRenderingState = StringResourceModelRenderingState()
//        cssChangeRequest.stringResourceModelRenderingState = stringResourceModelRenderingState
//        cssChangeRequest.styleSheet = styleSheetResource.styleSheet!
//
//        let cssDomOperation = CSSDOMOperation(cssChangeRequest: cssChangeRequest)
//
//        cssDomOperation.start()
//
//        return cssChangeRequest
//    }
    
    func createStyle(from stylesheetsFilenames: [String], with userAgentStyleSheetFilename: String) -> CSSStyle? {
        
        fatalError("should fix this method with pull method")
        
//        let style = CSSStyle(id: "test-style")
//
//        let userAgentStylesheetResource = createUserAgentStylesheet(from: userAgentStyleSheetFilename)
//        style.addStyleSheetResource(userAgentStylesheetResource!)
//
//        for stylesheetFilename in stylesheetsFilenames {
//
//            let url = urlOfFile(named: stylesheetFilename)
//
//            let origin = stylesheetOrigin(from: stylesheetFilename) ?? .author
//
//            let styleSheetResource = EditableStyleSheetResource(editedLanguage: Language.CSS, origin: origin)
//
//            let loadFileOperation = LoadFileContentOperation(href: url!)
//
//            loadFileOperation.start()
//
//            let styleSheetOperation = StyleSheetOperation(origin: origin, stringContainer: loadFileOperation, styleSheetResource: styleSheetResource, computePropertyValues: true)
//
//            styleSheetOperation.start()
//
//            style.addStyleSheetResource(styleSheetResource)
//        }
//
//        return style
    }
    
//    fileprivate func createUserAgentStylesheet(from filename: String) -> StyleSheetResource? {
//        
//        let userAgentStyleSheetResource = StyleSheetResource(origin: .userAgent)
//        
//        let url = urlOfFile(named: filename)
//        
//        let loadUserAgentFileOperation = LoadFileContentOperation(href: url!)
//        
//        loadUserAgentFileOperation.start()
//        
//        let styleSheetOperation = StyleSheetOperation(origin: .userAgent, stringContainer: loadUserAgentFileOperation, styleSheetResource: userAgentStyleSheetResource, computePropertyValues: true)
//        
//        styleSheetOperation.start()
//        
//        return userAgentStyleSheetResource
//    }
    
    fileprivate func stylesheetOrigin(from title: String) -> CSSOrigin? {
        
        if title.endsWith("user") {
            return .user
        }
        else if title.endsWith("ua") {
            return .userAgent
        }
        
        return .author
    }


}
