//
//  MacStyloDocument+Printable.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-01-04.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import Quartz
import PromiseKit
import Common
import os

extension MacStyloDocument {
    
    override public func print(withSettings printSettings: [NSPrintInfo.AttributeKey : Any], showPrintPanel: Bool, delegate: Any?, didPrint didPrintSelector: Selector?, contextInfo: UnsafeMutableRawPointer?) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("print with print settings: %@", log: Log.StyloCore.all, type: .info, %%printSettings)
        os_log("shared print settings: %@", log: Log.StyloCore.all, type: .info, %%NSPrintInfo.shared)
        os_log("shared print settings: %@", log: Log.StyloCore.all, type: .info, %%self.printInfo)
        #endif
        
        assert(self.windowControllers.first != nil)
        if let windowController = self.windowControllers.first as? StyloWindowController {
        
            firstly {
                windowController.displayPrepareDocumentForPrintingProgressIndicator()
            }.then {
                self.pdfData
            }.then { data -> Promise<Data> in
                windowController.dismissProgressIndicator(data: data)
            }.then { data -> Void in
                let printInfo = self.printInfo
                let document = PDFDocument(data: data)
                let printOperation = document!.printOperation(for: printInfo, scalingMode: PDFPrintScalingMode.pageScaleNone, autoRotate: true)!
                printOperation.showsPrintPanel = true
                printOperation.showsProgressPanel = true
                printOperation.run()
            }.catch { error in
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("error printing: %@", log: Log.StyloCore.all, type: .error, %%error)
                #endif
            }
        }
    }
}
