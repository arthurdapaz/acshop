import Foundation

final class StoreAPIClient: APIClient {
    private let baseURL: URL

    init(baseURL: URL = URL(string: "https://www.mocky.io/v2/59b6a65a0f0000e90471257d")!) {
        self.baseURL = baseURL
    }

    func fetchProducts() async throws -> [Product] {
        let url = baseURL.appendingPathComponent("products")
        let (data, _) = try await URLSession.shared.data(from: url)
        let products = try JSONDecoder().decode(Products.self, from: data).products
        return products
    }
}
