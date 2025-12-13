import Foundation
import SwiftUI

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
