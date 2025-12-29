import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                content
                    .padding(.vertical, 12)
            }
            .navigationTitle("Spotlight")
        }
        .task {
            await viewModel.loadIfNeeded()
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.status {
        case .idle, .loading:
            ProgressView("Fetching magic...")
                .padding()
        case .failed(let message):
            VStack(spacing: 16) {
                Text("Couldn't reach the feed")
                    .font(.title3)
                    .bold()
                    .foregroundStyle(.white)
                Text(message)
                    .font(.callout)
                    .foregroundStyle(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                Button(action: {
                    Task { await viewModel.retry() }
                }) {
                    Text("Try again")
                        .padding(.horizontal, 24)
                        .padding(.vertical, 10)
                        .background(Color.white.opacity(0.15))
                        .clipShape(Capsule())
                }
            }
            .padding()
        case .loaded:
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(viewModel.headline.uppercased())
                            .font(.subheadline.weight(.semibold))
                            .tracking(1)
                            .foregroundStyle(.secondary)
                        Text("Dive into the stories everyone is talking about")
                            .font(.largeTitle.bold())
                            .foregroundStyle(.primary)
                    }
                    if viewModel.items.isEmpty {
                        Text("No features are live right now.")
                            .foregroundStyle(.secondary)
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 20) {
                                ForEach(viewModel.items) { item in
                                    NavigationLink(destination: DetailsView(item: item)) {
                                        HomeCard(item: item)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .scrollTargetLayout() 
                                }
                            }
                        }
                        .scrollTargetBehavior(.viewAligned)
                    }
                }
                .padding(.horizontal, 20)
            }
            .refreshable {
                await viewModel.reload()
            }
        }
    }
}

//#Preview {
//    HomeView()
//}
