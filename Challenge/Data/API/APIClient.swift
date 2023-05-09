import Foundation
import class UIKit.UIImage

final class APIClient: APIClientProtocol {
    private static let baseURL = URL(string: "https://www.mocky.io/v2/59b6a65a0f0000e90471257d")

    func fetchProducts() async throws -> [Product] {
        guard let url = Self.baseURL else {
            throw APIError.invalidURL
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(Products.self, from: data)
        return decoded.products
    }

    func fetchImage(from imageURL: URL) async throws -> UIImage {
        let (data, _) = try await URLSession.shared.data(from: imageURL)
        guard let image = UIImage(data: data) else {
            throw APIError.invalidImageData
        }

        return image
    }
}
