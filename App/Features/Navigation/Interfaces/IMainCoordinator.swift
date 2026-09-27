@MainActor
protocol IMainCoordinator: AnyObject {
    var selectedTab: MainTab { get }
    func select(_ tab: MainTab)
}
