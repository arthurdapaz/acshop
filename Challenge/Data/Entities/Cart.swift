import Foundation

struct Cart {
    private var products: [Product: Int] = [:]
    private var order: [Product] = []

    private static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.numberStyle = .currency
        return formatter
    }()

    mutating func addProduct(_ product: Product) {
        products[product, default: 0] += 1
        if !order.contains(product) {
            order.append(product)
        }
    }

    mutating func removeProduct(_ product: Product) {
        products[product, default: 0] -= 1
        if products[product, default: 0] == 0 {
            products[product] = nil
            if let index = order.firstIndex(of: product) {
                order.remove(at: index)
            }
        }
    }

    func quantity(for product: Product) -> Int {
        return products[product, default: 0]
    }

    mutating func increaseQuantity(for product: Product) {
        products[product, default: 0] += 1
        if !order.contains(product) {
            order.append(product)
        }
    }

    mutating func decreaseQuantity(for product: Product) {
        products[product, default: 0] -= 1
        if products[product, default: 0] == 0 {
            products[product] = nil
            if let index = order.firstIndex(of: product) {
                order.remove(at: index)
            }
        }
    }

    func isEmpty() -> Bool {
        return products.isEmpty
    }

    func totalQuantity() -> Int {
        var total = 0
        for (_, quantity) in products {
            total += quantity
        }
        return total
    }

    func totalPrice() -> String {
        var totalPrice: Double = 0
        for (product, quantity) in products {
            totalPrice += Double(quantity) * convertMoneyToDouble(product.actualPrice)
        }
        let formattedPrice = Self.numberFormatter.string(from: NSNumber(value: totalPrice))
        return formattedPrice ?? ""
    }

    func uniqueItensQuantity() -> Int { products.count }

    func itemsInOrderAdded() -> [Product] { order }
}

// Money value handling
private extension Cart {
    func convertMoneyToDouble(_ valueString: String) -> Double {
        let cleanString = valueString.components(separatedBy: .whitespacesAndNewlines).joined()
        if let value = Self.numberFormatter.number(from: cleanString)?.doubleValue {
            return value
        } else {
            fatalError("Could not convert value to double")
        }
    }
}
