import Foundation

struct Cart {
    private var products: [Product: Int] = [:]
    private var order: [Product] = []

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

    func uniqueItensQuantity() -> Int { products.count }

    func itemsInOrderAdded() -> [Product] { order }
}
