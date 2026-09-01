//
//  ResourceLayoutManager.swift
//  Nebula Writer
//
//  Created by Sebastien hamel on 2015-08-31.
//  Copyright (c) 2015 Nebula Media. All rights reserved.
//

import Foundation

#if os(OSX)
    import Cocoa
#elseif os(iOS)
    import UIKit
#endif

#if os(OSX)
    public typealias PlateformLayoutManagerType = NSLayoutManager
#else
    public typealias PlateformLayoutManagerType = NSLayoutManager
#endif

public final class ResourceLayoutManager: PlateformLayoutManagerType {
    
    weak var resourceTextStorage: ResourceTextStorage?
    
    public override init() {
        
        super.init()
        
        self.allowsNonContiguousLayout = true
    }
    
    required public init?(coder: NSCoder) {
        
        super.init(coder: coder)
    }
    
}
