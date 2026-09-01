//
//  JsonStoreTests.swift
//  WriterCommonTests
//
//  Created by Sébastien Hamel on 2018-08-09.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import XCTest
import Web
import Igloo
@testable import WriterCommon

class JsonStoreTests: XCTestCase {

    func testContextCreate() {

        let state = JsonState()
        let dispatcher = JsonDispatcher(state: state)
        let jsonStore = JsonStore()
        dispatcher.register(store: jsonStore)
        
        let url = urlOfFile(named: "theme.json")
        
        XCTAssert(url != nil)
        if let url = url {
            
            let loadAction = EditableStoreActionsFactory.loadStringAction(url: url)
            dispatcher.sync(store: jsonStore, action: loadAction)
            
            let contextAction = JsonActionFactory.createMakeTemplateContextSyncAction()
            let contextResult = dispatcher.sync(store: jsonStore, action: contextAction) as? JsonActionResult
            
            XCTAssert(contextResult != nil)
        }
    }

    func testContextCreateAndRender() {
        
        let state = JsonState()
        let dispatcher = JsonDispatcher(state: state)
        let jsonStore = JsonStore()
        dispatcher.register(store: jsonStore)
        
        let url = urlOfFile(named: "theme.json")
        
        XCTAssert(url != nil)
        if let url = url {
            
            let loadAction = EditableStoreActionsFactory.loadStringAction(url: url)
            dispatcher.sync(store: jsonStore, action: loadAction)
            
            let contextAction = JsonActionFactory.createMakeTemplateContextSyncAction()
            let contextResult = dispatcher.sync(store: jsonStore, action: contextAction) as? JsonActionResult
            
            XCTAssert(contextResult != nil)
            if let contextResult = contextResult {
            
                switch contextResult {
                    
                case .updatedContext(let context):
                    
                    let templateState = TemplateState()
                    let templateDispatcher = TemplateDispatcher(state: templateState)
                    let templateStore = TemplateStore()
                    templateDispatcher.register(store: templateStore)
                    
                    let bundle = Bundle(for: type(of: self))
                    
                    let bundlePath = bundle.bundlePath
                    debugPrint("bundlePath: \(bundlePath)")
                    
                    let environmentAction = TemplateActionFactory.createLoadTemplatesSyncAction(with: "\(bundlePath)/Contents/Resources/")
                    templateDispatcher.sync(store: templateStore, action: environmentAction)
                    
                    let renderTemplateAction = TemplateActionFactory.renderTemplateSyncAction(templateName: "source-dark.stencil", context: context)
                    let renderResult = templateDispatcher.sync(store: templateStore, action: renderTemplateAction) as? TemplateActionResult
                    
                    XCTAssert(renderResult != nil)
                    if let renderResult = renderResult {
                    
                        switch renderResult {
                        
                        case .renderResult(let value):
                            debugPrint("Render template: \(value)")
                        case .updatedTemplate:
                            XCTAssert(false)
                        }
                    }
                    
                }
            }
        }
    }

    func contentOfFile(at url: URL) -> String {
        
        return try! String(contentsOf: url)
    }
    
    func urlOfFile(named name: String) -> URL? {
        
        let unitTestBundle = Bundle(for: type(of: self))
        
        let resourcesDirectoryURL = unitTestBundle.resourceURL!
        
        let fileManager = FileManager.default
        
        let resourcesDirectoryURLs: [URL] = (try! fileManager.contentsOfDirectory(at: resourcesDirectoryURL, includingPropertiesForKeys: nil, options: .skipsSubdirectoryDescendants))
        
        for url in resourcesDirectoryURLs {
            
            let last = url.lastPathComponent
            if last == name {
                return url
            }
        }
        return nil
    }
    
}

