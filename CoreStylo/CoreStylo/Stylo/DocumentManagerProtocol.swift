//
//  DocumentManagerProtocol.swift
//  CoreStylo
//
//  Created by Sebastien hamel on 2019-08-31.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Foundation

public protocol DocumentManagerProtocol {
    
    associatedtype SourceSetType: SourceSetManagerProtocol
    
    var documentUrl: URL { get }
    
    var sourceSetManager: SourceSetType? { get }
}
