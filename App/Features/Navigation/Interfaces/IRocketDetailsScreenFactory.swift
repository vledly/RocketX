@MainActor
protocol IRocketDetailsScreenFactory {
    func createRocketDetails(
        input: RocketDetailsAssemblyInput
    ) -> Screen
}
