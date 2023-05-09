import Combine
import Foundation

final class ShoppingCartViewModel {
    @Published var cart: [Product]

    init(cart: [Product]) {
        self.cart = cart
    }
}
