//
//  CancellableTimer.swift
//  Common
//
//  Created by Sébastien Hamel on 2018-07-26.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation

public class CancellableTimer {
    
    var timer: DispatchSourceTimer?
    
    let delay: Int
    
    var eventHandler: (() -> Void)?
    
    private var resumed = false
    
    public init(delay: Int) {
        
        self.delay = delay
    }
    
    public func start(eventHandler: (() -> Void)?) {
        
        self.resumed = false
        self.timer = DispatchSource.makeTimerSource()
        timer?.schedule(deadline: .now() + .milliseconds(delay))
        timer?.setEventHandler(handler: eventHandler)
    }
    
    public func cancel() {
        
        if let timer = timer {
    
            timer.setEventHandler {}
            if !timer.isCancelled {
        
                timer.cancel()
                /*
                 If the timer is suspended, calling cancel without resuming
                 triggers a crash. This is documented here
                 https://forums.developer.apple.com/thread/15902
                 */
                resume()
            }
            self.timer = nil
        }
    }
    
    func resume() {
        
        if resumed {
            return
        }
        resumed = true
        timer?.resume()
    }
}
