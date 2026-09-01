//
//  TemplateStore.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-08-07.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Common
import PromiseKit
import Igloo
import Web
import Stencil

public typealias TemplateId = String

public final class TemplateStore: Store, IdentifiableStoreType {
    
    public var reducer: TemplateReducer
    
    public typealias ReducerType = TemplateReducer
    
    var templates: [TemplateId: Template]
    
    public var environment: Dynamic<Environment?> = Dynamic<Environment?>(nil)
    
    /// Unique identifier
    public let identifier: String = UUID().uuidString
    
    init() {
        
        self.reducer = TemplateReducer(storeIdentifier: identifier)
        self.templates = [TemplateId: Template]()
    }
    
}
