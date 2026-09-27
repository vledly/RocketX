import SwiftUI

struct RocketsView<ViewModel: Store<RocketsViewState, RocketsInput>>: View {
    @State private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        Group {
            switch viewModel.state.status {
            case .loading:
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .error:
                ErrorView(title: .rocketsLoadError) {
                    send(.retry)
                }
            case let .content(content) where content.items.isEmpty:
                EmptyView(
                    title: .rocketsEmptyTitle,
                    description: .rocketsEmptyDescription,
                    systemImage: AppIcons.rocket,
                    state: .plain
                )
            case let .content(content):
                Content(
                    content: content,
                    didSelectRocketAction: { id in
                        send(.didSelectRocket(id: id))
                    },
                    loadNextPageAction: {
                        send(.loadNextPage)
                    },
                    retryNextPageAction: {
                        send(.retryNextPage)
                    }
                )
            }
        }
        .navigationTitle(.rocketsTitle)
        .onFirstAppear {
            send(.viewDidFirstAppear)
        }
    }

    private struct Content: View {
        let content: RocketsViewState.Content
        let didSelectRocketAction: (String) -> Void
        let loadNextPageAction: () -> Void
        let retryNextPageAction: () -> Void

        var body: some View {
            List {
                ForEach(content.items) { item in
                    Button {
                        didSelectRocketAction(item.id)
                    } label: {
                        RocketRow(item: item)
                    }
                    .buttonStyle(.plain)
                    .onAppear {
                        guard item.id == content.items.last?.id else { return }
                        loadNextPageAction()
                    }
                }

                PaginationFooter(
                    status: content.paginationStatus,
                    retryTitle: .rocketsNextPageRetry,
                    onRetry: retryNextPageAction
                )
            }
            .listStyle(.plain)
        }
    }

    private func send(_ input: RocketsInput) {
        Task { await viewModel.trigger(input) }
    }
}

#Preview {
    let item = RocketsStateMapper().map(SampleData.rocket)

    NavigationStack {
        RocketsView(
            viewModel: PreviewStore(
                state: RocketsViewState(
                    status: .content(RocketsViewState.Content(
                        items: [item],
                        paginationStatus: .end
                    ))
                ),
                input: RocketsInput.self
            )
        )
    }
}
