//
//  Exception.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-02-09.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation
import Common
import os

public final class Exception {
    
    public internal(set) var code: ExceptionCode
    
    public init() {
        
        self.code = ExceptionCode.noError
    }
    
    init(code: ExceptionCode) {
        
        self.code = code
    }
    
    public func isError() -> Bool {
     
        if code != ExceptionCode.noError {
            
            return true
        }
        
        return false
    }
    
    @discardableResult
    public func logIfError() -> Bool {
        
        if self.isError() {

            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%self)
            #endif
            assert(false)
            return true 
        }
        
        return false
    }
}
