import SwiftUI

struct LaunchRow: View {
    let item: LaunchesViewState.LaunchItem

    var body: some View {
        HStack(spacing: 16) {
            RemoteImage(url: item.imageURL, placeholderSymbol: AppIcons.launch)
                .frame(width: 72, height: 72)
                .background(.quaternary, in: RoundedRectangle(cornerRadius: 12))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 8) {
                Text(item.title)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Label(item.launchSite, systemImage: AppIcons.location)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text(item.date)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                LaunchStatusBadge(status: item.status)
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
    LaunchRow(
        item: LaunchesViewStateMapper().map(SampleData.launchWithLaunchpad)
    )
    .padding()
}
