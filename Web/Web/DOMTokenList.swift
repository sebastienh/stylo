//
//  DOMTokenList.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-01-16.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation
import Common
import os

// see https://dom.spec.whatwg.org/#domtokenlist
//interface DOMTokenList {
//    readonly attribute unsigned long length;
//    getter DOMString? item(unsigned long index);
//    boolean contains(DOMString token);
//    void add(DOMString... tokens);
//    void remove(DOMString... tokens);
//    boolean toggle(DOMString token, optional boolean force);
//    stringifier;
//    iterable<DOMString>;
//};

/// DOMTokenList contains a list of tokens associated 
/// with an attribute related to an Element.
/// see https://dom.spec.whatwg.org/#domtokenlist
open class DOMTokenList {
    
    /// A DOMTokenList object has an associated ordered set of tokens, which is initially empty.
    /// see https://dom.spec.whatwg.org/#concept-dtl-tokens
    var tokens: [DOMString]
    
    /// The length attribute must return the number of tokens in the tokens.
    /// readonly attribute unsigned long length;
    /// https://dom.spec.whatwg.org/#dom-domtokenlist-length
    open var length: Int {
     
        return tokens.count
    }
    
    open var isEmpty: Bool {
        return length == 0
    }
    
    /// A DOMTokenList object has an associated element and
    unowned let element: Web.Element
    
    /// A DOMTokenList object also has an attribute's local name.
    var attributeLocalName: DOMString!
    
    init(element: Web.Element, attributeLocalName: DOMString) {
        self.element = element
        self.attributeLocalName = attributeLocalName
        self.tokens = [DOMString]()
    }
    
    /// Returns the token with index index.
    subscript(index: Int) -> DOMString? {

        get {
            return item(index)
        }
    }
    
    /// Returns the token with index index.
    /// getter DOMString? item(unsigned long index);
    /// see https://dom.spec.whatwg.org/#dom-domtokenlist-item
    func item(_ index: Int) -> DOMString? {

        if index < tokens.count {
            
            return tokens[index]
        }
        
        return nil
    }
    
    /// Returns true if token is present, and false otherwise.
    /// boolean contains(DOMString token);
    /// see https://dom.spec.whatwg.org/#dom-domtokenlist-contains
    func contains(_ token: DOMString, exception: inout Exception) -> Bool? {

        // 1. If token is the empty string, 
        // then throw a SyntaxError exception.
        if token == "" {
            
            exception.code = ExceptionCode.syntaxError
            return nil
        }
        
        // 2. If token contains any ASCII whitespace, 
        // then throw an InvalidCharacterError exception.
        if token.components(separatedBy: " ").count > 1 {
            
            exception.code = ExceptionCode.invalidCharacterError
            return nil
        }
        
        // 3. Return true if token is in tokens, and false otherwise.
        for item in self {
         
            if item == token {
                return true
            }
        }
        
        return false
    }
    
    /// Adds all arguments passed, except those already present.
    /// void add(DOMString... tokens);
    /// see https://dom.spec.whatwg.org/#dom-domtokenlist-add
    func add(_ tokens: [DOMString], exception: inout Exception) {

        for token in tokens {
        
            // 1. If one of tokens is the empty string,
            // throw a SyntaxError exception.
            if token == "" {
                
                exception.code = ExceptionCode.syntaxError
                return
            }
            
            // 2. If one of tokens contains any ASCII whitespace,
            // then throw an InvalidCharacterError exception.
            if token.components(separatedBy: " ").count > 1 {
                
                exception.code = ExceptionCode.invalidCharacterError
                return
            }
            
            // 3. For each token in tokens, in given order, 
            // that is not in tokens, append token to tokens.
            self.tokens.append(token)
            
            // 4. Run the update steps.
            // see https://dom.spec.whatwg.org/#concept-dtl-update
        }
        
    }
    
    /// Removes arguments passed, if they are present.
    /// void remove(DOMString... tokens);
    /// see https://dom.spec.whatwg.org/#dom-domtokenlist-remove
    func remove(_ tokens: [DOMString], exception: inout Exception) {

        for token in self.tokens {
        
            // 1. If one of tokens is the empty string, 
            // throw a SyntaxError exception.
            if token == "" {
                
                exception.code = ExceptionCode.syntaxError
                return
            }
            
            // 2. If one of tokens contains any ASCII whitespace, 
            // then throw an InvalidCharacterError exception.
            if token.components(separatedBy: " ").count > 1 {
                
                exception.code = ExceptionCode.invalidCharacterError
                return
            }
            
            // 3. For each token in tokens, 
            // remove token from tokens.
            if let index = index(of: token) {
             
                self.tokens.remove(at: index)
            }
        }
    }
    
    /// If force is not given, "toggles" token, removing it if it's present and adding it if it's not. 
    /// If force is true, adds token (same as add()). If force is false, removes token (same as remove()).
    /// boolean toggle(DOMString token, optional boolean force);
    /// see https://dom.spec.whatwg.org/#dom-domtokenlist-toggle
    func toggle(_ token: DOMString, force: Bool?, exception: inout Exception) -> Bool? {

        // 1. If token is the empty string, 
        // throw a SyntaxError exception.
        if token == "" {
            
            exception.code = ExceptionCode.syntaxError
            return nil
        }
        
        // 2. If token contains any ASCII whitespace, 
        // throw an InvalidCharacterError exception.
        if token.components(separatedBy: " ").count > 1 {
            
            exception.code = ExceptionCode.invalidCharacterError
            return nil
        }
        
        // 3. If token is in tokens, run these substeps:
        if let _ = index(of: token) {
            
            // 1. If force is either not passed or is false, then remove token from tokens, 
            // run the update steps, and return false.
            if let force = force {
                
                if !force {
                    
                    var tokens: [DOMString] = [DOMString]()
                    
                    tokens.append(token)
                    
                    remove(tokens, exception: &exception)
                    
                    if exception.isError() {
                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                        os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                        #endif
                        return nil
                    }
                    
                    return false
                }
                // 2. Otherwise, return true.
                return true
            }
            // 1. If force is either not passed or is false, then remove token from tokens,
            // run the update steps, and return false.
            else {
                
                var tokens: [DOMString] = [DOMString]()
                
                tokens.append(token)
                
                remove(tokens, exception: &exception)
                
                if exception.isError() {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                    #endif
                    return nil
                }
                
                return false
            }
            
        }
        // 4. Otherwise, run these substeps:
        else {
            
            // 1. If force is passed and is false, return false.
            if let force = force , !force {
                
                return false
            }
            // 2. Otherwise, append token to tokens, run the update steps, and return true.
            else {
                
                tokens.append(token)
                
                updateSteps(&exception)
                
                if exception.isError() {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                    #endif
                    return nil
                }
                
                return true
            }
        }
    }
    
    /// DOMTokenList object's update steps
    /// see https://dom.spec.whatwg.org/#concept-dtl-update
    fileprivate func updateSteps(_ exception: inout Exception) {
        
        // 1. If there is no associated attribute (when the object is a DOMSettableTokenList), 
        // terminate these steps.
        if let _ = self as? DOMSettableTokenList {
            
            return
        }
        
        // 2. Set an attribute value for the associated element using associated attribute's local name 
        // and the result of running the ordered set serializer for tokens.
        element.setAttribute(attributeLocalName, value: stringify(), exception: &exception)
    }
    
    /// Return the index of token in tokens array.
    fileprivate func index(of token: DOMString) -> Int? {
        
        var index = 0
        
        for existingToken in tokens {
        
            if token == existingToken {
                
                return index
            }
            
            index += 1
        }
        
        return nil
    }
    
}







