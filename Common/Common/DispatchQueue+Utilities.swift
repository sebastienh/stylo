//
//  DispatchQueue+Utilities.swift
//  Common
//
//  Created by Sebastien Hamel on 2020-04-23.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

extension DispatchQueue {

    public static func syncOnMain(closure: @escaping () -> ()) {
        if Thread.isMainThread {
            closure()
        }
        else {
            DispatchQueue.main.sync {
                closure()
            }
        }
    }
    
    public static func asyncOnMain(closure: @escaping () -> ()) {
        if Thread.isMainThread {
            closure()
        }
        else {
            DispatchQueue.main.async {
                closure()
            }
        }
    }

    public static func forcedAsyncOnMain(closure: @escaping () -> ()) {
        DispatchQueue.main.async {
            closure()
        }
    }
    
}
