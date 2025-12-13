//
//  ContentView.swift
//  Swift app
//
//  Created by Ankit on 12/11/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }

        }
    }
}

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                content
                    .padding(.vertical, 12)
            }
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
                            .foregroundStyle(.white.opacity(0.7))
                        Text("Dive into the stories everyone is talking about")
                            .font(.largeTitle.bold())
                            .foregroundStyle(.primary)
                    }

                    if viewModel.items.isEmpty {
                        Text("No features are live right now.")
                            .foregroundStyle(.white.opacity(0.7))
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(viewModel.items) { item in
                                    HomeCard(item: item) 
                                }
                            }
                            .padding(.vertical, 4)
                        }
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

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundStyle(.blue)
                Text("Guest")
                    .font(.title.bold())
                Text("Sign in soon to sync your watchlist and preferences.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .navigationTitle("Profile")
        }
    }
}

struct DetailsView:View{
    var item:HomeItem
    var body :some View{
        VStack(spacing:20){
            Text(item.name)
                .font(.largeTitle.bold())
            AsyncImage(url: item.heroImageURL){phase in
                switch phase{
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                case .failure:
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundStyle(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(height:300)
            Text(item.displayDescription)
                .padding()
            Spacer()
        }
        .padding()
        .navigationTitle(item.name)
    }
}
struct HomeCard: View {
    let item: HomeItem

    var body: some View {
        NavigationLink(destination: DetailsView(item: item).toolbar(.hidden, for: .tabBar)) {
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

            LinearGradient(colors: [.clear, .black.opacity(0.2)], startPoint: .center, endPoint: .bottom)
                .clipShape(RoundedRectangle(cornerRadius: 28))

            VStack(alignment: .leading, spacing: 8) {
                Text(item.primaryCategory)
                    .font(.caption.bold())
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.white.opacity(0.2))
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                Text(item.name)
                    .font(.title.bold())
                    .foregroundColor(.white)
                Text(item.displayDescription)
                    .font(.subheadline)
                    .lineLimit(2)
                    .foregroundColor(.white.opacity(0.85))
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
        }
        
    }
}

@MainActor
final class HomeViewModel: ObservableObject {
    enum Status: Equatable {
        case idle
        case loading
        case loaded
        case failed(String)
    }

    @Published private(set) var items: [HomeItem] = []
    @Published private(set) var status: Status = .idle
    @Published private(set) var headline: String = "Popular videos"

    private let endpoint = URL(string: "https://api.zingroll.com/api/homes")!

    func loadIfNeeded() async {
        guard status == .idle else { return }
        await fetchHomes()
    }

    func reload() async {
        await fetchHomes()
    }

    func retry() async {
        await fetchHomes()
    }

    private func fetchHomes() async {
        status = .loading
        do {
            let (data, response) = try await URLSession.shared.data(from: endpoint)
            guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
                throw URLError(.badServerResponse)
            }

            let decoded = try JSONDecoder().decode(HomeResponse.self, from: data)
            withAnimation(.easeInOut) {
                self.items = decoded.items
                self.headline = decoded.message
                self.status = .loaded
            }
        } catch {
            status = .failed(error.localizedDescription)
        }
    }
}

struct HomeResponse: Decodable {
    let message: String
    let items: [HomeItem]
}

struct HomeItem: Identifiable, Decodable {
    let slug: String
    let name: String
    let description: String?
    let thumbnailUrl: String?
    let vthumbnailUrl: String?
    let category: [String]?
    let dViews: Int?
    let ratings: Double?

    var id: String { slug }

    var heroImageURL: URL? {
        if let primary = thumbnailUrl, let url = URL(string: primary) {
            return url
        }
        if let fallback = vthumbnailUrl, let url = URL(string: fallback) {
            return url
        }
        return nil
    }

    var primaryCategory: String {
        if let first = category?.first, !first.isEmpty {
            return first.uppercased()
        }
        return "FEATURE"
    }

    var displayDescription: String {
        if let description, !description.isEmpty {
            return description
        }
        return "No synopsis available just yet."
    }

    var viewsLabel: String {
        let views = dViews ?? 0
        if views >= 10_000 {
            let formatted = Double(views) / 1000
            return String(format: "%.1fk views", formatted)
        }
        return "\(views) views"
    }

    var ratingLabel: String {
        guard let ratings, ratings > 0 else { return "NR" }
        return String(format: "%.1f", ratings)
    }
}

#Preview {
    ContentView()
}
