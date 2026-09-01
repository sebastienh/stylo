//
//  MarkdownResourceEditorView+Scrollable.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-05-06.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import WriterCommon
import PromiseKit
import Common
import os

extension MarkdownResourceEditorView: Scrollable {
    
    public var numberOfTopElements: Promise<Int> {
        
        return Promise<Int> { fulfill, reject in
            
            if let staticHtmlPreviewable = self.editableManager as? StaticHtmlPreviewable {
                
                if let numberOfElements = staticHtmlPreviewable.numberOfElements {
                    fulfill(numberOfElements)
                }
                else {
                    reject(NWError.custom(message: "numberOfElements is nil"))
                }
            }
            else {
                reject(NWError.custom(message: "staticHtmlPreviewable is nil"))
            }
        }
    }
    
    var startBounds: Promise<NSRect> {
        
        return Promise<NSRect> { fulfill, reject in
            
            // get the range of the first element
            let range = firstElementRange()
            
            if let range = range {
            
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Computed first element range: %@", log: Log.StyloCore.all, type: .info, %%NSStringFromRange(range))
                #endif
                
                // get the rect of this first element
                let rect = wordRect(in: range)
                
                assert(rect != nil)
                if let rect = rect {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Computed first element rect: %@", log: Log.StyloCore.all, type: .info, %%NSStringFromRect(rect))
                    #endif
                    fulfill(NSMakeRect(0, 0, rect.width, rect.minY))
                }
                else {
                    let errorString = "nil rect"
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("Error: %@", log: Log.StyloCore.all, type: .error, %%errorString)
                    #endif
                    reject(NWError.custom(message: errorString))
                }
            }
            else {
                
                // if there is no element, then we just return the frame
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("No first element range found, returning frame: %@", log: Log.StyloCore.all, type: .info, %%NSStringFromRect(self.frame))
                #endif
                fulfill(self.frame)
            }
        }
    }
    
    var endBounds: Promise<NSRect?> {
        
        return Promise<NSRect?> { fulfill, reject in
        
            // get the range of the last element
            let range = lastElementRange()
            
            if let range = range {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Computed last element range: %@", log: Log.StyloCore.all, type: .info, %%NSStringFromRange(range))
                #endif
                
                // get the rect of this first element
                let rect = wordRect(in: range)
                
                assert(rect != nil)
                if let rect = rect {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Computed last element rect: %@", log: Log.StyloCore.all, type: .info, %%NSStringFromRect(rect))
                    #endif
                    let height = self.frame.height - rect.maxY
                    fulfill(NSMakeRect(rect.origin.x, rect.maxY, rect.width, height))
                }
                else {
                    let errorString = "nil rect"
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("%@", log: Log.StyloCore.all, type: .error)
                    #endif
                    reject(NWError.custom(message: errorString))
                }
            }
            else {
                
                // if there is no elements then there is not end bounds,
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("No element range found, returning nil", log: Log.StyloCore.all, type: .info)
                #endif
                fulfill(nil)
            }
        }
    }
    
    var scrollRatio: Promise<CGFloat> {
        
        return Promise<CGFloat> { fulfill, reject in
            let scrollPoint = self.enclosingScrollView!.contentView.bounds.origin.y
            fulfill(scrollPoint/self.bounds.size.height)
        }
    }
    
    var currentScrollPosition: Promise<ScrollPosition?> {
        
        return Promise<ScrollPosition?> { fulfill, reject in
        
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("currentScrollPosition request", log: Log.StyloCore.all, type: .info)
            #endif
            
            
            // the scroll point is the value in frame coordinates of the upper
            // point in the current visible view area.
            let scrollPoint = self.enclosingScrollView!.contentView.bounds.origin
            
            firstly {
                startScrollPosition(from: scrollPoint)
            }.then { startScrollPosition -> Void in
                
                if let startScrollPosition = startScrollPosition {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Fulfill promise with currentScrollPosition as: %@", log: Log.StyloCore.all, type: .info, %%startScrollPosition)
                    #endif
                    fulfill(startScrollPosition)
                }
                else {
                    
                    firstly {
                        self.endScrollPosition(from: scrollPoint)
                    }.then { endScrollPosition -> Void in
                        if let endScrollPosition = endScrollPosition {
                            
                            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                            os_log("Fulfill promise with currentScrollPosition as: %@", log: Log.StyloCore.all, type: .info, %%endScrollPosition)
                            #endif
                            fulfill(endScrollPosition)
                        }
                        else {
                            
                            firstly {
                                self.insideOrBetweenScrollPosition(from: scrollPoint)
                            }.then { scrollPosition -> Void in
                                if let scrollPosition = scrollPosition {
                                    
                                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                                    os_log("Fulfill promise with currentScrollPosition as: %@", log: Log.StyloCore.all, type: .info, %%scrollPosition)
                                    #endif
                                    fulfill(scrollPosition)
                                }
                                else {
                                    let errorString = "Error while getting inside or between scroll position: return value is nil"
                                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                                    os_log("Error: %@", log: Log.StyloCore.all, type: .error, %%errorString)
                                    #endif
                                    reject(NWError.custom(message: errorString))
                                }
                            }.catch { error in
                                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                                os_log("Error: %@", log: Log.StyloCore.all, type: .error, %%error)
                                #endif
                                reject(error)
                            }
                        }
                    }.catch { error in
                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                        os_log("Error: %@", log: Log.StyloCore.all, type: .error, %%error)
                        #endif
                        reject(error)
                    }
                }
            }.catch { error in
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Error: %@", log: Log.StyloCore.all, type: .error, %%error)
                #endif
                reject(error)
            }
        }
    }
    
