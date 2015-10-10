import SCAAtomic

class AtomicInt {
    
    var num : Atomic<Int>
    
    init(_ initialValue:Int) {
        num = Atomic(initialValue, lock: Mutex())
    }
    
    func increment() {
        self.num.performAndReplace { oldValue in
            return oldValue + 1
        }
    }
    
    func decrement() {
        self.num.performAndReplace { oldValue in
            return oldValue - 1
        }
    }
    
    func currentNumber() -> Int {
        return num.value
    }
    
    func isEven() -> Bool {
        return self.num.map { (currentValue) -> Bool in
            return (currentValue % 2 == 0)
        }
    }
}

// increment and decrement a number atomically
let atomicNumber = AtomicInt(0)
print("\(atomicNumber.currentNumber())")

print("Increment >-")
atomicNumber.increment()
print("\(atomicNumber.currentNumber())")

print("Decrement >-")
atomicNumber.decrement()
print("\(atomicNumber.currentNumber())")

print("Is Even Number? Let's check: \(atomicNumber.isEven())")

print("Setting to 15")
atomicNumber.num.value = 15
print("Still Even? \(atomicNumber.isEven())")
print("Increment to 16 >-")
atomicNumber.increment()
print("\(atomicNumber.currentNumber())")
print("Even Now? \(atomicNumber.isEven())")