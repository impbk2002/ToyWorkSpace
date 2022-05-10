//
//  SpinLock.swift
//  
//
//  Created by pbk on 2022/04/27.
//

import Darwin
import Foundation

@available(iOS 2.0, *)
@available(iOS, deprecated: 10.0, message: "Use UnfairLock instead")
@available(macOS 10.4, *)
@available(macOS, deprecated: 10.12, message: "Use UnfairLock instead")
public final class SpinLock: NSObject, Sendable, NSLocking, CiriticalRegionLocker {
    private let spinLock:UnsafeMutablePointer<OSSpinLock>
    public override init() {
        spinLock = .allocate(capacity: 1)
        spinLock.initialize(to: OS_SPINLOCK_INIT)
        super.init()
    }
    
    deinit {
        spinLock.deinitialize(count: 1)
        spinLock.deallocate()
    }
    
    public func lock() {
        OSSpinLockLock(spinLock)
    }
    
    public func unlock() {
        OSSpinLockUnlock(spinLock)
    }
    
    public func `try`() -> Bool {
        OSSpinLockTry(spinLock)
    }
    
}
