//
//  AutocompleteEntry.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2016-02-13.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation
import Common

final class AutocompleteEntry: NSObject {

    @objc dynamic var hidden: Bool
    
    var selected: Bool
    
    @objc dynamic var name: String {
        
        return entry.key!
    }
    
    @objc dynamic var desc: String {
        
        return entry.data!.desc
    }
    
    var entry: TstDictionaryEntry<CompletionValue>
    
    init(entry: TstDictionaryEntry<CompletionValue>, hidden: Bool = true, selected: Bool = false) {
        
        self.entry = entry
        self.hidden = hidden
        self.selected = selected
    }
}
