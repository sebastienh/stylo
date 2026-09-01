//
//  EditableReducerType.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-08-13.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Common
import Igloo
import PromiseKit

extension SourceStringChangeDescription {
    
    var edit: Edit {
        
        return Edit.with {
         
            $0.range = self.range.editRange
            
            let stringReplacement = self.stringReplacement
            
            assert(stringReplacement != nil)
            if let stringReplacement = stringReplacement {
                $0.replacementString = stringReplacement
            }
        }
    }
}

extension NSRange {
    
    var editRange: EditRange {
        
        return EditRange.with {
            
            $0.location = UInt32(self.location)
            $0.length = UInt32(self.length)
        }
    }
}

public protocol EditableReducerType {
    
    func updateSourceString<S: Store & EditableStoreType>(in store: S, string: String) -> Promise<Void>
    
    func saveEditingChange<S: Store & EditableStoreType>(description: SourceStringChangeDescription, in store: S)
    
    func saveEditingChange<S: Store & EditableStoreType>(string: String, in store: S)
    
}

extension EditableReducerType {
    
    public func updateSourceString<S: Store & EditableStoreType>(in store: S, string: String) -> Promise<Void> {
        
        return Promise<Void> { fulfill, reject in
            
            // update the sourceString value
            store.sourceString.setValue(string)
            fulfill(())
        }
    }
    
    
    public func saveEditingChange<S: Store & EditableStoreType>(description: SourceStringChangeDescription, in store: S) {
        
        store.editingChanges.append(description)
    }
    
    public func saveEditingChange<S: Store & EditableStoreType>(string: String, in store: S) {
        
        let description = SourceStringChangeDescription(range: NSMakeRange(0,0), stringReplacement: string, changeLength: string.utf16.count, targetString: NSMutableAttributedString(string: string))
        
        store.editingChanges.append(description)
    }
    
}
