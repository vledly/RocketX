import SwiftUI

struct LoadingView<ViewModel: Store<LoadingViewState, LoadingInput>>: View {
    @State private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ZStack {
            Color.white

            Image("LaunchLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
        }
        .ignoresSafeArea()
        .onFirstAppear {
            send(.viewDidFirstAppear)
        }
    }

    private func send(_ input: LoadingInput) {
        Task { await viewModel.trigger(input) }
    }
}

#Preview {
    LoadingView(
        viewModel: PreviewStore(
            state: LoadingViewState(),
            input: LoadingInput.self
        )
    )
}
