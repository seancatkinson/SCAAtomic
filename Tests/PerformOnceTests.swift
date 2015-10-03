//
//  PerformOnceTests.swift
//  SCAAtomic
//
//  Created by Sean C Atkinson on 02/10/2015.
//
//

import XCTest
import SCAAtomic

class PerformOnceTests: XCTestCase {

    func testPerformOnceOnlyExecutesFirstTime() {
        let once = PerformOnce()
        XCTAssertEqual(once.done, false)
        
        let expectation = self.expectationWithDescription("Should be performed")
        once.perform {
            expectation.fulfill()
        }
        
        XCTAssertEqual(once.done, true)
        once.perform { () -> Void in
            XCTFail("Should not be performed")
        }
        
        self.waitForExpectationsWithTimeout(0.5, handler: nil)
    }
    
    func testPerformOnceCanBeReset() {
        let once = PerformOnce()
        let expectation1 = self.expectationWithDescription("Should be performed")
        let expectation2 = self.expectationWithDescription("Should be performed")
        once.perform {
            expectation1.fulfill()
        }
        once.reset()
        once.perform {
            expectation2.fulfill()
        }
        self.waitForExpectationsWithTimeout(0.5, handler: nil)
    }
    
    func testPerformOnceWithMutex() {
        let once = PerformOnce(lock: Mutex())
        let expectation = self.expectationWithDescription("Should be performed")
        once.perform {
            expectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(0.5, handler: nil)
    }
}
