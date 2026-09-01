//
//  SplineInterpolation.swift
//  Common
//
//  Created by Sébastien Hamel on 2017-12-10.
//  Copyright © 2017 NM. All rights reserved.
//

import Foundation

/// see https://gist.github.com/lecho/7627739
public struct SplineInterpolator {
    
    private let mX: Array<CGFloat>
    private let mY: Array<CGFloat>
    private let mM: Array<CGFloat>
    
    private init(x: Array<CGFloat>, y: Array<CGFloat>, m: Array<CGFloat>) {
    
        self.mX = x
        self.mY = y
        self.mM = m
    }
    
    ///
    /// Simple Spline that with no monotonic warantie
    ///
    public static func CubicSpline(x: [CGFloat], y: [CGFloat]) -> SplineInterpolator? {
        
        if let (_, m) = SplineInterpolator.dm(x: x, y: y) {
            
            return SplineInterpolator(x: x, y: y, m: m)
        }
        return nil
    }
    
    ///
    /// Creates a monotone cubic spline from a given set of control points.
    ///
    /// The spline is guaranteed to pass through each control point exactly.
    /// Moreover, assuming the control points are
    /// monotonic (Y is non-decreasing or non-increasing) then the interpolated
    /// values will also be monotonic.
    ///
    /// This function uses the Fritsch-Carlson method for computing the spline parameters.
    /// http://en.wikipedia.org/wiki/Monotone_cubic_interpolation
    ///
    /// @param x: The X component of the control points, strictly increasing.
    /// @param y: The Y component of the control points
    ///
    ///
    /// @throws IllegalArgumentException
    /// if the X or Y arrays are null, have different lengths or have fewer than 2 values.
    ///
    public static func MonotoneCubicSpline(x: [CGFloat], y: [CGFloat]) -> SplineInterpolator? {
        
        if var (d, m) = SplineInterpolator.dm(x: x, y: y) {
        
            let n = x.count
            
            // Update the tangents to preserve monotonicity.
            for i in 0..<n-1 {
                
                if d[i] == 0.0 { // successive Y values are equal
                
                    m[i] = 0.0
                    m[i + 1] = 0.0
                    
                }
                else {
                    
                    let a = m[i] / d[i]
                    let b = m[i + 1] / d[i]
                    let h = hypot(a, b)
                    if h > 9.0 {
                        let t = 3.0 / h
                        m[i] = t * a * d[i]
                        m[i + 1] = t * b * d[i]
                    }
                }
            }
            return SplineInterpolator(x: x, y: y, m: m)
        }
        
        return nil
    }
    
    private static func dm(x: [CGFloat], y: [CGFloat]) -> (d: [CGFloat], m: [CGFloat])? {
        
        if x.count != y.count || x.count < 2 {
            return nil
        }
        
        let n = x.count
        var d = [CGFloat](repeating: CGFloat.nan, count: n - 1)  // float[n - 1]; // could optimize this out
        var m = [CGFloat](repeating: CGFloat.nan, count: n) //float[n];
        
        // Compute slopes of secant lines between successive points.
        // for (int i = 0; i < n - 1; i++) {
        for i in 0..<n-1 {
            
            // float h = x.get(i + 1) - x.get(i);
            let h = x[i + 1] - x[i]
            if h <= CGFloat(0) {
                return nil
            }
            // d[i] = (y.get(i + 1) - y.get(i)) / h;
            d[i] = (y[i + 1] - y[i])/h
        }
        
        // Initialize the tangents as the average of the secants.
        m[0] = d[0]
        //for (int i = 1; i < n - 1; i++) {
        for i in 1..<n-1 {
            m[i] = (d[i - 1] + d[i]) * 0.5
        }
        m[n - 1] = d[n - 2]
        
        return (d, m)
    }
    
    /**
     * Interpolates the value of Y = f(X) for given X. Clamps X to the domain of the spline.
     *
     * @param x
     *            The X value.
     * @return The interpolated Y = f(X) value.
     */
    public func interpolate(x: CGFloat) -> CGFloat {
    
        // Handle the boundary cases.
        let n: Int = mX.count
        
        if x.isNaN {
            return x
        }
        if x <= mX[0] {
            return mY[0]
        }
        if x >= mX[n - 1] {
            return mY[n - 1]
        }
    
        // Find the index 'i' of the last point with smaller X.
        // We know this will be within the spline due to the boundary tests.
        var i: Int = 0
        while x >= mX[i + 1] {
            i += 1
            
            if x == mX[i] {
                return mY[i]
            }
        }
    
        // Perform cubic Hermite spline interpolation.
        let h: CGFloat = mX[i + 1] - mX[i]
        let t: CGFloat = (x - mX[i]) / h
        
//        return (mY[i] * (1 + 2 * t) + h * mM[i] * t) * (1 - t) * (1 - t) + (mY[i + 1] * (3 - 2 * t) + h * mM[i + 1] * (t - 1)) * t * t
        
        return (mY[i] * (1 + 2 * t) + h * mM[i] * t) * (1 - t) * (1 - t)
            + (mY[i + 1] * (3 - 2 * t) + h * mM[i + 1] * (t - 1)) * t * t;
    }
    
    // For debugging.
    public func toString() -> String {
        
        var str: String = ""
        
        let n: Int = mX.count
        str += "["

        for i in 0..<n {
        
            if i != 0 {
                str += ", "
            }
            str += "(\(mX[i])"
            str += ", \(mY[i])"
            str += ": \(mM[i]))"
        }
        str += "]"
        return str
    }
}
