////
////  Elements.swift
////  ParseUtils
////
////  Created by Sébastien Hamel on 2015-02-08.
////  Copyright (c) 2015 CM. All rights reserved.
////
//
//import Foundation
//
////class Elements extends Array {
////    Element? query(DOMString relativeSelectors);
////    Elements queryAll(DOMString relativeSelectors);
////};
//
//
///// Elements is an ES6-style subclass of Array with two additional methods. 
///// It's the new NodeList / HTMLCollection.
///// see https://dom.spec.whatwg.org/#elements
//public final class Elements {
//    
//    var valuesArray = [Element]()
//    
//    /// Elements array initializer
//    init() {
//        
////        valuesArray = [Element]()
//    }
//    
//    /// append array decorator method
//    func append(_ newElement: Web.Element) {
//        
//        self.valuesArray.append(newElement)
//    }
//    
//    
//    /// Returns the first element that is a descendant of elements that matches relativeSelectors.
//    ///
//    /// FIXME: This implementation is based on the ContainerNode+ParentNode one, maybe we should put together
//    /// both those implementations. The only thing changed is the set against which the selectors are 
//    /// evaluated.
//    ///
//    /// Element? query(DOMString relativeSelectors);
//    /// see https://dom.spec.whatwg.org/#dom-elements-query
//    func query(_ relativeSelector: DOMString, exception: inout Exception) -> Element? {
//        
//        // 1. Let s be the result of parse a relative selector from relativeSelectors against set. [SELECTORS]
//        // FIXME: We should do something with this report .
//        let matchList = matchRelativeSelectors(relativeSelector, set: valuesArray, exception: &exception)
//        
//        if exception.isError() {
//
//            return nil
//        }
//        
//        if let matchList = matchList {
//            
//            if matchList.isEmpty {
//                
//                return nil
//            }
//            else {
//                
//                return matchList[0]
//            }
//        }
//        // 2. If s is failure, throw a SyntaxError.
//        // matchList should not be nil. If there was not error the 
//        // list would be empty.
//        else {
//            
//            exception.code = ExceptionCode.syntaxError
//            return nil
//        }
//    }
//    
//    /// Returns all element descendants of elements that match relativeSelectors.
//    ///
//    /// FIXME: This implementation is based on the ContainerNode+ParentNode one, maybe we should put together
//    /// both those implementations. The only thing changed is the set against which the selectors are
//    /// evaluated.
//    ///
//    /// Elements queryAll(DOMString relativeSelectors);
//    /// see https://dom.spec.whatwg.org/#dom-elements-queryall
//    func queryAll(_ relativeSelectors: DOMString, exception: inout Exception) -> Elements {
//        
//        let matchList = matchRelativeSelectors(relativeSelectors, set: valuesArray, exception: &exception)
//        
//        let elements = Elements()
//        
//        if let matchList = matchList {
//            
//            if !matchList.isEmpty {
//                
//                for element in matchList {
//                    
//                    elements.append(element)
//                }
//            }
//        }
//        
//        // FIXME: Maybe we should handle the errors here .
//        
//        return elements
//    }
//    
//    /// Match a relative selectors string relativeSelectors against a set
//    /// see https://dom.spec.whatwg.org/#match-a-relative-selectors-string
//    fileprivate func matchRelativeSelectors(_ selector: DOMString, set: [Element], exception: inout Exception) -> [Element]? {
//        
////        let selectorsModule = CSSSelectorsModule.shared
////        
////        // 1. Let s be the result of [parse a relative selector]
////        // (http://dev.w3.org/csswg/selectors/#parse-a-relative-selector)
////        // from relativeSelectors against set. [SELECTORS]
////        let result = selectorsModule.parseRelativeSelector(selector, refs: set)
////        
////        let selectorList = result.0
////        let parserReport = result.1
////        
////        // 2. If s is failure, throw a SyntaxError.
////        if parserReport.hasErrors() {
////            
////            exception.code = ExceptionCode.SyntaxError
////            return (nil, parserReport)
////        }
////        
////        if let selectorList = selectorList {
////            
////            // 3. Return the result of [evaluate a selector]
////            // (http://dev.w3.org/csswg/selectors/#evaluate-a-selector) s
////            // using :scope elements set. [SELECTORS]
////            
////            return selectorsModule.evaluate(selector: selectorList, against:)
////            
////            
//////            return selectorsModule.evaluate(selector: SelectorList, against: [Element], scopingMethod: ScopingMethod?, scopingRoot: S?, scopeElements: [S], allowedPseudoElements: [DOMString]?)
////        }
////        else {
////            
////            fatalError("selectorList is nil.")
////        }
//        
//        fatalError("Missing implementation.")
//    }
//    
//}

