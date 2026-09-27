import SwiftUI

struct MainView<LaunchesContent: View, RocketsContent: View>: View {
    let coordinator: any IMainCoordinator
    @ViewBuilder let launchesContent: () -> LaunchesContent
    @ViewBuilder let rocketsContent: () -> RocketsContent

    var body: some View {
        TabView(selection: Binding(
            get: { coordinator.selectedTab },
            set: { coordinator.select($0) }
        )) {
            Tab(.launchesTitle, systemImage: AppIcons.calendar, value: MainTab.launches) {
                launchesContent()
            }
            Tab(.rocketsTitle, systemImage: AppIcons.rocket, value: MainTab.rockets) {
                rocketsContent()
            }
        }
    }
}

#Preview {
    let container = AppContainer()
    MainAssembly.build(coordinator: MainFlowCoordinator(
        launchesFactory: LaunchesScreensFactory(
            launchesService: container.launchesService,
            rocketsService: container.rocketsService,
            launchpadsService: container.launchpadsService
        ),
        rocketsFactory: RocketsScreensFactory(
            rocketsService: container.rocketsService
        )
    ))
}
