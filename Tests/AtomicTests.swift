//
//  AtomicTests.swift
//  SCAAtomic
//
//  Created by Sean C Atkinson on 02/10/2015.
//
//

import XCTest
import SCAAtomic

class AtomicTests: XCTestCase {

    func testMap() {
        let atomic = Atomic(false)
        let result = atomic.map { current -> Bool in
            XCTAssertEqual(current, false)
            return true
        }
        XCTAssertEqual(result, true)
    }

    func testAtomicBlocksAccessWhilstLocked() {
        let atomic : Atomic<Int> = Atomic(0)
        self.runTestWithAtomic(atomic, numberOfRuns: 100, numberToAdd: 2)
    }
    
    func testPerformWithValue() {
        let value = 0
        let atomic = Atomic(value)
        let expectation1 = self.expectationWithDescription("1")
        atomic.performWithValue { current in
            XCTAssertEqual(current, 0)
            expectation1.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    func testSwapValue() {
        let value = 0
        let atomic = Atomic(value)
        var value2 = 5
        value2 = atomic.swapValueWith(value2)
        
        XCTAssertEqual(value2, value)
        XCTAssertEqual(atomic.value, 5)
    }
    
    func testSpinLock() {
        let atomic : Atomic<Int> = Atomic(0, lock:SpinLock())
        self.runTestWithAtomic(atomic, numberOfRuns: 100, numberToAdd: 2)
    }
    
    
    
    
    // MARK: - Helpers
    func runTestWithAtomic(atomicStore:Atomic<Int>, numberOfRuns:Int, numberToAdd:Int) {
        let expectedFinalValue = numberOfRuns*numberToAdd
        
        // concurrent queue so that we will be running at the same time
        let concurrentQueue = dispatch_queue_create("queue1", DISPATCH_QUEUE_CONCURRENT)
        
        for i in 0..<numberOfRuns {
            
            let expectation1 = self.expectationWithDescription("\(i)")
            
            print("Dispatching \(i)")
            dispatch_async(concurrentQueue) {
                print("Will call \(i)")
                atomicStore.performAndReplace { current -> Int in
                    print("\(i): \(current)")
                    return current + 2
                }
                print("Call \(i) finished")
                expectation1.fulfill()
            }
        }
        
        self.waitForExpectationsWithTimeout(2.5) { (maybeError) -> Void in
            print("Final: \(atomicStore.value)")
            XCTAssertEqual(atomicStore.value, expectedFinalValue)
        }
    }

}
