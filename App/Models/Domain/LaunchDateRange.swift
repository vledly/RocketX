import Foundation

struct LaunchDateRange: Equatable, Sendable {
    static let all = LaunchDateRange(start: nil, end: nil)

    let start: Date?
    let end: Date?

    init(start: Date?, end: Date?) {
        let calendar = Calendar.current
        self.start = start.map(calendar.startOfDay(for:))
        self.end = end.map(calendar.startOfDay(for:))
    }

    var isActive: Bool { start != nil || end != nil }
    var isValid: Bool {
        guard let start, let end else { return true }
        return start <= end
    }

    var startInclusive: Date? { start }

    var endExclusive: Date? {
        end.flatMap { Calendar.current.dateInterval(of: .day, for: $0)?.end }
    }

    func contains(_ date: Date) -> Bool {
        if let startInclusive, date < startInclusive { return false }
        if let endExclusive, date >= endExclusive { return false }
        return true
    }
}
