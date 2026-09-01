//
//  PThreadRWLock.swift
//  Common
//
//  Created by Sebastien Hamel on 2020-10-17.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

public final class ReadWriteLock {
    
    private var rwlock: pthread_rwlock_t = {
        var rwlock = pthread_rwlock_t()
        pthread_rwlock_init(&rwlock, nil)
        return rwlock
    }()
    
    public init() {
        
    }
    
    @discardableResult
    public func withReadLock<Result>(_ body: () throws -> Result) rethrows -> Result {
        self.readLock()
        defer { self.unlock() }
        return try body()
    }
    
    @discardableResult
    public func withWriteLock<Return>(_ body: () throws -> Return) rethrows -> Return {
        self.writeLock()
        defer { self.unlock() }
        return try body()
    }
    
    public func writeLock() {
        
        pthread_rwlock_wrlock(&rwlock)
    }
    
    public func readLock() {
        
        pthread_rwlock_rdlock(&rwlock)
    }
    
    public func unlock() {
        
        pthread_rwlock_unlock(&rwlock)
    }
    
    deinit {
        let status = pthread_rwlock_destroy(&rwlock)
        assert(status == 0)
    }
}


