//
//  Saving.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-07-26.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation

public protocol Saving {
    
    var fileWrapperId: String { get }
    
    var emptyFileWrapper: FileWrapper { get }
    
    func createFileWrapper() -> FileWrapper?
    
    /// The method is passed the existing file wrapper
    /// and can chose to update it or to return a new one.
    func fileWrapper(fromCurrentFileWrapper fileWrapper: FileWrapper) -> FileWrapper?
}

extension Saving {

    public var fileWrapperId: String {
        return ""
    }
    
    public var emptyFileWrapper: FileWrapper {
        return FileWrapper()
    }

    public func fileWrapper(fromCurrentFileWrapper fileWrapper: FileWrapper) -> FileWrapper? {
        assertionFailure("Error: not implemented")
        return nil
    }
}
