//
//  TemplateReducer.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-08-07.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Web
import Common
import PromiseKit
import Igloo
import os
import Stencil

public struct TemplateReducer: Reducer {
    
    // strongly referenced by the StyleStore
    let templateConcurrentQueue: DispatchQueue
    
    init(storeIdentifier: String) {
        
        self.templateConcurrentQueue = DispatchQueue(label: Constants.Queues.TemplateStoreQueueNamePrefix + storeIdentifier, attributes: .concurrent)
    }
    
    @discardableResult
    public func online<S: Store>(store: S, action: ActionType) throws -> ActionResult? {
        fatalError("missing implementation")
    }
    
    public func sync<S>(store: S, action: SyncAction) -> ActionResult? where S : Store {
        
        var result: ActionResult?
        
        let templateStore = store as? TemplateStore
        
        assert(templateStore != nil)
        if let templateStore = templateStore {
            
            let templateAction = action.type as? TemplateAction
            
            assert(templateAction != nil)
            if let templateAction = templateAction {
                
                switch templateAction {
                    
                case .loadTemplates(let directoryName):
                    self.templateConcurrentQueue.sync(flags: .barrier) {
                        loadTemplates(from: directoryName, store: templateStore)
                    }
                    
                case .renderTemplate(let templateName, let context):
                    
                    self.templateConcurrentQueue.sync {
                        
                        do {
                            result = try self.render(templateName: templateName, with: context, templateStore: templateStore)
                        }
                        catch let error {
                            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                            os_log("error: %@", log: Log.WriterCommon.all, type: .error, %%error)
//                                assert(false)
                            #endif
                        }
                    }
                }
            }
            else {
                
                let error = NWError.custom(message: "Not handling action: \(action.type)")
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("error: %@", log: Log.WriterCommon.all, type: .error, %%error)
                #endif
            }
        }
        else {
            let error = NWError.unhandledStoreType(storeId: String(describing: store))
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("error: %@", log: Log.WriterCommon.all, type: .error, %%error)
            #endif
        }
        
        
        return result 
    }
    
    public func async<S>(store: S, action: AsyncAction) -> Promise<ActionResult?> where S : Store {
        
        return Promise<ActionResult?> { fulfill, reject in
            
            let templateStore = store as? TemplateStore
            
            assert(templateStore != nil)
            if let templateStore = templateStore {
                
                let templateAction = action.type as? TemplateAction
                
                assert(templateAction != nil)
                if let templateAction = templateAction {
                    
                    switch templateAction {
                        
                    case .loadTemplates(let directoryName):
                    
                        self.templateConcurrentQueue.async(flags: .barrier) {
                            self.loadTemplates(from: directoryName, store: templateStore)
                            fulfill(nil)
                        }
                        
                    case .renderTemplate(let templateName, let context):
                        
                        // we are not writing for the moment but starting from the
                        // moment we cache the results in the md5 hashed dictionnary
                        self.templateConcurrentQueue.async {
                            
                            do {
                                let renderedResult = try self.render(templateName: templateName, with: context, templateStore: templateStore)
                                fulfill(renderedResult)
                            }
                            catch let error {
                                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                                os_log("error: %@", log: Log.WriterCommon.all, type: .error, %%error)
                                assert(false)
                                #endif
                                reject(error)
                            }
                        }
                    }
                }
                else {
                    
                    let error = NWError.custom(message: "Not handling action: \(action.type)")
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("error: %@", log: Log.WriterCommon.all, type: .error, %%error)
                    #endif
                    reject(error)
                }
            }
            else {
                let error = NWError.unhandledStoreType(storeId: String(describing: store))
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("error: %@", log: Log.WriterCommon.all, type: .error, %%error)
                #endif
                reject(error)
            }   
        }
    }
 
    private func loadTemplates(from directoryName: String, store: TemplateStore) {
        
        guard let bundle = Bundle(path: directoryName) else {
            assertionFailure("Error: unable to create bundle with directory name: \(directoryName)")
            return
        }
        
        let fileSystemLoader = FileSystemLoader(bundle: [bundle])
        let environment = Environment(loader: fileSystemLoader)
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        
        os_log("Start loading template at url: %@", log: Log.WriterCommon.all, type: .info, %%bundle.bundleURL)
        #endif
        do {
            let urls: [URL] = try FileManager.default.contentsOfDirectory(at: bundle.bundleURL, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
        
            // process files
            for url in urls {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Start loading template: %@", log: Log.WriterCommon.all, type: .info, %%url.lastPathComponent)
                #endif
                guard url.pathExtension == "stencil" else {
//                    assertionFailure("Error: unhandled file extension: \(url.pathExtension)")
                    continue
                }
                
                do {
                    let templateName = url.lastPathComponent
                    let template =  try environment.loadTemplate(name: url.lastPathComponent)
                    store.templates[templateName] = template
                    
                }
                catch let error {
                    assertionFailure("Error: error loading template: \(url.lastPathComponent): \(error)")
                    continue
                }
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("End loading template: %@", log: Log.WriterCommon.all, type: .info, %%url.lastPathComponent)
                #endif
            }
        } catch {
            let error = "Error while enumerating files \(bundle.bundleURL.path): \(error.localizedDescription)"
            assertionFailure("Error: \(error)")
        }
    }
    
    private func render(templateName: TemplateId, with context: [String : Any]?, templateStore: TemplateStore) throws -> TemplateActionResult? {

        guard let template = templateStore.templates[templateName] else {
            assertionFailure("Error: no template with name: \(templateName)")
            return nil
        }
        
        let renderResult = try template.render(context)
        return TemplateActionResult.renderResult(value: renderResult)
    }
    
    
    private func renderFromString(template: Template, with values: [String : Any]?) throws -> TemplateActionResult {
        
        let renderResult = try template.render(values)
        return TemplateActionResult.renderResult(value: renderResult)
    }
    
}