    func scrollTo(point: NSPoint) -> Promise<Void> {
        
        return Promise<Void> { fulfill, reject in
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Scrolling to: %@", log: Log.StyloCore.all, type: .info, %%NSStringFromPoint(point))
            #endif
            self.scroll(point)
            fulfill(())
        }
    }
    
    func boundsForElement(at index: Int) -> Promise<NSRect> {
        
        return Promise<NSRect> { fulfill, reject in
        
            let staticHtmlPreviewable = self.editableManager as? StaticHtmlPreviewable
            
            assert(staticHtmlPreviewable != nil)
            if let staticHtmlPreviewable = staticHtmlPreviewable {
                
                let range = staticHtmlPreviewable.rangeOfElement(at: index)
                
                
                assert(range != nil)
                if let range = range {
                
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Computed element range for element at index(%d): %@", log: Log.StyloCore.all, type: .info, index, %%NSStringFromRange(range))
                    #endif
                    if let rect = self.wordRect(in: range) {
                    
                        // get the rect of this first element
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Fulfilling with bounds rect for element at index(%d): %@", log: Log.StyloCore.all, type: .info, index, %%NSStringFromRect(rect))
                        #endif
                        fulfill(rect)
                    }
                    else {
                        let errorString = "Error: nil rect"
                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                        os_log("Error: %@", log: Log.StyloCore.all, type: .error, %%errorString)
                        #endif
                        reject(NWError.custom(message: errorString))
                    }
                }
                else {
                    let errorString = "Error: nil range"
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("Error: %@", log: Log.StyloCore.all, type: .error, %%errorString)
                    #endif
                    reject(NWError.custom(message: errorString))
                }
            }
            else {
                let errorString = "Error: editableManager is not StaticHtmlPreviewable"
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Error: %@", log: Log.StyloCore.all, type: .error, %%errorString)
                #endif
                reject(NWError.custom(message: errorString))
            }
        }
    }
    
