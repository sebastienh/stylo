//
//  DocumentStyle.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-22.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

//    partial interface Document {
//        [SameObject] readonly attribute StyleSheetList styleSheets;
//        attribute DOMString? selectedStyleSheetSet;
//        readonly attribute DOMString? lastStyleSheetSet;
//        readonly attribute DOMString? preferredStyleSheetSet;
//        readonly attribute DOMString[] styleSheetSets;
//        void enableStyleSheetsForSet(DOMString? name);
//    };
/// see http://dev.w3.org/csswg/cssom/#extensions-to-the-document-interface
protocol DocumentStyle: class {
    
    // [SameObject] readonly attribute StyleSheetList styleSheets;
    var styleSheets: StyleSheetList { get }
    
    //  attribute DOMString? selectedStyleSheetSet;
    var selectedStyleSheetSet: DOMString? {  get set }
    
    //  readonly attribute DOMString? lastStyleSheetSet;
    var lastStyleSheetSet: DOMString? { get }
    
    //  readonly attribute DOMString? preferredStyleSheetSet;
    var preferredStyleSheetSet: DOMString? { get }
    
    //  readonly attribute DOMString[] styleSheetSets;
    var styleSheetSets: [DOMString] { get }
    
    //  void enableStyleSheetsForSet(DOMString? name);
    func enableStyleSheetsForSet(_ name: DOMString?)
    
}
