import XCTest
@testable import CriticalManagement

final class CriticalManagementTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        //XCTAssertEqual(CriticalManagement().text, "Hello, World!")
//        let rwWrapped = Protected<Int,ReaderWriterLock>(10)
//        let _ = rwWrapped.wrappedValue
//        rwWrapped.wrappedValue = 100
        testLockWrapper(Mutex.self)
    }
    
    func testGCDRWLock() {
       // let rwLock = ReaderWriterLock()
       // let lock = NSRecursiveLock()
       
        @Protected<Int,UnfairLock>
        var value = 0
        let dispatchBlockCount = 16
        let iterationCountPerBlock = 100_000
        // This is an example of a performance test case.
        let queues = [
            DispatchQueue.global(qos: .userInteractive),
            DispatchQueue.global(qos: .default),
            DispatchQueue.global(qos: .utility),
            ]
//        @Protected<Bool, ReaderWriterLock>
//        var flag = false
        
        self.measure {
            let group = DispatchGroup.init()
            for block in 0..<dispatchBlockCount {
                group.enter()
                let queue = queues[block % queues.count]
                queue.async(execute: {
                    for _ in 0..<iterationCountPerBlock {
                        let randomFlag = Int.random(in: 0...100)
                        if randomFlag < 11 {
//                            rwLock.whileWriting {
//                            value = value + 2
//                            value = value - 1
//                            }
                            //lock.around {
                                value = value + 2
                                value = value - 1
                           // }
                        } else {
//                            rwLock.whileReading {
//                                value
//                            }
                           // lock.around {
                                value
                          //  }
                        }
//                        lock.around{
//                            value = value + 2
//                            value = value - 1
//                        }
                        //value.toggle()
//                        $value.atomicWrite {
//                            $0 += 2
//                            $0 -= 1
//                        }

                    }
                    group.leave()
                })
            }
            _ = group.wait(timeout: DispatchTime.distantFuture)
        }
    }
    
    func testLockWrapper<T: CiriticalRegionLocker>(_ lock:T.Type) {
        @Protected<Bool,T>
        var value = false
        //let lock = T()
        let dispatchBlockCount = 16
        let iterationCountPerBlock = 100_000
        // This is an example of a performance test case.
        let queues = [
            DispatchQueue.global(qos: .userInteractive),
            DispatchQueue.global(qos: .default),
            DispatchQueue.global(qos: .utility),
            ]
//        @Protected<Bool, ReaderWriterLock>
//        var flag = false
        
        self.measure {
            let group = DispatchGroup.init()
            for block in 0..<dispatchBlockCount {
                group.enter()
                let queue = queues[block % queues.count]
                queue.async(execute: {
                    for _ in 0..<iterationCountPerBlock {
                        let randomFlag = Int.random(in: 0...100)
                        if randomFlag < 11 {
                            value.toggle()
                        } else {
                            let _ = value
                        }
//                        lock.around{
//                            value = value + 2
//                            value = value - 1
//                        }
                        //value.toggle()
//                        $value.atomicWrite {
//                            $0 += 2
//                            $0 -= 1
//                        }

                    }
                    group.leave()
                })
            }
            _ = group.wait(timeout: DispatchTime.distantFuture)
        }
    }
    
    
    func testSpinLock() {
        let lock = SpinLock()
        executeLockTest { (block) in
            lock.lock()
            block()
            lock.unlock()
        }
    }
    
    @available(macOS 10.12, *)
    @available(iOS 10.0, *)
    func testUnfairLock() {
        let lock = UnfairLock()
        executeLockTest { (block) in
            lock.lock()
            block()
            lock.unlock()
        }
    }

    func testDispatchSemaphore() {
        let sem = DispatchSemaphore(value: 1)
        executeLockTest { (block) in
            _ = sem.wait(timeout: DispatchTime.distantFuture)
            block()
            sem.signal()
        }
    }

    func testNSLock() {
        let lock = NSLock()
        executeLockTest { (block) in
            lock.lock()
            block()
            lock.unlock()
        }
    }
    
    func testReculsiveCondition() {
        let lock = NSRecursiveLock()
        executeLockTest { block in
            lock.lock()
            block()
            lock.unlock()
        }
    }

    func testPthreadMutex() {
        let mutex = Mutex()
        executeLockTest{ (block) in
            mutex.lock()
            block()
            mutex.unlock()
        }
    }

    func testSyncronized() {
        let obj = NSObject()
        executeLockTest{ (block) in
            objc_sync_enter(obj)
            block()
            objc_sync_exit(obj)
        }
    }

    func testQueue() {
        let lockQueue = DispatchQueue.init(label: "com.test.LockQueue")
        executeLockTest{ (block) in
            lockQueue.sync() {
                block()
            }
        }
    }

    
    func testRwlock() {
        let lock = ReaderWriterLock()
        executeLockTest { block in
            lock.lock()
            block()
            lock.unlock()
        }
    }


    
    func disabled_testNoLock() {
        executeLockTest { (block) in
            block()
        }
    }
    
    private func executeLockTest(performBlock:@escaping (_ block:() -> Void) -> Void) {
        let dispatchBlockCount = 16
        let iterationCountPerBlock = 100_000
        // This is an example of a performance test case.
        let queues = [
            DispatchQueue.global(qos: .userInteractive),
            DispatchQueue.global(qos: .default),
            DispatchQueue.global(qos: .utility),
            ]
        var value = 0
        self.measure {
            let group = DispatchGroup.init()
            for block in 0..<dispatchBlockCount {
                group.enter()
                let queue = queues[block % queues.count]
                queue.async(execute: {
                    for _ in 0..<iterationCountPerBlock {
                        performBlock({
                            value = value + 2
                            value = value - 1
                        })
                    }
                    group.leave()
                })
            }
            _ = group.wait(timeout: DispatchTime.distantFuture)
        }
    }
    
    
}
