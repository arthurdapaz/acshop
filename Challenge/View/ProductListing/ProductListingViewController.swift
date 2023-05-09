import Combine
import UIKit

final class ProductListingViewController: ViewController<ProductListingViewModel> {

    private var cancellables: [AnyCancellable] = []

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

    override func setupHierarchy() {
        view.addSubview(tableView)
        view.addSubview(indicatorView)
    }

    override func setupConstraints() {
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -Design.Token.spacing_C).isActive = true
        indicatorView.widthAnchor.constraint(equalToConstant: 40).isActive = true
    }

    override func configViews() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Produtos"
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "cart.fill"),
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
    }

    @objc private func didTapCartIcon() {

    }

    private func handleState(_ state: ProductListingViewModel.ViewState) {
        switch state {
        case .loading:
            indicatorView.startAnimating()
        case .loaded:
            indicatorView.stopAnimating()
        case let .error(error):
            indicatorView.stopAnimating()
            showError(title: "Erro desconhecido", message: "Um erro não esperado aconteceu. \(String(describing: error))")
        }
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
