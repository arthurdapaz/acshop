import Foundation
@testable import Challenge

class MockAPIClient: APIClientProtocol {
    var products: [Product]?
    var error: Error?

    func fetchProducts() async throws -> [Product] {
        if let error = error {
            throw error
        }
        guard let products = products else {
            throw NSError(domain: "test", code: 0, userInfo: nil)
        }
        return products
    }
}
