import SwiftUI

struct LaunchesView<ViewModel: Store<LaunchesViewState, LaunchesInput>>: View {
    @State private var showingDateFilter = false
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
                ErrorView(title: .launchesLoadError) {
                    send(.retry)
                }
            case let .content(content) where content.items.isEmpty:
                if viewModel.state.dateRange.isActive {
                    EmptyView(
                        title: .launchesEmptyTitle,
                        description: .launchesEmptyDescription,
                        systemImage: AppIcons.filteredEmpty,
                        state: .filtered(onReset: {
                            send(.applyDateRange(.all))
                        })
                    )
                } else {
                    EmptyView(
                        title: .launchesEmptyAllTitle,
                        description: .launchesEmptyAllDescription,
                        systemImage: AppIcons.calendar,
                        state: .plain
                    )
                }
            case let .content(content):
                Content(
                    content: content,
                    didSelectLaunchAction: { id in
                        send(.didSelectLaunch(id: id))
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
        .navigationTitle(.launchesTitle)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingDateFilter = true
                } label: {
                    Image(systemName: viewModel.state.dateRange.isActive
                          ? AppIcons.activeFilter
                          : AppIcons.filter)
                }
                .accessibilityLabel(.launchesFilterTitle)
            }
        }
        .sheet(isPresented: $showingDateFilter) {
            LaunchDateFilterSheet(
                range: viewModel.state.dateRange,
                suggestedDate: viewModel.state.suggestedFilterDate ?? Date()
            ) { range in
                showingDateFilter = false
                send(.applyDateRange(range))
            }
        }
        .onFirstAppear {
            send(.viewDidFirstAppear)
        }
    }

    private struct Content: View {
        let content: LaunchesViewState.Content
        let didSelectLaunchAction: (String) -> Void
        let loadNextPageAction: () -> Void
        let retryNextPageAction: () -> Void

        var body: some View {
            List {
                ForEach(content.items) { item in
                    Button {
                        didSelectLaunchAction(item.id)
                    } label: {
                        LaunchRow(item: item)
                    }
                    .buttonStyle(.plain)
                    .onAppear {
                        guard item.id == content.items.last?.id else { return }
                        loadNextPageAction()
                    }
                }

                PaginationFooter(
                    status: content.paginationStatus,
                    retryTitle: .launchesNextPageRetry,
                    onRetry: retryNextPageAction
                )
            }
            .listStyle(.plain)
        }
    }

    private func send(_ input: LaunchesInput) {
        Task { await viewModel.trigger(input) }
    }
}

#Preview {
    let item = LaunchesViewStateMapper().map(SampleData.launchWithLaunchpad)

    NavigationStack {
        LaunchesView(
            viewModel: PreviewStore(
                state: LaunchesViewState(
                    status: .content(LaunchesViewState.Content(
                        items: [item],
                        paginationStatus: .ready
                    ))
                ),
                input: LaunchesInput.self
            )
        )
    }
}
