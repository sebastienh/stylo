//
//  CSComponentValueList.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-07-03.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation

final class CSComponentValueList: CSLanguageObject {
    
    var components: [CSComponentValue]
    
    init() {
        
        self.components = [CSComponentValue]()
        
        super.init(sourceStringSegment: nil)
    }
    
    func addDeclaration(_ component: CSComponentValue) {
        
        updateSourceStringSegment(with: component)
        components.append(component)
    }
    
    func updateSourceStringSegment(with component: CSComponentValue) {
        
        let componentSourceStringSegment = component.sourceStringSegment
        
        assert(componentSourceStringSegment != nil)
        if let componentSourceStringSegment = componentSourceStringSegment {
            
            if var sourceStringSegment = self.sourceStringSegment {
                
                assert(sourceStringSegment.endIndex.integerValue <= componentSourceStringSegment.endIndex.integerValue)
                sourceStringSegment.endIndex = componentSourceStringSegment.endIndex
                self.sourceStringSegment = sourceStringSegment
            }
        }
    }
    
    
}
