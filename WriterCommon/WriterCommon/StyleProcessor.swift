//
//  StyleProcessor.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2016-01-14.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation
import Common
import Web

final class StyleProcessor: Processor {
    
    /// Singleton instance.
    static var shared = StyleProcessor()
    
    func createStyleSheet(_ sourceString: String, origin: CSSOrigin, computePropertyValues: Bool = false) -> CSSStyleSheet? {
        
        let parser = CSParser(sourceString: sourceString as NSString)
        let csStyleSheet = parser.parseStyleSheet()
        let cssOmCreatorVisitor = CSSOMCreatorVisitor(origin: origin, computePropertyValues: computePropertyValues, declarationStopIndex: nil)
        let styleSheet = cssOmCreatorVisitor.process(csStyleSheet)
        styleSheet.sourceString = sourceString
        return styleSheet
    }
    
    /// create a stylesheet provided a stopIndex parameter.
    /// The stopIndex is used to stop parsing rules
    /// when we can. If a rule doesn't close then we will
    /// continue to parse until the end of the string.
    ///
    /// The funtion returns the index in the string until
    /// which it effectively stopped.
    func createStyleSheet(_ sourceString: String, rulesStopIndex: Int?, selectorStopIndex: Int?, origin: CSSOrigin, computePropertyValues: Bool = false) -> (stylesheet: CSSStyleSheet?, rulesStoppedIndex: Int?, selectorStoppedIndex: Int?) {
        
        let parser = CSParser(sourceString: sourceString as NSString)
        let (csStyleSheet, rulesStoppedIndex, selectorStoppedIndex, declarationStoppedIndex) = parser.parseStyleSheet(rulesStopIndex: rulesStopIndex, selectorStopIndex: selectorStopIndex, declarationStopIndex: nil)
        assert(declarationStoppedIndex == nil)
        let cssOmCreatorVisitor = CSSOMCreatorVisitor(origin: origin, computePropertyValues: computePropertyValues, declarationStopIndex: nil)
        let styleSheet = cssOmCreatorVisitor.process(csStyleSheet)
        styleSheet.sourceString = sourceString
        return (styleSheet, rulesStoppedIndex, selectorStoppedIndex)
    }
    
    /// create a stylesheet provided a declarationStopIndex parameter.
    /// The declarationStopIndex is used to stop parsing the declarations
    /// when we can. If a declaration doesn't stop then we will
    /// continue to parse until the end of the string.
    ///
    /// The funtion returns the index in the string until
    /// which it effectively stopped.
    func createStyleSheet(withDeclarationStopIndex declarationStopIndex: DeclarationStopIndex, sourceString: String, origin: CSSOrigin, computePropertyValues: Bool = false) -> (stylesheet: CSSStyleSheet?, declarationStoppedIndex: Int?) {
        
        let prelude = "* {"
        let stylesheetString = prelude + sourceString
        let declarationStopIndex = declarationStopIndex.with(indexVariation: prelude.count)
        
        let parser = CSParser(sourceString: stylesheetString as NSString)
        let (csStyleSheet, rulesStoppedIndex, selectorStoppedIndex, csDeclarationStoppedIndex) = parser.parseStyleSheet(rulesStopIndex: nil, selectorStopIndex: nil, declarationStopIndex: declarationStopIndex)
        assert(rulesStoppedIndex == nil)
        assert(selectorStoppedIndex == nil)
        let cssOmCreatorVisitor = CSSOMCreatorVisitor(origin: origin, computePropertyValues: computePropertyValues, declarationStopIndex: declarationStopIndex)
        let styleSheet = cssOmCreatorVisitor.process(csStyleSheet)
        let omDeclarationStoppedIndex = cssOmCreatorVisitor.declarationStoppedIndex
        let declarationStoppedIndex: Int? = {
            if let omDeclarationStoppedIndex = omDeclarationStoppedIndex, let csDeclarationStoppedIndex = csDeclarationStoppedIndex, omDeclarationStoppedIndex == csDeclarationStoppedIndex {
                return csDeclarationStoppedIndex - prelude.count
            }
            return nil
        }()
        styleSheet.sourceString = sourceString as String
        return (styleSheet, declarationStoppedIndex)
    }
    
}

     
