import SwiftUI

struct DetailHeroImage: View {
    let url: URL?
    let placeholderSymbol: String

    var body: some View {
        RemoteImage(url: url, placeholderSymbol: placeholderSymbol, placeholderFont: .largeTitle)
            .frame(maxWidth: .infinity)
            .frame(height: 240)
            .background(.quaternary)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview("Placeholder") {
    DetailHeroImage(
        url: nil,
        placeholderSymbol: AppIcons.rocket
    )
    .padding()
}
