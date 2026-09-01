//
//  StaticHtmlPreviewViewController.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-05-01.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon
import WebKit
import Common
import PromiseKit
import Markdown
import os

class StaticHtmlPreviewViewController: NSViewController, WKUIDelegate,  WKNavigationDelegate, WKScriptMessageHandler, WKURLSchemeHandler {
    
    @IBOutlet var htmlPreviewBackgroundView: StaticHtmlPreviewBackgroundView!
    
    var webView: WKWebView!
    
    var textManager: TextManager? {
        fatalError("missing implementation")
    }
    
    weak var documentManager: DocumentManager?
    
    private var htmlPreviewBackgroundColor: NSColor?

    private var staticHtmlPreviewable: StaticHtmlPreviewable? {
        
        return nil
    }
    
    private var visibleScroller: NSScroller?
    
    private var underTitleView: WindowTitleBackgroundView?
    
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
    
    private var disableContextMenuScript: String {
        
        // source Stackoverflow "WKWebView disable right click menu" question 
        let source = """
        document.getElementByTagName('body')[0].setAttribute('oncontextmenu', 'event.preventDefault();');
        """
        return source
    }
    
    var webViewLoadedPromise: Promise<Void>?
    var fulfill: ((Void) -> Swift.Void)?
    var reject: ((Error) -> Swift.Void)?
    
    private var styloWindowController: StyloWindowController? {
        
        return self.view.window?.windowController as? StyloWindowController
    }

    override func loadView() {
        super.loadView()
        configureWebView()
    }
    
    override func viewWillAppear() {

        initialize()
        super.viewWillAppear()
    }
    
    override func viewDidAppear() {
        
        initUnderTitleViewState()
        applyTextManagerPreviewBackgroundColor()
        super.viewDidAppear()
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        self.unsubscribeToStyleStoreChange()
    }
    
    func initUnderTitleViewState() {
        
        let windowController = self.windowController
        
        assert(windowController != nil)
        if let windowController = windowController {
            
            if windowController.styloWindow.titleBarHidden || windowController.fullscreenMode {
                hideUnderTitleView()
            }
        }
    }
    
    func hideUnderTitleView() {
        
        self.underTitleView?.isHidden = true
    }
    
    func showUnderTitleView() {
        
        self.underTitleView?.isHidden = false
    }
    
    func hideScroller() {
        
        //
        // ::-webkit-scrollbar {
        //    width: 0px;
        // }
        
        let scrollView = webView.enclosingScrollView
        
        assert(scrollView != nil)
        if let scrollView = scrollView {
            
            let verticalScroller = scrollView.verticalScroller
            
            assert(verticalScroller != nil)
            if let verticalScroller = verticalScroller {
                
                assert(visibleScroller == nil)
                self.visibleScroller = verticalScroller
                scrollView.verticalScroller = HiddenScroller(frame: verticalScroller.frame)
                scrollView.verticalScroller?.isHidden = true
                scrollView.verticalScroller?.isEnabled = false
            }
        }
    }
    
    func showScroller() {
        
        let scrollView = webView.enclosingScrollView
        
        assert(scrollView != nil)
        if let scrollView = scrollView {
        
            if scrollView.verticalScroller is HiddenScroller {
                
                let scrollerFrame = scrollView.verticalScroller?.frame
                assert(scrollerFrame != nil)
                if let scrollerFrame = scrollerFrame {
                    
                    self.visibleScroller?.frame = scrollerFrame
                    scrollView.verticalScroller = visibleScroller
                }
                else {
                    scrollView.verticalScroller = NSScroller()
                }
                scrollView.scrollerStyle = .overlay
                scrollView.verticalScroller?.isHidden = false
                scrollView.verticalScroller?.isEnabled = true
                
            }
            visibleScroller = nil
        }
    }
    
