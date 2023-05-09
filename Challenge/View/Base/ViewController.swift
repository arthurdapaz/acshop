import UIKit

class ViewController<ViewModel>: UIViewController {

    private let viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }

    func setupConstraints() {
        fatalError("Please override this")
    }
}
