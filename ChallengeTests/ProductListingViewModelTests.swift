import Combine
import XCTest
@testable import Challenge

class ProductListingViewModelTests: XCTestCase {

    var viewModel: ProductListingViewModel!
    var mockService: MockAPIClient!
    var cancellables = [AnyCancellable]()

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockService = MockAPIClient()
        viewModel = ProductListingViewModel(service: mockService)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockService = nil
        try super.tearDownWithError()
    }

    func testFetchProducts() throws {
        // Given
        let size1 = Size(available: true, size: "M", sku: "123")
        let size2 = Size(available: true, size: "L", sku: "456")
        let expectedProducts = [Product(name: "Product 1", style: "Style 1", codeColor: "1234", colorSlug: "color-1", color: "Color 1", onSale: true, regularPrice: "100", actualPrice: "80", discountPercentage: "20%", installments: "4x R$ 20", image: "image1", sizes: [size1, size2])]
        mockService.products = expectedProducts

        // When
        let exp = expectation(description: "Loading products")
        exp.assertForOverFulfill = false

        viewModel.fetchProducts()

        viewModel.$products.receive(on: RunLoop.main).sink { value in
            exp.fulfill()
        }.store(in: &cancellables)

        wait(for: [exp], timeout: 1)

        // Then
        XCTAssertEqual(viewModel.products, expectedProducts)
        XCTAssertEqual(viewModel.viewState, .loaded)
    }

    func testFetchProductsError() throws {
        // Given
        let expectedError = NSError(domain: "test", code: 0, userInfo: nil)
        mockService.error = expectedError

        // When
        let exp = expectation(description: "Loading products")
        exp.assertForOverFulfill = false

        viewModel.$products.receive(on: RunLoop.main).sink { value in
            exp.fulfill()
        }.store(in: &cancellables)

        viewModel.fetchProducts()

        wait(for: [exp], timeout: 1)

        // Then
        XCTAssertEqual(viewModel.viewState, .error(expectedError))
    }

    func testAddToCart() {
        // Given
        let size1 = Size(available: true, size: "M", sku: "123")
        let product = Product(name: "Product 1", style: "Style 1", codeColor: "1234", colorSlug: "color-1", color: "Color 1", onSale: true, regularPrice: "100", actualPrice: "80", discountPercentage: "20%", installments: "4x R$ 20", image: "image1", sizes: [size1])
        viewModel.products = [product]

        // When
        viewModel.addToCart(productIndex: 0)

        // Then
        XCTAssertEqual(viewModel.cart.items.first, product)
    }
}

extension ProductListingViewModel.ViewState: Equatable {
    public static func == (lhs: ProductListingViewModel.ViewState, rhs: ProductListingViewModel.ViewState) -> Bool {
        var lhsDump = String()
        dump(lhs, to: &lhsDump)

        var rhsDump = String()
        dump(rhs, to: &rhsDump)

        return rhsDump == lhsDump
    }
}
