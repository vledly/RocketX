@MainActor
protocol ILaunchesScreensFactory {
    func createLaunches(
        coordinator: any ILaunchesCoordinator
    ) -> Screen

    func createLaunchDetails(
        input: LaunchDetailsAssemblyInput,
        coordinator: any ILaunchDetailsCoordinator
    ) -> Screen
}
