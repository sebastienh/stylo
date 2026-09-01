//
//  BackgroundStyleApplicator.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-01-04.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Common
import PromiseKit
import os

class BackgroundStyleApplicator {
    
    class StyleApplicationOperation: Operation {
        
        private let textManagers: [TextManager]
        
        private let styleAssemblyStore: StyleAssemblyStore
        
        init(textManagers: [TextManager], styleAssemblyStore: StyleAssemblyStore) {
            
            self.textManagers = textManagers
            self.styleAssemblyStore = styleAssemblyStore
        }
        
        override func main() {
            for textManager in textManagers {
                if !self.isCancelled {
                    // TODO: we should handle the style assemblies
                    fatalError("missing implementation")
//                    textManager.applyPermanentStyleSync(fromStyleManager: styleAssemblyStore)
                }
            }
        }
    }
    
    let styleApplicationQueue: OperationQueue
    
    init() {
        
        self.styleApplicationQueue = OperationQueue()
        self.styleApplicationQueue.qualityOfService = .background
        self.styleApplicationQueue.maxConcurrentOperationCount = 1
    }
    
    func applyStyle(_ styleAssemblyStore: StyleAssemblyStore, toTextManagers textManagers: [TextManager]) {
    
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("applying style: %@", log: Log.WriterCommon.all, type: .info, %%styleAssemblyStore.id)
        #endif
        
        styleApplicationQueue.cancelAllOperations()
        styleApplicationQueue.addOperation(StyleApplicationOperation(textManagers: textManagers, styleAssemblyStore: styleAssemblyStore))
    }
}
