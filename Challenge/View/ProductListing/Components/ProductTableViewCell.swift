import UIKit

protocol ProductTableViewCellDelegate: AnyObject {
    func didTapAddToCart(_ product: Product) -> Int
}

final class ProductTableViewCell: UITableViewCell {

    weak var delegate: ProductTableViewCellDelegate?

    static var reuseIdentifier: String { String(describing: self) }

    private var quantity = Int.zero {
        didSet {
            updateQuantity()
        }
    }

    private var product: Product!

    private lazy var productImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()

    private lazy var noImageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .caption2)
        label.numberOfLines = 0
        label.textColor = .storePrimary
        label.isHidden = true
        label.text = "Sem imagem"
        return label
    }()

    private lazy var name: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        label.numberOfLines = 0
        return label
    }()

    private lazy var price: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
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
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()

    private lazy var availableSizes: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        label.numberOfLines = 2
        return label
    }()

    private lazy var addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.semanticContentAttribute = .forceRightToLeft
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.setTitle("Adicionar ", for: .normal)
        button.setImage(UIImage(systemName: "cart.fill.badge.plus"), for: .normal)
        button.contentEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
        button.backgroundColor = .storeSecondary
        button.layer.cornerRadius = 25
        button.addAction(UIAction { [unowned self] _ in
            if let updatedQuantity = delegate?.didTapAddToCart(self.product) {
                quantity = updatedQuantity
            }
            self.animation()
        }, for: .touchUpInside)

        return button
    }()

    private lazy var verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = Design.Token.spacing_A

        stack.addArrangedSubview(name)
        stack.addArrangedSubview(price)
        stack.addArrangedSubview(promotion)
        stack.addArrangedSubview(promotionPrice)
        stack.addArrangedSubview(availableSizes)
        stack.addArrangedSubview(addToCartButton)

        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(top: Design.Token.spacing_B, left: Design.Token.spacing_B, bottom: Design.Token.spacing_B, right: Design.Token.spacing_B)
        stack.setCustomSpacing(Design.Token.spacing_C, after: availableSizes)

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
        selectionStyle = .none
        
        contentView.addSubview(productImage)
        contentView.addSubview(noImageLabel)
        contentView.addSubview(verticalStack)

        verticalStack.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        verticalStack.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -Design.Token.spacing_C).isActive = true
        verticalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        verticalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

        productImage.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        productImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        productImage.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -Design.Token.spacing_C).isActive = true
        productImage.heightAnchor.constraint(equalTo: verticalStack.heightAnchor).isActive = true

        noImageLabel.centerXAnchor.constraint(equalTo: productImage.centerXAnchor).isActive = true
        noImageLabel.centerYAnchor.constraint(equalTo: productImage.centerYAnchor, constant: Design.Token.spacing_C).isActive = true

        addToCartButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    func configure(with model: Product, quantity: Int) {
        self.product = model
        setImage(model.image)

        name.text = model.name
        price.text = model.regularPrice
        promotionPrice.text = model.actualPrice
        promotionPrice.isHidden = !model.onSale
        if model.onSale {
            promotion.text = "Em promoção:"
            promotion.textColor = .systemGreen
        } else {
            promotion.text = "Sem promoção"
            promotion.textColor = .systemGray
        }

        let sizes = (model.sizes.filter { $0.available }.map { $0.size }).joined(separator: " ")
        availableSizes.text = "Tamanhos:\n\(sizes)"

        self.quantity = quantity
    }

    private func updateQuantity() {
        if quantity > .zero {
            addToCartButton.setTitle("Adicionado: \(quantity) ", for: .normal)
        } else {
            addToCartButton.setTitle("Adicionar ", for: .normal)
        }
    }

    private func setImage(_ remoteURL: String) {
        noImageLabel.isHidden = true
        productImage.image = nil
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
        noImageLabel.isHidden = false
    }

    private func animation() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.addToCartButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            self.contentView.layoutIfNeeded()
        }, completion: { _ in
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.addToCartButton.setImage(UIImage(systemName: "cart.fill.badge.plus"), for: .normal)
            })
        })

    }
}
