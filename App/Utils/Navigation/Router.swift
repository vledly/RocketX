import Foundation
import Observation

@MainActor
@Observable
final class Router {
    let root: Screen
    var path: [Screen] = []
    private(set) var isReady = false

    init(root: Screen) {
        self.root = root
    }

    var currentScreen: Screen { path.last ?? root }

    func push(_ screen: Screen) {
        guard currentScreen.id != screen.id else { return }
        isReady = false
        path.append(screen)
    }

    func pop() {
        guard !path.isEmpty else { return }
        isReady = false
        path.removeLast()
    }

    func popToRoot() {
        guard !path.isEmpty else { return }
        isReady = false
        path.removeAll()
    }

    func screenDidAppear(id: UUID) {
        guard currentScreen.id == id else { return }
        isReady = true
    }
}
