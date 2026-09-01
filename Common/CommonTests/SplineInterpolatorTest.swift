//
//  SplineInterpolatorTest.swift
//  Common
//
//  Created by Sébastien Hamel on 2017-12-11.
//  Copyright © 2017 NM. All rights reserved.
//

import XCTest
@testable import Common

class SplineInterpolatorTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSimpleCubicSplineBaseValues() {
        
        let x: [CGFloat] = [1.0, 2.0, 3.0]
        let y: [CGFloat] = [1.0, 2.0, 3.0]
        
        if let spline = SplineInterpolator.CubicSpline(x: x, y: y) {
            
            let interpolatedY1 = spline.interpolate(x: 1.0)
            let interpolatedY2 = spline.interpolate(x: 2.0)
            let interpolatedY3 = spline.interpolate(x: 3.0)
            
            XCTAssert(interpolatedY1 == CGFloat(1.0), "Received: \(interpolatedY1)")
            XCTAssert(interpolatedY2 == CGFloat(2.0), "Received: \(interpolatedY2)")
            XCTAssert(interpolatedY3 == CGFloat(3.0), "Received: \(interpolatedY3)")
        }
        else {
            XCTAssert(false, "nil spline interpolator")
        }
    }
    
    func testSimpleCubicSpline() {
        
        let x: [CGFloat] = [1.0, 2.0, 3.0]
        let y: [CGFloat] = [1.0, 2.0, 3.0]
        
        if let spline = SplineInterpolator.CubicSpline(x: x, y: y) {
        
            let interpolatedY = spline.interpolate(x: 1.5)
        
            XCTAssert(interpolatedY == 1.5)
        }
        else {
            XCTAssert(false, "nil spline interpolator")
        }
    }

    func testSimpleCubicSpline2() {
        
        let x: [CGFloat] = [1.0, 2.0, 3.0]
        let y: [CGFloat] = [1.0, 2.0, 3.0]
        
        if let spline = SplineInterpolator.CubicSpline(x: x, y: y) {
            
            let interpolatedY = spline.interpolate(x: 1.4)
            
            XCTAssert(interpolatedY == CGFloat(1.4), "Received: \(interpolatedY)")
        }
        else {
            XCTAssert(false, "nil spline interpolator")
        }
    }
    
    func testSimpleCubicSpline4() {
        
        let x: [CGFloat] = [420.0, 480.0, 540.0, 600.0, 660.0]
        let y: [CGFloat] = [333.7659574468085, 383.55319148936167, 461.13043478260869, 512.3478260869565, 564.39130434782612]
        
        if let spline = SplineInterpolator.CubicSpline(x: x, y: y) {
            
            let interpolatedY = spline.interpolate(x: 542.74449041292064)
            
            debugPrint("y[3]: \(y[2])")
            debugPrint("y[4]: \(y[3])")
            
            XCTAssert(interpolatedY >= y[2] && interpolatedY <= y[3], "Received: \(interpolatedY)")
        }
        else {
            XCTAssert(false, "nil spline interpolator")
        }
    }
    
    func testSimpleCubicCrossing() {
        
        let x: [CGFloat] = [0.0, 1.0, 2.0, 3.0, 4.0]
        let y: [CGFloat] = [4.0, 1.1, 5.0, 3.0, 8.0]
        
        let x2: [CGFloat] =     [1.0, 2.0, 3.0, 4.0, 5.0]
        let y2: [CGFloat] =     [1.1, 5.0, 3.0, 8.0, 10.0]
        
        if let spline = SplineInterpolator.CubicSpline(x: x, y: y) {
            
            if let spline2 = SplineInterpolator.CubicSpline(x: x2, y: y2) {
                
                let interpolatedY1 = spline.interpolate(x: 2.5)
                let interpolatedY2 = spline2.interpolate(x: 2.5)
                
                debugPrint("value: \(interpolatedY2)")
                
                XCTAssert(interpolatedY1 == interpolatedY2, "Received: \(interpolatedY1) and \(interpolatedY2)")
            }
        }
        else {
            XCTAssert(false, "nil spline interpolator")
        }
    }
    
    func testSimpleCubicCrossing2() {
        
        let x: [CGFloat] = [1.0, 2.0, 3.0]
        let y: [CGFloat] = [1.1, 5.0, 3.0]
        
        let x2: [CGFloat] =     [2.0, 3.0, 4.0]
        let y2: [CGFloat] =     [5.0, 3.0, 8.0]
        
        if let spline = SplineInterpolator.CubicSpline(x: x, y: y) {
            
            if let spline2 = SplineInterpolator.CubicSpline(x: x2, y: y2) {
                
                let interpolatedY1 = spline.interpolate(x: 2.5)
                let interpolatedY2 = spline2.interpolate(x: 2.5)
                
                debugPrint("value: \(interpolatedY2)")
                
                XCTAssert(interpolatedY1 != interpolatedY2, "Received: \(interpolatedY1) and \(interpolatedY2)")
            }
        }
        else {
            XCTAssert(false, "nil spline interpolator")
        }
    }
    
    func testSimpleCubicCrossing3() {
        
        let x: [CGFloat] = [0.0, 1.0, 2.0, 3.0, 4.0]
        let y: [CGFloat] = [4.0, 1.1, 5.0, 3.0, 8.0]
        
        let x2: [CGFloat] =     [1.0, 2.0, 3.0, 4.0, 5.0]
        let y2: [CGFloat] =     [1.1, 5.0, 3.0, 8.0, 10.0]
        
        let x3: [CGFloat] =          [2.0, 3.0, 4.0, 5.0, 6.0]
        let y3: [CGFloat] =          [5.0, 3.0, 8.0, 10.0, 20.0]
        
        if let spline = SplineInterpolator.CubicSpline(x: x, y: y) {
            
            if let spline2 = SplineInterpolator.CubicSpline(x: x2, y: y2) {
                
                let interpolatedY1 = spline.interpolate(x: 2.5)
                let interpolatedY2 = spline2.interpolate(x: 2.5)
                
                debugPrint("value: \(interpolatedY2)")
                
                XCTAssert(interpolatedY1 == interpolatedY2, "Received: \(interpolatedY1) and \(interpolatedY2)")
                
                if let spline3 = SplineInterpolator.CubicSpline(x: x3, y: y3) {
                
                    let interpolatedY22 = spline2.interpolate(x: 3.2)
                    let interpolatedY3 = spline3.interpolate(x: 3.2)
                    
                    debugPrint("value: \(interpolatedY22)")
                    
                    XCTAssert(interpolatedY3 == interpolatedY22, "Received: \(interpolatedY3) and \(interpolatedY22)")
                }
            }
        }
        else {
            XCTAssert(false, "nil spline interpolator")
        }
    }
    
    func testPerformanceExample() {
        
        let x: [CGFloat] = [1.0, 2.0, 3.0]
        let y: [CGFloat] = [1.0, 2.0, 3.0]
        
        // This is an example of a performance test case.
        self.measure {
            
            for _ in 0..<1000 {
            
                if let spline = SplineInterpolator.CubicSpline(x: x, y: y) {
                    
                    let interpolatedY = spline.interpolate(x: 1.4)
                }
            }
        }
    }

}
