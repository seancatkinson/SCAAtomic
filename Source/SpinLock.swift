//
//  SpinLock.swift
//  SCAAtomic
//
//  Created by Sean C Atkinson on 10/10/2015.
//
//

import Foundation


public final class SpinLock {
    private var spinLock = OS_SPINLOCK_INIT
    
    public init() {}
}

extension SpinLock : Lockable {
    /// lock the mutex and block other threads from accessing until unlocked
    public func lock() {
        withUnsafeMutablePointer(&spinLock, OSSpinLockLock)
    }
    
    /// unlock the mutex and allow other threads access once again
    public func unlock() {
        withUnsafeMutablePointer(&spinLock, OSSpinLockUnlock)
    }
}