import UIKit

final class ProductTableViewCell: UITableViewCell {

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
        label.font = .preferredFont(forTextStyle: .title1)
        label.numberOfLines = 0
        return label
    }()

    private lazy var price: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        return label
    }()

    private lazy var promotion: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        return label
    }()

    private lazy var promotionPrice: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        return label
    }()

    private lazy var availableSizes: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        label.numberOfLines = 2
        return label
    }()

    private lazy var addToCartButton: UIButton = {
        let action = UIAction { action in
            print(action)
        }

        let button = UIButton(type: .system)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.setTitle("Adicionar", for: .normal)
        button.setImage(UIImage(systemName: "cart.fill.badge.plus"), for: .normal)
        button.addAction(action, for: .touchUpInside)
        button.largeContentImageInsets = .zero

        return button
    }()

    private lazy var verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Design.Token.spacing_A
        stack.alignment = .top

        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isLayoutMarginsRelativeArrangement = true
        stack.addArrangedSubview(name)
        stack.addArrangedSubview(price)
        stack.addArrangedSubview(promotion)
        stack.addArrangedSubview(promotionPrice)
        stack.addArrangedSubview(availableSizes)
        stack.addArrangedSubview(addToCartButton)

        let spacerView = UIView()
        spacerView.frame = .init(x: 0, y: 0, width: 0, height: Design.Token.spacing_B)
        stack.addArrangedSubview(spacerView)

        stack.setCustomSpacing(Design.Token.spacing_C, after: availableSizes)
        stack.layoutMargins.top = Design.Token.spacing_B
        stack.layoutMargins.left = Design.Token.spacing_B
        stack.layoutMargins.right = Design.Token.spacing_B
        stack.layoutMargins.right = Design.Token.spacing_B
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

extension ProductTableViewCell {
    private func commonConfig() {
        contentView.addSubview(productImage)
        contentView.addSubview(verticalStack)

        productImage.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        productImage.heightAnchor.constraint(equalTo: verticalStack.heightAnchor).isActive = true
        productImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        productImage.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -Design.Token.spacing_C).isActive = true

        verticalStack.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        verticalStack.leadingAnchor.constraint(equalTo: productImage.trailingAnchor).isActive = true
        verticalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        verticalStack.heightAnchor.constraint(equalToConstant: 400).isActive = true
        verticalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }

    func configure(with product: Product) {
        setImage(product.image)

        name.text = product.name
        price.text = product.regularPrice
        promotionPrice.text = product.actualPrice

        if product.onSale {
            promotion.text = "Em promoção"
            promotion.textColor = .systemGreen
        } else {
            promotion.text = "Sem promoção"
            promotion.textColor = .systemGray
        }

        let sizes = (product.sizes.filter { $0.available }.map { $0.size }).joined(separator: " ")
        availableSizes.text = "Tamanhos:\n\(sizes)"
    }

    private func setImage(_ remoteURL: String) {
        let placeHolder = UIImage.remove
        guard let url = URL(string: remoteURL) else {
            productImage.image = placeHolder
            return
        }

        Task {
            do {
                try await productImage.setImageFrom(url: url)
            } catch {
                productImage.image = placeHolder
            }
        }
    }
}
