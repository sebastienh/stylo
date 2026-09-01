//
//  VersionableResource.swift
//  Common
//
//  Created by Sébastien Hamel on 2016-01-24.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation

public protocol Versionable: class {
    
    typealias Version = UUID
    
    /// String version of the UUID
    var stringVersion: String { get }
    
    /// Version of the item which is updated every time we operate on it
    /// on the main thread by the updateVersion() function.
    var version: Dynamic<Version> { get }
    
    /// This method update the syle version to a new version which
    /// simply consist of a UUID.
    ///
    /// Note: this method should be called from the main thread, since
    /// this is the simpler way of synchronizing access to it.
    func updateVersion()
    
}

public extension Versionable {
    
    /// String version of the UUID
    var stringVersion: String {
        
        return version.value.uuidString
    }
    
    ///
    /// This method update the syle version to a new version which
    /// simply consist of a UUID.
    ///
    /// Note: this method should be called from the main thread, since
    /// this is the simpler way of synchronizing access to it.
    ///
    func updateVersion() {
        
        self.version.setValue(UUID())
    }
}

