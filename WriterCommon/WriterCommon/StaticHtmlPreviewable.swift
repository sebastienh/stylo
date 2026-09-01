//
//  StaticHtmlPreviewable.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-05-01.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import PromiseKit
import Common

public protocol StaticHtmlPreviewable: class {
 
    var htmlPreviewBackgroundColor: PlateformColorType? { get }
    
    var htmlStyleStore: Dynamic<StyleAssemblyStore?> { get set }
    
    var visibleTextRange: NSRange? { get }
    
    var numberOfElements: Int? { get }
    
    var firstVisibleElementIndex: Int? { get }
    
    func updateStaticHtmlPreviewString(forced: Bool) -> Promise<String?>
    
    func rangeOfElement(at index: Int) -> NSRange?
    
    func applyHtmlStyle(_ htmlStyleStore: StyleAssemblyStore?)
    
    func startListeningToHtmlPreviewBackgroundColorChange(_ object: Observer, closure: @escaping (PlateformColorType?) -> Void)
    
    func stopListeningToHtmlPreviewBackgroundColorChange(_ object: Observer)
}

