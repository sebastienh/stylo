//
//  CancellableVisitor.swift
//  Common
//
//  Created by Sébastien Hamel on 2015-11-13.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation

public protocol CancellableVisitor: Visitor {
    
    // FIXME: see below
//    typealias VisitableNodeType: Visitable
    
    var triggerOperation: Operation? { get } 

    func checkForCancellation() -> NodeInfoType?
    
    // FIXME: Should reintroduce the more complete function below
//    func checkForCancellation(visitableNode: VisitableNodeType) -> NodeInfoType?
}
