import CGPIOD
import Glibc

public struct GPIOEvent {
    public let value: Int
    public let event: EventType
}

final class GPIOInputMonitor {

    private let consumer: String
    private let monitorType: MonitorType
    private let line: OpaquePointer
    private var monitor: ((GPIOEvent) -> Void)?

    init(consumer: String, monitorType: MonitorType, line: OpaquePointer) {
        self.consumer = consumer
        self.monitorType = monitorType
        self.line = line
    }

    func run() throws {
        let activeLow = Int32(GPIOD_LINE_REQUEST_FLAG_ACTIVE_LOW)
        let pullUp = Int32(GPIOD_LINE_REQUEST_FLAG_BIAS_PULL_UP)
        let flags = activeLow | pullUp
        switch monitorType {
        case .continuus(let onChange):
            self.monitor = onChange
            try requestInput(flags: flags)
            Task { await runContinuus() }
        case .event:
            fatalError("Not supported yet")
            try requestBothEdgesEvents(line: line, flags: Int32(flags))
        }
    }

    func requestInput(flags: Int32) throws {
        let err = gpiod_line_request_input_flags(line, consumer, flags)
        if err < 0 {
            throw GPIOError.lineRequestInputFailure
        } else {
            print("Line requested")
        }
    }

    func requestBothEdgesEvents(line: OpaquePointer, flags: Int32 = 0) throws {
        let err = gpiod_line_request_both_edges_events_flags(line, consumer, flags)
        if err < -1 {
            throw GPIOError.lineRequestInputFailure
        }
    }

    private func runContinuus() async {
        let stream = basicContinuusChange(delay: .milliseconds(100))
        do {
            for try await event in stream {
                monitor?(event)
            }
        } catch {
            print(error)
        }
    }

    private func basicContinuusChange(delay: Duration) -> AsyncThrowingStream<GPIOEvent, Error> {
        AsyncThrowingStream { continuation in 
            Task {
                var previousValue = try readValue()
                continuation.yield(.init(value: Int(previousValue), event: .unknown))
                
                while true {
                    let value = try readValue()
                    if previousValue > value {
                        continuation.yield(.init(value: Int(value), event: .fallingEdge))
                    } else if previousValue < value {
                        continuation.yield(.init(value: Int(value), event: .risingEdge))
                    }
                    previousValue = value
                    try await Task.sleep(for: delay)
                }
            }
        }
    }

    func readValue() throws -> Int {
        let value = gpiod_line_get_value(line)
        if value < 0 {
            throw GPIOError.getValueFailed
        }
        return Int(value)
    }
}