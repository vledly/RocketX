import Observation

@MainActor
@Observable
final class PreviewStore<State, Input: Sendable>: Store {
    var state: State

    @ObservationIgnored
    private let inputHandler: ((Input) async -> Void)?

    init(
        state: State,
        input _: Input.Type,
        onInput: ((Input) async -> Void)? = nil
    ) {
        self.state = state
        inputHandler = onInput
    }

    func trigger(_ input: Input) async {
        await inputHandler?(input)
    }
}
