import Foundation

enum BackendMode {
    case mock
    case live

    static var current: BackendMode {
        switch ProcessInfo.processInfo.environment["ROCKETX_BACKEND"] {
        case "live":
            .live
        default:
            .mock
        }
    }
}
