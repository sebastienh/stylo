//
//  StyleAssemblyStore+ResourceComputedStyle.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-10-20.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Web

extension StyleAssemblyStore {
    
    public var resourceComputedStyle: ResourceComputedStyle? {
        
        guard let style = self.style.value else {
            assertionFailure("Error: style is nil")
            return nil
        }
        
        return ComputedStylesCache.shared.resourceComputedStyle(for: style)
    }
    
}
