//
//  Regionalisable.swift
//  Common
//
//  Created by Sébastien Hamel on 2015-11-10.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation

public protocol Regionalisable: class {
    
    var sourceStringRegion: SourceStringRegion { get set }
    
    func addSourceStringSegment(_ sourceStringSegment: SourceStringSegment)
}

public extension Regionalisable {
    

}
