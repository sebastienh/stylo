//
//  WKWebView+Extensions.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-05-01.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import WebKit
import WriterCommon
import PromiseKit

extension WKWebView {
    
    var contentHeight: Promise<CGFloat> {
        
        let script = """
            height();
            function height() {
                return document.documentElement.offsetHeight;
            }
        """
        
        let (promise, fulfill, reject) = Promise<CGFloat>.pending()
        
        self.evaluateJavaScript(script) { (result, error) in
            
            if let error = error {
                reject(error)
            }
            else {
                if let result = result as? CGFloat {
                    fulfill(result)
                }
                else {
                    reject(NWError.custom(message: "nil result"))
                }
            }
        }
        
        return promise
    }
    
    /// For keeping scroll position
    /// see https://forums.macrumors.com/threads/nsoulineview-scroll-position.764193/
    func loadString(_ string: String) {
        
        loadHTMLString(string, baseURL: nil)
    }
    
}
