//
//  Atomic.swift
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


/// Box a value in an atomic wrapper
public final class Atomic <T> {
    
    // mutex for locking
    private var lockable : Lockable
    
    // private backing var for the value
    private var _value : T
    
    /// Atomically get or set the stored value
    public var value : T {
        get {
            self.lockable.lock()
            defer { self.lockable.unlock() }
            
            return _value
        }
        set {
            self.lockable.lock()
            defer { self.lockable.unlock() }
            
            _value = newValue
        }
    }
    
    /// Initialise a new Atomic store with a provided initial value
    public init(_ value : T, lock:Lockable = Mutex()) {
        self._value = value
        self.lockable = lock
    }
    
    /// Atomically execute a closure passing in the current value and replacing the stored
    /// value with the result.
    /// Returns the original value
    public func performAndReplace(@noescape closure: T -> T) -> T {
        self.lockable.lock()
        defer { self.lockable.unlock() }
        let originalValue = self._value
        self._value = closure(originalValue)
        
        return originalValue
    }
    
    /// Atomically map the currently stored value to a value of type R
    /// Returns the result of the closure
    public func map<R>(@noescape closure: T -> R) -> R {
        self.lockable.lock()
        defer { self.lockable.unlock() }
        
        return closure(self._value)
    }
}
