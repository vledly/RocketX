import SwiftUI

struct Screen: Identifiable, Hashable {
    let id = UUID()
    let content: @MainActor () -> AnyView

    init<Content: View>(@ViewBuilder content: @escaping @MainActor () -> Content) {
        self.content = { AnyView(content()) }
    }

    static func == (lhs: Screen, rhs: Screen) -> Bool { lhs.id == rhs.id }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
