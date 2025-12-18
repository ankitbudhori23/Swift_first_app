import SwiftUI

struct DetailsView: View {
    let item: HomeItem

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                AsyncImage(url: item.heroImageURL) { phase in
                    switch phase {
                    case .empty:
                        Rectangle().fill(Color.gray.opacity(0.1))
                            .frame(height: 260)
                            .overlay(ProgressView().tint(.gray))
                    case .success(let image):
                        image.resizable().scaledToFill()
                            .frame(height: 260)
                            .clipped()
                    case .failure:
                        Rectangle().fill(Color.gray.opacity(0.2))
                            .frame(height: 260)
                            .overlay(Image(systemName: "photo").font(.largeTitle).foregroundStyle(.gray))
                    @unknown default:
                        EmptyView()
                    }
                }
                .cornerRadius(18)
                .padding(.bottom, 8)
                Text(item.name)
                    .font(.largeTitle.bold())
                    .foregroundStyle(.primary)
                Text(item.primaryCategory)
                    .font(.caption.bold())
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.12))
                    .clipShape(Capsule())
                Text(item.displayDescription)
                    .font(.body)
                    .foregroundStyle(.secondary)
                HStack(spacing: 24) {
                    Label(item.viewsLabel, systemImage: "play.fill")
                    Label(item.ratingLabel, systemImage: "star.fill")
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                Spacer()
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(item.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
}
