import Combine
import Foundation

final class ShoppingCartViewModel {
    @Published var cart: Cart = Cart()

    init(cart: Cart) {
        self.cart = cart
    }
}
