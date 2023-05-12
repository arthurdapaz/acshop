import UIKit

protocol CartTableViewCellDelegate: AnyObject {
    func increaseQuantity(_ cell: CartTableViewCell)
    func decreaseQuantity(_ cell: CartTableViewCell)
}

final class CartTableViewCell: UITableViewCell {

    weak var delegate: CartTableViewCellDelegate?

    static var reuseIdentifier: String { String(describing: self) }

    private lazy var productImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()

    private lazy var name: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 0
        return label
    }()

    private lazy var price: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()

    private lazy var decreaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "cart.fill.badge.minus"), for: .normal)
        button.tintColor = .red
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.delegate?.decreaseQuantity(self)
        }), for: .touchUpInside)
        return button
    }()

    private lazy var increaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "cart.fill.badge.plus"), for: .normal)
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.delegate?.increaseQuantity(self)
        }), for: .touchUpInside)
        return button
    }()

    private lazy var quantity: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()


    private lazy var quantityStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 2
        stack.distribution = .fill
        stack.alignment = .fill
        stack.addArrangedSubview(decreaseButton)
        stack.addArrangedSubview(quantity)
        stack.addArrangedSubview(increaseButton)
        return stack
    }()

    private lazy var verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 2
        stack.alignment = .top
        stack.distribution = .fillProportionally

        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isLayoutMarginsRelativeArrangement = true
        stack.addArrangedSubview(name)
        stack.addArrangedSubview(price)
        stack.addArrangedSubview(quantityStack)

        stack.layoutMargins = .init(top: Design.Token.spacing_A,
                                    left: Design.Token.spacing_A,
                                    bottom: Design.Token.spacing_A,
                                    right: Design.Token.spacing_A)
        return stack
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonConfig()
    }

    required init?(coder: NSCoder) { fatalError() }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension CartTableViewCell {
    private func commonConfig() {
        selectionStyle = .none

        contentView.addSubview(productImage)
        contentView.addSubview(verticalStack)

        productImage.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        productImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        productImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        productImage.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -Design.Token.spacing_C*2).isActive = true

        verticalStack.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        verticalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        verticalStack.leadingAnchor.constraint(equalTo: productImage.trailingAnchor).isActive = true
        verticalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }

    func configure(with product: Product, quantity: Int) {
        setImage(product.image)

        name.text = product.name
        price.text = product.actualPrice
        self.quantity.text = "Quantidade: \(quantity)"
    }

    private func setImage(_ remoteURL: String) {
        productImage.contentMode = .scaleAspectFill
        guard let url = URL(string: remoteURL) else {
            usePlaceHolder()
            return
        }

        Task {
            do {
                try await productImage.setImageFrom(url: url)
            } catch {
                usePlaceHolder()
            }
        }
    }

    private func usePlaceHolder() {
        productImage.contentMode = .center
        productImage.image = .productPlaceHolder
    }
}
