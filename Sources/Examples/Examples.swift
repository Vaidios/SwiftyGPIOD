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
            let gpio23 = try gpiod.getInputGPIO(pin: 23) { event in 
                    hangup.setFromPin23(value: event.value)
                }
            let gpio24 = try gpiod.getInputGPIO(pin: 24) { event in 
                    hangup.setFromPin24(value: event.value)
                }
            try await Task.sleep(for: .seconds(30))

        } catch {
            print(error)
        }
        print("monitoring")
    }
}