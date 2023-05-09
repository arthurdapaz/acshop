import Combine
import UIKit

class ViewController<ViewModel>: UIViewController {

    var cancellables: [AnyCancellable] = []

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

extension ViewController {
    func showError(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}
