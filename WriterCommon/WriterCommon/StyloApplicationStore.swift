//
//  StyloApplicationStore.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-11-13.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Web
import Markdown
import Common
import PromiseKit
import Igloo

final public class StyloApplicationStore: Store, IdentifiableStoreType {
    
    /// Unique identifier
    public let identifier: String = UUID().uuidString
    
    /// This is the final appearance based on system appearance and user selected appearance.
    public let computedAppearance = Dynamic<AppearanceMode?>(nil)
    
    public let systemAppearance = Dynamic<AppearanceMode?>(nil)
    
    public let userSelectedAppearance = Dynamic<AppearanceMode?>(nil)
    
    public let selectedPrintTheme = Dynamic<ThemeStore?>(nil)

    public let focusMode: Dynamic<FocusMode>
    
    /// Reference to the associated reducer
    public let reducer: StyloApplicationReducer

    init() {
        
        self.focusMode = Dynamic<FocusMode>(.disabled)
        self.reducer = StyloApplicationReducer(storeIdentifier: self.identifier)
    }
    
//    public func styleAssemblyStore(from styleType: StyleType?) -> StyleStore? {
//        
//        if let styleType = styleType {
//            switch styleType {
//            default:
//                assert(false)
//                break
//            }
//        }
//        return nil
//    }
}
