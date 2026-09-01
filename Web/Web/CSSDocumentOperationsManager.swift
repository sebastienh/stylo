//
//  DocumentOperationsManager.swift
//  Web
//
//  Created by Sebastien hamel on 2015-06-21.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

/// All operations in this manager are serialized. All the operations
/// comprise the source string update up until the dom update, the last operation 
/// before document style operations.
class CSSDocumentOperationsManager: DocumentOperationsManager {
    
    let cssSourceDocument: CSSSourceDocument
    
    weak var sourceStringUpdateOperation: SourceStringUpdateOperation?
    
    weak var styleSheetCleanupOperation: CSSStyleSheetCleanupOperation?
    weak var styleSheetUpdateOperation: CSSStyleSheetUpdateOperation?
    weak var cssDomCleanupOperation: CSSDOMCleanupOperation?
    weak var cssDomUpdateOperation: CSSDOMUpdateOperation?
    
    /// document rendering queue
    let documentQueue: NSOperationQueue
    
    init(cssSourceDocument: CSSSourceDocument) {
        
        self.cssSourceDocument = cssSourceDocument
        self.documentQueue = NSOperationQueue()
    }
    
    func updateDocument() {
        
        var operations = [NSOperation]()
        
        ////////////////////////////////
        // SourceString update operation
        ////////////////////////////////
        self.sourceStringUpdateOperation = SourceStringUpdateOperation()
        operations.append(sourceStringUpdateOperation)
        
        // sourceStringUpdateOperation only depends on cssDomUpdateOperation
        // if there was one previously thay is still not finished ...
        if let cssDomUpdateOperation = cssDomUpdateOperation {
            
            self.sourceStringUpdateOperation.addDependency(cssDomUpdateOperation)
        }
        
        ///////////////////////////////
        // StyleSheet Cleanup Operation
        ///////////////////////////////
        self.styleSheetCleanupOperation = CSSStyleSheetCleanupOperation()
        styleSheetCleanupOperation.addDependency(self.sourceStringUpdateOperation)
        operations.append(styleSheetCleanupOperation)
        
        //////////////////////////////
        // StyleSheet Update Operation
        //////////////////////////////
        self.styleSheetUpdateOperation = CSSStyleSheetUpdateOperation()
        styleSheetUpdateOperation.addDependency(self.styleSheetCleanupOperation)
        operations.append(styleSheetUpdateOperation)
        
        ///////////////////////////
        // CSSDOM Cleanup Operation
        ///////////////////////////
        self.cssDomCleanupOperation = CSSDOMCleanupOperation()
        cssDomCleanupOperation.addDependency(self.styleSheetUpdateOperation)
        operations.append(cssDomCleanupOperation)
        
        //////////////////////////
        // CSSDOM Update Operation
        //////////////////////////
        self.cssDomUpdateOperation = CSSDOMUpdateOperation()
        cssDomUpdateOperation.addDependency(self.cssDomCleanupOperation)
        cssDomUpdateOperation.addDependency(self.styleSheetUpdateOperation)
        operations.append(cssDomUpdateOperation)

        
        
        self.documentQueue.addOperations(ops: [
            self.sourceStringUpdateOperation,
            self.styleSheetCleanupOperation,
            self.styleSheetUpdateOperation,
            self.cssDomCleanupOperation,
            self.cssDomUpdateOperation], waitUntilFinished: false)
    }
    
    
}