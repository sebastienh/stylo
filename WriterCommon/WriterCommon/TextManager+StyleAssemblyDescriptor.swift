//
//  TextManager+StyleAssemblyDescriptor.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-06-24.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Common
import Web
import Igloo
import PromiseKit
import os


#if os(OSX)
    import Cocoa
#elseif os(iOS)
    import UIKit
#endif

extension TextManager {

    ///
    public func setStyleAssemblyDescriptorAsync(_ descriptor: StyleAssemblyDescriptor, forEditorId editorId: EditorId) -> Promise<Void> {
        
        return Promise<Void> { fulfill, reject in
            
            let visibleRanges = self.visibleRanges
            self.compilationQueue.async { [weak self] in
                
                if let _self = self, let visibleRange = visibleRanges[editorId] {
                    _self.setStyleAssemblyDescriptor(descriptor, forEditorId: editorId, visibleRange: visibleRange)
                    fulfill(())
                }
                else {
                    reject(NWError.custom(message: "self is nil"))
                }
            }
        }
    }
    
    
}




