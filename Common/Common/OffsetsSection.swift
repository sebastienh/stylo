//
//  OffsetsSection.swift
//  Common
//
//  Created by Sébastien Hamel on 2017-12-17.
//  Copyright © 2017 NM. All rights reserved.
//

import Foundation

public struct OffsetsSection {
    
    private let splineInterpolator: SplineInterpolator
    
    private let origins: [CGFloat]
    private let offsets: [CGFloat]
    
    init(origins: [CGFloat], offsets: [CGFloat]) {
        
        self.origins = origins
        self.offsets = offsets
        self.splineInterpolator = SplineInterpolator.CubicSpline(x: origins, y: offsets)!
    }
    
    func offset(at origin: CGFloat) -> CGFloat {
        
        return self.splineInterpolator.interpolate(x: origin)
    }
}
