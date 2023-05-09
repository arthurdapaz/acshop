import UIKit

enum ShoppingCartFactory {
    static func make(_ cart: [Product]) -> UIViewController {
        let viewModel = ShoppingCartViewModel(cart: cart)
        let controller = ShoppingCartViewController(viewModel: viewModel)
        return controller
    }
}
