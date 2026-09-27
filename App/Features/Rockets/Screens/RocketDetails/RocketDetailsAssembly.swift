import SwiftUI

struct RocketDetailsAssemblyInput {
    let rocketID: String
}

@MainActor
struct RocketDetailsAssembly {
    static func build(
        input: RocketDetailsAssemblyInput,
        dependencies: RocketDetailsDependencies
    ) -> some View {
        let viewModel = RocketDetailsViewModel(
            input: input,
            dependencies: dependencies
        )
        return RocketDetailsView(viewModel: viewModel)
    }
}
