import CGPIOD

public class GPIO {

    private let consumer: String
    private let line: OpaquePointer
    private let inputMonitor: GPIOInputMonitor?

    private var valueChangedAction: ((Int) -> Void)?
    
    var bias: BiasType { BiasType(gpiod_line_bias(line)) }
    var activeState: ActiveState { ActiveState(gpiod_line_active_state(line)) }

    init(chip: OpaquePointer, offset: UInt32, consumer: String, direction: GPIODirection) throws {
        guard let line = gpiod_chip_get_line(chip, offset) else {
            throw GPIOError.getLineFailure
        }
        self.line = line
        self.consumer = consumer
        if case .input(let monitorType) = direction {
            self.inputMonitor = GPIOInputMonitor(consumer: consumer, monitorType: monitorType, line: line)
            try self.inputMonitor?.run()
            inputMonitor?.monitor = { [weak self] event in 
                self?.valueChangedAction?(Int(event.value))
            }
        } else {
            self.inputMonitor = nil
        }
    }

    deinit {
        gpiod_line_release(line)
    }

    public func onValueChanged(_ action: @escaping (Int) -> Void) throws {
        if inputMonitor == nil { throw GPIOError.triedReadingFromOutputPin }
        valueChangedAction = action
    }

    public func readValue() throws -> Int {
        guard let inputMonitor else { throw GPIOError.triedReadingFromOutputPin  }
        return try inputMonitor.readValue()
    }
}