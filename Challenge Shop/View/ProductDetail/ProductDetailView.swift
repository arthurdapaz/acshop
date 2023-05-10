import SwiftUI

struct ProductDetailView: View {
    @StateObject private var viewModel: ProductDetailViewModel

    init(product: Product) {
        _viewModel = StateObject(wrappedValue: ProductDetailViewModel(product: product))
    }

    var body: some View {
        VStack {
            Image(uiImage: viewModel.productImage ?? UIImage(systemName: "photo")!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
                .padding(.top, 16)

            VStack(alignment: .leading, spacing: 16) {
                Text(viewModel.productName)
                    .font(.title)

                Text(viewModel.productPrice)

                if viewModel.productOnSale {
                    Text(viewModel.productDiscountedPrice)
                        .foregroundColor(.red)
                }

                if !viewModel.productSizes.isEmpty {
                    Text("Tamanhos disponíveis:")

                    ForEach(viewModel.productSizes, id: \.self) { size in
                        Text(size)
                    }
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle(viewModel.productName)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: viewModel.addToCart) {
                    Label("Adicionar", systemImage: "cart.badge.plus")
                }
            }
        }
    }
}

class ProductDetailViewModel: ObservableObject {
    @Published var product: Product
    @Published var productImage: UIImage?

    private let apiClient: APIClient
    private let imageCache: NSCache<NSString, UIImage>

    init(product: Product, apiClient: APIClient = StoreAPIClient(), imageCache: NSCache<NSString, UIImage> = NSCache<NSString, UIImage>()) {
        self.product = product
        self.apiClient = apiClient
        self.imageCache = imageCache
        fetchProductImage()
    }

    var productName: String {
        product.name
    }

    var productPrice: String {
        "Preço: \(product.actualPrice)"
    }

    var productOnSale: Bool {
        product.onSale
    }

    var productDiscountedPrice: String {
        "Preço promocional: \(product.actualPrice)"
    }

    var productSizes: [String] {
        product.sizes.filter { $0.available }.map { $0.size }
    }

    func addToCart() {
        // Implement cart functionality here
    }

    private func fetchProductImage() {
        /*guard let url = URL(string: product.image) else { return }

        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            productImage = cachedImage
            return
        }

        Task {
            do {
                let imageData = try await apiClient.getData(from: url)
                let image = UIImage(data: imageData)
                imageCache.setObject(image!, forKey: url.absoluteString as NSString)
                productImage = image
            } catch {
                print("Error fetching product image: \(error)")
            }
        }*/
    }
}
