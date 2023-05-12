import XCTest
@testable import Challenge

class ShoppingCartViewModelTests: XCTestCase {

    var viewModel: ShoppingCartViewModel!

    override func setUp() {
        super.setUp()
        viewModel = ShoppingCartViewModel(cart: Cart())
    }

    func testCartIsInitiallyEmpty() {
        XCTAssertTrue(viewModel.cart.isEmpty)
    }

    func testAddingProductToCart() {
        let product = createProduct()
        viewModel.cart.addProduct(product)
        XCTAssertEqual(viewModel.cart.quantity(for: product), 1)
        XCTAssertEqual(viewModel.cart.totalQuantity, 1)
        XCTAssertFalse(viewModel.cart.isEmpty)
        XCTAssertEqual(viewModel.cart.uniqueQuantity, 1)
        XCTAssertEqual(viewModel.cart.items.first, product)
    }

    func testRemovingProductFromCart() {
        let product = createProduct()
        viewModel.cart.addProduct(product)
        viewModel.cart.removeProduct(product)
        XCTAssertEqual(viewModel.cart.quantity(for: product), 0)
        XCTAssertEqual(viewModel.cart.totalQuantity, 0)
        XCTAssertTrue(viewModel.cart.isEmpty)
        XCTAssertEqual(viewModel.cart.uniqueQuantity, 0)
        XCTAssertEqual(viewModel.cart.items.count, 0)
    }

    func testIncreasingProductQuantity() {
        let product = createProduct()
        viewModel.cart.addProduct(product)
        viewModel.cart.increaseQuantity(for: product)
        XCTAssertEqual(viewModel.cart.quantity(for: product), 2)
        XCTAssertEqual(viewModel.cart.totalQuantity, 2)
        XCTAssertFalse(viewModel.cart.isEmpty)
        XCTAssertEqual(viewModel.cart.uniqueQuantity, 1)
        XCTAssertEqual(viewModel.cart.items.first, product)
    }

    func testDecreasingProductQuantity() {
        let product = createProduct()
        viewModel.cart.addProduct(product)
        viewModel.cart.increaseQuantity(for: product)
        viewModel.cart.decreaseQuantity(for: product)
        XCTAssertEqual(viewModel.cart.quantity(for: product), 1)
        XCTAssertEqual(viewModel.cart.totalQuantity, 1)
        XCTAssertFalse(viewModel.cart.isEmpty)
        XCTAssertEqual(viewModel.cart.uniqueQuantity, 1)
        XCTAssertEqual(viewModel.cart.items.first, product)
    }

    func testTotalPrice() {
        let product1 = createProduct(actualPrice: "R$ 100,00")
        let product2 = createProduct(actualPrice: "R$ 50,00")
        viewModel.cart.addProduct(product1)
        viewModel.cart.increaseQuantity(for: product1)
        viewModel.cart.addProduct(product2)
        XCTAssertEqual(viewModel.cart.totalPrice(), "R$ 250,00")
    }

    func createProduct(actualPrice: String = "R$ 0,00") -> Product {
        Product(name: "Product Name",
                style: "Style",
                codeColor: "000000",
                colorSlug: "color-slug",
                color: "Color",
                onSale: false,
                regularPrice: "R$ 0,00",
                actualPrice: actualPrice,
                discountPercentage: "0%",
                installments: "0x de R$ 0,00",
                image: "image-url",
                sizes: [
                    .init(available: true, size: "", sku: UUID().uuidString),
                    .init(available: true, size: "", sku: UUID().uuidString)
                ])
    }
}
