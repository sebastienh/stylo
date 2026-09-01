//
//  HtmlExportViewController.swift
//  HtmlExportPlugin
//
//  Created by Sebastien hamel on 2019-09-22.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Cocoa
import WebKit

class HtmlExportViewController: NSViewController, WKScriptMessageHandler {
    
    var webView: WebView!
    
    private var htmlPreviewBackgroundView: NSView {
        
        return self.view
    }
    
    private var topBoundsScript: WKUserScript {
        
        let source = """
            function postTopBound() {
                window.webkit.messageHandlers.notification.postMessage({top: window.pageYOffset});
            }
                
            window.addEventListener("scroll", function(){
                postTopBound()
            }, false)
        """
        
        return WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureWebView()
    }
    
    private func configureWebView() {
        
        let userContentController = WKUserContentController()
        userContentController.addUserScript(topBoundsScript)
        userContentController.add(self, name: "notification")
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Setting url scheme handler for %@ to self", log: Log.HtmlExport.all, type: .info, %%Markdown.Constants.Html.styloUrlScheme)
        #endif
        
        // NW-1486
        //        configuration.setURLSchemeHandler(self, forURLScheme: Markdown.Constants.Html.styloUrlScheme)
        self.webView = WebView(frame: .zero)
            
//            WKWebView(frame: NSMakeRect(0, 0, 10, 22), configuration: configuration)
        
//        self.webView.setValue(false, forKey: "drawsBackground")
//        webView.navigationDelegate = self
        
        // the value 436.6 is manually computed and comes from experimentation...
        // not the best, I know.
        let minimumWidthConstraint = NSLayoutConstraint(item: self.webView, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 436.6)
        
        webView.addConstraint(minimumWidthConstraint)
        
        self.htmlPreviewBackgroundView.addSubview(webView)
        
        // see https://stackoverflow.com/questions/24896810/nslayoutconstraint-prevents-nswindow-resizing
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        let topConstraint = NSLayoutConstraint(item: webView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
        
        let leadingConstraint = NSLayoutConstraint(item: webView, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.htmlPreviewBackgroundView, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
        
        let trailingConstraint = NSLayoutConstraint(item: webView, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.htmlPreviewBackgroundView, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)
        
        let bottomConstraint = NSLayoutConstraint(item: webView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.htmlPreviewBackgroundView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        
        webView.setContentHuggingPriority(NSLayoutConstraint.Priority(249), for: NSLayoutConstraint.Orientation.vertical)
        webView.setContentHuggingPriority(NSLayoutConstraint.Priority(249), for: NSLayoutConstraint.Orientation.horizontal)
        webView.setContentCompressionResistancePriority(NSLayoutConstraint.Priority(750), for: NSLayoutConstraint.Orientation.vertical)
        webView.setContentCompressionResistancePriority(NSLayoutConstraint.Priority(750), for: NSLayoutConstraint.Orientation.horizontal)
        
        self.htmlPreviewBackgroundView.addConstraints([topConstraint, leadingConstraint, trailingConstraint, bottomConstraint])
        
        self.htmlPreviewBackgroundView.needsUpdateConstraints = true
        
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: WKScriptMessageHandler protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        let dict = message.body as! [String:AnyObject]
        
        let topBound = dict["top"]
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("called userContentController %@", log: Log.StyloCore.all, type: .debug, %%topBound)
        #endif
        
        if let topBound = topBound as? CGFloat {
        
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("called userContentController %@", log: Log.StyloCore.all, type: .debug, %%topBound)
            #endif
            
        }
    }
}
