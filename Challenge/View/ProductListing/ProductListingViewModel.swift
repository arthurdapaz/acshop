import Foundation

final class ProductListingViewModel {
    enum ViewState {
        case loading
        case loaded
        case error(Error?)
    }

    @Published var viewState: ViewState = .loading
    @Published var products: [Product] = []
    @Published var cart: Cart = Cart()

    private let service: APIClientProtocol
    init(service: APIClientProtocol = APIClient()) {
        self.service = service
    }

    func fetchProducts() {
        viewState = .loading
        Task {
            do {
                products = try await service.fetchProducts()
                viewState = .loaded
            } catch {
                viewState = .error(error)
            }
        }
    }

    func addToCart(productIndex: Int) {
        guard products.indices.contains(productIndex) else {
            fatalError("Got wrong item index")
        }
        cart.addProduct(products[productIndex])
    }
}
