//
//  SourceSetManagerProtocol.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-08-31.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import Common

public protocol SourceSetManagerProtocol {
    
    var textManagers: DynamicArray<String> { get }
    
    func contentManager(withId id: String) -> ContentManager?
}

extension SourceSetManager: SourceSetManagerProtocol {
    
    public var textManagers: DynamicArray<String> {
     
        return _textManagers
    }
    
    public func contentManager(withId id: String) -> ContentManager? {
        
        guard let directoryItemManager = self.directoryItemManager(withId: id) else {
            // no assertion: this case is possible when unsubscribing and the
            // content has already been released.
            return nil
        }
        
        guard let contentManager = directoryItemManager as? ContentManager else {
            assertionFailure("Error: directoryItemManager is not ContentManager")
            return nil
        }
        return contentManager
    }
}
