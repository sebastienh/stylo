//
//  WKWebView+Scrollable.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-05-04.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import WriterCommon
import PromiseKit
import Common
import WebKit
import os

extension WKWebView: Scrollable {

    public var numberOfTopElements: Promise<Int> {
        
        let script = """
            document.body.children.length;
        """
        
        let (promise, fulfill, reject) = Promise<Int>.pending()
        
        self.evaluateJavaScript(script) { (result, error) in
            
            if let error = error {
                reject(error)
            }
            else {
                if let result = result {
                    
                    let string = NSString(format: "%@", result as! CVarArg)
                    let int = Int(string as String)
                    
                    if let int = int {
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("web top elements fulfill with value", log: Log.StyloCore.all, type: .info, %%int)
                        #endif
                        fulfill(int)
                    }
                    else {
                        reject(NWError.custom(message: "nil int value"))
                    }
                }
                else {
                    reject(NWError.custom(message: "nil result"))
                }
            }
        }
        
        return promise
    }
    
    public var scrollRatio: Promise<CGFloat> {
        
        let script = """
            window.scrollY;
        """
        
        let (promise, fulfill, reject) = Promise<CGFloat>.pending()
        
        self.evaluateJavaScript(script) { (result, error) in
            
            if let error = error {
                reject(error)
            }
            else {
                if let result = result {
            
                    let string = NSString(format: "%@", result as! CVarArg)
                    let floatValue = Float(string as String)
                    let float = CGFloat(floatValue!)
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("web scrollRatio fulfill with value", log: Log.StyloCore.all, type: .info, %%float)
                    #endif
                    fulfill(float/self.frame.height)
                }
                else {
                    reject(NWError.custom(message: "nil result"))
                }
            }
        }
        
        return promise
    }
    
    public var startBounds: Promise<NSRect> {
        
        let script = """

            JSON.stringify(startBounds());
            function startBounds() {

                var children = document.body.children;
                if(children.length > 0) {
                    var firstChild = children[0];
                    var offset = firstChild.offsetHeight;
                    return "{{0,0},{0," + offset + "}}";
                }
                return "{{0,0},{0,0}}";
            }
        """
        
        let (promise, fulfill, reject) = Promise<NSRect>.pending()
        
        self.evaluateJavaScript(script) { (result, error) in
            
            if let error = error {
                reject(error)
            }
            else {
                if let result = result {
                    
                    let string = NSString(format: "%@", result as! CVarArg)
                    let rect = NSRectFromString(string as String)
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("startBounds fulfill with value", log: Log.StyloCore.all, type: .info, %%rect)
                    #endif
                    
                    fulfill(rect)
                }
                else {
                    
                    reject(NWError.custom(message: "nil result"))
                }
            }
        }
        
        return promise
    }
    
    public var endBounds: Promise<NSRect?> {
        
        let script = """
            endBounds();
            function endBounds() {

                var children = document.body.children;

                if(children.length > 0) {

                    var lastElement = children[children.length-1];
                    var res = new Object();
                    res.x = 0; res.y = 0;
                    var viewportElement = document.documentElement;
                    var box = lastElement.getBoundingClientRect();
                    var scrollLeft = viewportElement.scrollLeft;
                    var scrollTop = viewportElement.scrollTop;
                    res.x = box.left + scrollLeft;
                    res.y = box.top + scrollTop;

                    var totalHeight = document.documentElement.offsetHeight
                    var lastElementBoundingRect = lastElement.getBoundingClientRect();
                    var lastElementEndPosition = res.y+lastElementBoundingRect.height;
                    var height = totalHeight - lastElementEndPosition;
                    return "{{0,"+ lastElementEndPosition + "},{0," + height + "}}";
                }
                return "{{0,0},{0,0}}";
            }
        """
        
        let (promise, fulfill, reject) = Promise<NSRect?>.pending()
        
        self.evaluateJavaScript(script) { (result, error) in
            
            if let error = error {
                reject(error)
            }
            else {
                if let result = result {
                    
                    let string = NSString(format: "%@", result as! CVarArg)
                    let rect = NSRectFromString(string as String)
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("endBounds fulfill with value", log: Log.StyloCore.all, type: .info, %%rect)
                    #endif

                    fulfill(rect)
                }
                else {
                    reject(NWError.custom(message: "nil result"))
                }
            }
        }
        
        return promise
    }
    
