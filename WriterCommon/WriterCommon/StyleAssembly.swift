//
//  StyleAssembly.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-04-08.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Common
import Web
import PromiseKit
import Igloo

///
/// This class is responsible to hold all the stylesheets for
/// a particular style assembly together. It does nothing by itself
/// but it provides a way to act on a style assembly from outside.
///
/// This class is used by the StyleManager
///
public class StyleAssembly: NSObject, Observer {
    
    public typealias Id = String
    
    public enum AssemblyType {
        case permanent
        case temporary
    }
    
    public var priority: ObserverPriority {
        return .background
    }
    
    let descriptor: StyleAssemblyDescriptor
    
    public let hasPendingChanges: Dynamic<Bool>
    
    /// Reference to the Dispatcher
    public var dispatcher: Dispatcher?
    
    unowned let styleAssemblyStore: StyleAssemblyStore
    
    public var stylePreview: Dynamic<StylePreview?>
    
    public var managedStyle: CSSStyle? {

        return styleAssemblyStore.style.value
    }
    
    @objc public dynamic var title: String
    
    var id: Id {
        return styleAssemblyStore.id
    }
    
    init(title: String, dispatcher: Dispatcher, editedStyleLanguage: Language, descriptor: StyleAssemblyDescriptor) {
        
        self.title = title
        self.dispatcher = dispatcher
        self.descriptor = descriptor
        self.hasPendingChanges = Dynamic<Bool>(false)
        self.stylePreview = Dynamic<StylePreview?>(nil)
        
        ComputedStylesCache.shared.removeComputedStyle(forStyleAssemblyIdentifier: title)
        let styleAssemblyStore = StyleAssemblyStore(editedLanguage: editedStyleLanguage, id: title)
        dispatcher.register(store: styleAssemblyStore)
        self.styleAssemblyStore = styleAssemblyStore
        
        super.init()
        self.bindStylePreview()
    }

    func updateStyleStoreValue(withStylesheets stylesheets: [CSSStyleSheet]) {
        let action = StyleAssemblyAction.createStyleWithStylesheets(stylesheets: stylesheets, styleId: self.title)
        assert(self.dispatcher != nil)
        self.dispatcher?.sync(store: self.styleAssemblyStore, action: action.syncAction)
        assert(self.styleAssemblyStore.style.value != nil)
        computeStylePreview()
    }
    
    @discardableResult
    func updateStyleStoreValueAsync(withStylesheets stylesheets: [CSSStyleSheet]) -> Promise<Void> {
        
        guard let dispatcher = self.dispatcher else {
            assertionFailure("Error: dispatcher is nil")
            return Promise<Void>(error: NWError.custom(message: "Error: dispatcher is nil"))
        }
        
        return Promise<Void> { fulfill, reject in
            firstly { () -> Promise<ActionResult?> in
                let action = StyleAssemblyAction.createStyleWithStylesheets(stylesheets: stylesheets, styleId: self.title).asyncAction
                return dispatcher.async(store: self.styleAssemblyStore, action: action)
            }.then { _ -> Void in
                assert(self.styleAssemblyStore.style.value != nil)
                self.computeStylePreview()
                fulfill(())
            }.catch { error in
                reject(error)
            }
        }
    }
    
    private func bindStylePreview() {

        // set initial value, we need to do this because styles that
        // are not applied to the text manager won't get their style preview
        // computed otherwise...
        self.stylePreview.setValue(stylePreview.value)
        styleAssemblyStore.stylePreview.subscribe({(stylePreview) in
            self.stylePreview.setValue(stylePreview)
        }, observer: self)
    }
    
    private func computeStylePreview() {

        let stylePreviewAction = StyleAssemblyAction.updateStylePreview
        assert(self.dispatcher != nil)
        self.dispatcher?.sync(store: self.styleAssemblyStore, action: stylePreviewAction.syncAction)
    }
}
