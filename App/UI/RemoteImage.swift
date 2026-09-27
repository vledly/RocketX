import SwiftUI

struct RemoteImage: View {
    let url: URL?
    let placeholderSymbol: String
    var placeholderFont: Font = .title2

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case let .success(image):
                image.resizable().scaledToFill()
            case .empty where url != nil:
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .empty, .failure:
                placeholder
            @unknown default:
                placeholder
            }
        }
    }

    private var placeholder: some View {
        Image(systemName: placeholderSymbol)
            .font(placeholderFont)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview("Placeholder") {
    RemoteImage(
        url: nil,
        placeholderSymbol: AppIcons.launch
    )
    .frame(width: 160, height: 120)
    .background(.quaternary)
    .clipShape(RoundedRectangle(cornerRadius: 16))
    .padding()
}
