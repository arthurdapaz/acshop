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
        tableView.contentInset = .init(top: 0, left: 0, bottom: Design.Token.spacing_C * 2, right: 0)
        return tableView
    }()

    private lazy var buyButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.setTitle("Comprar ", for: .normal)
        button.contentEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
        button.imageEdgeInsets = .init(top: 0, left: -8, bottom: 0, right: 0)
        button.backgroundColor = .storeSecondary
        button.layer.cornerRadius = 25
        button.addAction(UIAction { [unowned self] _ in
            showError(title: "Comprou! 🤥", message: "É mentira! Função não implementada :D.")
        }, for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        addBindings()
    }

    override func setupHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
        view.addSubview(buyButton)
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

        buyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Design.Token.spacing_B).isActive = true
        buyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Design.Token.spacing_B).isActive = true
        buyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        buyButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    override func configViews() {
        view.backgroundColor = .white
        title = "Carrinho"
    }

    private func addBindings() {
        viewModel.$cart
            .receive(on: RunLoop.main)
            .map { !$0.isEmpty }
            .assign(to: \.isHidden, on: emptyLabel)
            .store(in: &cancellables)

        viewModel.$cart
            .receive(on: RunLoop.main)
            .map { $0.isEmpty }
            .assign(to: \.isHidden, on: buyButton)
            .store(in: &cancellables)

        viewModel.$cart
            .receive(on: RunLoop.main)
            .map { $0.totalPrice() }
            .sink { [weak self] price in
                self?.buyButton.setTitle("Comprar \(price)", for: .normal)
            }.store(in: &cancellables)

        viewModel.$cart
            .receive(on: RunLoop.main)
            .sink { [weak self] cart in
                self?.tableView.reloadData()
            }.store(in: &cancellables)
    }
}

extension ShoppingCartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { viewModel.cart.uniqueQuantity }

    func numberOfSections(in tableView: UITableView) -> Int { 1 }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.reuseIdentifier, for: indexPath) as! CartTableViewCell

        let product = viewModel.cart.items[indexPath.row]
        let quantity = viewModel.cart.quantity(for: product)

        cell.tag = indexPath.row
        cell.configure(with: product, quantity: quantity)
        cell.delegate = self

        return cell
    }
}

extension ShoppingCartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 120 }
}

extension ShoppingCartViewController: CartTableViewCellDelegate {
    func increaseQuantity(_ cell: CartTableViewCell) {
        let product = viewModel.cart.items[cell.tag]
        viewModel.cart.increaseQuantity(for: product)
    }

    func decreaseQuantity(_ cell: CartTableViewCell) {
        let product = viewModel.cart.items[cell.tag]
        viewModel.cart.decreaseQuantity(for: product)
    }
}
