//
//  CSSSourceDocumentScheduler.swift
//  Web
//
//  Created by Sebastien hamel on 2015-06-17.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation

class CSSSourceDocumentScheduler: SourceDocumentScheduler {
    
    unowned let cssSourceDocument: CSSSourceDocument
    
    // this variable is optional since it could have been released by the
    // operation queue
    weak var styleSheetUpdateOperation: CSSStyleSheetUpdateOperation?
    
    // if this operation has been se we want to keep it around 
    // in order to be able to cancel it.
    weak var previousCssDomPaintOperation: CSSPaintOperation?

    // if this operation has been se we want to keep it around
    // in order to be able to cancel it.
    weak var previousCssDomLayoutOperation: CSSDOMLayoutOperation?
    
    // if this operation has been se we want to keep it around
    // in order to be able to cancel it.
    weak var previousRenderTreeCreateOperation: CSSDOMRenderTreeCreateOperation?
    
    weak var previousCssDomUpdateOperation: CSSDOMUpdateOperation?
    
    var documentStyleUpdateOperations: [CSSStyle: DocumentStyleUpdateOperation]
    
    var sourceDocumentQueue: NSOperationQueue {
        
        cssSourceDocument.documentQueue
    }
    
    init(cssSourceDocument: CSSSourceDocument) {

        self.cssSourceDocument = cssSourceDocument
        self.documentStyleOperations = [CSSStyle: DocumentStyleUpdateOperation]()
    }
    
    func scheduleCreationForStyle(style: CSSStyle) {

        var operations = [NSOperation]()
        
        
        
        sourceDocumentQueue.addOperations(operations, waitUntilFinished: false)
    }

    func scheduleStyleUpdateForStyle(style: CSSStyle, styleSheetResourceDocument: ResourceDocument) {
        
        var operations = [NSOperation]()
        
//        // If there is already a document style update operation,
//        // we need to cancel it since it will be invalidated anyway.
//        if let documentStyleUpdateOperation = documentStyleUpdateOperations[style]
//            where !documentStyleUpdateOperation.finished {
//                
//                documentStyleUpdateOperation.cancel()
//        }
//        
        
        //////////////////////////////////
        // DocumentStyle cleanup operation
        // Note: No need for dependencies
        //////////////////////////////////
        let documentStyleCleanupOperation = DocumentStyleCleanupOperation(sourceDocument: cssSourceDocument, style: style, affectedResourceDocument: styleSheetResourceDocument)
        
        if let documentStyleUpdateOperation = documentStyleUpdateOperations[style]
            where !documentStyleUpdateOperation.finished {
        
            documentStyleCleanupOperation.addDependency(documentStyleUpdateOperation)
        }
        
        /////////////////////////////////
        // DocumentStyle update operation
        /////////////////////////////////
        let documentStyleUpdateOperation = DocumentStyleUpdateOperation(sourceDocument: cssSourceDocument, style: style)
        documentStyleUpdateOperation.addDependency(documentStyleCleanupOperation)
        
        if let styleUpdateOperation = style.styleUpdateOperation where !styleUpdateOperation.finished {

            documentStyleUpdateOperation.addDependency(styleUpdateOperation)
        }
        
        // update the current document style update operation
        documentStyleUpdateOperations[style] = documentStyleUpdateOperation
        
        ///////////////////////////////
        // Common RenderTree operations
        ///////////////////////////////
        createRenderingOperations(operations, renderingDependencies: [documentStyleUpdateOperation])
    }
    
    /// FIXME: Document style may have been or may be calculated already by 
    /// a background working queue. We should consider this case when doing this
    /// when those will be implemented.
    func scheduleCurrentStyleChangeToStyle(style: CSSStyle) {
        
        var operations = [NSOperation]()
        
        //////////////////////////////////
        // DocumentStyle cleanup operation
        //////////////////////////////////
        let documentStyleCleanupOperation = DocumentStyleCleanupOperation(sourceDocument: cssSourceDocument, style: style)
        
        if let styleUpdateOperation = style.styleUpdateOperation {
            
            documentStyleUpdateOperation.addDependency(styleUpdateOperation)
        }
        
        /////////////////////////////////
        // DocumentStyle update operation
        /////////////////////////////////
        let documentStyleUpdateOperation = DocumentStyleUpdateOperation(sourceDocument: cssSourceDocument, style: style)
        documentStyleUpdateOperation.addDependency(documentStyleCleanupOperation)
        
        if let styleUpdateOperation = style.styleUpdateOperation {
            
            documentStyleUpdateOperation.addDependency(styleUpdateOperation)
        }
        
        ///////////////////////////////
        // Common Rendering operations
        ///////////////////////////////
        createRenderingOperations(operations, renderingDependencies: [documentStyleUpdateOperation])
    }
    
