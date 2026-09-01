//
//  MarkdownDocumentStore.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-08-31.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Web
import Markdown
import Common
import PromiseKit
import Igloo
import WebKit 

public final class MarkdownDocumentStore: Store, IdentifiableStoreType, EditableStoreType, DocumentStoreType, StatisticallyAnalysableStore {
    
    /// Unique identifier
    public let identifier: String
    
    /// Reference to the associated reducer
    public var reducer: MarkdownDocumentReducer
    
    var disabled: Bool
    
    // Could change, we need to make sure an action is proided
    // to change this value.
    var markdownPresetName: String
    
    /// queues on which we access the document, it is defined here
    /// because we may need to queue to provide read access to the document
    /// from outside the local Reducer
    var serialCompilationQueue: DispatchQueue {
        return reducer.serialCompilationQueue
    }
    
    let ext: Dynamic<String>
    
    let name: Dynamic<String>
    
    public let parentID: Dynamic<String>
    
    public let pathComponents: DynamicArray<String>
    
    public let document = Dynamic<Document?>(nil)
    
    init(identifier: String, markdownPresetName: String = "all-available", name: String, parentId: String) {
        
        self.identifier = identifier
        self.markdownPresetName = markdownPresetName
        self.env = StyloMarkdownEnv()
        self.disabled = false
        self.reducer = MarkdownDocumentReducer(storeIdentifier: identifier)
        self.ext = Dynamic<String>("md")
        self.name = Dynamic<String>(name)
        self.parentID = Dynamic<String>(parentId)
        self.pathComponents = DynamicArray<String>()
    }
    
    init(fileMetadata: FileMetadata, name: String, parentId: String) {
        
        self.identifier = fileMetadata.id
        self.markdownPresetName = "all-available"
        self.env = StyloMarkdownEnv()
        self.disabled = false
        self.reducer = MarkdownDocumentReducer(storeIdentifier: identifier)
        self.name = Dynamic<String>(name)
        self.ext = Dynamic<String>("md")
        self.parentID = Dynamic<String>(parentId)
        self.pathComponents = DynamicArray<String>()
    }
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EditableStoreType protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public let sourceString: Dynamic<String?> = Dynamic<String?>(nil)
    
    public var editingChanges = DynamicArray<SourceStringChangeDescription>()
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: MarkdownStoreState protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /// the result of the previous tokens evaluation
    var markdownTokens: Tokens? = Tokens()
    
    /// previous markdown references to move from the old MarkdownParser
    /// to the new parser and any other information that we may want to pass
    /// from one compilation to the next.
    var env: StyloMarkdownEnv?
    
    // [Node: [String: Set<String>]]
    public let nodesAttributes = DynamicDictionary<Node, [String: Set<String>]>()
    
    public var tokensAttributes = Dynamic<[AttributeTagInputSection : Set<AttributeTagInputItem>]?>(nil)
    
    public let coalescedAttributes = DynamicDictionary<String, Set<String>>()
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: StatisticallyAnalysableStore protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    var totalStatistics: Dynamic<TextStatistics?> = Dynamic<TextStatistics?>(nil)
    
    var sessionStatistics: Dynamic<TextStatistics?> = Dynamic<TextStatistics?>(nil)
    
    var sessionStartDate: Dynamic<Date?> = Dynamic<Date?>(nil)
    
    var writingSessions: Dynamic<Array<WritingSession>> = Dynamic<Array<WritingSession>>([])
    
    var writingSessionHidden: Dynamic<Bool?> = Dynamic<Bool?>(nil)
    
    var textStatisticsQueue: DispatchQueue {
        return reducer.serialQueue
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: HtmlPreviewableStoreType protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public var htmlPreviewVisible: Dynamic<Bool> = Dynamic<Bool>(false)
    
    // html preview support
    public var htmlPreviewStyle: Dynamic<CSSStyle?> = Dynamic<CSSStyle?>(nil)
    
    public var htmlPreviewString: Dynamic<String?> = Dynamic<String?>(nil)
    
    // scrolling support
    
    public var htmlPreviewBackgroundColor = Dynamic<PlateformColorType?>(nil)
    
    public var domDocument: Dynamic<DOMDocument?> = Dynamic<DOMDocument?>(nil)
}
