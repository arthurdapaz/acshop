import UIKit

enum ShoppingCartFactory {
    static func make() -> UIViewController {
        let viewModel = ShoppingCartViewModel()
        let controller = ShoppingCartViewController(viewModel: viewModel)
        return controller
    }
}
