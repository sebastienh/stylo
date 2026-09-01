//
//  DOMViewController.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2016-01-04.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon
import Web
import Common

final class DomInspectorViewController: NSViewController {
    
    var scrollItem: DomInspectable?
    
    var expandedItemsPaths: [[Int]]
    
    var domInspectorDelegate: DomInspectorDelegate!
    
    var domRenderable: DomRenderable! {
            
        didSet {
            domRenderable.domRenderingComponent = self
            registerToDocumentChanges(with: domRenderable)
        }
    }
    
    var document: Document? {
        
        return domRenderable.document.value
    }
    
    @IBOutlet var scrollView: NSScrollView!
    
    @IBOutlet var outlineView: DomInspectorOutlineView!
    
    @IBOutlet var topView: DomInspectorBackgroundView!

    required init?(coder: NSCoder) {
        
        self.expandedItemsPaths = [[Int]]()
        
        super.init(coder: coder)
    }
    
    override func viewDidAppear() {
        
        super.viewDidAppear()
        
        reload()
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: private implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    private func registerToDocumentChanges(with domRenderable: DomRenderable) {
        
        // each time we change he document completely
        // we reload the outline view.
        domRenderable.document.subscribe({ [weak self](document) in
            if let _ = document {
                DispatchQueue.main.async {
                    self?.reload()
                }
            }
        }, observer: self)
        
        // each time a part of the document is replaced
        // we replace it in the outline view
        // see see https://forums.macrumors.com/threads/swift-cocoa-error-refreshing-an-nsoutlineview.2079228/
        
        //func insertItems(at: IndexSet, inParent: Any?, withAnimation: NSTableView.AnimationOptions = [])
        //func removeItems(at: IndexSet, inParent: Any?, withAnimation: NSTableView.AnimationOptions = [])
        
        
    }
}
