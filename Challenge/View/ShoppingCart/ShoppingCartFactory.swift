import UIKit

enum ShoppingCartFactory {
    @MainActor static func make() -> UIViewController {
        let viewModel = ShoppingCartViewModel()
        let controller = ShoppingCartViewController(viewModel: viewModel)
        return controller
    }
}