    func loadWebView(with string: String) -> Promise<Void> {
        
        let (webViewLoadedPromise, fulfill, reject) = Promise<Void>.pending()
        self.webViewLoadedPromise = webViewLoadedPromise
        self.fulfill = fulfill
        self.reject = reject
        
        self.loadHtml(htmlString: string)
        return webViewLoadedPromise
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
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: WKNavigationDelegate protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        if fulfill != nil {
        
            webView.evaluateJavaScript(disableContextMenuScript, completionHandler: nil)
            
            DispatchQueue.main.async {
                self.fulfill!(())
                self.fulfill = nil
            }
        }
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {

        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("host: %@", log: Log.StyloCore.all, type: .info, %%navigationAction.request.url!.absoluteString)
        os_log("navigationType", log: Log.StyloCore.all, type: .info, %%navigationAction.navigationType)
        #endif
        
        switch navigationAction.navigationType {
            
        case .other: fallthrough
        case .reload:
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("allow", log: Log.StyloCore.all, type: .info)
            #endif
            decisionHandler(.allow)
            
        case .linkActivated:
            decisionHandler(.cancel)
        default:
            os_log("cancel", log: Log.StyloCore.all, type: .info)
            decisionHandler(.cancel)
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: private implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    private var initialized: Bool = false
    
    private func initialize() {
        
        if !initialized {

            createUnderTitleView()
            listenToBackgroundColorChange()
            initialized = true
        }
    }
    
    func listenToBackgroundColorChange() {
        
        applyTextManagerPreviewBackgroundColor()
    }
    
    func unsubscribeToStyleStoreChange() {
        
        assert(textManager != nil)
        if let textManager = textManager {
            
            textManager.htmlStyleStore.unsubscribe(observer: self)
        }
    }
    
    private func applyTextManagerPreviewBackgroundColor() {
        
        assert(staticHtmlPreviewable != nil)
        self.htmlPreviewBackgroundColor = staticHtmlPreviewable?.htmlPreviewBackgroundColor
        self.applyCurrentBackgroundColor()
    }
    
    private func applyCurrentBackgroundColor() {
        
        if let htmlPreviewBackgroundColor = htmlPreviewBackgroundColor {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Applying new background-color to htmlPreviewBackgroundView: %@", log: Log.StyloCore.all, type: .info, %%htmlPreviewBackgroundColor)
            #endif
            
            underTitleView?.backgroundColor = htmlPreviewBackgroundColor.cgColor
            htmlPreviewBackgroundView?.backgroundColor = htmlPreviewBackgroundColor.cgColor
            styloDocument?.htmlPreviewBackgroundColor.setValue(htmlPreviewBackgroundColor)
        }
    }
    
    private func loadHtml(htmlString: String?) {
        
        assert(htmlString != nil)
        assert(webView != nil)
        if let htmlString = htmlString {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("loading html string %@", log: Log.StyloCore.all, type: .info, %%htmlString)
            #endif
            
            webView.loadHTMLString(htmlString, baseURL: nil)
        }
    }
    
    private func configureWebView() {
        
        let userContentController = WKUserContentController()
        userContentController.addUserScript(topBoundsScript)
        userContentController.add(self, name: "notification")
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Setting url scheme handler for %@ to self", log: Log.StyloCore.all, type: .info, %%Markdown.Constants.Html.styloUrlScheme)
        #endif
        
        // NW-1486
//        configuration.setURLSchemeHandler(self, forURLScheme: Markdown.Constants.Html.styloUrlScheme)
        self.webView = WebView(frame: .zero, configuration: configuration)
        
        guard let webView = self.webView else {
            assertionFailure("Error: webView is nil")
            return
        }
        
        webView.setValue(false, forKey: "drawsBackground")
        webView.navigationDelegate = self
        
        // the value 436.6 is manually computed and comes from experimentation...
        // not the best, I know.
        let minimumWidthConstraint = NSLayoutConstraint(item: webView, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 436.6)
            
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
    
    public func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) {
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Handling url scheme request(stop) for task", log: Log.StyloCore.all, type: .info, %%urlSchemeTask)
        #endif
    }
    
    public func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG_LOGS_ENABLED
        os_log("Handling url scheme request(start) for task", log: Log.StyloCore.all, type: .info, %%urlSchemeTask)
        #endif
        
        guard let url = urlSchemeTask.request.url else {
            
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Url is nil in request: %@", log: Log.StyloCore.all, type: .error, %%urlSchemeTask.request)
            #endif
            
            // Bad Request
            let response = HTTPURLResponse(url: URL(fileURLWithPath: "/"), statusCode: 400, httpVersion: nil, headerFields: nil)
            
            assert(response != nil)
            if let response = response {
                urlSchemeTask.didReceive(response)
            }
            urlSchemeTask.didFinish()
            return
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG_LOGS_ENABLED
        os_log("Loading request for stylo url %@", log: Log.StyloCore.all, type: .info, %%url)
        #endif
        
        do {
            
            var components = URLComponents()
            components.scheme = Markdown.Constants.Html.fileUrlScheme
            components.host = url.host
            components.path = url.path
            
            guard let fileUrl = components.url else {

                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Unable to load data at %@", log: Log.StyloCore.all, type: .error, %%components.url)
                #endif

                // Bad Request
                let response = HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil)

                assert(response != nil)
                if let response = response {
                    urlSchemeTask.didReceive(response)
                }
                urlSchemeTask.didFinish()
                return
            }
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG_LOGS_ENABLED
            os_log("Loading data from url %@", log: Log.StyloCore.all, type: .info, %%fileUrl)
            #endif
            
            let data = try Data(contentsOf: fileUrl)
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG_LOGS_ENABLED
            os_log("Loaded data %@", log: Log.StyloCore.all, type: .info, %%data)
            #endif
            
            let response = HTTPURLResponse(url: fileUrl, mimeType: nil, expectedContentLength: data.count, textEncodingName: nil)
            
            urlSchemeTask.didReceive(response)
            urlSchemeTask.didReceive(data)
            urlSchemeTask.didFinish()
        }
        catch let error {
            
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Unable to load url %@: %@", log: Log.StyloCore.all, type: .error, %%url, %%error)
            #endif
            
            // Internal Server Error
            let response = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)
            
            assert(response != nil)
            if let response = response {
                urlSchemeTask.didReceive(response)
            }
            urlSchemeTask.didFinish()
        }
    }
    
//
//
//    public func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
//
//        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
//        os_log("Handling url scheme request(start) for task", log: Log.StyloCore.all, type: .info, %%urlSchemeTask)
//        #endif
//
//        if let url = urlSchemeTask.request.url {
//
//            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
//            os_log("Loading request for stylo url %@", log: Log.StyloCore.all, type: .info, %%url)
//            #endif
//
//            do {
//
//                var components = URLComponents()
//                components.scheme = Markdown.Constants.Html.fileUrlScheme
//                components.host = url.host
//                components.path = url.path
//
//                if let fileUrl = components.url {
//
//                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
//                    os_log("Loading data from url %@", log: Log.StyloCore.all, type: .info, %%fileUrl)
//                    #endif
//
//                    let data = try Data(contentsOf: fileUrl)
//
//                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
//                    os_log("Loaded data %@", log: Log.StyloCore.all, type: .info, %%data)
//                    #endif
//
//                    let response = URLResponse(url: fileUrl, mimeType: nil, expectedContentLength: data.count, textEncodingName: nil)
//
//                    urlSchemeTask.didReceive(response)
//                    urlSchemeTask.didReceive(data)
//                    urlSchemeTask.didFinish()
//                }
//                else {
//
//                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
//                    os_log("Unable to load data at %@", log: Log.StyloCore.all, type: .error, %%components.url)
//                    #endif
//                }
//            }
//            catch let error {
//
//                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
//                os_log("Unable to load url %@: %@", log: Log.StyloCore.all, type: .error, %%url, %%error)
//                #endif
//            }
//        }
//        else {
//
//            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
//            os_log("Url is nil in request: %@", log: Log.StyloCore.all, type: .error, %%urlSchemeTask.request)
//            #endif
//        }
//    }
    
    private func createUnderTitleView() {
        
        let frame = NSMakeRect(0, 0, self.view.frame.width, 22)
        let windowTitleBackgroundView = WindowTitleBackgroundView(frame: frame)
        windowTitleBackgroundView.autoresizingMask = .width
        windowTitleBackgroundView.backgroundColor = NSColor.blue.cgColor

        if let titleBarHidden = self.windowController?.styloWindow.titleBarHidden, titleBarHidden {
            windowTitleBackgroundView.isHidden = true
        }
        
        self.view.addSubview(windowTitleBackgroundView, positioned: .above, relativeTo: nil)
        self.underTitleView = windowTitleBackgroundView
    }
}