    private func insideOrBetweenScrollPosition(from scrollPoint: NSPoint) -> Promise<ScrollPosition?> {
        
        return Promise<ScrollPosition?> { fulfill, reject in
            
            let staticHtmlPreviewable = self.editableManager as? StaticHtmlPreviewable
            
            assert(staticHtmlPreviewable != nil)
            if let staticHtmlPreviewable = staticHtmlPreviewable {
            
                // we are either inside an element or between elements
                let firstVisibleElementIndex = staticHtmlPreviewable.firstVisibleElementIndex
                
                // at this point we must have a visible element because, if there wasn't
                // any elements then we would have been in the startBounds
                assert(firstVisibleElementIndex != nil)
                if let firstVisibleElementIndex = firstVisibleElementIndex {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("First visible element index: %d", log: Log.StyloCore.all, type: .info, firstVisibleElementIndex)
                    #endif
                    
                    firstly {
                        boundsForElement(at: firstVisibleElementIndex)
                    }.then { bounds -> Void in
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Bounds for element index(%d): %@", log: Log.StyloCore.all, type: .info, firstVisibleElementIndex, %%NSStringFromRect(bounds))
                        #endif
                        
                        if scrollPoint.y >= bounds.minY && scrollPoint.y <= bounds.maxY {
                            
                            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                            os_log("Inside element case.", log: Log.StyloCore.all, type: .info)
                            os_log("scrollPoint: %@ inside bounds: %@", log: Log.StyloCore.all, type: .info, %%NSStringFromPoint(scrollPoint), %%NSStringFromRect(bounds))
                            #endif
                            
                            let distance = scrollPoint.y-bounds.minY
                            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                            os_log("At ditance from bounds origin (%f): %f", log: Log.StyloCore.all, type: .info, bounds.minY, distance)
                            #endif
                            let ratio = distance/bounds.height
                            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                            os_log("At ratio: %f", log: Log.StyloCore.all, type: .info, ratio)
                            #endif
                            fulfill(ScrollPosition.inside(index: firstVisibleElementIndex, ratio: ratio))
                        }
                        else {
                            
                            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                            os_log("Between elements case or inside previous...", log: Log.StyloCore.all, type: .info)
                            #endif
                            
                            // we are before the first element
                            assert(scrollPoint.y < bounds.minY)
                            
                            // we know there is an element before because we are not
                            // in the start bounds...
                            assert(firstVisibleElementIndex >= 1)
                            
                            firstly {
                                self.boundsForElement(at: firstVisibleElementIndex-1)
                            }.then { previousBounds -> Void in

                                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                                os_log("Bounds for element index(%d): %@", log: Log.StyloCore.all, type: .info, firstVisibleElementIndex-1, %%NSStringFromRect(previousBounds))
                                #endif
                                
                                // we should not be inside the previous element, because we are
                                // between elements
                                // may not be true because the layout manager may return an extended bounds which contains the scorllpoint for the previous element
                                //assert(!(scrollPoint.y >= previousBounds.minY && scrollPoint.y <= previousBounds.maxY))
                                
                                let betweenHeight = bounds.minY - previousBounds.maxY
                                
                                if scrollPoint.y < previousBounds.maxY {
                                    
                                    let distance = scrollPoint.y-previousBounds.minY
                                    
                                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                                    os_log("At ditance from bounds origin (%f): %f", log: Log.StyloCore.all, type: .info, bounds.minY, distance)
                                    #endif
                                    let ratio = distance/bounds.height
                                    
                                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                                    os_log("At ratio: %f", log: Log.StyloCore.all, type: .info, ratio)
                                    #endif
                                    
                                    fulfill(ScrollPosition.inside(index: firstVisibleElementIndex-1, ratio: ratio))
                                }
                                else {
                                    
                                    let absolutePosition = scrollPoint.y - previousBounds.maxY
                                    let ratio = absolutePosition/betweenHeight
                                    
                                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                                    os_log("bounds.minY: %@", log: Log.StyloCore.all, type: .info, %%bounds.minY)
                                    os_log("previousBounds.maxY: %@", log: Log.StyloCore.all, type: .info, %%previousBounds.maxY)
                                    os_log("scrollPoint.y: %@", log: Log.StyloCore.all, type: .info, %%scrollPoint.y)
                                    os_log("absolutePosition: %@", log: Log.StyloCore.all, type: .info, %%absolutePosition)
                                    os_log("betweenHeight: %@", log: Log.StyloCore.all, type: .info, %%betweenHeight)
                                    os_log("ratio: %@", log: Log.StyloCore.all, type: .info, %%ratio)
                                    #endif
                                    
                                    fulfill(ScrollPosition.between(first: firstVisibleElementIndex-1, second: firstVisibleElementIndex, ratio: ratio))
                                }
                            }.catch { error in
                                
                                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                                os_log("Error: %@", log: Log.StyloCore.all, type: .error, %%error)
                                #endif
                                reject(error)
                            }
                        }
                    }.catch { error in
                        
                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                        os_log("Error: %@", log: Log.StyloCore.all, type: .error, %%error)
                        #endif
                        reject(error)
                    }
                }
                else {
                    
                    let errorString = "Error: nil firstVisibleElementIndex"
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("Error: %@", log: Log.StyloCore.all, type: .error, %%errorString)
                    #endif
                    reject(NWError.custom(message: errorString))
                }
            }
            else {
                
                let errorString = "Error: editableManager is not StaticHtmlPreviewable"
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Error: %@", log: Log.StyloCore.all, type: .error, %%errorString)
                #endif
                reject(NWError.custom(message: errorString))
            }
        }
    }
    
    private func endScrollPosition(from scrollPoint: NSPoint) -> Promise<ScrollPosition?> {
     
        return Promise<ScrollPosition?> { fulfill, reject in
            
            firstly {
                endBounds
            }.then { endBounds ->Void in
                if let endBounds = endBounds, endBounds.contains(scrollPoint) {
                    fulfill(ScrollPosition.end(ratio: (scrollPoint.y-endBounds.minY)/endBounds.height))
                }
                else {
                    fulfill(nil)
                }
            }.catch { error in
                
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Error: %@", log: Log.StyloCore.all, type: .error, %%error)
                #endif
                reject(error)
            }
        }
    }
    
    private func startScrollPosition(from scrollPoint: NSPoint) -> Promise<ScrollPosition?> {
        
        return Promise<ScrollPosition?> { fulfill, reject in
            
            firstly {
                self.startBounds
            }.then { startBounds -> Void in
                if startBounds.contains(scrollPoint) {
                    fulfill(ScrollPosition.start(ratio: scrollPoint.y/startBounds.height))
                }
                else {
                    fulfill(nil)
                }
            }.catch { error in
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Error: %@", log: Log.StyloCore.all, type: .error, %%error)
                #endif
                reject(error)
            }
        }
    }
    
    
    private func firstElementRange() -> NSRange? {
        
        if let staticHtmlPreviewable = self.editableManager as? StaticHtmlPreviewable {
            
            return staticHtmlPreviewable.rangeOfElement(at: 0)
        }
        return nil
    }
    
    private func lastElementRange() -> NSRange? {
        
        if let staticHtmlPreviewable = self.editableManager as? StaticHtmlPreviewable {
            
            let numberOfElements = staticHtmlPreviewable.numberOfElements
            
            assert(numberOfElements != nil)
            if let numberOfElements = numberOfElements {
             
                return staticHtmlPreviewable.rangeOfElement(at: numberOfElements-1)
            }
        }
        return nil
    }
}
