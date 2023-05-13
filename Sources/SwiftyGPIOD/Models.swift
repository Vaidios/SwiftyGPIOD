import CGPIOD

public enum MonitorType {
    case continuus((GPIOEvent) -> Void)
    case event
}

public enum GPIOError: Error {
    case openChipFailure
    case getLineFailure
    case lineRequestInputFailure
    case streamFailure
    case getValueFailed
    case triedReadingFromOutputPin
}

public enum GPIODirection {
    case input(MonitorType)
    case output
}

enum ActiveState {
    case high
    case low
    case unknown

    init(_ rawValue: Int32) {
        switch rawValue {
            case Int32(GPIOD_LINE_ACTIVE_STATE_HIGH):
                self = .high
            case Int32(GPIOD_LINE_ACTIVE_STATE_LOW):
                self = .low
            default:
                self = .unknown
        }
    }

}

enum BiasType {
    case pullUp
    case pullDown
    case disable
    case asIs
    case unknown

    init(_ rawValue: Int32) {
        switch rawValue {
            case Int32(GPIOD_LINE_BIAS_PULL_UP):
            self = .pullUp
            case Int32(GPIOD_LINE_BIAS_PULL_DOWN):
            self = .pullDown
            case Int32(GPIOD_LINE_BIAS_DISABLE):
            self = .disable
            case Int32(GPIOD_LINE_BIAS_AS_IS):
            self = .asIs
            default:
            self = .unknown
        }
    }

}

public enum EventType {

    case risingEdge
    case fallingEdge
    case bothEdges
    case timeout
    case unknown

    init(ctxless: Int32) {
        switch ctxless {
            case Int32(GPIOD_CTXLESS_EVENT_CB_RISING_EDGE):
            self = .risingEdge
            case Int32(GPIOD_CTXLESS_EVENT_CB_FALLING_EDGE):
            self = .fallingEdge
            case Int32(GPIOD_CTXLESS_EVENT_CB_TIMEOUT):
            self = .timeout
            default:
            self = .unknown
        }
    }

    init(lineEvent: Int32) {
        switch lineEvent {
        case Int32(GPIOD_LINE_EVENT_RISING_EDGE):
            self = .risingEdge
        case Int32(GPIOD_LINE_EVENT_FALLING_EDGE):
            self = .fallingEdge
        default:
            self = .unknown
        }
    }
}