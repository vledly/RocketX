import SwiftUI

@MainActor
struct MainAssembly {
    static func build(coordinator: MainFlowCoordinator) -> some View {
        MainView(coordinator: coordinator) {
            RouterView(router: coordinator.launchesFlow.router)
        } rocketsContent: {
            RouterView(router: coordinator.rocketsFlow.router)
        }
    }
}
