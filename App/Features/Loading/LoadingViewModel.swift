import Observation

struct LoadingViewState {}

enum LoadingInput: Sendable {
    case viewDidFirstAppear
}

@MainActor
@Observable
final class LoadingViewModel: Store {
    let state = LoadingViewState()
    private let dependencies: LoadingDependencies
    private var didStart = false

    init(dependencies: LoadingDependencies) {
        self.dependencies = dependencies
    }

    func trigger(_ input: LoadingInput) async {
        switch input {
        case .viewDidFirstAppear:
            guard !didStart else { return }
            didStart = true
            dependencies.coordinator.loadingDidFinish()
        }
    }
}
