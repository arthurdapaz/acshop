import Combine
import Foundation

@MainActor
final class ProductsListViewModel: ObservableObject {
    @Published var products: [Product] = []

    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func fetchProducts() {
        Task {
            do {
                self.products = try await apiClient.fetchProducts()
            } catch {
                print("Failed to fetch products: \(error.localizedDescription)")
            }
        }
    }
}
