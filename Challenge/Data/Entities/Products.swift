import Foundation

struct Size: Codable, Equatable {
    let available: Bool
    let size: String
    let sku: String
}

struct Product: Codable, Equatable, Identifiable {
    var id: String { sizes.map { $0.sku }.joined() }

    let name: String
    let style: String
    let codeColor: String
    let colorSlug: String
    let color: String
    let onSale: Bool
    let regularPrice: String
    let actualPrice: String
    let discountPercentage: String
    let installments: String
    let image: String
    let sizes: [Size]

    enum CodingKeys: String, CodingKey {
        case name
        case style
        case codeColor = "code_color"
        case colorSlug = "color_slug"
        case color
        case onSale = "on_sale"
        case regularPrice = "regular_price"
        case actualPrice = "actual_price"
        case discountPercentage = "discount_percentage"
        case installments
        case image
        case sizes
    }
}

struct Products: Codable, Equatable {
    let products: [Product]
}

extension Product: Hashable {
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }

    public static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
}
