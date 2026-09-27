import SwiftUI

struct RocketDetailsView<ViewModel: Store<RocketDetailsViewState, RocketDetailsInput>>: View {
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
                ErrorView(title: .detailsLoadError) {
                    send(.retry)
                }
            case let .content(content):
                Content(content: content)
            }
        }
        .navigationTitle(.rocketDetailsTitle)
        .navigationBarTitleDisplayMode(.inline)
        .onFirstAppear {
            send(.viewDidFirstAppear)
        }
    }

    private struct Content: View {
        let content: RocketDetailsViewState.Content

        var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    DetailHeroImage(url: content.imageURL, placeholderSymbol: AppIcons.rocket)

                    VStack(alignment: .leading, spacing: 8) {
                        Text(content.title)
                            .font(.largeTitle.bold())
                        Text(content.type)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    DetailTextSection(title: .rocketDetailsDescription, text: content.description)

                    VStack(alignment: .leading, spacing: 12) {
                        Text(.rocketDetailsSpecifications)
                            .font(.title2.bold())
                        LabeledContent(.rocketDetailsActiveStatus) {
                            Text(content.activeStatus)
                        }
                        LabeledContent(.rocketDetailsStages, value: content.stages)
                        LabeledContent(.rocketDetailsEngines, value: content.engines)
                        LabeledContent(.rocketDetailsEngineType, value: content.engineType)
                        LabeledContent(.rocketDetailsFirstFlight, value: content.firstFlight)
                    }
                }
                .padding(20)
            }
        }
    }

    private func send(_ input: RocketDetailsInput) {
        Task { await viewModel.trigger(input) }
    }
}

#Preview {
    let content = RocketDetailsStateMapper().map(SampleData.rocket)

    NavigationStack {
        RocketDetailsView(
            viewModel: PreviewStore(
                state: RocketDetailsViewState(
                    status: .content(content)
                ),
                input: RocketDetailsInput.self
            )
        )
    }
}
