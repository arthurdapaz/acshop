import Foundation

@MainActor
final class ProductListingViewModel {
    enum ViewState {
        case loading
        case loaded
        case error
    }

    @Published var viewState: ViewState = .loading
    @Published var products: [Product] = []

    private let service: APIClientProtocol
    init(service: APIClientProtocol = APIClient()) {
        self.service = service
    }

    func fetchProducts() {
        viewState = .loading
        Task {
            do {
                products = try await service.fetchProducts()
                print(products)
            } catch {
                viewState = .error
            }
        }
    }
}
