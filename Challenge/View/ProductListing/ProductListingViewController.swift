import Combine
import UIKit

final class ProductListingViewController: ViewController<ProductListingViewModel> {

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: ProductTableViewCell.reuseIdentifier)
        tableView.allowsSelection = false
        return tableView
    }()

    private lazy var dataSource = UITableView.DataSource<Product>(tableView: tableView) { [weak self] tableView, indexPath, item in
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.reuseIdentifier, for: indexPath) as? ProductTableViewCell
        cell?.configure(with: item, quantity: self?.viewModel.cart.quantity(for: item) ?? .zero)
        cell?.tag = indexPath.row
        cell?.delegate = self
        return cell
    }

    private lazy var indicatorView: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.startAnimating()
        loader.hidesWhenStopped = true
        loader.style = .large
        loader.color = .storePrimary
        return loader
    }()

    private lazy var retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .storeSecondary
        button.setTitle("Tentar Novamente", for: .normal)
        button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        button.isHidden = true
        button.addAction(UIAction { [weak viewModel] _ in
            viewModel?.fetchProducts()
        }, for: .touchUpInside)
        return button
    }()

    override func setupHierarchy() {
        view.addSubview(tableView)
        view.addSubview(indicatorView)
        view.addSubview(retryButton)
    }

    override func setupConstraints() {
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -Design.Token.spacing_C).isActive = true
        indicatorView.widthAnchor.constraint(equalToConstant: 40).isActive = true

        retryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        retryButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -Design.Token.spacing_C).isActive = true
    }

    override func configViews() {
        title = "Produtos"
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "cart"),
            style: .plain,
            target: self,
            action: #selector(didTapCartIcon)
        )
        tableView.dataSource = dataSource
        tableView.delegate = self
    }

    override func configBindings() {
        viewModel.$viewState
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.handleState($0)
            }.store(in: &cancellables)

        viewModel.$products
            .receive(on: RunLoop.main)
            .sink { [weak self] products in
                self?.dataSource.set(items: products)
            }.store(in: &cancellables)

        viewModel.$cart
            .receive(on: RunLoop.main)
            .map { UIImage(systemName: $0.isEmpty ? "cart" : "cart.fill") }
            .assign(to: \.image, on: navigationItem.rightBarButtonItem.unsafelyUnwrapped)
            .store(in: &cancellables)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchProducts()
    }

    @objc private func didTapCartIcon() {
        let (cartController, cartViewModel) = ShoppingCartFactory.make(viewModel.cart)

        cartViewModel.$cart
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.viewModel.cart = $0
                self?.tableView.reloadData()
            }.store(in: &cancellables)

        present(cartController, animated: true)
    }

    private func handleState(_ state: ProductListingViewModel.ViewState) {
        switch state {
        case .loading:
            indicatorView.startAnimating()
            retryButton.isHidden = true

        case .loaded:
            indicatorView.stopAnimating()
            retryButton.isHidden = true

        case let .error(error):
            indicatorView.stopAnimating()
            retryButton.isHidden = false
            showError(title: "Erro desconhecido", message: "Um erro não esperado aconteceu. \(error?.localizedDescription ?? String(describing: error))")
        }
    }
}

extension ProductListingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { tableView.bounds.height / 2.3 }
}

extension ProductListingViewController: ProductTableViewCellDelegate {
    func didTapAddToCart(_ cellIndex: Int) -> Int {
        viewModel.addToCart(productIndex: cellIndex)
        guard viewModel.products.indices.contains(cellIndex) else {
            assertionFailure("This should never happen")
            return 0
        }
        return viewModel.cart.quantity(for: viewModel.products[cellIndex])
    }
}
