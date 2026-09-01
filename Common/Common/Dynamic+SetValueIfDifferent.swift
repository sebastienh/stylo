//
//  Dynamic+SetValueIfDifferent.swift
//  Common
//
//  Created by Sebastien Hamel on 2020-01-16.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

public extension Dynamic where T: Equatable {
    
    func setValueIfDifferent(_ newValue: T, notify: Bool = true, sameExecutionStack: Bool = false) {
        if self.value != newValue {
            self.setValue(newValue, notify: notify, sameExecutionStack: sameExecutionStack)
        }
    }
    
}
