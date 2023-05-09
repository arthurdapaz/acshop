import Combine
import UIKit

final class ProductListingViewController: ViewController<ProductListingViewModel> {

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: ProductTableViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

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
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "cart"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didTapCartIcon))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addBindings()
        viewModel.fetchProducts()
    }

    private func addBindings() {
        viewModel.$viewState
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.handleState($0)
            }.store(in: &cancellables)

        viewModel.$products
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
            self?.tableView.reloadData()
        }.store(in: &cancellables)

        viewModel.$cart
            .receive(on: RunLoop.main)
            .map { UIImage(systemName: $0.isEmpty() ? "cart" : "cart.fill") }
            .sink { [weak self] in
                self?.setCartIcon($0)
        }.store(in: &cancellables)
    }

    @objc private func didTapCartIcon() {
        let (cartController, cartViewModel) = ShoppingCartFactory.make(viewModel.cart)

        cartViewModel.$cart
            .receive(on: RunLoop.main)
            .sink { [weak viewModel] in
                viewModel?.cart = $0
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

    private func setCartIcon(_ image: UIImage? = UIImage(systemName: "cart")) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didTapCartIcon))
    }
}

extension ProductListingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { viewModel.products.count }

    func numberOfSections(in tableView: UITableView) -> Int { 1 }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.bounds.height / 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.reuseIdentifier, for: indexPath) as! ProductTableViewCell
        cell.configure(with: viewModel.products[indexPath.row])
        cell.tag = indexPath.row
        cell.delegate = self
        return cell
    }
}

extension ProductListingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*let product = viewModel.products[indexPath.row]
        let productDetailViewController = ProductDetailViewController(viewModel: ProductDetailViewModel(product: product))
        navigationController?.pushViewController(productDetailViewController, animated: true)*/
    }
}

extension ProductListingViewController: ProductTableViewCellDelegate {
    func didTapAddToCart(_ cellIndex: Int) {
        viewModel.addToCart(productIndex: cellIndex)
    }
}
