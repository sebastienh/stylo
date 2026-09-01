//
//  HtmlExportPlugin+WKNavigationDelegate.swift
//  HtmlExportPlugin
//
//  Created by Sebastien hamel on 2019-09-22.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Foundation
import WebKit

extension HtmlExportPlugin: WKNavigationDelegate {
    
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        guard let fulfill = self.fulfill else {
            assertionFailure("Error: self.fulfill is nil")
            return
        }
        
        DispatchQueue.main.async {
            fulfill(())
            self.fulfill = nil
        }
    }
    
}
