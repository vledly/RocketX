import SwiftUI

@MainActor
struct RocketsAssembly {
    static func build(dependencies: RocketsDependencies) -> some View {
        let viewModel = RocketsViewModel(dependencies: dependencies)
        return RocketsView(viewModel: viewModel)
    }
}
