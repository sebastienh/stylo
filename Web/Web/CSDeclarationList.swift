//
//  CSDeclarationList.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-09-26.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation

final class CSDeclarationList: CSLanguageObject {
    
    var declarations: [Declaration]
    
    init() {
        
        self.declarations = [Declaration]()
        
        super.init(sourceStringSegment: nil)
    }
    
    func addDeclaration(_ declaration: Declaration) {
        
        declarations.append(declaration)
    }
    
}
