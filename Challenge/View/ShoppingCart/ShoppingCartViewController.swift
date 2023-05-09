import UIKit

final class ShoppingCartViewController: ViewController<ShoppingCartViewModel> {

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.text = "Carrinho"
        return label
    }()

    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Seu carrinho está vazio"
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: CartTableViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        addBindings()
    }

    override func setupHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
    }

    override func setupConstraints() {
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Design.Token.spacing_B).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Design.Token.spacing_B).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Design.Token.spacing_B).isActive = true

        tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Design.Token.spacing_B).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Design.Token.spacing_B).isActive = true
        emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Design.Token.spacing_B).isActive = true
        emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    override func configViews() {
        view.backgroundColor = .white
        title = "Carrinho"
    }

    private func addBindings() {
        viewModel.$cart
            .receive(on: RunLoop.main)
            .map { !$0.isEmpty() }
            .assign(to: \.isHidden, on: emptyLabel)
            .store(in: &cancellables)
    }
}

extension ShoppingCartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { viewModel.cart.uniqueItensQuantity() }

    func numberOfSections(in tableView: UITableView) -> Int { 1 }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.reuseIdentifier, for: indexPath) as! CartTableViewCell
        cell.configure(with: viewModel.cart.itemsInOrderAdded()[indexPath.row])
        cell.delegate = self
        return cell
    }
}

extension ShoppingCartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*let product = viewModel.products[indexPath.row]
        let productDetailViewController = ProductDetailViewController(viewModel: ProductDetailViewModel(product: product))
        navigationController?.pushViewController(productDetailViewController, animated: true)*/
    }
}

extension ShoppingCartViewController: CartTableViewCellDelegate {
    func didTapAddToCart(_ cellIndex: Int) {

    }
}
