import UIKit

class ViewController<ViewModel>: UIViewController {

    let viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupHierarchy()
        setupConstraints()
        configViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }

    func setupHierarchy() { fatalError("Please override \(#function)") }

    func setupConstraints() { fatalError("Please override \(#function)") }

    func configViews() { fatalError("Please override \(#function)") }
}
