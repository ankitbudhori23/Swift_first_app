import Foundation

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
