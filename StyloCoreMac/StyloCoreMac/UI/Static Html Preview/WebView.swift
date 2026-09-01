//
//  SwippableWebView.swift
//  Stylo
//
//  Created by Sebastien hamel on 2018-12-22.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import WebKit
import os

class WebView: WKWebView {
    
//    private var twoFingersTouches: NSMutableDictionary = NSMutableDictionary()
//
//    override func swipe(with event: NSEvent) {
//
//        os_log("swipe", log: Log.StyloCore.all, type: .info)
//
//
//    }
//
//    override func touchesBegan(with event: NSEvent) {
//
//        os_log("touchesBegan", log: Log.StyloCore.all, type: .info)
//
//        if event.type == .gesture {
//
//            let touches = event.touches(matching: .any, in: self)
//
//            if touches.count == 2 {
//
//                for touch in touches {
//
//                    twoFingersTouches[touch.identity] = touch
//                }
//            }
//        }
//    }
//
//    override func touchesMoved(with event: NSEvent) {
//
//        os_log("touchesMoved", log: Log.StyloCore.all, type: .info)
//
//        let touches = event.touches(matching: .ended, in: self)
//
//        if touches.count > 0 {
//
//            let beginTouches: NSMutableDictionary = self.twoFingersTouches.copy() as! NSMutableDictionary
//            self.twoFingersTouches.removeAllObjects()
//
//            let magnitudes: NSMutableArray = NSMutableArray()
//
//            for touch in touches {
//
//                let beginTouch = beginTouches.object(forKey: touch.identity)
//
//                if let beginTouch = beginTouch as? NSTouch {
//
//                    let magnitude = Float(touch.normalizedPosition.x - beginTouch.normalizedPosition.x)
//                    magnitudes.add(NSNumber(value: magnitude))
//                }
//            }
//
//            var sum: Float = 0
//
//            for magnitude in magnitudes {
//
//                if let magnitude = magnitude as? NSNumber {
//
//                    sum += magnitude.floatValue
//                }
//            }
//
//            // See if absolute sum is long enough to be considered a complete gesture
//            let absoluteSum: Float = abs(sum)
//
//            if absoluteSum < 0.2 {
//                return
//            }
//
//            // Handle the actual swipe
//            // This might need to be > (i am using flipped coordinates)
//            if sum > 0 {
//                os_log("go back", log: Log.StyloCore.all, type: .info)
//            }
//            else {
//                os_log("go forward", log: Log.StyloCore.all, type: .info)
//            }
//        }
//    }
}
