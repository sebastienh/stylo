//
//  DeclarationStopIndex.swift
//  Web
//
//  Created by Sebastien Hamel on 2021-01-18.
//  Copyright © 2021 Textually Inc. All rights reserved.
//

import Foundation

public enum DeclarationStopIndex {
    
    case endOfDeclaration(index: Int)
    case endOfStyleDeclarationBloc(index: Int)
    
    public var isEndOfDeclaration: Bool {
        switch self {
        case .endOfDeclaration:
            return true
        case .endOfStyleDeclarationBloc:
            return false
        }
    }
    
    public var isEndOfStyleDeclarationBloc: Bool {
        switch self {
        case .endOfDeclaration:
            return false
        case .endOfStyleDeclarationBloc:
            return true
        }
    }
    
    public func with(indexVariation variation: Int) -> DeclarationStopIndex {
        switch self {
        case .endOfDeclaration(let index):
            return .endOfDeclaration(index: index + variation)
        case .endOfStyleDeclarationBloc(let index):
            return .endOfStyleDeclarationBloc(index: index + variation)
        }
    }
    
    public var index: Int {
        switch self {
        case .endOfDeclaration(let index):
            return index
        case .endOfStyleDeclarationBloc(let index):
            return index
        }
    }
}
