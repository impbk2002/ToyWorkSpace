//
//  ReaderWriterLock.swift
//  
//
//  Created by pbk on 2022/04/27.
//

import Darwin
import Foundation

@available(iOS 2.0, *)
public final class ReaderWriterLock: NSObject, Sendable, NSLocking, CiriticalRegionLocker {
    private let rwLock:UnsafeMutablePointer<pthread_rwlock_t>
    
    public override init() {
        rwLock = .allocate(capacity: 1)
        rwLock.initialize(to: .init())
        super.init()
        pthread_rwlock_init(rwLock, nil)
    }
    
    deinit {
        pthread_rwlock_destroy(rwLock)
        rwLock.deinitialize(count: 1)
        rwLock.deallocate()
    }
    
    public func lock() {
        pthread_rwlock_wrlock(rwLock)
    }
    
    public func unlock() {
        pthread_rwlock_unlock(rwLock)
    }
    
    public func `try`() -> Bool {
        pthread_rwlock_trywrlock(rwLock) == 0
    }
    
    public func readLock() {
        pthread_rwlock_rdlock(rwLock)
    }
    
    public func tryRead() -> Bool {
        pthread_rwlock_tryrdlock(rwLock) == 0
    }
    
    public func whileReading<T>(body: () throws -> T) rethrows -> T {
        readLock(); defer { unlock() }
        return try body()
    }
    
    public func whileWriting<T>(body: () throws -> T) rethrows -> T {
        lock(); defer { unlock() }
        return try body()
    }
}

extension ReaderWriterLock {
    /// Executes a closure returning a value while acquiring the lock.
    ///
    /// - Parameter closure: The closure to run.
    ///
    /// - Returns:           The value the closure generated.
    func readAround<T>(_ closure: () throws -> T) rethrows -> T {
        readLock(); defer { unlock() }
        return try closure()
    }
    
}


