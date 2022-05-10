//
//  Protected.swift
//  
//
//  Created by pbk on 2022/05/03.
//

import Foundation

@propertyWrapper
@dynamicMemberLookup
final class Protected<T,Lock:CiriticalRegionLocker> {
    private let lock:Lock = .init()
    private var value:T
    init(_ value: T) {
        self.value = value
    }
    init(wrappedValue: T) {
        value = wrappedValue
    }
    var wrappedValue:T {
        get { lock.around{ value } }
        set { lock.around{ value = newValue }}
    }
    
    var projectedValue: Protected<T,Lock> { self }
    
    /// Synchronously modify the protected value.
    ///
    /// - Parameter closure: The closure to execute.
    ///
    /// - Returns:           The modified value.
    @discardableResult
    func atomicWrite<U>(_ closure: (inout T) throws -> U) rethrows -> U {
        try lock.around { try closure(&self.value) }
    }

}

extension Protected {
    /// Synchronously read or transform the contained value.
    ///
    /// - Parameter closure: The closure to execute.
    ///
    /// - Returns:           The return value of the closure passed.
    func atomicRead<U>(_ closure: (T) throws -> U) rethrows -> U {
        try lock.around { try closure(self.value) }
    }
    subscript<Property>(dynamicMember keyPath: WritableKeyPath<T, Property>) -> Property {
        get { lock.around { value[keyPath: keyPath] } }
        set { lock.around { value[keyPath: keyPath] = newValue } }
    }

    subscript<Property>(dynamicMember keyPath: KeyPath<T, Property>) -> Property {
        lock.around { value[keyPath: keyPath] }
    }
}

extension Protected where Lock == ReaderWriterLock {
    var wrappedValue:T {
        get { lock.whileReading{ value } }
        set { lock.whileWriting{ value = newValue }}
    }
    /// Synchronously read or transform the contained value.
    ///
    /// - Parameter closure: The closure to execute.
    ///
    /// - Returns:           The return value of the closure passed.
    func atomicRead<U>(_ closure: (T) throws -> U) rethrows -> U {
        try lock.whileReading { try closure(self.value) }
    }
    
    subscript<Property>(dynamicMember keyPath: WritableKeyPath<T, Property>) -> Property {
        get { lock.whileReading { value[keyPath: keyPath] } }
        set { lock.whileWriting { value[keyPath: keyPath] = newValue } }
    }

    subscript<Property>(dynamicMember keyPath: KeyPath<T, Property>) -> Property {
        lock.whileReading { value[keyPath: keyPath] }
    }
    
}

@propertyWrapper
@dynamicMemberLookup
final class ReadWriteProtected<T> {
    private let queue = DispatchQueue(label: "ReadWriteProtected.private.concurrent.queue", attributes: .concurrent)
    private var value:T
    init(_ value: T) {
        self.value = value
    }
    init(wrappedValue: T) {
        value = wrappedValue
    }
    var wrappedValue:T {
        get {
            queue.sync {
                value
            }
            
        }
        set { queue.async(flags: [.barrier]) {
            self.value = newValue
        }}
    }
    
    var projectedValue: ReadWriteProtected<T> { self }
    
    subscript<Property>(dynamicMember keyPath: WritableKeyPath<T, Property>) -> Property {
        get { queue.sync { value[keyPath: keyPath] } }
        set { queue.async(flags: [.barrier]) { self.value[keyPath: keyPath] = newValue } }
    }

    subscript<Property>(dynamicMember keyPath: KeyPath<T, Property>) -> Property {
        queue.sync { value[keyPath: keyPath] }
    }
}

extension NSRecursiveLock: CiriticalRegionLocker {}
