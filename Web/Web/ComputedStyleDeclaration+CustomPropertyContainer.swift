//
//  ComputedStyleDeclaration+CustomProperty.swift
//  Web
//
//  Created by Sebastien Hamel on 2020-10-21.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Common

extension RawComputedStyle: CustomPropertyContainer {
    
    ///
    /// This property returns an dictionary with an
    /// entry for all distinct local properties, with
    /// priority given to the last one, like it would
    /// be for other CSS normal properties.
    ///
    private var localProperties: [String: DependencyNode] {
        
        var localProperties: [String: DependencyNode] = [:]
        
        for (name, _) in self.propertyValues {
            
            // if a same property is defined mutliple times
            // we only consider the last one, as it is with CSS
            // normal properties.
            localProperties[name] = DependencyNode(name: name)
        }
        return localProperties
    }
    
    ///
    /// > For each element, create a directed dependency graph,
    /// > containing nodes for each custom property. If the value of a custom property
    /// > prop contains a var() function referring to the property var (including in the
    /// > fallback argument of var()), add an edge between prop and the var.
    /// >
    /// > Edges are possible from a custom property to itself.
    ///
    /// > If there is a cycle in the dependency graph, all the custom properties
    /// > in the cycle are cyclic at computed-value time, and must compute to the
    /// > guaranteed-invalid value.
    ///
    /// from: [css-variables](https://drafts.csswg.org/css-variables/#cycles)
    ///
    ///
    var localPropertiesDirectedDependencyGraph: [String: DependencyNode]? {
        
        let localProperties = self.localProperties
        
        guard !localProperties.isEmpty else {
            // if localCustomProperties is empty we dont need to do anything
            return nil
        }
        
        // since we can have more than one time the same property defined
        // we need to ensure that we do not update the dependencies graph
        // for already treated properties.
        var updatedProperties = Set<String>()
        
        // going in reverse ensures that we priorize the last defined
        // property declaration over the first one.
        for (name, propertyValueContainer) in self.propertyValues.reversed() {
            guard let propertyDeclaration = propertyValueContainer.customValueDeclaration else {
                continue
            }
            if !updatedProperties.contains(name) {
                propertyDeclaration.updateLocalDependenciesGraph(fromLocalProperties: localProperties)
                updatedProperties.insert(name)
            }
        }
        return localProperties
    }
    
    func customPropertiesInsideOutsideCycles(fromdirectedDependencyGraph directedDependencyGraph: [String: DependencyNode]) -> (in: Set<String>, out: Set<String>) {
        
        return dfsVisit(directedDependencyGraph: directedDependencyGraph)
    }
    
    private func dfsVisit(directedDependencyGraph: [String: DependencyNode]) -> (in: Set<String>, out: Set<String>) {

        var containsCycle: Bool = false
        let dependenciesNodes = directedDependencyGraph.map { (arg) -> DependencyNode in
            return arg.value
        }
        var unvisitedNodes = Set<DependencyNode>(dependenciesNodes)
        var inCycle = Set<String>()
        let complete = Set<String>(dependenciesNodes.map { (dependencyNode) -> String in
            return dependencyNode.name
        })
        
        while let unvisitedDependency = unvisitedNodes.first {
            var cycle: Bool = false
            dfsVisit(dependencyNode: unvisitedDependency, cycle: &cycle, unvisitedNodes: &unvisitedNodes, inCycle: &inCycle, directedDependencyGraph: directedDependencyGraph)
            containsCycle = containsCycle || cycle
        }
        
        return (inCycle, complete.symmetricDifference(inCycle))
    }
    
    private func dfsVisit(dependencyNode: DependencyNode, cycle: inout Bool, unvisitedNodes: inout Set<DependencyNode>, inCycle: inout Set<String>, directedDependencyGraph: [String: DependencyNode]) {
        
        dependencyNode.visitedState = .visiting
        unvisitedNodes.remove(dependencyNode)
        
        for dependency in dependencyNode.dependencies {
            if dependency.visitedState == .pending {
                dfsVisit(dependencyNode: dependency, cycle: &cycle, unvisitedNodes: &unvisitedNodes, inCycle: &inCycle, directedDependencyGraph: directedDependencyGraph)
            }
            else if dependency.visitedState == .visiting {
                
                let visitingNodes = directedDependencyGraph.compactMap { (arg) -> String? in
                    if arg.value.visitedState == .visiting {
                        return arg.key
                    }
                    return nil
                }
                inCycle.formUnion(visitingNodes)
                cycle = true
            }
            else if inCycle.contains(dependency.name) {
                inCycle.insert(dependencyNode.name)
            }
        }
        
        dependencyNode.visitedState = .visited
    }
    
}

