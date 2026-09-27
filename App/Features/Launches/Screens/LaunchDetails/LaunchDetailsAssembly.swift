import SwiftUI

struct LaunchDetailsAssemblyInput {
    let launchID: String
}

@MainActor
struct LaunchDetailsAssembly {
    static func build(
        input: LaunchDetailsAssemblyInput,
        dependencies: LaunchDetailsDependencies
    ) -> some View {
        let viewModel = LaunchDetailsViewModel(
            input: input,
            dependencies: dependencies
        )
        return LaunchDetailsView(viewModel: viewModel)
    }
}
