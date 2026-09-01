//
//  CSSDOMDocumentFragment.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-06-16.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation

final public class CSSDOMDocumentFragment: DocumentFragment {
    
    var commentsCount: Int {
        
        var count = 0
        var child = firstChild
        
        while child != nil {
            
            if let tokenElement = child as? CSSDOMTokenElement, tokenElement.tokenClass == .CommentToken {
                count += 1
            }
            child = child?.nextSibling
        }
        return count
    }
    
    init() {
        
        super.init(sourceStringFragment: nil, document: nil, host: nil)
    }
    
    public func removeAllComments() -> [CSSDOMTokenElement] {
        
        var comments = [CSSDOMTokenElement]()
        var exception = Exception()
        var child = firstChild
        
        while child != nil {
            
            if let tokenElement = child as? CSSDOMTokenElement, tokenElement.tokenClass == .CommentToken {
                
                let nextChild = tokenElement.nextSibling
                self.remove(tokenElement, exception: &exception)
                comments.append(tokenElement)
                exception.logIfError()
                child = nextChild
            }
            else {
                child = child?.nextSibling
            }
        }
        return comments
    }
    
}
