@MainActor
protocol IRocketsScreensFactory: IRocketDetailsScreenFactory {
    func createRockets(
        coordinator: any IRocketsCoordinator
    ) -> Screen
}
