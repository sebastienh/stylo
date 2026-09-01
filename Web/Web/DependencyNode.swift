//
//  DependencyNode.swift
//  Web
//
//  Created by Sebastien Hamel on 2020-08-12.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation


class DependencyNode: Hashable {

    enum VisitedState {
        case visited
        case visiting
        case pending
    }
    
    /// Contains an ordered from primary, to defaulting values
    /// of variable names.
    let name: String
    
    var hasEmptyDependenciesDependencies: Bool {
        
        guard self.dependencies.isEmpty else {
            return true
        }
        
        for dependency in dependencies {
            if !dependency.dependencies.isEmpty {
                return false
            }
        }
        return true
    }
    
    var dependencies: Set<DependencyNode>
    
    var visitedState: VisitedState = .pending
    
    init(name: String) {
        self.name = name
        self.dependencies = []
    }
    
    func addDependency(to dependencyNode: DependencyNode) {
        
        self.dependencies.insert(dependencyNode)
    }
    
    static func == (lhs: DependencyNode, rhs: DependencyNode) -> Bool {
        if lhs.name != rhs.name {
            return false
        }
        return true
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
