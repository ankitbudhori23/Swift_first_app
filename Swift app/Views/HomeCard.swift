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
                        .fill(Color.gray.opacity(0.2))
                        .overlay(ProgressView().tint(.white))
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Color.gray.opacity(0.3))
                        .overlay(Image(systemName: "photo").font(.largeTitle).foregroundStyle(.white))
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 320, height: 420)
            .clipShape(RoundedRectangle(cornerRadius: 28))
            LinearGradient(colors: [.clear, .black.opacity(0.9)], startPoint: .center, endPoint: .bottom)
                .clipShape(RoundedRectangle(cornerRadius: 28))
            VStack(alignment: .leading, spacing: 8) {
                Text(item.primaryCategory)
                    .font(.caption.bold())
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.white.opacity(0.2))
                    .clipShape(Capsule())
                Text(item.name)
                    .font(.title.bold())
                Text(item.displayDescription)
                    .font(.subheadline)
                    .lineLimit(2)
                    .foregroundStyle(.white.opacity(0.85))
                HStack(spacing: 16) {
                    Label(item.viewsLabel, systemImage: "play.fill")
                    Label(item.ratingLabel, systemImage: "star.fill")
                }
                .font(.footnote)
                .foregroundStyle(.white.opacity(0.9))
            }
            .padding(20)
        }
        .frame(width: 320, height: 420)
        .shadow(color: .black.opacity(0.35), radius: 30, x: 0, y: 20)
    }
}
