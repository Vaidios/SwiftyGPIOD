import SwiftyGPIOD
import ArgumentParser

struct PhoneHangup {

    var normallyOpen: Bool
    var normallyClosed: Bool

    var isUp: Bool {
        normallyOpen && !normallyClosed
    }

    mutating func setFromPin23(value: Int) {
        normallyOpen = value == 1
        printOut()
    }

    mutating func setFromPin24(value: Int) {
        normallyClosed = value == 1
        printOut()
    }

    func printOut() {
        print("Phone is \(isUp ? "Up" : "Down")")
    }
}

@main
struct AudioPassthroughExample: AsyncParsableCommand {

    func run() async throws {
        do {
            var hangup: PhoneHangup = .init(normallyOpen: true, normallyClosed: true)
            let gpiod = try SwiftyGPIOD(chip: "gpiochip0")

        } catch {
            print(error)
        }
        print("monitoring")
    }
}