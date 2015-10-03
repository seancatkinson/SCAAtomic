//: Playground - noun: a place where people can play

import SCAAtomic

let once = PerformOnce()

once.perform {
    print("I will be done :)")
}

once.perform {
    print("I won't be done :(")
}

once.reset()

once.perform {
    print("I will be done too :)")
}
