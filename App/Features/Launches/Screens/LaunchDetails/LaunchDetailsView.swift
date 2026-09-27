import SwiftUI

struct LaunchDetailsView<ViewModel: Store<LaunchDetailsViewState, LaunchDetailsInput>>: View {
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
                Content(
                    content: content,
                    didSelectRocketAction: { rocketID in
                        send(.didSelectRocket(rocketID: rocketID))
                    }
                )
            }
        }
        .navigationTitle(.launchDetailsTitle)
        .navigationBarTitleDisplayMode(.inline)
        .onFirstAppear {
            send(.viewDidFirstAppear)
        }
    }

    private struct Content: View {
        let content: LaunchDetailsViewState.Content
        let didSelectRocketAction: (String) -> ()
        
        var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    DetailHeroImage(url: content.imageURL, placeholderSymbol: AppIcons.launch)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text(content.title)
                            .font(.largeTitle.bold())
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Label(content.date, systemImage: AppIcons.calendar)
                            .foregroundStyle(.secondary)
                        
                        Label(content.launchSite, systemImage: AppIcons.location)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        LaunchStatusBadge(status: content.status, size: .regular)
                    }
                    
                    DetailTextSection(title: .launchDetailsDescription, text: content.description)
                    
                    if let webcastURL = content.webcastURL {
                        Link(destination: webcastURL) {
                            Label(.launchDetailsWatchWebcast, systemImage: AppIcons.webcast)
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text(.launchDetailsRocket)
                            .font(.title2.bold())
                        
                        Button {
                            didSelectRocketAction(content.rocketID)
                        } label: {
                            HStack(spacing: 16) {
                                RemoteImage(url: content.rocketImageURL, placeholderSymbol: AppIcons.rocket)
                                    .frame(width: 64, height: 64)
                                    .background(.quaternary)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(content.rocketName)
                                        .font(.headline)
                                        .foregroundStyle(.primary)
                                    Text(content.rocketType)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                
                                Spacer()
                                Image(systemName: AppIcons.disclosure)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.tertiary)
                            }
                            .padding(16)
                            .background(.quaternary.opacity(0.5), in: RoundedRectangle(cornerRadius: 16))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(20)
            }
        }
    }

    private func send(_ input: LaunchDetailsInput) {
        Task { await viewModel.trigger(input) }
    }

}

#Preview {
    let content = LaunchDetailsStateMapper().map(
        launch: SampleData.launch,
        rocket: SampleData.rocket,
        launchpad: SampleData.launchpad
    )

    NavigationStack {
        LaunchDetailsView(
            viewModel: PreviewStore(
                state: LaunchDetailsViewState(
                    status: .content(content)
                ),
                input: LaunchDetailsInput.self
            )
        )
    }
}
