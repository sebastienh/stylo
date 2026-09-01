//
//  CompletionValue.swift
//  Common
//
//  Created by Sébastien Hamel on 2016-03-02.
//  Copyright © 2016 NM. All rights reserved.
//

import Foundation

public final class CompletionValue: CompletionValueType {
    
    public let desc: String
    
    public let language: Language
    
    public let completionValue: String
    
    public let completionDisplay: String
    
    public let type: AutocompletionType
    
    public var shortDescription: String {
        
        return type.stringValue
    }
    
    
    // see NW-245
    // public var languageSyntaxElementType: LanguageSyntaxElementType
    
    // see NW-246
    // public var elementType: String
    
    public init(desc: String, completionValue: String, completionDisplay: String? = nil, language: Language? = nil, type: AutocompletionType) {
        
        self.desc = desc
        self.completionValue = completionValue
        self.completionDisplay = completionDisplay == nil ? completionValue : completionDisplay!
        self.language = language != nil ? language! : Language.All
        self.type = type
    }
}

public func ==(lhs: CompletionValue, rhs: CompletionValue) -> Bool {
    
    if lhs.desc != rhs.desc {
        
        return false
    }
    
    if lhs.language != rhs.language {
        
        return false
    }
    
    if lhs.completionValue != rhs.completionValue {
        
        return false
    }

    if lhs.completionDisplay != rhs.completionDisplay {
        
        return false
    }
    
    if lhs.shortDescription != rhs.shortDescription {
        
        return false 
    }
    
    return true
}

