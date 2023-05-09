import UIKit

protocol ProductTableViewCellDelegate: AnyObject {
    func didTapAddToCart(_ cellIndex: Int)
}

final class ProductTableViewCell: UITableViewCell {

    weak var delegate: ProductTableViewCellDelegate?

    private var index = 0

    static var reuseIdentifier: String { String(describing: self) }

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
            delegate?.didTapAddToCart(self.tag)
            self.animation()
        }, for: .touchUpInside)

        return button
    }()

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

    private lazy var verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Design.Token.spacing_A
        stack.alignment = .top
        stack.distribution = .fill
        // stack.distribution = .fillProportionally

        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isLayoutMarginsRelativeArrangement = true
        stack.addArrangedSubview(name)
        stack.addArrangedSubview(price)
        stack.addArrangedSubview(promotion)
        stack.addArrangedSubview(promotionPrice)
        stack.addArrangedSubview(availableSizes)
        stack.addArrangedSubview(addToCartButton)

        stack.setCustomSpacing(Design.Token.spacing_C, after: availableSizes)
        stack.layoutMargins = .init(top: Design.Token.spacing_B,
                                    left: Design.Token.spacing_B,
                                    bottom: Design.Token.spacing_B,
                                    right: Design.Token.spacing_B)
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
        contentView.addSubview(verticalStack)
        contentView.addSubview(noImageLabel)

        productImage.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        productImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        productImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        productImage.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -Design.Token.spacing_C).isActive = true

        noImageLabel.centerXAnchor.constraint(equalTo: productImage.centerXAnchor).isActive = true
        noImageLabel.centerYAnchor.constraint(equalTo: productImage.centerYAnchor, constant: Design.Token.spacing_C).isActive = true

        verticalStack.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        verticalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        verticalStack.leadingAnchor.constraint(equalTo: productImage.trailingAnchor).isActive = true
        verticalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true

        addToCartButton.leadingAnchor.constraint(equalTo: verticalStack.leadingAnchor, constant: Design.Token.spacing_B).isActive = true
        addToCartButton.trailingAnchor.constraint(equalTo: verticalStack.trailingAnchor, constant: -Design.Token.spacing_B).isActive = true
        addToCartButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    func configure(with product: Product) {
        setImage(product.image)

        name.text = product.name
        price.text = product.regularPrice
        promotionPrice.text = product.actualPrice
        promotionPrice.isHidden = !product.onSale
        if product.onSale {
            promotion.text = "Em promoção:"
            promotion.textColor = .systemGreen
        } else {
            promotion.text = "Sem promoção"
            promotion.textColor = .systemGray
        }

        let sizes = (product.sizes.filter { $0.available }.map { $0.size }).joined(separator: " ")
        availableSizes.text = "Tamanhos:\n\(sizes)"
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
        noImageLabel.isHidden = false
    }
}
