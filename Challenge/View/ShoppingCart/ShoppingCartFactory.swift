import UIKit

enum ShoppingCartFactory {
    static func make(_ cart: Cart) -> UIViewController {
        let viewModel = ShoppingCartViewModel(cart: cart)
        let controller = ShoppingCartViewController(viewModel: viewModel)
        return controller
    }
}
