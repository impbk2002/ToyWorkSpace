//
//  UnfairLock.swift
//  
//
//  Created by pbk on 2022/04/27.
//

import Foundation

@available(macOS 10.12, *)
@available(iOS 10.0, *)
public final class UnfairLock: NSObject, Sendable, NSLocking, CiriticalRegionLocker {
    private let osLock:os_unfair_lock_t
    public override init() {
        osLock = .allocate(capacity: 1)
        osLock.initialize(to: .init())
        super.init()
    }
    
    deinit {
        osLock.deinitialize(count: 1)
        osLock.deallocate()
    }
    
    public func `try`() -> Bool {
        os_unfair_lock_trylock(osLock)
    }
    
    public func lock() {
        os_unfair_lock_lock(osLock)
    }
    
    public func unlock() {
        os_unfair_lock_unlock(osLock)
    }
    
    public func assertOwner() {
        os_unfair_lock_assert_owner(osLock)
    }
    
    public func assertNotOwner() {
        os_unfair_lock_assert_not_owner(osLock)
    }
}

