//
//  CSSOMLanguageObject+AncestorsSetConstructor.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-05-29.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common

extension CSSOMLanguageObject : CommonAncestorsSetConstructor {
    
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CommonAncestorsSetConstructor protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public typealias AncestorType = CSSOMLanguageObject
    
    public func buildInitialCommonAncestorSet() -> Set<AncestorSetItem<CSSOMLanguageObject>> {
        
        var set = Set<AncestorSetItem<CSSOMLanguageObject>>()
        
        var order: Int = 0
        
        var currentParent: CSSOMLanguageObject? = self.parent
        
        while let _currentParent = currentParent {
            
            var item = AncestorSetItem<CSSOMLanguageObject>(ancestor: _currentParent)
            item.cumulatedOrder = order
            
            set.insert(item)
            
            order += 1
            currentParent = _currentParent.parent
        }
     
        return set
    }
    
    public func buildCommonAncestorsSet(_ set: inout Set<AncestorSetItem<CSSOMLanguageObject>>){
        
        var order: Int = 0
        
        var currentParent: CSSOMLanguageObject? = self.parent
        
        while let _currentParent = currentParent {
            
            let item = AncestorSetItem<CSSOMLanguageObject>(ancestor: _currentParent)
            
            if set.contains(item) {
                
                let index = set.index(of: item)
                
                var existingItem = set[index!]
                
                existingItem.increaseCumulatedOrder(order)
            }
            else {
                
                set.remove(item)
            }
            
            order += 1
            currentParent = _currentParent.parent
        }
    }
    
}
