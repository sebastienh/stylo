//
//  SemanticVersion+BundleVersion.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-03-11.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation

extension SemanticVersion {
    
    static var bundleSemanticVersion: SemanticVersion? {
        
        let infoDictionary = Bundle.main.infoDictionary
        
        assert(infoDictionary != nil)
        if let infoDictionary = infoDictionary {
            
            //First get the nsObject by defining as an optional anyObject
            let any: Any? = infoDictionary["CFBundleShortVersionString"]
            
            //Then just cast the object as a String, but be careful, you may want to double check for nil
            let version = any as? String
            
            assert(version != nil)
            if let version = version {
                
                let components = version.components(separatedBy: ".")

                if components.count == 3 {
                
                    let major = UInt32(components[0])
                    let minor = UInt32(components[1])
                    let patch = UInt32(components[2])
                    
                    assert(major != nil)
                    assert(minor != nil)
                    assert(patch != nil)
                    if let major = major, let minor = minor, let patch = patch {
                    
                        return SemanticVersion.with {
                            $0.major = major
                            $0.minor = minor
                            $0.patch = patch
                        }
                    }
                }
            }
        }
        return nil
    }
    
    

    
}