    public var currentScrollPosition: Promise<ScrollPosition?> {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("currentScrollPosition request", log: Log.StyloCore.all, type: .info)
        #endif
        
        let script = """

            var children = document.body.children;
            
            // get any element index inside the visible
            // portion of the current window
            var index = elementInsideIndex(children);

            var indexes = indexesAround(index, children);
            var scrollPosition = buildScrollPosition(indexes, children)
            JSON.stringify(scrollPosition);

            function buildScrollPosition(indexes, children) {

                if(typeof indexes === "number") {

                    if(indexes == -1) {

                        if(children.length > 0) {
                        
                            var firstElement = children[0];
                            var firstElementRect = firstElement.getBoundingClientRect();

                            return {
                                type: "start",
                                index: -1,
                                ratio: firstElementRect.top/firstElement.offsetHeight
                            }
                        }
                        else {

                            return {
                                type: "start",
                                index: -1,
                                ratio: 0
                            }
                        }
                    }
                    else {
                        
                        var element = children[indexes];
                        var elementRect = element.getBoundingClientRect();
                        return {
                            type: "inside",
                            index: indexes,
                            ratio: Math.abs(elementRect.top)/elementRect.height
                        }
                    }
                }
                else {

                    var firstElement = children[indexes.beforeIndex];
                    var firstElementRect = firstElement.getBoundingClientRect();
                    var secondElement = children[indexes.afterIndex];
                    var secondElementRect = secondElement.getBoundingClientRect();
                    var distance = secondElementRect.top + Math.abs(firstElementRect.bottom);

                    return {
                        type: "between",
                        beforeIndex: indexes.beforeIndex,
                        afterIndex: indexes.afterIndex,
                        ratio: Math.abs(firstElementRect.bottom)/distance
                    }

                }
            }

            // return any element index inside the visible
            // portion of the current window
            function elementInsideIndex(children) {

                var start = 0;
                var end = children.length;
                var windowHeight = window.innerHeight;

                // we iterate through all elements and we want
                // to find the last
                var mid = 0

                // console.log(children);
                while(start < end) {

                    mid = Math.floor((end+start)/2);
                    var element = children[mid];
                    var elementRect = element.getBoundingClientRect();

                    if(elementRect.bottom <= 0) {
                        start = mid + 1;
                    }
                    else if(elementRect.top > windowHeight) {
                        end = mid;
                    }
                    else {
                        break;
                    }
                }
                return mid;
            }

            function indexesAround(index, children) {

                var element = children[index];
                var rect = element.getBoundingClientRect();

                while (rect.bottom > 0) {

                    // check if we are in the middle of an element
                    if(rect.top <= 0) {
                        return index;
                    }
                    else {

                        if(index >= 1) {

                            // is it between two elements
                            var previousDisplayedElement = children[index-1];
                            var previousDisplayedElementRect = previousDisplayedElement.getBoundingClientRect();

                            if(previousDisplayedElementRect.bottom <= 0) {

                                return {
                                    beforeIndex: index-1,
                                    afterIndex: index
                                }
                            }
                            else {
                                index--;
                                rect = previousDisplayedElementRect;
                            }
                        }
                        else {
                            // index == 0
                            // we are at the start of the document
                            return -1;
                        }
                    }
                }
            }
        """

        
        let (promise, fulfill, reject) = Promise<ScrollPosition?>.pending()
        
        self.evaluateJavaScript(script) { (result, error) in
            
            if let error = error {
                reject(error)
            }
            else {
                if let result = result {
                    let string = NSString(format: "%@", result as! CVarArg)
                    if let scrollPosition = ScrollPosition.fromJson(string: string as String) {
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("currentScrollPosition fulfill with value", log: Log.StyloCore.all, type: .info, %%scrollPosition)
                        #endif
                        
                        fulfill(scrollPosition)
                    }
                    else {
                        reject(NWError.custom(message: "nil scrollPosition"))
                    }
                }
                else {
                    reject(NWError.custom(message: "nil result"))
                }
            }
        }
        
        return promise
    }
    