    func scheduleSourceUpdateForStyle(style: CSSStyle) {
        
        var operations = [NSOperation]()
        
        ////////////////////////////////
        // SourceString update operation
        ////////////////////////////////
        let sourceStringUpdateOperation = SourceStringUpdateOperation()
        operations.append(sourceStringUpdateOperation)
        
        // sourceStringUpdateOperation only depends on lastCSSDOMRenderTreeUpdateOperation
        // if there was one previously thay is still not finished ...
        if let previousCssDomPaintOperation = previousCssDomPaintOperation {
                
            sourceStringUpdateOperation.addDependency(previousCssDomPaintOperations)
        }
        
        ///////////////////////////////
        // StyleSheet Cleanup Operation
        ///////////////////////////////
        let styleSheetCleanupOperation = CSSStyleSheetCleanupOperation()
        styleSheetCleanupOperation.addDependency(sourceStringUpdateOperation)
        operations.append(styleSheetCleanupOperation)
        
        //////////////////////////////
        // StyleSheet Update Operation
        //////////////////////////////
        let styleSheetUpdateOperation = CSSStyleSheetUpdateOperation()
        styleSheetUpdateOperation.addDependency(styleSheetCleanupOperation)
        operations.append(styleSheetUpdateOperation)
        
        ///////////////////////////
        // CSSDOM Cleanup Operation
        ///////////////////////////
        let cssDomCleanupOperation = CSSDOMCleanupOperation()
        cssDomCleanupOperation.addDependency(styleSheetCleanupOperation)
        operations.append(cssDomCleanupOperation)
        
        //////////////////////////
        // CSSDOM Update Operation
        //////////////////////////
        let cssDomUpdateOperation = CSSDOMUpdateOperation()
        cssDomUpdateOperation.addDependency(cssDomCleanupOperation)
        cssDomUpdateOperation.addDependency(styleSheetUpdateOperation)
        operations.append(cssDomUpdateOperation)
        previousCssDomUpdateOperation = cssDomUpdateOperation
        
        ///////////////////////////////
        // Common RenderTree operations
        ///////////////////////////////
        createRenderingOperations(operations, renderingDependencies: [cssDomUpdateOperation])
    }
    
    private func createRenderingOperations(previousOperations: [NSOperation], renderingDependencies: [NSOperation], display: Bool = true) {
        
        var operations = [NSOperation]()
        
        operations.join(previousOperations)
        
        //////////////////////////////
        // RenderTree Create Operation
        //////////////////////////////
        let renderTreeCreateOperation = CSSDOMRenderTreeCreateOperation()

        for operation in renderTreeCreateDependencies {
            
            renderTreeCreateOperation.addDependency(operation)
        }
        
        operations.append(renderTreeUpdateOperation)
        
        // render tree also depends on document style update
        // this document style update should be removed when a new document style update
        // operation arrives.
        if let documentStyleUpdateOperation = documentStyleUpdateOperations[style] {
            
            renderTreeUpdateOperation.addDependency(documentStyleUpdateOperation)
        }
        
        if display {
        
             appendDisplayOperations(renderTreeUpdateOperation: CSSDOMRenderTreeUpdateOperation)
        }
        
        sourceDocumentQueue.addOperations(operations, waitUntilFinished: false)
    }
    
    private func appendDisplayOperations(renderTreeCreateOperation: CSSDOMRenderTreeCreateOperation) -> [NSOperation] {
        
        //////////////////////////
        // CSSDOM Layout operation
        //////////////////////////
        let cssDomDocumentLayoutOperation = CSSDOMLayoutOperation()
        cssDomDocumentLayoutOperation.addDependency(renderTreeCreateOperation)
        operations.append(cssDomDocumentLayoutOperation)
        
        /////////////////////////
        // CSSDOM Paint operation
        /////////////////////////
        let cssDomPaintOperation = CSSPaintOperation()
        cssDomPaintOperation.addDependency(cssDomDocumentLayoutOperation)
        operations.append(cssDomPaintOperation)
        
        self.previousCssDomPaintOperation = cssDomPaintOperation
    }
    
    
}