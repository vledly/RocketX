import SwiftUI

@MainActor
struct LoadingAssembly {
    static func build(dependencies: LoadingDependencies) -> some View {
        let viewModel = LoadingViewModel(dependencies: dependencies)
        return LoadingView(viewModel: viewModel)
    }
}
