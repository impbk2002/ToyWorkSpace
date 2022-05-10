//
//  Mutex.swift
//  
//
//  Created by pbk on 2022/04/27.
//

import Foundation

public final class Mutex: NSObject, Sendable, NSLocking, CiriticalRegionLocker {
    private let mutex:UnsafeMutablePointer<pthread_mutex_t>
    public override init() {
        mutex = .allocate(capacity: 1)
        mutex.initialize(to: .init())
        super.init()
        pthread_mutex_init(mutex, nil)
    }
    
    deinit {
        pthread_mutex_destroy(mutex)
        mutex.deinitialize(count: 1)
        mutex.deallocate()
    }
    
    public func lock() {
        pthread_mutex_lock(mutex)
    }
    
    public func unlock() {
        pthread_mutex_unlock(mutex)
    }
    
    public func `try`() -> Bool {
        pthread_mutex_trylock(mutex) == 0
    }
    
}
