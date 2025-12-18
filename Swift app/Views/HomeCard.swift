import SwiftUI
import Foundation

struct HomeCard: View {
    let item: HomeItem

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: item.heroImageURL) { phase in
                switch phase {
                case .empty:
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Color.gray.opacity(0.1))
                        .overlay(ProgressView().tint(.gray))
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Color.gray.opacity(0.2))
                        .overlay(Image(systemName: "photo").font(.largeTitle).foregroundStyle(.gray))
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 320, height: 420)
            .clipShape(RoundedRectangle(cornerRadius: 28))
            VStack(alignment: .leading, spacing: 8) {
                Text(item.primaryCategory)
                    .font(.caption.bold())
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.12))
                    .clipShape(Capsule())
                Text(item.name)
                    .font(.title.bold())
                    .foregroundStyle(.primary)
                Text(item.displayDescription)
                    .font(.subheadline)
                    .lineLimit(2)
                    .foregroundStyle(.secondary)
                HStack(spacing: 16) {
                    Label(item.viewsLabel, systemImage: "play.fill")
                    Label(item.ratingLabel, systemImage: "star.fill")
                }
                .font(.footnote)
                .foregroundStyle(.secondary)
            }
            .padding(20)
        }
        .contentShape(Rectangle())
        .frame(width: 320, height: 420)
        .shadow(color: .gray.opacity(0.18), radius: 18, x: 0, y: 10)
    }
}
