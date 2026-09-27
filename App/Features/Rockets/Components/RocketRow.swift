import SwiftUI

struct RocketRow: View {
    let item: RocketsViewState.RocketItem

    var body: some View {
        HStack(spacing: 16) {
            RemoteImage(url: item.imageURL, placeholderSymbol: AppIcons.rocket)
                .frame(width: 80, height: 80)
                .background(.quaternary)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 7) {
                Text(item.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(item.type)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                HStack(spacing: 4) {
                    Text(.rocketsSuccessRate)
                    Text(item.successRate)
                }
                .font(.caption.weight(.medium))
                .foregroundStyle(.secondary)
            }

            Spacer(minLength: 0)
            Image(systemName: AppIcons.disclosure)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .contentShape(Rectangle())
        .padding(.vertical, 4)
    }
}

#Preview {
    RocketRow(
        item: RocketsStateMapper().map(SampleData.rocket)
    )
    .padding()
}
