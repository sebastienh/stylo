//
//  Double+Time.swift
//  Common
//
//  Created by Sebastien hamel on 2019-11-08.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation

extension Double {
    
    public var hoursMinutesSecondsMilliseconds: String {
        
        let (hours, minutes, seconds, milliseconds) = secondsToHoursMinutesSecondsMilliseconds(seconds: self)
        return timeString(from: hours, minutes: minutes, seconds: seconds, milliseconds: milliseconds)
    }

    public var hoursMinutesSecondsRoundedUp: String {
        
        let (hours, minutes, seconds) = secondsToHoursMinutesSecondsRoundedUp(seconds: self)
        return timeString(from: hours, minutes: minutes, seconds: seconds)
    }
    
    
    public var hoursMinutesSeconds: String {
        
        let (hours, minutes, seconds) = secondsToHoursMinutesSeconds(seconds: self)
        return timeString(from: hours, minutes: minutes, seconds: seconds)
    }
    
    private func timeString(from hours: Int, minutes: Int, seconds: Int, milliseconds: Int? = nil) -> String {
        
        var timeString = ""
        if hours > 0 {
            timeString = "\(String(format: "%02d", seconds))"
            timeString = "\(String(format: "%02d", minutes)):\(timeString)"
            timeString = "\(String(format: "%02d", hours)):\(timeString)"
        }
        else {
            if let milliseconds = milliseconds {
                timeString = "\(String(format: "%02d", milliseconds))"
                timeString = "\(String(format: "%02d", seconds)):\(timeString)"
            }
            else {
                timeString = "\(String(format: "%02d", seconds))"
            }
            timeString = "\(String(format: "%02d", minutes)):\(timeString)"
        }
        return timeString
    }
    
    private func secondsToHoursMinutesSecondsMilliseconds(seconds: Double) -> (Int, Int, Int, Int) {
        
        let (_, fractionalPart) = modf(seconds)
        let milliseconds = Int(fractionalPart*100)
        
        let (hours, minutes, seconds) = secondsToHoursMinutesSeconds(seconds: seconds)
        return (hours, minutes, seconds, milliseconds)
    }
    
    private func secondsToHoursMinutesSeconds(seconds: Double) -> (Int, Int, Int) {
        // we round the milliseconds time
        let seconds = Int(seconds)
        let hours = seconds / 3600
        let minutes = (seconds-(hours*3600))/60
        let leftSeconds = (seconds-(hours*3600)-minutes*60)
        return (hours, minutes, leftSeconds)
    }

    private func secondsToHoursMinutesSecondsRoundedUp(seconds: Double) -> (Int, Int, Int) {
        // we round the milliseconds time
        let seconds = Int(seconds)
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
}
