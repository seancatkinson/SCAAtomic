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
        let atomic = Atomic(0)
        let expectation1 = self.expectationWithDescription("1")
        let expectation2 = self.expectationWithDescription("2")
        
        // concurrent queue so that we will be running at the same time
        let concurrentQueue = dispatch_queue_create("queue1", DISPATCH_QUEUE_CONCURRENT)
        
        print("Dispatching 1")
        dispatch_async(concurrentQueue) {
            print("Will call 1")
            let originalNumber = atomic.performAndReplace { current -> Int in                                
                print("1: \(current)")
                return 2
            }
            print("Call 1 finished")
            XCTAssertEqual(originalNumber, 0)
            expectation1.fulfill()
        }
        
        print("Dispatching 2")
        dispatch_async(concurrentQueue) {
            print("Will call 2")
            let originalNumber = atomic.performAndReplace { current -> Int in
                XCTAssertEqual(current, 2)
                print("2: \(current)")
                return 0
            }
            print("Call 2 finished")
            XCTAssertEqual(originalNumber, 2)
            expectation2.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(0.5, handler: nil)
    }

}
