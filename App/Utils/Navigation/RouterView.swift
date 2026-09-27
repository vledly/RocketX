import SwiftUI

struct RouterView: View {
    @Bindable var router: Router

    var body: some View {
        NavigationStack(path: $router.path) {
            screen(router.root)
                .navigationDestination(for: Screen.self) { session in
                    screen(session)
                }
        }
    }

    private func screen(_ session: Screen) -> some View {
        session.content()
            .id(session.id)
            .onAppear { router.screenDidAppear(id: session.id) }
    }
}
