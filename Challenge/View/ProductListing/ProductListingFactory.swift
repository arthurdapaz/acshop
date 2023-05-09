import UIKit

enum ProductListingFactory {
    static func make() -> UIViewController {
        let viewModel = ProductListingViewModel()
        let controller = ProductListingViewController(viewModel: viewModel)
        return controller
    }
}