    @discardableResult
    public func scrollTo(point: NSPoint) -> Promise<Void> {

        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("StaticHtmlWebView scrollTo(point: NSPoint) to point: %@", log: Log.StyloCore.all, type: .info, %%point)
        #endif
        
        return Promise<Void> { fulfill, reject in
        
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("StaticHtmlWebView scrolling to point: %@", log: Log.StyloCore.all, type: .info, %%point)
            #endif
            
            let yPosition = point.y
            
            let script = """
                window.scrollTo(0, \(yPosition));
            """
            
            self.evaluateJavaScript(script) { (result, error) in
                
                if let error = error {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("Error: %@", log: Log.StyloCore.all, type: .error, %%error)
                    #endif
                    reject(error)
                }
                else {
                    if let result = result {
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Scroll to result: %@", log: Log.StyloCore.all, type: .info, %%result)
                        #endif
                    }
                    fulfill(())
                }
            }
        }
    }
    
    public func boundsForElement(at index: Int) -> Promise<NSRect> {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("requesting bounds for element at index: %d)", log: Log.StyloCore.all, type: .info, index)
        #endif
        
        let script = """
        
        boundsForElement(\(index));
        function boundsForElement(index) {

            var children = document.body.children;
        
            if(index >= 0 && index < children.length) {

                var element = children[index];
                var rect = element.getBoundingClientRect();
                var originY = rect.top + window.scrollY;
                var rectString= "{{"+rect.x+","+  originY  +"},{"+ rect.width +"," + rect.height+"}}";
        
                // var childrenString = "";
                // for(var i = 0; i < children.length; i++) {
                //    var name = children[i].localName;
                //    childrenString += i + ": " + name + "\\n";
                // }
        
                var result = {
                    "rect" : rectString,
                    //"debugInfo" : childrenString
                };
        
                return result;
            }
        
            return "nil";
        }
        
        """
        
        let (promise, fulfill, reject) = Promise<NSRect>.pending()
        
        self.evaluateJavaScript(script) { (result, error) in
            
            if let error = error {
                reject(error)
            }
            else {
                if let result = result {
                    let string = NSString(format: "%@", result as! CVarArg)
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Result from script: %@", log: Log.StyloCore.all, type: .info, %%string)
                    #endif
                    
                    if !string.hasSuffix("nil")  {
                        
                        if let dictionnary = result as? Dictionary<String, Any> {
                            
                            if let rectString = dictionnary["rect"] as? String {
                                
                                let rect = NSRectFromString(rectString)
                                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                                os_log("boundsForElement(at index: Int) fulfill with value", log: Log.StyloCore.all, type: .info, %%rect)
                                #endif
                                
                                fulfill(rect)
                            }
                            else {
                                assert(false, "error")
                                let errorString = "result is not dict at boundsForElement(at: \(index))"
                                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                                os_log("%@", log: Log.StyloCore.all, type: .error, %%errorString)
                                #endif
                                reject(NWError.custom(message: errorString))
                            }
                        }
                        else {
                            assert(false, "error")
                            let errorString = "result is not dict at boundsForElement(at: \(index))"
                            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                            os_log("%@", log: Log.StyloCore.all, type: .error, %%errorString)
                            #endif
                            reject(NWError.custom(message: errorString))
                        }
                    }
                    else {
                        assert(false, "error")
                        let errorString = "webview nil result in boundsForElement(at: \(index))"
                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                        os_log("%@", log: Log.StyloCore.all, type: .error, %%errorString)
                        #endif
                        reject(NWError.custom(message: errorString))
                    }
                }
                else {
                    assert(false, "error")
                    let errorString = "webview nil result in boundsForElement(at: \(index))"
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("%@", log: Log.StyloCore.all, type: .error, %%errorString)
                    #endif
                    reject(NWError.custom(message: errorString))
                }
            }
        }
        return promise
    }
}
