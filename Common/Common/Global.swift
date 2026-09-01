//
//  Global.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-02-20.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation
import os

var globalId: UInt64 = 0

func createUniqueFunctionId(_ file: String = #file, function: String = #function) -> String {
    
    let functionId = "\(file)_\(function)_\(globalId)"
    
    globalId += 1 
    
    return functionId
}

typealias PRECONDITION = (() -> Void) -> Void


func validateConditions(_ preconditions: [(Bool, String)]) {
    
    #if DEBUG
    for (precondition, message) in preconditions {
        validate(precondition, message: message)
    }
    #endif
}

func validate(_ condition: Bool, message: String) {
    
    #if DEBUG
        if !condition {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("%@", log: Log.Common.all, type: .debug, message)
            #endif
        }
    #endif
}
