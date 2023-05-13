import XCTest
@testable import swift_lgpio_wrapper

final class swift_lgpio_wrapperTests: XCTestCase {
    func testExample() async throws {
        let gpio = try SwiftyLGPIO()
        while true {
            let value = try gpio.read(pin: 23)
            print(value)
            try await Task.sleep(for: .seconds(1))
        }
        
        // try await Task.sleep(for: .seconds(10))
        // XCTest Documenation
        // https://developer.apple.com/documentation/xctest

        // Defining Test Cases and Test Methods
        // https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods
    }
}
