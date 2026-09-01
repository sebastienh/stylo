//
//  Env.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-12-01.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

public protocol Env {
    
    var isEmpty: Bool { get }
    
    var referencingTokens: Set<Token> { get set }
    
    var references: [String: [ReferenceEntry]] { get }
    
    var referencesSignature: String { get }
    
    func reference(for key: String) -> ReferenceEntry?
    
    func addReference(_ reference: inout ReferenceEntry) 
    
    func clean()
    
    func clean(in range: NSRange) -> Set<String>
    
    func cleanReferences(range: NSRange, keys impactedReferencesKeys: [String])
    
    func cleanReferencingTokens(_ tokens: [Token])
    
    func moveReferences(after index: Int, by count: Int)

    func updateReferenceEntryAttributes(with label: String, attrs: [AttributesBloc], in range: Range<Int>)
}
