//
//  CSSStyle.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-01-15.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation
import Common
import os

/// The CSSSourceDocumentType represents the type of source document that
/// are used to compute this style. They all have a reference to
//struct CSSStyle: StyleDefinition, Versionable, Clonable, Syncable {
public struct CSSStyle: StyleDefinition {
    
    /// Id of the document.
    public var id: DOMString
    
    /// Temporary value to tell if this style is a temporary kind of style.
    /// A temporary style only contains temporary attributes to apply to a document.
    public let temporary: Bool
    
    public let styleAssemblyIdentifier: StyleAssemblyIdentifier
    
    public var debugDescription: String {
        
        return serialize()
    }
    
    public var numberOfStylesheets: Int {
        
        var _numberOfStylesheets = 0
        
        if userAgentStyleSheet != nil {
            _numberOfStylesheets += 1
        }
        _numberOfStylesheets += authorStyleSheets.count
        return _numberOfStylesheets
    }
    
    /// Style constructor
    public init(id: DOMString, userAgentStyleSheet: CSSStyleSheet? = nil, authorStyleSheets: [CSSStyleSheet]? = nil, userStyleSheet: CSSStyleSheet? = nil, temporary: Bool = false, styleAssemblyIdentifier: StyleAssemblyIdentifier = UUID().uuidString) {
        
        self.id = id
        self.authorStyleSheets = authorStyleSheets ?? [CSSStyleSheet]()
        self.userAgentStyleSheet = userAgentStyleSheet
        self.userStyleSheet = userStyleSheet
        self.temporary = temporary
        self.styleAssemblyIdentifier = styleAssemblyIdentifier
    }
    
    public mutating func addStyleSheet(_ styleSheet: CSSStyleSheet) {
        switch styleSheet.origin {
        case .user:
            assert(userStyleSheet == nil)
            userStyleSheet = styleSheet
        case .author:
            authorStyleSheets.append(styleSheet)
        case .userAgent:
            userAgentStyleSheet = styleSheet
        }
    }
    
    /// This method takes a copy of the single error style and assign a value
    /// to the nw-message-id selector.
    public func singleErrorStyleCopy(withErrorId errorId: String) -> CSSStyle {
        
        var temporarySingleErrorStyle = self.clone()
        temporarySingleErrorStyle.id = errorId
        
        let errorStylesheet = temporarySingleErrorStyle.authorStyleSheets.first
        
        assert(errorStylesheet != nil)
        if let errorStylesheet = errorStylesheet {
            
            errorStylesheet.updateErrorIdAttributeSelectorValue(withErrorId: errorId)
        }
        
        // return self
        return temporarySingleErrorStyle
    }

    public func clone() -> CSSStyle {

        var clone = self

        clone.userStyleSheet = nil
        clone.authorStyleSheets.removeAll()
        clone.userStyleSheet = nil

        if let userAgentStyleSheet = self.userAgentStyleSheet {

            let userAgentStyleSheetClone = userAgentStyleSheet.clone()
            clone.userAgentStyleSheet = userAgentStyleSheetClone
        }

        for authorStyleSheet in self.authorStyleSheets {

            let authorStyleSheetClone = authorStyleSheet.clone()
            clone.addStyleSheet(authorStyleSheetClone)
        }

        if let userStyleSheet = self.userStyleSheet {

            let userStyleSheetClone = userStyleSheet.clone()
            clone.userStyleSheet = userStyleSheetClone
        }

        return clone
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public func equals(to other: Any?) -> Bool {
        
        if let other = other {
        
            if let other = other as? CSSStyle {
            
                if let userAgentStyleSheet = self.userAgentStyleSheet {
                    
                    if !userAgentStyleSheet.equals(to: other.userAgentStyleSheet) {
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: other userAgentStyleSheet is different.", log: Log.Web.all, type: .debug)
                        #endif
                        return false
                    }
                }
                else if other.userAgentStyleSheet != nil {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: other userAgentStyleSheet is not nil.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                if self.authorStyleSheets.count != other.authorStyleSheets.count {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: other authorStyleSheets.count is different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                    
                for i in 0..<self.authorStyleSheets.count {
                    
                    let authorStyleSheet = self.authorStyleSheets[i]
                    let otherAuthorStyleSheet = other.authorStyleSheets[i]
                    
                    if !authorStyleSheet.equals(to: otherAuthorStyleSheet, comparePositions: false) {
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: other authorStyleSheets element is different.", log: Log.Web.all, type: .debug)
                        #endif
                        return false
                    }
                }

                if let userStyleSheet = self.userStyleSheet {
                    
                    if let otherUserStyleSheet = other.userStyleSheet {
                        
                        if !userStyleSheet.equals(to: otherUserStyleSheet) {
                            
                            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                            os_log("Not equals: other userStyleSheet is different.", log: Log.Web.all, type: .debug)
                            #endif
                            return false
                        }
                    }
                }
                else if other.userStyleSheet != nil {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: other userStyleSheet is not nil.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
            }
            else {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not CSSStyle.", log: Log.Web.all, type: .debug)
                #endif
                return false
            }
        }
        else {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Not equals: other is nil.", log: Log.Web.all, type: .debug)
            #endif
            return false
        }
        return true
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: debug method implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public func validateStyleStylesheetsAreNotSame(as current: CSSStyle) {
        
        if let userAgentStyleSheet = self.userAgentStyleSheet {
            
            let userAgentStylesheetId = ObjectIdentifier(userAgentStyleSheet)
            let currentUserAgentStylesheetId = ObjectIdentifier(current.userAgentStyleSheet!)
            
            assert(userAgentStylesheetId != currentUserAgentStylesheetId)
        }
        
        for i in 0..<self.authorStyleSheets.count {
            
            let authorStyleSheet = self.authorStyleSheets[i]
            let currentAuthorStyleSheet = current.authorStyleSheets[i]
            
            let authorStylesheetId = ObjectIdentifier(authorStyleSheet)
            let currentAuthorStylesheetId = ObjectIdentifier(currentAuthorStyleSheet)
            
            assert(authorStylesheetId != currentAuthorStylesheetId)
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: StyleDefinition protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public var style: CSSStyle {
        
        return self
    }
    
    public var styleString: String = ""
    
    public var userAgentStyleSheet: CSSStyleSheet?
    
    /// The list of author style sheets
    public var authorStyleSheets: [CSSStyleSheet]
    
    // This is the user stylesheet
    public var userStyleSheet: CSSStyleSheet?
    
}

extension CSSStyle: Equatable {
    
    public static func ==(lhs: CSSStyle, rhs: CSSStyle) -> Bool {
        
        return lhs.equals(to: rhs)
    }
}