extension CSSStyleDeclaration: CustomPropertyContainer {
    
    ///
    /// This property returns an dictionary with an
    /// entry for all distinct local properties, with
    /// priority given to the last one, like it would
    /// be for other CSS normal properties.
    ///
    private var localProperties: [String: DependencyNode] {
        
        var localProperties: [String: DependencyNode] = [:]
        
        for (name, _) in self.propertyValues {
            
            // if a same property is defined mutliple times
            // we only consider the last one, as it is with CSS
            // normal properties.
            localProperties[name] = DependencyNode(name: name)
        }
        return localProperties
    }
    
    ///
    /// > For each element, create a directed dependency graph,
    /// > containing nodes for each custom property. If the value of a custom property
    /// > prop contains a var() function referring to the property var (including in the
    /// > fallback argument of var()), add an edge between prop and the var.
    /// >
    /// > Edges are possible from a custom property to itself.
    ///
    /// > If there is a cycle in the dependency graph, all the custom properties
    /// > in the cycle are cyclic at computed-value time, and must compute to the
    /// > guaranteed-invalid value.
    ///
    /// from: [css-variables](https://drafts.csswg.org/css-variables/#cycles)
    ///
    ///
    var localPropertiesDirectedDependencyGraph: [String: DependencyNode]? {
        
        let localProperties = self.localProperties
        
        guard !localProperties.isEmpty else {
            // if localCustomProperties is empty we dont need to do anything
            return nil
        }
        
        // since we can have more than one time the same property defined
        // we need to ensure that we do not update the dependencies graph
        // for already treated properties.
        var updatedProperties = Set<String>()
        
        // going in reverse ensures that we priorize the last defined
        // property declaration over the first one.
        for (name, propertyValueContainer) in self.propertyValues.reversed() {
            guard let propertyDeclaration = propertyValueContainer.customValueDeclaration else {
                continue
            }
            if !updatedProperties.contains(name) {
                propertyDeclaration.updateLocalDependenciesGraph(fromLocalProperties: localProperties)
                updatedProperties.insert(name)
            }
        }
        return localProperties
    }
    
    func customPropertiesInsideOutsideCycles(fromdirectedDependencyGraph directedDependencyGraph: [String: DependencyNode]) -> (in: Set<String>, out: Set<String>) {
        
        return dfsVisit(directedDependencyGraph: directedDependencyGraph)
    }
    
    private func dfsVisit(directedDependencyGraph: [String: DependencyNode]) -> (in: Set<String>, out: Set<String>) {

        var containsCycle: Bool = false
        let dependenciesNodes = directedDependencyGraph.map { (arg) -> DependencyNode in
            return arg.value
        }
        var unvisitedNodes = Set<DependencyNode>(dependenciesNodes)
        var inCycle = Set<String>()
        let complete = Set<String>(dependenciesNodes.map { (dependencyNode) -> String in
            return dependencyNode.name
        })
        
        while let unvisitedDependency = unvisitedNodes.first {
            var cycle: Bool = false
            dfsVisit(dependencyNode: unvisitedDependency, cycle: &cycle, unvisitedNodes: &unvisitedNodes, inCycle: &inCycle, directedDependencyGraph: directedDependencyGraph)
            containsCycle = containsCycle || cycle
        }
        
        return (inCycle, complete.symmetricDifference(inCycle))
    }
    
    private func dfsVisit(dependencyNode: DependencyNode, cycle: inout Bool, unvisitedNodes: inout Set<DependencyNode>, inCycle: inout Set<String>, directedDependencyGraph: [String: DependencyNode]) {
        
        dependencyNode.visitedState = .visiting
        unvisitedNodes.remove(dependencyNode)
        
        for dependency in dependencyNode.dependencies {
            if dependency.visitedState == .pending {
                dfsVisit(dependencyNode: dependency, cycle: &cycle, unvisitedNodes: &unvisitedNodes, inCycle: &inCycle, directedDependencyGraph: directedDependencyGraph)
            }
            else if dependency.visitedState == .visiting {
                
                let visitingNodes = directedDependencyGraph.compactMap { (arg) -> String? in
                    if arg.value.visitedState == .visiting {
                        return arg.key
                    }
                    return nil
                }
                inCycle.formUnion(visitingNodes)
                cycle = true
            }
            else if inCycle.contains(dependency.name) {
                inCycle.insert(dependencyNode.name)
            }
        }
        
        dependencyNode.visitedState = .visited
    }
    
}
