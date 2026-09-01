//
//  CustomPropertyContainer.swift
//  Web
//
//  Created by Sebastien Hamel on 2020-10-21.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

protocol CustomPropertyContainer {
    
    var localPropertiesDirectedDependencyGraph: [String: DependencyNode]? { get }
    
    func customPropertiesInsideOutsideCycles(fromdirectedDependencyGraph directedDependencyGraph: [String: DependencyNode]) -> (in: Set<String>, out: Set<String>)
    
}
