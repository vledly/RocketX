import SwiftUI

@MainActor
struct LaunchesAssembly {
    static func build(dependencies: LaunchesDependencies) -> some View {
        let viewModel = LaunchesViewModel(dependencies: dependencies)
        return LaunchesView(viewModel: viewModel)
    }
}
