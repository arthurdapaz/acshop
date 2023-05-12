import Foundation

struct Cart {
    private var products: [Product: Int] = [:]

    private static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.numberStyle = .currency
        return formatter
    }()

    mutating func addProduct(_ product: Product) {
        products[product, default: 0] += 1
    }

    mutating func removeProduct(_ product: Product) {
        products[product, default: 0] -= 1
        if products[product, default: 0] == 0 {
            products[product] = nil
        }
    }

    func quantity(for product: Product) -> Int {
        products[product, default: 0]
    }

    mutating func increaseQuantity(for product: Product) {
        products[product, default: 0] += 1
    }

    mutating func decreaseQuantity(for product: Product) {
        products[product, default: 0] -= 1
        if products[product, default: 0] == 0 {
            products[product] = nil
        }
    }

    var items: [Product] { products.keys.map { $0 } }

    var isEmpty: Bool { products.isEmpty }

    var totalQuantity: Int { products.reduce(0) { $0 + $1.value } }

    var uniqueQuantity: Int { products.count }

    func totalPrice() -> String {
        let sum = products.reduce(Double.zero) { result, element in
            let (product, quantity) = element
            return result + Double(quantity) * currencyStringToDouble(product.actualPrice)
        }
        return Self.numberFormatter.string(from: NSNumber(value: sum)) ?? ""
    }
}

// Money value handling
private extension Cart {
    func currencyStringToDouble(_ valueString: String) -> Double {
        let parsedValue = valueString.components(separatedBy: .whitespacesAndNewlines).joined()

        guard let value = Self.numberFormatter.number(from: parsedValue)?.doubleValue else {
            assertionFailure("Could not convert value to double")
            return .zero
        }
        return value
    }
}
