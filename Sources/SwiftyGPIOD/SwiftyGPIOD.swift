import CGPIOD

public final class SwiftyGPIOD {
    
    private let chip: OpaquePointer
    private let consumer: String

    public init(chip: String, consumer: String = "SwiftyGPIOD") throws {
        guard let chip = gpiod_chip_open_by_name(chip) else {
            throw GPIOError.openChipFailure
        }
        self.chip = chip
        self.consumer = consumer
    }

    deinit {
        gpiod_chip_close(chip)
    }

    public func getGPIO(pin: UInt32, direction: GPIODirection) throws -> GPIO {
        try GPIO(chip: chip, offset: pin, consumer: consumer, direction: direction)
    }

    public func getInputGPIO(pin: UInt32, onInputChanged: @escaping (GPIOEvent) -> Void) throws -> GPIO {
        try GPIO(chip: chip, offset: pin, consumer: consumer, direction: .input(.continuus(onInputChanged)))
    }
}