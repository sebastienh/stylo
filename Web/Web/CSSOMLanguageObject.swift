//
//  CSSOMLanguageObject.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-05-24.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import os

open class CSSOMLanguageObject: LanguageObject, CSSVisitable, Hashable, ParentOwner, CommonTreeOperable, Compilable {
    
    open var sourceStringSegment: SourceStringSegment? {
        get {
            return super.sourceStringFragment as? SourceStringSegment
        }
        set {
            super.sourceStringFragment = newValue
            #if DEBUG
            if let newValue = newValue {
                newValue.validate()
            }
            #endif
        }
    }
    
    init(sourceStringSegment: SourceStringSegment? = nil) {

        #if DEBUG
        if let sourceStringSegment = sourceStringSegment {
            sourceStringSegment.validate()
        }
        #endif
        super.init(sourceStringFragment: sourceStringSegment)
    }
    
    /// Each CSSOM language element knows it's corresponding CSS DOM
    /// element in the CSS DOM pseudo tree. 
    weak var correspondingCssDomElement: Element?
    
    func updateCorrespondingCssDomElement(_ element: Element) {
        
        correspondingCssDomElement = element
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Compilable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public typealias LanguageObjectType = CSSOMLanguageObject
    
    open var minimalCompilationUnit: CSSOMLanguageObject {
     
        fatalError("Missing subclass implementation.")
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ParentOwner protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public typealias ParentType = CSSOMLanguageObject
    
    weak open var parent: CSSOMLanguageObject?
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CommonTreeOperable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias ChildNodeType = CSSOMLanguageObject
    
    open func childIndexForChild(_ child: CSSOMLanguageObject) -> Int? {
        
        assert(false, "Missing subclass implementation.")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("childIndexForChild(..) missing subclass implementation.", log: Log.Web.all, type: .error)
        #endif
        return nil
    }
    
    open func deleteAllChildren() {
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Missing subclass implementation!", log: Log.Web.all, type: .fault)
        #endif
        assert(false, "Missing subclass implementation.")
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSSVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    open func accept(_ visitor: CSSVisitor) {
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Missing subclass implementation!", log: Log.Web.all, type: .fault)
        #endif
        assert(false, "Missing subclass implementation.")
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Hashable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    open var hashValue: Int {
        
        return UInt(bitPattern: ObjectIdentifier(self)).hashValue
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    open override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
        
        if let other = other {
        
            if let other = other as? CSSOMLanguageObject {
                
                return super.equals(to: other, comparePositions: comparePositions)
            }
            else {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not CSSOMLanguageObject.", log: Log.Web.all, type: .debug)
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
    }
    
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                  MARK: Equatable protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////

public func ==(lhs: CSSOMLanguageObject, rhs: CSSOMLanguageObject) -> Bool {
    
    return lhs.equals(to: rhs)
}
