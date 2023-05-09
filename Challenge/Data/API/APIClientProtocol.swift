import Foundation

protocol APIClientProtocol {
    func fetchProducts() async throws -> [Product]
}

