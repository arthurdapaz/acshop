import UIKit

protocol CartTableViewCellDelegate: AnyObject {
    func didTapAddToCart(_ cellIndex: Int)
}

final class CartTableViewCell: UITableViewCell {

    weak var delegate: CartTableViewCellDelegate?

    private var index = 0

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

    func configure(with product: Product) {
        setImage(product.image)

        name.text = product.name
        price.text = product.regularPrice
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
