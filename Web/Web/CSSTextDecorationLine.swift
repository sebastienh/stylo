//
//  CSSTextDecorationLine.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-29.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

public struct CSSTextDecorationLine {
    
    static var defaultValue: CSSTextDecorationLine {
        
        var textDecorationLine = CSSTextDecorationLine()
        textDecorationLine.addTextDecorationLineType(CSSTextDecorationLineType.noUnderline)
        return textDecorationLine
    }
    
    public var length: Int {
        
        return textDecorationLineArray.count
    }
    
    var textDecorationLineArray: [CSSTextDecorationLineType]
    
    init() {
        
        self.textDecorationLineArray = [CSSTextDecorationLineType]()
    }
    
    mutating func addTextDecorationLineType(_ type: CSSTextDecorationLineType) {
        
        textDecorationLineArray.append(type)
    }
}
