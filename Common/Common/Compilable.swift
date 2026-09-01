//
//  Compilable.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-06-05.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

public protocol Compilable: class {
    
    associatedtype LanguageObjectType : LanguageObject
    
    var minimalCompilationUnit: LanguageObjectType { get }
    
}
