//
//  Scrollable.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-05-04.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import PromiseKit
import Common
import os

public protocol Scrollable {
    
    var numberOfTopElements: Promise<Int> { get }
    
    var scrollRatio: Promise<CGFloat> { get }
    
    var startBounds: Promise<NSRect> { get }
    
    var endBounds: Promise<NSRect?> { get }

    var currentScrollPosition: Promise<ScrollPosition?> { get }
    
    func scrollToCorrespondingScrollPosition(otherScrollPosition: ScrollPosition) -> Promise<Void>
    
    func scrollTo(point: NSPoint) -> Promise<Void>
    
    func boundsForElement(at index: Int) -> Promise<NSRect>
    
    func computeScrollPoint(fromScrollPosition scrollPosition: ScrollPosition) -> Promise<NSPoint>
    
}

extension Scrollable {
    
    @discardableResult
    public func scrollToCorrespondingScrollPosition(otherScrollPosition: ScrollPosition) -> Promise<Void> {
        
        return firstly {
            computeScrollPoint(fromScrollPosition: otherScrollPosition)
        }.then { point -> Promise<Void> in
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("computed scroll point is %@", log: Log.WriterCommon.all, type: .info, %%point)
            #endif
            return self.scrollTo(point: point)
        }.catch { error in
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Error: %@", log: Log.WriterCommon.all, type: .error, %%error)
            #endif
        }
    }
    
    @discardableResult
    public func computeScrollPoint(fromScrollPosition scrollPosition: ScrollPosition) -> Promise<NSPoint> {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Compute scroll point from other scroll position: %@", log: Log.WriterCommon.all, type: .info, %%scrollPosition)
        #endif
        
        return Promise<NSPoint> { fulfill, reject in
            
            switch scrollPosition {
                
            case .start(let ratio):
                
                firstly {
                    self.startBounds
                }.then { startBounds -> Void in
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("start -> startBounds: %@", log: Log.WriterCommon.all, type: .info, %%startBounds)
                    #endif
                    fulfill(NSMakePoint(0, startBounds.height*ratio))
                }.catch { error in
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("Error: %@", log: Log.WriterCommon.all, type: .error, %%error)
                    #endif
                    reject(error)
                }
                
            case .between(let first, let second, let ratio):
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("between firstBounds boundsForElement request in %@", log: Log.WriterCommon.all, type: .info, %%self)
                #endif
                
                firstly {
                    boundsForElement(at: first)
                }.then { firstBounds in
                    return Promise<(NSRect, NSRect)> { fulfill, reject in
                        
                        firstly {
                            self.boundsForElement(at: second)
                        }.then { secondBounds -> Void in
                            os_log("between -> firstBounds: %@", log: Log.WriterCommon.all, type: .info, %%firstBounds)
                            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                            os_log("between -> secondBounds: %@", log: Log.WriterCommon.all, type: .info, %%secondBounds)
                            #endif
                            fulfill((firstBounds, secondBounds))
                        }.catch{ error in
                            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                            os_log("Error: %@", log: Log.WriterCommon.all, type: .error, %%error)
                            #endif
                            reject(error)
                        }
                    }
                }.then { bounds -> Void in
                    
                    let (firstBounds, secondBounds) = bounds
                    let spaceBetween = firstBounds.maxY-secondBounds.minY
                    let ditance = spaceBetween*ratio
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("space between: %@", log: Log.WriterCommon.all, type: .info, %%spaceBetween)
                    #endif
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("ratio: %@", log: Log.WriterCommon.all, type: .info, %%ratio)
                    #endif
                    
                    let scrollPoint = NSMakePoint(0, firstBounds.maxY + ditance)
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("between -> scrollPoint: %@", log: Log.WriterCommon.all, type: .info, %%scrollPoint)
                    #endif
                    fulfill(scrollPoint)
                }.catch { error in
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("Error: %@", log: Log.WriterCommon.all, type: .error, %%error)
                    #endif
                    reject(error)
                }
                
            case .inside(let index, let ratio):
            
                firstly {
                    boundsForElement(at: index)
                }.then { bounds -> Void in
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("inside -> bounds: %@", log: Log.WriterCommon.all, type: .info, %%bounds)
                    #endif
                    let distance = bounds.height*ratio
                    let scrollPoint = NSMakePoint(0, bounds.minY + distance)
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("inside -> scrollPoint: %@", log: Log.WriterCommon.all, type: .info, %%scrollPoint)
                    #endif
                    fulfill(scrollPoint)
                }.catch { error in
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("Error: %@", log: Log.WriterCommon.all, type: .error, %%error)
                    #endif
                    reject(error)
                }
                
            case .end(let ratio):
                
                firstly {
                    self.endBounds
                }.then { endBounds -> Void in
                    if let endBounds = endBounds {
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("endBounds: %@", log: Log.WriterCommon.all, type: .info, %%endBounds)
                        #endif
                        let distance = endBounds.height*ratio
                        let scrollPoint = NSMakePoint(0, endBounds.minY + distance)
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("end -> scrollPoint: %@", log: Log.WriterCommon.all, type: .info, %%scrollPoint)
                        #endif
                        fulfill(scrollPoint)
                    }
                    else {
                        let errorString = "received nil endBounds"
                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                        os_log("Error: %@", log: Log.WriterCommon.all, type: .error, %%errorString)
                        #endif
                        assert(false, "received nil endBounds")
                        reject(NWError.custom(message: errorString))
                    }
                }.catch { error in
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("Error: %@", log: Log.WriterCommon.all, type: .error, %%error)
                    #endif
                    reject(error)
                }
            }
        }
    }
    
}
