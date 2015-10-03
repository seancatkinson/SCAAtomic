//
//  PerformOnce.swift
//  SCAAtomic
//
//  Copyright (c) 2015 SeanCAtkinson (http://seancatkinson.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


/// Ensure an operation is only done once by performing it with a PerformOnce
/// Remember to store it in a static variable to ensure it is persisted
/// 
public final class PerformOnce {
    
    private var _done : Atomic<Bool>
    
    /// Check if the PerformOnce has been used yet
    public var done : Bool {
        return _done.value
    }
    
    /// Initialise a new PerformOnce
    /// Optionally provide a specific lock - defaults to a Mutex
    public init(lock:Lockable = Mutex()) {
        self._done = Atomic(false, lock:lock)
    }
    
    /// perform a closure if it hasn't been used already
    /// Returns a Bool indicating whether the closure was performed
    public func perform(@noescape closure:()->Void) -> Bool {
        let originalDoneValue = self._done.performAndReplace { _ in true }
        guard originalDoneValue == false else {
            return false
        }
        closure()
        return true
    }
    
    /// reset the performOnce so that the next perform() call will execute
    public func reset() {
        self._done.value = false
    }
}
