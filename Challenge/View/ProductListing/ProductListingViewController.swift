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
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        addBindings()
        viewModel.fetchProducts()
    }

    override func setupHierarchy() {
        view.addSubview(tableView)
    }

    override func setupConstraints() {
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    override func configViews() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Produtos"
        view.backgroundColor = .white
        addCartIcon()
    }

    private func addCartIcon() {
        let barButton = UIBarButtonItem(image: UIImage(systemName: "cart.fill"), style: .plain, target: self, action: #selector(didTapCartIcon))
        // barButton.tintColor = Color.primary500.color
        navigationItem.rightBarButtonItem = barButton
    }

    private func addBindings() {
        viewModel.$products
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
            self?.tableView.reloadData()
        }.store(in: &cancellables)
    }

    @objc private func didTapCartIcon() {

    }
}

extension ProductListingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { viewModel.products.count }

    func numberOfSections(in tableView: UITableView) -> Int { 1 }

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
