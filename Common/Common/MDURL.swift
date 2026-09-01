//
//  MDURL.swift
//  Common
//
//  Created by Sébastien Hamel on 2016-06-09.
//  Copyright © 2016 NM. All rights reserved.
//

import Foundation


public struct MDURL: Equatable {
    
    public var proto: String?
    public var slashes: Bool?
    public var auth: String?
    public var port: String?
    public var hostname: String?
    public var hash: String?
    public var search: String?
    public var pathname: String?
    
    init() {
        // empty 
    }
    
    init(json: [String: String]) {
        
        // Loop
        for (key, value) in json {
            
            let keyName = key as String
            
            switch keyName {
                
            case "proto": proto = value
            case "slashes": slashes = value == "true" ? true : false
            case "auth": auth = value
            case "port" : port = value
            case "hostname" : hostname = value
            case "hash": hash = value
            case "search" : search = value
            case "pathname" : pathname = value
            default: break
            }
        }
        
        if hostname == nil {
            
            hostname = ""
        }
        
        if port == nil {
            
            port = ""
        }
    }
    
    
    public func format() -> String {
        
        var result = ""
        
        if let proto = proto {
            
            result += proto
        }
        else {
            
            result += ""
        }
        
        if let slashes = slashes, slashes {
            
            result += "//"
        }
        
        if let auth = auth {
            
            result += auth + "@"
        }
        
        if hostname != nil && hostname!.indexOf(§":") != nil {
            
            // ipv6 address
            result += "[" + hostname! + "]"
        }
        else {
            
            if let hostname = hostname {
                
                result += hostname
            }
        }
    
        if let port = port, port.length > 0 {
            
            result += ":" + port
        }
        
        if let pathname = pathname {
            
            result += pathname
        }
        
        if let search = search {
            
            result += search
        }
        
        if let hash = hash {
            
            result += hash
        }
        
        return result
    }
}

public func ==(lhs: MDURL, rhs: MDURL) -> Bool {
    
    if let lhsproto = lhs.proto  {
        
        if let rhsproto = rhs.proto  {
        
            if lhsproto.lowercased() != rhsproto.lowercased() {
                
                return false
            }
        }
        else {
        
            return false
        }
    }
    
    if let lhsslashes = lhs.slashes  {
        
        if let rhsslashes = rhs.slashes  {
            
            if lhsslashes != rhsslashes {
                
                return false
            }
        }
        else {
        
            return false
        }
    }
    
    if let lhsauth = lhs.auth  {
        
        if let rhsauth = rhs.auth  {
            
            if lhsauth != rhsauth {
                
                return false
            }
        }
        else {
        
            return false
        }
    }
    
    if let lhsport = lhs.port  {
        
        if let rhsport = rhs.port  {
            
            if lhsport != rhsport {
                
                return false
            }
        }
        else {
        
            return false
        }
    }
    
    if let lhshostname = lhs.hostname  {
        
        if let rhshostname = rhs.hostname  {
            
            if lhshostname != rhshostname {
                
                return false
            }
        }
        else {
            
            return false
        }
    }
    
    if let lhshash = lhs.hash  {
        
        if let rhshash = rhs.hash  {
            
            if lhshash != rhshash {
                
                return false
            }
        }
        else {
            
            return false
        }
    }

    if let lhssearch = lhs.search  {
        
        if let rhssearch = rhs.search  {
            
            if lhssearch != rhssearch {
                
                return false
            }
        }
        else {
            
            return false
        }
    }
    
    if let lhspathname = lhs.pathname  {
        
        if let rhspathname = rhs.pathname  {
            
            if lhspathname != rhspathname {
                
                return false
            }
        }
        else {
            
            return false
        }
    }
    
    return true
}
