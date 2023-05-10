protocol APIClient {
    func fetchProducts() async throws -> [Product]
}
